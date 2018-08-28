package com.aquima.plugin.xslt.ui;

 
import com.aquima.interactions.foundation.text.StringUtil;

import org.w3c.dom.Element;

/**
 * Handler that can be used by HtmlDiff to include or exclude html element with or without a specified class name.
 * 
 * @author Danny Roest
 * @author Jon van Leuven
 * @since 9.0
 */
public class HtmlDiffClassNameHandler implements HtmlDiff.IIncludeElementHandler {
  private final String className;
  private final boolean isUpdateable;

  /**
   * Creates a new handler where the classname determines whether an element is a diff element or not. This constructor
   * can be used when not all elements with an id should be included in the differences.
   * <p>
   * If updateable==false, only elements with an id and <b>without</b> the specified classname are valid diff elements.
   * If updateable==true, only elements with an id and <b>with</b> the specified classname are valid diff elements.
   * <p>
   * 
   * Examples:<br />
   * <ol>
   * <li>when only html elements that are widgets should be returned as differences ("widget", true)</li>
   * <li>when some html elements should not be included in the differences ("notrefreshable", false)</li>
   * </ol>
   * 
   * @param className the class name of the element with an id
   * @param updateable whether elements with the specified classname can be updated or not
   */
  public HtmlDiffClassNameHandler(String className, boolean updateable) {
    if (StringUtil.isEmpty(className)) {
      throw new IllegalArgumentException("Unable to construct a HtmlDiffClassNameHandler with an empty class name");
    }
    this.className = className;
    this.isUpdateable = updateable;
  }

  @Override
  public boolean includeElement(Element element) {
    if (this.isUpdateable) {
      // the node should have the specified class
      return this.hasClassName(element);
    } else {
      // the node should NOT have the specified class
      return !this.hasClassName(element);
    }
  }

  private boolean hasClassName(Element element) {
    if (element.getAttributes() == null) {
      return false;
    }
    if (element.getAttributes().getNamedItem("class") == null) {
      return false;
    }
    if (element.getAttributes().getNamedItem("class").getNodeValue() == null) {
      return false;
    }
    String[] classNames = element.getAttributes().getNamedItem("class").getNodeValue().split(" ");
    for (String className : classNames) {
      if (this.className.equalsIgnoreCase(className)) {
        return true;
      }
    }
    return false;
  }

  @Override
  public String toString() {
    return String.format("HtmlDiffClassNameHandler[className='%s', isUpdateable=%s]", this.className,
        this.isUpdateable);
  }
}
