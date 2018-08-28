package com.aquima.plugin.xslt.ui;


/**
 * Interface for dynamically loading xslt files.
 * 
 * @author Danny Roest
 * @since 9.0
 */
public interface IDynamicXsltLoader {

  /**
   * This registers the specified xslt. Use this method in plugins that contain xsl files.
   * 
   * @param fileName the filename (on the classpath) of the xslt to register
   */
  void registerXslt(String fileName);
}
