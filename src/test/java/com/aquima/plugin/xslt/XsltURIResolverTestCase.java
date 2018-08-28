package com.aquima.plugin.xslt;

import static org.junit.Assert.assertEquals;

import com.aquima.interactions.foundation.io.IResource;
import com.aquima.interactions.foundation.utility.SystemProperties;
import com.aquima.interactions.framework.resource.DefaultResourceManager;
import com.aquima.plugin.xslt.ui.XsltURIResolver;

import org.junit.After;
import org.junit.Before;
import org.junit.Test;

import java.io.File;
import java.io.FileWriter;
import java.io.IOException;

import javax.xml.transform.TransformerFactory;
import javax.xml.transform.stream.StreamSource;

/**
 * Testcase for the Xslt URI Resolver.
 *
 * @author Danny Roest
 * @since 9.0
 */
public class XsltURIResolverTestCase {

  private File xslFile;
  private static final File USER_HOME = new File(System.getProperty("user.home"));

  @Before
  public void setup() {
    SystemProperties.setConfigurationLocation(USER_HOME);
    this.xslFile = new File(SystemProperties.getConfigurationLocation(), "home.xsl");

    String xsl =
        "<xsl:stylesheet version='1.0' xmlns:xsl='http://www.w3.org/1999/XSL/Transform' ><xsl:template match='test/home'><succes>home</succes></xsl:template></xsl:stylesheet>";
    FileWriter writer;
    try {

      writer = new FileWriter(this.xslFile);
      writer.write(xsl);
      writer.close();
    } catch (IOException e) {
      e.printStackTrace();
    }
  }

  @After
  public void cleanup() {
    this.xslFile.delete();
  }

  /**
   * This method tests whether an xslt can be imported from the Aquima Home Folder
   *
   * @throws Exception when something went wrong
   */
  @Test
  public void loadFromAquimaHome() throws Exception {
    // Setup
    TransformerFactory transformerFactory = TransformerFactory.newInstance();
    transformerFactory.setURIResolver(new XsltURIResolver(new DefaultResourceManager()));
    IResource resource = new DefaultResourceManager().getResource("com/aquima/web/ui/xslt/imports.xsl");
    StreamSource source = new StreamSource(resource.asReader(), resource.getInfo().getURI().toString());

    // SUT
    String html = XsltTestUtil.renderHtml(source, "<test><classpath /><home /></test>");

    // verify
    assertEquals("<?xml version=\"1.0\" encoding=\"UTF-8\"?><succes>classpath</succes><succes>home</succes>", html);
  }
}
