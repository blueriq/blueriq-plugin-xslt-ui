package com.aquima.plugin.xslt.ui;

import com.aquima.interactions.framework.renderer.IXmlRenderer;
import com.aquima.plugin.xslt.util.XsltLinkHelper;
import com.aquima.plugin.xslt.util.XsltRedirectHelper;
import com.aquima.web.config.CacheKeyService;
import com.aquima.web.config.ResourceUrlConfiguration;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cloud.context.config.annotation.RefreshScope;
import org.springframework.stereotype.Component;

/**
 * Default render view. It converts a page object to xml with the supplied AbstractPageXmlRenderer and uses an xslt file
 * to convert the xml to html.
 * 
 * @author J. van Leuven
 * @author Danny Roest
 * 
 * @since 8.0
 */
@Component
@RefreshScope
public class XsltUi extends AbstractXsltUi {

  private final XsltRedirectHelper redirectHelper;
  private final XsltLinkHelper linkHelper;

  /**
   * Constructs a new Xslt UI.
   * 
   * @param renderer the renderer to use
   * @param config Xslt specific configuration
   */
  @Autowired
  public XsltUi(IXmlRenderer renderer, XsltConfiguration config, XsltRedirectHelper redirectHelper,
      XsltLinkHelper linkHelper, ResourceUrlConfiguration resourceUrlConfiguration, CacheKeyService cacheKeyService) {
    super(renderer, config, resourceUrlConfiguration, cacheKeyService);
    this.redirectHelper = redirectHelper;
    this.linkHelper = linkHelper;
  }

  @Override
  public String getName() {
    return "Xslt";
  }

  @Override
  public String getPath(String sessionId) {
    return redirectHelper.getXsltUiPath(sessionId);
  }

  @Override
  public String getLink(String sessionId) {
    return linkHelper.getXsltUiPath(sessionId);
  }
}
