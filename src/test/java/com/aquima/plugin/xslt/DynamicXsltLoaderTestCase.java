package com.aquima.plugin.xslt;

import static org.junit.Assert.assertEquals;

import com.aquima.interactions.foundation.utility.SystemProperties;
import com.aquima.interactions.framework.resource.DefaultResourceManager;
import com.aquima.plugin.xslt.ui.DynamicXsltLoader;
import com.aquima.plugin.xslt.ui.XsltConfiguration;

import org.apache.commons.io.FileUtils;
import org.junit.AfterClass;
import org.junit.Test;

import java.io.File;
import java.io.FileWriter;
import java.io.IOException;

import javax.xml.transform.Source;

/**
 * Test case for the DynamicXsltloader that test whether it can dynamically include xslts.
 *
 * @author Danny Roest
 * @since 9.0
 */
public class DynamicXsltLoaderTestCase {

  private static File xsltFolder;

  private static final File USER_HOME = new File(System.getProperty("user.home"));

  @AfterClass
  public static void cleanup() throws IOException {
    SystemProperties.setConfigurationLocation(USER_HOME);
    xsltFolder = new File(SystemProperties.getConfigurationLocation(), "temp");

    FileUtils.deleteDirectory(xsltFolder);
  }

  /**
   * Tests whether a registered xsl is imported.
   *
   * @throws Exception when something went wrong
   */
  @Test
  public void dynamicLoadingRegistredXslt() throws Exception {
    // Setup
    XsltConfiguration config = XsltConfiguration.createInstance("com/aquima/web/ui/xslt/", "dynamicxsltloadertest.xsl",
        new String[] { "theme1", "theme2" }, "temp/dynamic", null, null, null, null, null, null, null, null, null);

    // SUT
    DynamicXsltLoader loader = new DynamicXsltLoader();
    loader.registerXslt("com/aquima/web/ui/xslt/registered/registered.xsl");
    Source source = loader.createRootXslt(new DefaultResourceManager(), config, "theme1");

    String html = XsltTestUtil.renderHtml(source, "<test><classpath /><registered /></test>");

    // verify
    assertEquals("<?xml version=\"1.0\" encoding=\"UTF-8\"?><succes>classpath</succes><succes>registered</succes>",
        html);
  }

  /**
   * Tests whether a xsl from the dynamic folder is automatically imported.
   *
   * @throws Exception when something went wrong
   */
  @Test
  public void dynamicLoadingXslt() throws Exception {
    // Setup
    XsltConfiguration config = XsltConfiguration.createInstance("com/aquima/web/ui/xslt/", "dynamicxsltloadertest.xsl",
        new String[] { "theme1", "theme2" }, "temp/dynamic", null, null, null, null, null, null, null, null, null);

    // SUT
    DynamicXsltLoader loader = new DynamicXsltLoader();
    this.createXsltInAquimaHome();
    Source source = loader.createRootXslt(new DefaultResourceManager(), config, "theme1");

    String html = XsltTestUtil.renderHtml(source, "<test><classpath /><dynamic /></test>");

    // verify
    assertEquals("<?xml version=\"1.0\" encoding=\"UTF-8\"?><succes>classpath</succes><succes>dynamic</succes>", html);
  }

  public void createXsltInAquimaHome() throws IOException {
    cleanup();
    xsltFolder.mkdir();
    File dynamicFolder = new File(xsltFolder, "dynamic");
    dynamicFolder.mkdir();

    String xsl = "<xsl:stylesheet version='1.0' xmlns:xsl='http://www.w3.org/1999/XSL/Transform' >";
    xsl += "<xsl:template match='test/dynamic'><succes>dynamic</succes></xsl:template>";
    xsl += "</xsl:stylesheet>";
    FileWriter writer;
    try {
      writer = new FileWriter(new File(dynamicFolder, "dynamic.xsl"));
      writer.write(xsl);
      writer.close();
    } catch (IOException e) {
      e.printStackTrace();
    }
  }

}
