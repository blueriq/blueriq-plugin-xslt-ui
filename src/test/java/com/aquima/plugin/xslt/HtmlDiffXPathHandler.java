package com.aquima.plugin.xslt;

 
import com.aquima.interactions.foundation.text.StringUtil;
import com.aquima.plugin.xslt.ui.HtmlDiff;

import org.springframework.xml.xpath.XPathExpression;
import org.springframework.xml.xpath.XPathExpressionFactory;
import org.springframework.xml.xpath.XPathParseException;
import org.w3c.dom.Element;

/**
 * This diff handler uses an xpath expression to determine if a node should be included in a diff.
 * <p>
 * <b>This class is moved to src/test! Do not use this handler! It has a major performance risk!</b>
 * </p>
 * 
 * @author Jon van Leuven
 * @since 9.0
 */
public class HtmlDiffXPathHandler implements HtmlDiff.IIncludeElementHandler {

  private final XPathExpression xPathExpression;
  private final String xPath;

  public HtmlDiffXPathHandler(String xpath) throws XPathParseException {
    if (StringUtil.isEmpty(xpath)) {
      throw new IllegalArgumentException("Unable to constuct an HtmlDiffXPathHandler with an empty xpath");
    }
    this.xPath = xpath;
    this.xPathExpression = XPathExpressionFactory.createXPathExpression(xpath);
  }

  @Override
  public boolean includeElement(Element element) {
    return this.xPathExpression.evaluateAsBoolean(element);
  }

  @Override
  public String toString() {
    return String.format("HtmlDiffXPathHandler[xpath=\"%s\"]", this.xPath);
  }

}
