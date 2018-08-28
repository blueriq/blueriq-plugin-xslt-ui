package com.aquima.plugin.xslt.ui;

import com.aquima.interactions.composer.ICompositeElement;
import com.aquima.interactions.foundation.GUID;
import com.aquima.interactions.foundation.Parameters;
import com.aquima.interactions.foundation.exception.AppException;
import com.aquima.interactions.foundation.exception.InvalidStateException;
import com.aquima.interactions.foundation.exception.SysException;
import com.aquima.interactions.foundation.io.IResourceManager;
import com.aquima.interactions.foundation.text.StringUtil;
import com.aquima.interactions.foundation.utility.ClassFactory;
import com.aquima.interactions.foundation.xml.generation.IXmlElement;
import com.aquima.interactions.framework.renderer.IXmlRenderer;
import com.aquima.interactions.framework.resource.DefaultResourceManager;
import com.aquima.web.config.CacheKeyService;
import com.aquima.web.config.ResourceUrlConfiguration;
import com.aquima.web.ui.AbstractAquimaUi;
import com.aquima.web.ui.RenderContext;

import com.blueriq.component.api.ui.IRenderContext;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.InitializingBean;
import org.springframework.beans.factory.annotation.Autowired;
import org.w3c.dom.Node;

import java.io.IOException;
import java.io.StringReader;
import java.io.StringWriter;
import java.io.Writer;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpSession;
import javax.xml.transform.ErrorListener;
import javax.xml.transform.Source;
import javax.xml.transform.Templates;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerConfigurationException;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;

/**
 * Default render view. It converts a page object to xml with the supplied AbstractPageXmlRenderer and uses an xslt file
 * to convert the xml to html.
 *
 * @author J. van Leuven
 * @author Danny Roest
 *
 * @since 8.0
 */
public abstract class AbstractXsltUi extends AbstractAquimaUi implements InitializingBean {

  private static final Logger LOG = LoggerFactory.getLogger(AbstractXsltUi.class);

  private final IXmlRenderer xsltRenderer;
  private final XsltConfiguration xsltConfiguration;
  private final ResourceUrlConfiguration resourceUrlConfiguration;
  private final CacheKeyService cacheKeyService;
  private final TransformerFactory transformerFactory;

  private IResourceManager resourceManager;
  private DynamicXsltLoader dynamicXsltLoader;

  private final Map<String, Templates> compiledStyleSheets = new HashMap<>();

  private final HtmlDiff htmlDiff;


  /**
   * Constructs a new Xslt Aquima User Interface.
   *
   * @param xsltRenderer the XmlRenderer to use
   * @param xsltConfiguration Xslt specific configuration
   */
  public AbstractXsltUi(IXmlRenderer xsltRenderer, XsltConfiguration xsltConfiguration,
      ResourceUrlConfiguration resourceUrlConfiguration, CacheKeyService cacheKeyService) {

    super(xsltConfiguration.getThemes());

    if (xsltRenderer == null) {
      throw new IllegalArgumentException("AbstractXsltUi has to be constructer with an xml-renderer.");
    }
    if (resourceUrlConfiguration == null) {
      throw new IllegalArgumentException("AbstractXsltUi has to be constructer with a ResourceUrlConfiguration.");
    }

    this.xsltRenderer = xsltRenderer;
    this.xsltConfiguration = xsltConfiguration;
    this.resourceUrlConfiguration = resourceUrlConfiguration;
    this.cacheKeyService = cacheKeyService;
    transformerFactory = getTransformerFactory(xsltConfiguration);

    resourceManager = new DefaultResourceManager();
    htmlDiff = new HtmlDiff(xsltConfiguration.getHtmlDiffHandler());
    htmlDiff.setErrorHandler(new HtmlDiff.IErrorHandler() {

      @Override
      public void noParentFound(Node node, String userFriendlyMessage) {
        AbstractXsltUi.LOG
            .warn(String.format("Ignoring changed html element/attribute '%s': %s (fix this in your xslt?)",
                node.getNodeName(), userFriendlyMessage));
      }
    });
    setXsltURIResolver(transformerFactory, resourceManager);
  }

  private TransformerFactory getTransformerFactory(XsltConfiguration xsltConfiguration) {
    TransformerFactory transformerFactory;
    if (StringUtil.isEmpty(xsltConfiguration.getTransformerFactory())) {
      transformerFactory = TransformerFactory.newInstance();
    } else {
      try {
        transformerFactory =
            (TransformerFactory) ClassFactory.createInstance(xsltConfiguration.getTransformerFactory());
      } catch (Exception e) {
        throw new IllegalArgumentException(String.format(
            "Invalid transformerfactory specified: %s."
                + " The factory should be on the class path and of the type javax.xml.transform.TransformerFactory",
            xsltConfiguration.getTransformerFactory()), e);
      }
    }
    transformerFactory.setErrorListener(new ThrowExceptionErrorListener());

    if (LOG.isDebugEnabled()) {
      LOG.debug("Using transformerfactory {} for UI {}", transformerFactory.getClass().getName(),
          this.getClass().getSimpleName());
    }

    return transformerFactory;
  }

  /**
   * This method sets the URI resolver. This method is called when the resource manager is set. Override this method to
   * use another URI resolver.
   *
   * @param transformerFactory the transformerfactory
   * @param resourceManager the resource manager to user for the UriResolver
   */
  protected void setXsltURIResolver(TransformerFactory transformerFactory, IResourceManager resourceManager) {
    transformerFactory.setURIResolver(new XsltURIResolver(resourceManager));
  }

  /**
   * This method can be used to set a different xslt loader
   *
   * @param dynamicXsltLoader the new dynamic xslt loader to use
   */
  @Autowired
  public void setDynamicXsltLoader(DynamicXsltLoader dynamicXsltLoader) {
    this.dynamicXsltLoader = dynamicXsltLoader;
  }

  public void setResourceManager(IResourceManager resourceManager) {
    if (resourceManager == null) {
      throw new IllegalArgumentException("Unable to set empty resource manager");
    }
    this.resourceManager = resourceManager;
    setXsltURIResolver(transformerFactory, resourceManager);
  }

  @Override
  public void afterPropertiesSet() throws Exception {
    compileStylesheets();
  }

  public XsltConfiguration getConfiguration() {
    return xsltConfiguration;
  }

  public HtmlDiff getHtmlDiff() {
    return htmlDiff;
  }

  public void writeHtml(Writer writer, ICompositeElement element, RenderContext context) {
    this.writeHtml(writer, element, context, null);
  }

  public void writeHtml(Writer writer, ICompositeElement element, RenderContext context, HttpSession httpSession) {
    try {
      Templates template = compiledStyleSheets.get(xsltConfiguration.getStyleSheet(context.getTheme()));
      if (template == null) {
        throw new IllegalStateException(
            "No compiled stylesheet for " + xsltConfiguration.getStyleSheet(context.getTheme()));
      }
      Transformer transformer = template.newTransformer();

      for (String key : context.getParameters().keySet()) {
        transformer.setParameter(key, context.getParameters().get(key));
      }
      transformer.setErrorListener(new ErrorHandlerListener());
      StringWriter result = new StringWriter();
      IXmlElement xml = generateXml(element, context);
      transformer.transform(new StreamSource(new StringReader(xml.toXmlFragment(false))), new StreamResult(result));
      String html = result.toString();
      if (httpSession != null) {
        httpSession.setAttribute(createSessionKey(context), html);
      }
      writer.write(html);
    } catch (Exception e) {
      throw new SysException("Exception during xml->html transformation.", e);
    }
  }

  private String createSessionKey(RenderContext context) {
    return String.format("pageHtml_%s_%s", context.getSessionId(), context.getTheme());
  }

  public String getLastHtml(HttpSession httpSession, RenderContext context) {
    String sessionKey = createSessionKey(context);
    String result = (String) httpSession.getAttribute(sessionKey);
    if (result == null) {
      throw new InvalidStateException("No last html page found for key '" + sessionKey + "'");
    }
    return result;
  }

  @Override
  public boolean resetCache() {
    compileStylesheets();
    return true;
  }

  private void compileStylesheets() {
    compiledStyleSheets.clear();
    for (String theme : xsltConfiguration.getThemes()) {
      String styleSheet = xsltConfiguration.getStyleSheet(theme);
      if (compiledStyleSheets.containsKey(styleSheet)) {
        continue;
      }
      Templates compileStyleSheet = compileStyleSheet(resourceManager, styleSheet, theme);
      compiledStyleSheets.put(styleSheet, compileStyleSheet);
    }
  }

  @Override
  public boolean hasCache() {
    return true;
  }

  @Override
  public void writeSource(ICompositeElement element, IRenderContext context, Writer result) throws IOException {
    result.write(generateXml(element, context).toXmlFragment(true));
  }

  private IXmlElement generateXml(ICompositeElement element, IRenderContext context) throws IOException {
    Parameters parameters = new Parameters(true);
    if (context.getPageWard() != null) {
      parameters.setParameter(context.getPageWard().getKey(), context.getPageWard().getWard());
    }

    try {
      return xsltRenderer.generateXml(element, context.getApplicationId(), context.getLanguage(),
          context.getDefaultLanguage(), parameters, context.getRuntimeKeyPrinter());
    } catch (AppException e) {
      throw new SysException("Error rendering the element to xml", e);
    }
  }

  /**
   * This method sets default parameters to the render context.
   *
   * @param context the render context
   */
  public void addDefaultParameters(RenderContext context) {
    // Caching is enabled for document links (in the DocumentController) to allow documents to be downloaded
    // through SSL
    // We add a random ID to the URL (in document-link.xsl) to force a new document to be generated each time.
    // @Deprecated
    context.setParameter("cache-killer", String.valueOf(GUID.generate().hashCode()));
    context.setParameter("formAction", createPageUrl(context));
    context.setParameter("sessionId", context.getSessionId());
    context.setParameter("theme", context.getTheme());
    context.setParameter("webResourcesCacheKey", cacheKeyService.getCacheKey()); // remove?
    context.setParameter("webResourcesPath",
        context.getParameters().get("contextPath") + resourceUrlConfiguration.getPath());
    context.setParameter("ajaxEnabled", xsltConfiguration.isAjaxEnabled());

    for (Map.Entry<String, String> xsltParam : xsltConfiguration.getXsltParameters().entrySet()) {
      context.setParameter(xsltParam.getKey(), xsltParam.getValue());
    }
  }

  public String createPageUrl(RenderContext renderContext) {
    if (renderContext.getPageUrl() != null) {
      return renderContext.getPageUrl();
    }
    String pageName = renderContext.getPagename();
    return String.format("%s.html?sessionId=%s", pageName == null ? "xslt" : pageName, renderContext.getSessionId());
  }

  /**
   * This method whether dynamic stylesheets should be loaded in this UI (default is true)
   *
   * @return whether dynamic stylesheets should be loaded in this UI (default is true)
   */
  protected boolean loadDynamicStylesheets() {
    return true;
  }

  @Override
  public String getSourceContentType() {
    return "text/xml;charset=utf-8";
  }

  // AQR-3148: use encoding that is set in the stylesheet:
  protected String getContentEncoding(String themeName) {
    Templates xsl = compiledStyleSheets.get(xsltConfiguration.getStyleSheet(themeName));
    if (xsl == null || xsl.getOutputProperties() == null) {
      return "utf-8";
    }
    return xsl.getOutputProperties().getProperty("encoding", "utf-8");
  }

  private Templates compileStyleSheet(IResourceManager resourceManager, String styleSheet, String theme) {
    try {
      Source source = null;
      if (loadDynamicStylesheets() && dynamicXsltLoader != null) {
        source = dynamicXsltLoader.createRootXslt(resourceManager, xsltConfiguration, theme);
      }
      if (source == null) {
        source = XsltURIResolver.asResource(resourceManager.getResource(styleSheet));
      }
      Templates compiledStyleSheet = transformerFactory.newTemplates(source);
      if (compiledStyleSheet == null) { // should never occur when using the ThrowExceptionErrorListener
        throw new SysException("Unable to compile stylesheet '" + styleSheet + "'");
      }
      return compiledStyleSheet;
    } catch (TransformerConfigurationException e) {
      throw new SysException("Unable to compile stylesheet '" + styleSheet + "': " + e.getMessageAndLocation(), e);
    } catch (Exception e) {
      throw new SysException("Unable to compile stylesheet '" + styleSheet + "'", e);
    }
  }

  /**
   * ErrorListener to make sure an exception is thrown when an xslt could not be parsed.
   *
   * @author Jon van Leuven
   * @since 9.0
   */
  class ThrowExceptionErrorListener implements ErrorListener {

    @Override
    public void warning(TransformerException exception) throws TransformerException {
      throw exception;
    }

    @Override
    public void error(TransformerException exception) throws TransformerException {
      throw exception;
    }

    @Override
    public void fatalError(TransformerException exception) throws TransformerException {
      throw exception;
    }
  }
}
