package com.aquima.plugin.xslt.dom;

import org.w3c.dom.DocumentType;
import org.w3c.dom.NamedNodeMap;

/**
 * Readonly DOM tree that wraps a (Tidy) node to add parent support
 * 
 * @author Jon van Leuven
 * @since 9.0
 */
public final class DocumentTypeWrapper extends NodeWrapper implements DocumentType {

  private final DocumentType delegate;

  protected DocumentTypeWrapper(DocumentType delegate, NodeWrapper parent, DocumentWrapper document) {
    super(delegate, parent, document);
    this.delegate = delegate;
  }

  @Override
  public String getName() {
    return this.delegate.getName();
  }

  @Override
  public NamedNodeMap getEntities() {
    return super.wrapAttributes(this.delegate.getEntities());
  }

  @Override
  public NamedNodeMap getNotations() {
    return super.wrapAttributes(this.delegate.getNotations());
  }

  @Override
  public String getPublicId() {
    return this.delegate.getPublicId();
  }

  @Override
  public String getSystemId() {
    return this.delegate.getSystemId();
  }

  @Override
  public String getInternalSubset() {
    return this.delegate.getInternalSubset();
  }
}
