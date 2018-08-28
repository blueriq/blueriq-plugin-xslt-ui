package com.aquima.plugin.xslt.ui;

import com.aquima.interactions.foundation.exception.SysException;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.xml.transform.ErrorListener;
import javax.xml.transform.TransformerException;

/**
 * This class is used during XSLT transformation to make sure any error is detected by throwing an exception.
 * 
 * @author F. van der Meer
 * 
 * @since 6.4
 */
public class ErrorHandlerListener implements ErrorListener {
  private static final Logger LOG = LoggerFactory.getLogger(ErrorHandlerListener.class);

  @Override
  public void error(TransformerException exception) throws TransformerException {
    throw new SysException("Error during transformation of xml in style sheet", exception);
  }

  @Override
  public void fatalError(TransformerException exception) throws TransformerException {
    throw new SysException("Fatal error during transformation of xml in style sheet", exception);
  }

  @Override
  public void warning(TransformerException exception) throws TransformerException {
    LOG.warn("Warning during transformation of xml in style sheet", exception);
  }
}
