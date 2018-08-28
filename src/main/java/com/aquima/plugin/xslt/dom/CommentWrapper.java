package com.aquima.plugin.xslt.dom;

import org.w3c.dom.Comment;

/**
 * Readonly DOM tree that wraps a (Tidy) node to add parent support
 * 
 * @author Jon van Leuven
 * @since 9.0
 */
public final class CommentWrapper extends CharacterDataWrapper implements Comment {

  protected CommentWrapper(Comment delegate, NodeWrapper parent, DocumentWrapper document) {
    super(delegate, parent, document);
  }
}
