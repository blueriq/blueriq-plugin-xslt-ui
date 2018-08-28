package com.aquima.plugin.xslt.ui;

import com.aquima.interactions.composer.IPage;
import com.aquima.web.ui.RenderContext;

import org.springframework.web.servlet.View;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Renderer that uses a style to render the current page to html.
 * 
 * @author Danny Roest
 * @since 8.0
 */
public class XsltViewRenderer implements View {

  private final AbstractXsltUi renderer;
  private final IPage page;
  private final RenderContext renderContext;

  /**
   * Constructs a new xslt view Renderer.
   * 
   * @param xsltUI the xslt ui
   * @param page the page to render
   * @param context the renderer context
   */
  public XsltViewRenderer(AbstractXsltUi xsltUI, IPage page, RenderContext context) {
    this.renderer = xsltUI;
    this.page = page;
    this.renderContext = context;
    // this.session = session;
  }

  @Override
  public String getContentType() {
    return null;
  }

  @Override
  public void render(Map<String, ?> parameters, HttpServletRequest request, HttpServletResponse response)
      throws Exception {
    response.setContentType(
        String.format("text/html;charset=%s", this.renderer.getContentEncoding(this.renderContext.getTheme()))); // AQR-3148
    try {
      this.renderer.writeHtml(response.getWriter(), this.page, this.renderContext, request.getSession());

    } finally {
      response.getWriter().close();
    }
  }
}
