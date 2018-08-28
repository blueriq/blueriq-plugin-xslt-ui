package com.aquima.plugin.xslt.dom;

import org.w3c.dom.Attr;
import org.w3c.dom.DOMException;
import org.w3c.dom.Element;
import org.w3c.dom.TypeInfo;

/**
 * Readonly DOM tree that wraps a (Tidy) node to add parent support
 * 
 * @author Jon van Leuven
 * @since 9.0
 */
public final class AttrWrapper extends NodeWrapper implements Attr {

  private final Attr delegate;
  private final ElementWrapper parent;

  protected AttrWrapper(Attr delegate, NodeWrapper parent, DocumentWrapper document) {
    super(delegate, parent, document);
    this.delegate = delegate;
    if (!(parent instanceof ElementWrapper)) {
      throw new IllegalArgumentException("Unable to constuct an AttrTree, parent must be an ElementTree");
    }
    this.parent = (ElementWrapper) parent;
  }

  @Override
  public String getName() {
    return this.delegate.getName();
  }

  @Override
  public boolean getSpecified() {
    return this.delegate.getSpecified();
  }

  @Override
  public String getValue() {
    return this.delegate.getValue();
  }

  @Override
  public void setValue(String value) throws DOMException {
    throw new UnsupportedOperationException("This operation is not supported");
  }

  @Override
  public Element getOwnerElement() {
    return this.parent;
  }

  @Override
  public TypeInfo getSchemaTypeInfo() {
    return this.delegate.getSchemaTypeInfo();
  }

  @Override
  public boolean isId() {
    return this.delegate.isId();
  }
}
