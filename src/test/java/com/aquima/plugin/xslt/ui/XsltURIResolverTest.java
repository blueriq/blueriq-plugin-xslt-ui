package com.aquima.plugin.xslt.ui;

import static org.hamcrest.CoreMatchers.startsWith;
import static org.junit.Assert.assertEquals;

import com.aquima.interactions.foundation.io.IResourceManager;
import com.aquima.interactions.foundation.io.ResourceException;
import com.aquima.interactions.framework.resource.DefaultResourceManager;

import org.junit.Before;
import org.junit.Rule;
import org.junit.Test;
import org.junit.rules.ExpectedException;

import java.net.URL;

import javax.xml.transform.Source;

public class XsltURIResolverTest {
  private static final String XSLT_FILE_DIR = "/UI/xslt/";
  private static final String PATH_PREFIX = "file:";

  private XsltURIResolver xsltURIResolver;

  @Rule
  public ExpectedException exception = ExpectedException.none();

  @Before
  public void setUp() {
    IResourceManager resourceManager = new DefaultResourceManager();
    xsltURIResolver = new XsltURIResolver(resourceManager);
  }

  @Test
  public void testResolveURLResource() {
    String referencedFile = "generic/page.xsl";
    String baseFile = XSLT_FILE_DIR + "configuration.xsl";
    URL baseFileresource = xsltURIResolver.getClass().getResource(baseFile);
    String basePath = PATH_PREFIX + baseFileresource.getPath();

    // Class Under Test
    Source resultSource = xsltURIResolver.resolve(referencedFile, basePath);

    // Verify
    URL referencedFileResource = xsltURIResolver.getClass().getResource(XSLT_FILE_DIR + referencedFile);
    String referencedFilePath = PATH_PREFIX + referencedFileResource.getPath();
    assertEquals(referencedFilePath, resultSource.getSystemId());
  }

  @Test
  public void testResolveFromJar() {
    String referencedFile = "generic/page.xsl";
    String baseFile = XSLT_FILE_DIR + "web.xsl";
    URL baseFileresource = xsltURIResolver.getClass().getResource(baseFile);
    String basePath = "pretendingToBeAJar.jar!.file:" + baseFileresource.getPath();

    // Class Under Test
    Source resultSource = xsltURIResolver.resolve(referencedFile, basePath);

    // Verify
    URL referencedFileResource = xsltURIResolver.getClass().getResource(XSLT_FILE_DIR + referencedFile);
    String referencedFilePath = PATH_PREFIX + referencedFileResource.getPath();
    assertEquals(referencedFilePath, resultSource.getSystemId());
  }


  @Test
  public void testResolveResourceManagerSupportedType() {
    String referencedFile = XSLT_FILE_DIR + "web.xsl";
    URL referencedFileResource = xsltURIResolver.getClass().getResource(referencedFile);
    String hrefPath = PATH_PREFIX + referencedFileResource.getPath();

    // Class Under Test
    Source resultSource = xsltURIResolver.resolve(hrefPath, null);
    
    // Verify
    String referencedFilePath = PATH_PREFIX + referencedFileResource.getPath();
    assertEquals(referencedFilePath, resultSource.getSystemId());
  }

  @Test
  public void testResolveNonExistingFile() {
    exception.expect(IllegalStateException.class);
    exception.expectMessage(startsWith("Error resolving 'file:/"));

    String referencedFile = "Unknown.xsl";
    String baseFile = XSLT_FILE_DIR + "configuration.xsl";
    URL baseFileresource = xsltURIResolver.getClass().getResource(baseFile);
    String basePath = PATH_PREFIX + baseFileresource.getPath();

    // Class Under Test
    xsltURIResolver.resolve(referencedFile, basePath);

  }

  @Test
  public void testResolveXslWithSyntaxError() {
    exception.expect(ResourceException.class);
    exception.expectMessage(startsWith("Unable to parse xslt 'file:/"));

    String referencedFile = XSLT_FILE_DIR + "wrong.xsl";
    URL referencedFileResource = xsltURIResolver.getClass().getResource(referencedFile);
    String hrefPath = PATH_PREFIX + referencedFileResource.getPath();

    // Class Under Test
    xsltURIResolver.resolve(hrefPath, null);

  }
}
