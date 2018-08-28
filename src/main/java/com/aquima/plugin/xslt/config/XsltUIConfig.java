package com.aquima.plugin.xslt.config;

import com.aquima.interactions.framework.renderer.IXmlElementRenderer;
import com.aquima.interactions.framework.renderer.IXmlRenderer;
import com.aquima.interactions.framework.renderer.page.r6.PageR6XmlRenderer;
import com.aquima.plugin.xslt.ui.XsltConfiguration;
import com.aquima.plugin.xslt.util.XsltLinkHelper;
import com.aquima.plugin.xslt.util.XsltRedirectHelper;
import com.aquima.web.boot.ServerConfig;
import com.aquima.web.boot.annotation.RootConfiguration;
import com.aquima.web.boot.annotation.ServerConfiguration;
import com.aquima.web.config.AnnotatedRendererStore;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.context.ServletContextAware;
import org.springframework.web.util.UriComponentsBuilder;

import java.util.Map;

import javax.servlet.ServletContext;

/**
 * Configuration for the Xslt UI plugin.
 * 
 * @author Nicky van Noorloos
 * @since 9.1
 */
@Configuration
public class XsltUIConfig {

  @ServerConfiguration(basePackages = "com.aquima.plugin.xslt")
  public static class XsltUIServerConfig {
    // for component scanning
  }

  @RootConfiguration(basePackages = "com.aquima.plugin.xslt")
  public static class XsltUIRootConfig implements ServletContextAware {

    private ServletContext servletContext;

    @Autowired
    private AnnotatedRendererStore rendererStore;

    @Bean
    public IXmlRenderer xmlPageRenderer(XsltConfiguration configuration) {
      Map<String, IXmlElementRenderer> renderers = rendererStore.getXmlPageRenderers();

      return PageR6XmlRenderer.createFor(renderers, //
          configuration.isEnableContainerMessages(), //
          configuration.isIncludeContainerProperties(), //
          configuration.isSortDomainValues(), //
          configuration.isIncludePresentationStyles());
    }

    @Bean
    public XsltRedirectHelper xsltRedirectHelper() {
      return new XsltRedirectHelper(UriComponentsBuilder.fromPath(ServerConfig.SERVLET_PATH));
    }

    @Bean
    public XsltLinkHelper xsltLinkHelper() {
      return new XsltLinkHelper(
          UriComponentsBuilder.fromPath(servletContext.getContextPath()).path(ServerConfig.SERVLET_PATH));
    }

    @Override
    public void setServletContext(ServletContext servletContext) {
      this.servletContext = servletContext;
    }
  }
}
