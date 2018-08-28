package com.aquima.plugin.xslt;

import com.aquima.interactions.framework.resource.DefaultResourceManager;
import com.aquima.plugin.xslt.ui.XsltURIResolver;

import java.io.StringReader;
import java.io.StringWriter;

import javax.xml.transform.Source;
import javax.xml.transform.Templates;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerConfigurationException;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;

public class XsltTestUtil {

  public static String renderHtml(Source source, String xml)
      throws TransformerConfigurationException, TransformerException {
    TransformerFactory transformerFactory = TransformerFactory.newInstance();
    transformerFactory.setURIResolver(new XsltURIResolver(new DefaultResourceManager()));

    Templates compiledStyleSheet = transformerFactory.newTemplates(source);
    Transformer transformer = compiledStyleSheet.newTransformer();
    StringWriter result = new StringWriter();
    transformer.transform(new StreamSource(new StringReader(xml)), new StreamResult(result));
    String html = result.toString();
    return html;
  }

}
