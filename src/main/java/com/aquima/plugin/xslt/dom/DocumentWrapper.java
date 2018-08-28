package com.aquima.plugin.xslt.dom;

import org.w3c.dom.Attr;
import org.w3c.dom.CDATASection;
import org.w3c.dom.CharacterData;
import org.w3c.dom.Comment;
import org.w3c.dom.DOMConfiguration;
import org.w3c.dom.DOMException;
import org.w3c.dom.DOMImplementation;
import org.w3c.dom.Document;
import org.w3c.dom.DocumentFragment;
import org.w3c.dom.DocumentType;
import org.w3c.dom.Element;
import org.w3c.dom.EntityReference;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.w3c.dom.ProcessingInstruction;
import org.w3c.dom.Text;

import java.util.HashMap;

/**
 * Readonly DOM tree that wraps a (Tidy) document.
 * 
 * The DOM implementation of Tidy loses the relation with parent nodes. This wrapper class fixes the parent reference.
 * 
 * @author Jon van Leuven
 * @since 9.0
 */
public final class DocumentWrapper extends NodeWrapper implements Document {

  private final Document delegate;

  // cache to make sure a node is wrapped by the same instance
  private final HashMap<NodeReference, NodeWrapper> wrappedNodes = new HashMap<NodeReference, NodeWrapper>();

  public DocumentWrapper(Document delegate) {
    super(delegate, null, null);
    if (!(delegate instanceof org.w3c.tidy.DOMDocumentImpl)) {
      throw new IllegalArgumentException("The DocumentTree class may only be used to wrap "
          + org.w3c.tidy.DOMDocumentImpl.class + ", not " + delegate.getClass());
    }
    this.delegate = delegate;
  }

  @Override
  public Document getOwnerDocument() {
    return this;
  }

  @Override
  public DocumentType getDoctype() {
    return (DocumentType) wrapChildNode(this.delegate.getDoctype());
  }

  @Override
  public DOMImplementation getImplementation() {
    return this.delegate.getImplementation();
  }

  @Override
  public Element getDocumentElement() {
    return (Element) wrapChildNode(this.delegate.getDocumentElement());
  }

  @Override
  public Element createElement(String tagName) throws DOMException {
    throw new UnsupportedOperationException("This operation is not supported");
  }

  @Override
  public DocumentFragment createDocumentFragment() {
    throw new UnsupportedOperationException("This operation is not supported");
  }

  @Override
  public Text createTextNode(String data) {
    throw new UnsupportedOperationException("This operation is not supported");
  }

  @Override
  public Comment createComment(String data) {
    throw new UnsupportedOperationException("This operation is not supported");
  }

  @Override
  public CDATASection createCDATASection(String data) throws DOMException {
    throw new UnsupportedOperationException("This operation is not supported");
  }

  @Override
  public ProcessingInstruction createProcessingInstruction(String target, String data) throws DOMException {
    throw new UnsupportedOperationException("This operation is not supported");
  }

  @Override
  public Attr createAttribute(String name) throws DOMException {
    throw new UnsupportedOperationException("This operation is not supported");
  }

  @Override
  public EntityReference createEntityReference(String name) throws DOMException {
    throw new UnsupportedOperationException("This operation is not supported");
  }

  @Override
  public NodeList getElementsByTagName(String tagname) {
    throw new UnsupportedOperationException("This operation is not supported");
  }

  @Override
  public Node importNode(Node importedNode, boolean deep) throws DOMException {
    throw new UnsupportedOperationException("This operation is not supported");
  }

  @Override
  public Element createElementNS(String namespaceURI, String qualifiedName) throws DOMException {
    throw new UnsupportedOperationException("This operation is not supported");
  }

  @Override
  public Attr createAttributeNS(String namespaceURI, String qualifiedName) throws DOMException {
    throw new UnsupportedOperationException("This operation is not supported");
  }

  @Override
  public NodeList getElementsByTagNameNS(String namespaceURI, String localName) {
    throw new UnsupportedOperationException("This operation is not supported");
  }

  @Override
  public Element getElementById(String elementId) {
    throw new UnsupportedOperationException("This operation is not supported");
  }

  @Override
  public String getInputEncoding() {
    return this.delegate.getInputEncoding();
  }

  @Override
  public String getXmlEncoding() {
    return this.delegate.getXmlEncoding();
  }

  @Override
  public boolean getXmlStandalone() {
    return this.delegate.getXmlStandalone();
  }

  @Override
  public void setXmlStandalone(boolean xmlStandalone) throws DOMException {
    throw new UnsupportedOperationException("This operation is not supported");
  }

  @Override
  public String getXmlVersion() {
    return this.delegate.getXmlVersion();
  }

  @Override
  public void setXmlVersion(String xmlVersion) throws DOMException {
    throw new UnsupportedOperationException("This operation is not supported");
  }

  @Override
  public boolean getStrictErrorChecking() {
    return this.delegate.getStrictErrorChecking();
  }

  @Override
  public void setStrictErrorChecking(boolean strictErrorChecking) {
    throw new UnsupportedOperationException("This operation is not supported");
  }

  @Override
  public String getDocumentURI() {
    return this.delegate.getDocumentURI();
  }

  @Override
  public void setDocumentURI(String documentURI) {
    throw new UnsupportedOperationException("This operation is not supported");
  }

  @Override
  public Node adoptNode(Node source) throws DOMException {
    throw new UnsupportedOperationException("This operation is not supported");
  }

  @Override
  public DOMConfiguration getDomConfig() {
    return this.delegate.getDomConfig();
  }

  @Override
  public void normalizeDocument() {
    throw new UnsupportedOperationException("This operation is not supported");
  }

  @Override
  public Node renameNode(Node n, String namespaceURI, String qualifiedName) throws DOMException {
    throw new UnsupportedOperationException("This operation is not supported");
  }

  protected NodeWrapper wrapNode(Node node, NodeWrapper parent) {
    if (node == null) {
      return null;
    }
    if (node instanceof NodeWrapper) {
      // should not occur
      throw new IllegalStateException("Node '" + node + "' already wrapped");
    }
    NodeWrapper wrappedNode = this.wrappedNodes.get(new NodeReference(node));
    if (wrappedNode != null) {
      return wrappedNode;
    }
    NodeWrapper result = null;

    if (node instanceof DocumentType) {
      result = new DocumentTypeWrapper((DocumentType) node, parent, this);
    } else if (node instanceof Attr) {
      result = new AttrWrapper((Attr) node, parent, this);
    } else if (node instanceof Element) {
      result = new ElementWrapper((Element) node, parent, this);
    } else if (node instanceof Comment) {
      result = new CommentWrapper((Comment) node, parent, this);
    } else if (node instanceof CharacterData) {
      result = new CharacterDataWrapper((CharacterData) node, parent, this);
    } else if (node instanceof Text) {
      result = new TextWrapper((Text) node, parent, this);
    }
    if (result == null) {
      throw new IllegalStateException("Unexpected node type: " + node);
    }
    this.wrappedNodes.put(new NodeReference(node), result);
    return result;
  }

  private class NodeReference {

    private final Node node;

    protected NodeReference(Node node) {
      this.node = node;
    }

    @Override
    public int hashCode() {
      return this.node.hashCode();
    }

    @Override
    public boolean equals(Object obj) {
      return this.node == ((NodeReference) obj).node; // compare reference to node
    }
  }
}
