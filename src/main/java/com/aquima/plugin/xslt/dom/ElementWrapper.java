package com.aquima.plugin.xslt.dom;

import org.w3c.dom.Attr;
import org.w3c.dom.DOMException;
import org.w3c.dom.Element;
import org.w3c.dom.NodeList;
import org.w3c.dom.TypeInfo;

/**
 * Readonly DOM tree that wraps a (Tidy) node to add parent support
 * 
 * @author Jon van Leuven
 * @since 9.0
 */
public final class ElementWrapper extends NodeWrapper implements Element {

  private final Element delegate;

  public ElementWrapper(Element delegate, NodeWrapper parent, DocumentWrapper document) {
    super(delegate, parent, document);
    this.delegate = delegate;
  }

  @Override
  public String getTagName() {
    return this.delegate.getTagName();
  }

  @Override
  public String getAttribute(String name) {
    return this.delegate.getAttribute(name);
  }

  @Override
  public void setAttribute(String name, String value) throws DOMException {
    throw new UnsupportedOperationException("This operation is not supported");
  }

  @Override
  public void removeAttribute(String name) throws DOMException {
    throw new UnsupportedOperationException("This operation is not supported");
  }

  @Override
  public Attr getAttributeNode(String name) {
    return (Attr) super.wrapChildNode(this.delegate.getAttributeNode(name));
  }

  @Override
  public Attr setAttributeNode(Attr newAttr) throws DOMException {
    throw new UnsupportedOperationException("This operation is not supported");
  }

  @Override
  public Attr removeAttributeNode(Attr oldAttr) throws DOMException {
    throw new UnsupportedOperationException("This operation is not supported");
  }

  @Override
  public NodeList getElementsByTagName(String name) {
    throw new UnsupportedOperationException("This operation is not supported");
  }

  @Override
  public String getAttributeNS(String namespaceURI, String localName) throws DOMException {
    return this.delegate.getAttributeNS(namespaceURI, localName);
  }

  @Override
  public void setAttributeNS(String namespaceURI, String qualifiedName, String value) throws DOMException {
    throw new UnsupportedOperationException("This operation is not supported");
  }

  @Override
  public void removeAttributeNS(String namespaceURI, String localName) throws DOMException {
    throw new UnsupportedOperationException("This operation is not supported");
  }

  @Override
  public Attr getAttributeNodeNS(String namespaceURI, String localName) throws DOMException {
    return (Attr) super.wrapChildNode(delegate.getAttributeNodeNS(namespaceURI, localName));
  }

  @Override
  public Attr setAttributeNodeNS(Attr newAttr) throws DOMException {
    throw new UnsupportedOperationException("This operation is not supported");
  }

  @Override
  public NodeList getElementsByTagNameNS(String namespaceURI, String localName) throws DOMException {
    throw new UnsupportedOperationException("This operation is not supported");
  }

  @Override
  public boolean hasAttribute(String name) {
    return this.delegate.hasAttribute(name);
  }

  @Override
  public boolean hasAttributeNS(String namespaceURI, String localName) throws DOMException {
    return this.delegate.hasAttributeNS(namespaceURI, localName);
  }

  @Override
  public TypeInfo getSchemaTypeInfo() {
    return this.delegate.getSchemaTypeInfo();
  }

  @Override
  public void setIdAttribute(String name, boolean isId) throws DOMException {
    throw new UnsupportedOperationException("This operation is not supported");
  }

  @Override
  public void setIdAttributeNS(String namespaceURI, String localName, boolean isId) throws DOMException {
    throw new UnsupportedOperationException("This operation is not supported");
  }

  @Override
  public void setIdAttributeNode(Attr idAttr, boolean isId) throws DOMException {
    throw new UnsupportedOperationException("This operation is not supported");
  }
}
