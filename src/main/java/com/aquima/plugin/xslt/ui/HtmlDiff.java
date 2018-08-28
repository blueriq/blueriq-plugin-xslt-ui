package com.aquima.plugin.xslt.ui;

import com.aquima.interactions.foundation.text.StringUtil;
import com.aquima.plugin.xslt.ui.TidyParser.TidyLogger;

import net.sf.saxon.TransformerFactoryImpl;
import org.custommonkey.xmlunit.DetailedDiff;
import org.custommonkey.xmlunit.Diff;
import org.custommonkey.xmlunit.Difference;
import org.custommonkey.xmlunit.DifferenceEngine;
import org.custommonkey.xmlunit.XMLUnit;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.w3c.dom.Attr;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

import java.io.StringReader;
import java.io.StringWriter;
import java.util.ArrayList;
import java.util.Collection;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.xml.transform.OutputKeys;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;

/**
 * Class that compares two html fragments pages and returns the differences (in html) of the closest parent with an id.
 * If a html fragment is a subfragment of another difference fragment, only the parent is returned. Only elements in the
 * body are compared. Changes outside the body will throw an exception. <b>Important: The body should ALWAYS have an
 * element with an id, and ids should be unique</b>
 * <p>
 * Example when comparing
 * 
 * <pre>
 * {@code
 * <html>
 *   <head>
 *   ...
 *   </head>
 *   <body>
 *     <div id="aquima">
 *       <div id="1">foo</div>
 *       <div id="2">
 *         <div id="3" value="val">text</div>
 *       </div>
 *     </div>
 *   </body>
 * </html>
 * 
 * <html>
 *   <head>
 *   ...
 *   </head>
 *   <body>
 *     <div id="aquima">
 *       <div id="1">bar</div>
 *       <div id="2">
 *          <div id="3" value="newvalue">newtext</div>
 *       </div>
 *     </div>
 *   </body>
 * </html>
 * }
 * </pre>
 * 
 * will return two diffs
 * 
 * <pre>
 * {@code
 * 1-> <div id="1">bar</div>
 * 3-> <div id="3" value="newvalue">newtext</div>
 * }
 * </pre>
 * 
 * Note that this implementation uses JTidy to parse the html. So html version supported by JTidy can be used only. See
 * for more information <a href="http://jtidy.sourceforge.net/license.html/">JTidy</a>.
 * 
 * @author Danny Roest
 * @author Jon van Leuven
 * @since 9.0
 */
public final class HtmlDiff {

  private static final Logger LOG = LoggerFactory.getLogger(HtmlDiff.class);

  private TransformerFactory transfac;
  private final IIncludeElementHandler handler;

  // optional
  private IErrorHandler mErrorHandler;

  /**
   * Creates a new Html Diff. Every element with an id can be a valid diff element.
   */
  public HtmlDiff() {
    this(null);
  }

  /**
   * Creates a new Html Diff with an optional handler that is used to check if nodes should be included in the diff.
   * 
   * @param handler Optional handler.
   */
  public HtmlDiff(IIncludeElementHandler handler) {
    this.handler = handler;
    try {
      transfac = new TransformerFactoryImpl();
    } catch (Exception e) {
      transfac = TransformerFactory.newInstance();
    }
  }

  /**
   * This method may be used to set a custom transformer factory
   * 
   * @param transformerFactory the transformer factory to use
   */
  public void setTransformerFactory(TransformerFactory transformerFactory) {
    transfac = transformerFactory;
  }

  /**
   * This method may be used to set a custom error handler.
   * 
   * @param handler The handler, may be null.
   */
  public void setErrorHandler(IErrorHandler handler) {
    mErrorHandler = handler;
  }

  public Map<String, String> getDifferences(String htmlBefore, String htmlAfter) throws Exception {
    Transformer transformer = transfac.newTransformer();
    transformer.setOutputProperty(OutputKeys.OMIT_XML_DECLARATION, "yes");

    Document beforeDoc = parseHtml(htmlBefore, "htmlBefore");
    if (LOG.isTraceEnabled()) {
      LOG.trace("before input:" + htmlBefore);
      LOG.trace("before tree:" + toHtml(beforeDoc, transformer));
    }
    Document afterDoc = parseHtml(htmlAfter, "htmlAfter");
    if (LOG.isTraceEnabled()) {
      LOG.trace("after input:" + htmlAfter);
      LOG.trace("after tree:" + toHtml(afterDoc, transformer));
    }

    HashMap<String, Node> foundNodes = new HashMap<>();
    Diff dif = XMLUnit.compareXML(beforeDoc, afterDoc);
    DetailedDiff diff = new DetailedDiff(dif);

    for (Object obj : diff.getAllDifferences()) {
      Difference difference = (Difference) obj;

      if (difference.getId() == DifferenceEngine.CHILD_NODE_NOT_FOUND_ID) {
        continue;
      }
      Node node;// = this.findParentWithId(d.getTestNodeDetail().getNode(), false);
      if (isDivIdChanged(difference)) {
        // node = this.findParentWithId(node.getParentNode());
        node = findParentWithId(difference.getTestNodeDetail().getNode(), false);
        node = findParentWithId(node.getParentNode(), true);
      } else {
        node = findParentWithId(difference.getTestNodeDetail().getNode(), true);
      }
      // node = this.findParentWithId(node, true);
      if (node == null) {
        continue;
      }

      String id = node.getAttributes().getNamedItem("id").getNodeValue();
      Node duplicateNode = foundNodes.get(id.toLowerCase());
      if (duplicateNode != null && duplicateNode != node) {
        throw new IllegalStateException(
            String.format("Could not update changed element, element id not unique for '%s' and '%s'",
                prettyPrintPath(node), prettyPrintPath(duplicateNode)));
      }
      foundNodes.put(id.toLowerCase(), node);
    }

    // create the difference map
    Map<String, String> differences = new HashMap<>();
    Collection<Node> foundNodesList = foundNodes.values();
    for (Node node : foundNodesList) {
      if (isChildOfFoundNode(node, foundNodesList)) {
        // filter nodes that have parent that is already included in the diff
        continue;
      }
      checkChildOfBody(node);
      String id = node.getAttributes().getNamedItem("id").getNodeValue();
      differences.put(id, toHtml(node, transformer));
    }

    return differences;
  }

  private Document parseHtml(String html, String name) throws Exception {
    return new TidyParser(new TidyLogger(name)).parseHtml(new StringReader(html));
  }

  private String toHtml(Node node, Transformer transformer) throws TransformerException {
    StringWriter sw = new StringWriter();
    StreamResult result = new StreamResult(sw);
    DOMSource source = new DOMSource(node);
    transformer.transform(source, result);
    return sw.toString();
  }

  private static boolean isDivIdChanged(Difference d) {
    return d.getId() == DifferenceEngine.ATTR_VALUE_ID
        && d.getControlNodeDetail().getNode().getNodeName().equalsIgnoreCase("id");
  }

  private Node findParentWithId(Node node, boolean checkHandler) {
    Node orgNode = node;
    while (!isValidDiffElement(node, checkHandler)) {
      node = getParent(node);
      if (node == null) {
        String msg = "Could not determine a parent within the body with an id attribute";
        if (checkHandler && handler != null) {
          msg += " and is included by handler " + handler;
        }
        msg = String.format(msg + ". Element: '%s'", prettyPrintPath(orgNode));
        if (mErrorHandler == null) {
          throw new IllegalStateException(msg);
        } else {
          mErrorHandler.noParentFound(orgNode, msg);
          return null;
        }
      }
    }
    return node;
  }

  private static void checkChildOfBody(Node node) {
    Node orgNode = node;
    while (node != null) {
      if (node.getNodeName().equalsIgnoreCase("body")) {
        return;
      }
      node = getParent(node);
    }
    throw new IllegalStateException(
        String.format("Could not update changes that are not in the body. Element: '%s'", prettyPrintPath(orgNode)));
  }

  private static Node getParent(Node node) {
    if (node instanceof Attr) {
      node = ((Attr) node).getOwnerElement();
    } else {
      node = node.getParentNode();
    }
    return node;
  }

  private boolean isValidDiffElement(Node node, boolean checkHandler) {
    if (node == null) {
      return false;
    }
    if (node.getAttributes() == null) {
      return false;
    }
    if (node.getAttributes().getNamedItem("id") == null) {
      return false;
    }
    if (StringUtil.isEmpty(node.getAttributes().getNamedItem("id").getNodeValue())) {
      return false;
    }
    if (!(node instanceof Element)) {
      return false;
    }
    if (checkHandler && handler != null && !handler.includeElement((Element) node)) {
      return false;
    }
    return true;
  }

  private static boolean isChildOfFoundNode(Node node, Collection<Node> foundNodes) {
    List<Node> path = getParents(node);
    for (Node pathNode : path) {
      for (Node foundNode : foundNodes) {
        if (pathNode == foundNode) {
          return true;
        }
      }
    }
    return false;
  }

  private static List<Node> getParents(Node node) {
    List<Node> result = new ArrayList<>();
    for (int i = 0; node.getParentNode() != null; i++) {
      if (i > 0) {
        result.add(node);
      }
      node = node.getParentNode();
    }
    return result;
  }

  private static String prettyPrintPath(Node node) {
    StringBuffer result = new StringBuffer();
    for (; node != null && node.getParentNode() != null; node = node.getParentNode()) {
      if (node.getAttributes() == null) {
        continue;
      }
      StringBuffer nodeString = new StringBuffer();
      nodeString.append(String.format("/%s", node.getNodeName()));
      Node id = node.getAttributes().getNamedItem("id");
      if (id != null) {
        nodeString.append(String.format("[@id='%s']", id.getNodeValue()));
      } else {
        NodeList childNodes = node.getParentNode().getChildNodes();
        int index = 1;
        int total = 0;
        for (int i = 0; i < childNodes.getLength(); i++) {
          if (!node.getNodeName().equalsIgnoreCase(childNodes.item(i).getNodeName())) {
            continue;
          }
          if (childNodes.item(i) == node) {
            index = total + 1;
          }
          total++;
        }
        if (total > 1) {
          nodeString.append(String.format("[%s]", index));
        }
      }
      result.insert(0, nodeString.toString());
    }
    return result.toString();
  }

  /**
   * Handler to determine if an element may be included as a diff element.
   * 
   * @author Jon van Leuven
   * @since 9.0
   */
  public interface IIncludeElementHandler {

    /**
     * This method should return true when the element should be included as a diff element.
     * 
     * @param node The current node, never null.
     * @return True if the element should be included.
     */
    boolean includeElement(Element element);
  }

  /**
   * Handler to handle errors detected during calculation of html differences.
   * 
   * @author Jon van Leuven
   * @since 9.0
   */
  public interface IErrorHandler {

    /**
     * This method is called when a changed node has no parent that may be included as a difference element.
     * 
     * @param node The node that has been changed, never null.
     * @param userFriendlyMessage A user friendly message, never null.
     */
    void noParentFound(Node node, String userFriendlyMessage);
  }
}
