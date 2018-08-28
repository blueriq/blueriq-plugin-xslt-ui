package com.aquima.plugin.xslt.dom;

import org.w3c.dom.CharacterData;
import org.w3c.dom.DOMException;

/**
 * Readonly DOM tree that wraps a (Tidy) node to add parent support
 * 
 * @author Jon van Leuven
 * @since 9.0
 */
public class CharacterDataWrapper extends NodeWrapper implements CharacterData {

  private final CharacterData delegate;

  protected CharacterDataWrapper(CharacterData delegate, NodeWrapper parent, DocumentWrapper document) {
    super(delegate, parent, document);
    this.delegate = delegate;
  }

  @Override
  public String getData() throws DOMException {
    return this.delegate.getData();
  }

  @Override
  public void setData(String data) throws DOMException {
    throw new UnsupportedOperationException("This operation is not supported");
  }

  @Override
  public int getLength() {
    return this.delegate.getLength();
  }

  @Override
  public String substringData(int offset, int count) throws DOMException {
    return this.delegate.substringData(offset, count);
  }

  @Override
  public void appendData(String arg) throws DOMException {
    throw new UnsupportedOperationException("This operation is not supported");
  }

  @Override
  public void insertData(int offset, String arg) throws DOMException {
    throw new UnsupportedOperationException("This operation is not supported");
  }

  @Override
  public void deleteData(int offset, int count) throws DOMException {
    throw new UnsupportedOperationException("This operation is not supported");
  }

  @Override
  public void replaceData(int offset, int count, String arg) throws DOMException {
    throw new UnsupportedOperationException("This operation is not supported");
  }
}
