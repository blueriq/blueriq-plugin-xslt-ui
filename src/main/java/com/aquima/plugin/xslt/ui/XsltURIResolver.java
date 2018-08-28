package com.aquima.plugin.xslt.ui;

import com.aquima.interactions.foundation.io.IResource;
import com.aquima.interactions.foundation.io.IResourceManager;
import com.aquima.interactions.foundation.io.ResourceException;

import org.springframework.core.io.UrlResource;
import org.springframework.util.Assert;
import org.w3c.dom.Document;
import org.xml.sax.SAXParseException;

import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.net.URI;
import java.net.URISyntaxException;

import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.transform.Source;
import javax.xml.transform.URIResolver;
import javax.xml.transform.dom.DOMSource;

/**
 * URI transolver for xslt transformations that supports loading via an IResourceManager and URLResource.
 * 
 * @author Danny Roest
 * @since 9.0
 */
public class XsltURIResolver implements URIResolver {
  private final IResourceManager resourceManager;

  public XsltURIResolver(IResourceManager resourceManager) {
    Assert.notNull(resourceManager, "ResourceManager is required");
    this.resourceManager = resourceManager;
  }

  @Override
  public Source resolve(String href, String base) {
    for (String prefix : resourceManager.getSupportedTypes()) {
      if (href.startsWith(prefix + ":")) {
        return readFromClasspath(href);
      }
    }

    String baseFolder = base.substring(0, base.lastIndexOf('/') + 1);

    if (base.contains("!")) {
      return readFromJarFile(href, base, baseFolder);
    }

    String xslt = baseFolder + href;
    return readFromFileSystem(xslt);
  }

  private Source readFromClasspath(String href) {
    IResource resource = resourceManager.getResource(href);
    return asResource(resource);
  }

  private Source readFromJarFile(String href, String base, String baseFolder) {
    String baseFolderWithoutJarExtension = baseFolder.substring(base.lastIndexOf('!') + 2);
    String xslt = baseFolderWithoutJarExtension + href;
    return readFromClasspath(xslt);
  }

  /**
   * Might be a virtual file system
   */
  private Source readFromFileSystem(String xsltLocation) {
    try {
      URI uri = new URI(xsltLocation);
      // Use the spring-core-io-URLResource to prevent problems with the JBoss VFS
      UrlResource urlResource = new UrlResource(uri);
      try (FileInputStream stream = new FileInputStream(urlResource.getFile())) {
        return asResource(stream, uri.toString());
      }
    } catch (ResourceException | IOException | URISyntaxException ex) {
      throw new IllegalStateException("Error resolving '" + xsltLocation + "'", ex);
    }
  }

  /**
   * This method creates a source based on a resource that revers to an xslt document.
   * 
   * @param resource The resource revering to the xslt document.
   * @return The source containing the xslt, never null.
   * @throws ResourceException
   */
  public static Source asResource(IResource resource) throws ResourceException {
    try (InputStream stream = resource.asInputStream()) {
      return asResource(stream, resource.getInfo().getURI().toString());
    } catch (IOException ex) {
      throw new IllegalStateException("Error resolving '" + resource + "'", ex);
    }
  }

  /**
   * This method creates a source of an input stream that revers to an xslt document.
   * 
   * Note that this method does not close the stream. The caller is responsible for closing the stream.
   * 
   * @param stream The stream revering to the xslt document.
   * @param uri The uri of the stream.
   * @return The source containing the xslt, never null.
   * @throws ResourceException
   */
  private static Source asResource(InputStream stream, String uri) throws ResourceException {
    try {
      // AQR-3558: parse xml to use the correct encoding:
      DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
      factory.setNamespaceAware(true);
      factory.setValidating(false); // validation needs an internet connection!
      Document document = factory.newDocumentBuilder().parse(stream, uri);
      return new DOMSource(document, uri);
    } catch (SAXParseException ex) {
      throw new ResourceException(String.format("Unable to parse xslt '%s', error at line:%s, column:%s", uri,
          ex.getLineNumber(), ex.getColumnNumber()), ex);
    } catch (Exception ex) {
      throw new ResourceException(String.format("Unable to parse xslt '%s'", uri), ex);
    }
  }
}
