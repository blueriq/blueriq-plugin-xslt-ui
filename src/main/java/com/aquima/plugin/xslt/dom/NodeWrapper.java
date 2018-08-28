package com.aquima.plugin.xslt.dom;

import org.w3c.dom.DOMException;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.NamedNodeMap;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.w3c.dom.UserDataHandler;

/**
 * Readonly DOM tree that wraps a (Tidy) node to add parent support
 * 
 * @author Jon van Leuven
 * @since 9.0
 */
public abstract class NodeWrapper implements Node {

  private final Node delegate;
  private final NodeWrapper parent;
  private final DocumentWrapper document;

  public NodeWrapper(Node delegate, NodeWrapper parent, DocumentWrapper document) {
    if (delegate == null) {
      throw new IllegalArgumentException("Unable to constuct a Node Tree with no delegate");
    }
    if (delegate instanceof NodeWrapper) {
      throw new IllegalArgumentException("Unable to constuct a Node Tree, element already wrapped");
    }
    this.delegate = delegate;
    this.parent = parent;
    this.document = document;
  }

  @Override
  public String getNodeName() {
    return delegate.getNodeName();
  }

  @Override
  public String getNodeValue() throws DOMException {
    return delegate.getNodeValue();
  }

  @Override
  public void setNodeValue(String nodeValue) throws DOMException {
    throw new UnsupportedOperationException("This operation is not supported");
  }

  @Override
  public short getNodeType() {
    return delegate.getNodeType();
  }

  @Override
  public Node getParentNode() {
    return this.parent;
  }

  @Override
  public NodeList getChildNodes() {
    return wrapChildNodeList(delegate.getChildNodes());
  }

  @Override
  public Node getFirstChild() {
    return wrapChildNode(delegate.getFirstChild());
  }

  @Override
  public Node getLastChild() {
    return wrapChildNode(delegate.getLastChild());
  }

  @Override
  public Node getPreviousSibling() {
    return wrapSiblingNode(this.delegate.getPreviousSibling());
  }

  @Override
  public Node getNextSibling() {
    return wrapSiblingNode(this.delegate.getNextSibling());
  }

  @Override
  public NamedNodeMap getAttributes() {
    return wrapAttributes(delegate.getAttributes());
  }

  @Override
  public Document getOwnerDocument() {
    return this.document;
  }

  @Override
  public Node insertBefore(Node newChild, Node refChild) throws DOMException {
    throw new UnsupportedOperationException("This operation is not supported");
  }

  @Override
  public Node replaceChild(Node newChild, Node oldChild) throws DOMException {
    throw new UnsupportedOperationException("This operation is not supported");
  }

  @Override
  public Node removeChild(Node oldChild) throws DOMException {
    throw new UnsupportedOperationException("This operation is not supported");
  }

  @Override
  public Node appendChild(Node newChild) throws DOMException {
    throw new UnsupportedOperationException("This operation is not supported");
  }

  @Override
  public boolean hasChildNodes() {
    return this.delegate.hasChildNodes();
  }

  @Override
  public Node cloneNode(boolean deep) {
    throw new UnsupportedOperationException("This operation is not supported");
  }

  @Override
  public void normalize() {
    throw new UnsupportedOperationException("This operation is not supported");
  }

  @Override
  public boolean isSupported(String feature, String version) {
    return delegate.isSupported(feature, version);
  }

  @Override
  public String getNamespaceURI() {
    return delegate.getNamespaceURI();
  }

  @Override
  public String getPrefix() {
    return delegate.getPrefix();
  }

  @Override
  public void setPrefix(String prefix) throws DOMException {
    throw new UnsupportedOperationException("This operation is not supported");
  }

  @Override
  public String getLocalName() {
    return delegate.getLocalName();
  }

  @Override
  public boolean hasAttributes() {
    return delegate.hasAttributes();
  }

  @Override
  public String getBaseURI() {
    return delegate.getBaseURI();
  }

  @Override
  public short compareDocumentPosition(Node other) throws DOMException {
    return delegate.compareDocumentPosition(other);
  }

  @Override
  public String getTextContent() throws DOMException {
    return delegate.getTextContent();
  }

  @Override
  public void setTextContent(String textContent) throws DOMException {
    throw new UnsupportedOperationException("This operation is not supported");
  }

  @Override
  public boolean isSameNode(Node other) {
    return delegate.isSameNode(other);
  }

  @Override
  public String lookupPrefix(String namespaceURI) {
    return delegate.lookupPrefix(namespaceURI);
  }

  @Override
  public boolean isDefaultNamespace(String namespaceURI) {
    return delegate.isDefaultNamespace(namespaceURI);
  }

  @Override
  public String lookupNamespaceURI(String prefix) {
    return delegate.lookupNamespaceURI(prefix);
  }

  @Override
  public boolean isEqualNode(Node arg) {
    return delegate.isEqualNode(arg);
  }

  @Override
  public Object getFeature(String feature, String version) {
    return delegate.getFeature(feature, version);
  }

  @Override
  public Object setUserData(String key, Object data, UserDataHandler handler) {
    throw new UnsupportedOperationException("This operation is not supported");
  }

  @Override
  public Object getUserData(String key) {
    return delegate.getUserData(key);
  }

  @Override
  public int hashCode() {
    return delegate.hashCode();
  }

  @Override
  public boolean equals(Object obj) {
    Object other = obj;
    if (obj instanceof NodeWrapper) {
      other = ((NodeWrapper) obj).delegate;
    }
    return delegate.equals(other);
  }

  protected Node wrapChildNode(Node node) {
    return ((DocumentWrapper) getOwnerDocument()).wrapNode(node, this);
  }

  protected Node wrapSiblingNode(Node node) {
    return ((DocumentWrapper) getOwnerDocument()).wrapNode(node, this.parent);
  }

  protected NodeList wrapChildNodeList(final NodeList childNodes) {
    if (childNodes == null) {
      return null;
    }
    return new NodeList() {

      @Override
      public Node item(int index) {
        return wrapChildNode(childNodes.item(index));
      }

      @Override
      public int getLength() {
        return childNodes.getLength();
      }
    };
  }

  protected NamedNodeMap wrapAttributes(final NamedNodeMap attributes) {
    if (!(this instanceof Element)) {
      return null;
    }
    if (attributes == null) {
      return null;
    }
    return new NamedNodeMap() {

      @Override
      public Node setNamedItemNS(Node arg) throws DOMException {
        throw new UnsupportedOperationException("This operation is not supported");
      }

      @Override
      public Node setNamedItem(Node arg) throws DOMException {
        throw new UnsupportedOperationException("This operation is not supported");
      }

      @Override
      public Node removeNamedItemNS(String namespaceURI, String localName) throws DOMException {
        throw new UnsupportedOperationException("This operation is not supported");
      }

      @Override
      public Node removeNamedItem(String name) throws DOMException {
        throw new UnsupportedOperationException("This operation is not supported");
      }

      @Override
      public Node item(int index) {
        return wrapChildNode(attributes.item(index));
      }

      @Override
      public Node getNamedItemNS(String namespaceURI, String localName) throws DOMException {
        return wrapChildNode(attributes.getNamedItemNS(namespaceURI, localName));
      }

      @Override
      public Node getNamedItem(String name) {
        return wrapChildNode(attributes.getNamedItem(name));
      }

      @Override
      public int getLength() {
        return attributes.getLength();
      }
    };
  }

  @Override
  public String toString() {
    return String.format("%s[%s]", getNodeName(), super.toString());
  }
}
