package com.aquima.plugin.xslt.dom;

import org.w3c.dom.Node;
import org.w3c.dom.Text;

/**
 * Readonly DOM tree that wraps a (Tidy) node to add parent support
 * 
 * @author Jon van Leuven
 * @since 9.0
 */
public final class TextWrapper extends NodeWrapper implements Node {

  protected TextWrapper(Text delegate, NodeWrapper parent, DocumentWrapper document) {
    super(delegate, parent, document);
  }
}
