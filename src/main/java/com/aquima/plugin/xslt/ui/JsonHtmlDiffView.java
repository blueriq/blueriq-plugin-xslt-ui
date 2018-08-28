package com.aquima.plugin.xslt.ui;

import com.aquima.interactions.composer.IPage;
import com.aquima.interactions.foundation.json.writer.JsonWriter;
import com.aquima.web.ui.RenderContext;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.servlet.View;

import java.io.StringWriter;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * View to renderer the HTML changes between two pages and return it in a Json object.
 *
 * @author Jon van Leuven
 * @since 9.0
 */
public class JsonHtmlDiffView implements View {

  private static final Logger LOG = LoggerFactory.getLogger(JsonHtmlDiffView.class);

  private final AbstractXsltUi ui;
  private final IPage page;
  private final RenderContext renderContext;

  /**
   * Constructs a new xslt view Renderer.
   *
   * @param xsltUI the xslt ui
   * @param page the page to render
   * @param context the renderer context
   */
  public JsonHtmlDiffView(AbstractXsltUi xsltUI, IPage page, RenderContext context) {
    this.ui = xsltUI;
    this.page = page;
    this.renderContext = context;
  }

  @Override
  public String getContentType() {
    return null; // Content type depends on the request headers
  }

  @Override
  public void render(Map<String, ?> parameters, HttpServletRequest request, HttpServletResponse response)
      throws Exception {
    String acceptHeader = request.getHeader("Accept");
    boolean renderJson = acceptHeader != null && acceptHeader.contains("application/json");

    // Set content type based on accept headers
    if (renderJson) {
      response.setContentType("application/json;charset=" + this.ui.getContentEncoding(this.renderContext.getTheme())); // AQR-3148
    } else {
      response.setContentType("text/plain;charset=" + this.ui.getContentEncoding(this.renderContext.getTheme())); // AQR-3148
    }

    StringWriter html = new StringWriter();
    HttpSession httpSession = request.getSession();
    String previousHtml = this.ui.getLastHtml(httpSession, this.renderContext);
    this.ui.writeHtml(html, this.page, this.renderContext, httpSession);

    Map<String, String> diffs = this.ui.getHtmlDiff().getDifferences(previousHtml, html.toString());

    JsonWriter result = new JsonWriter(response.getWriter(), false);
    try {
      result.writeObjectStart();
      for (Map.Entry<String, String> diff : diffs.entrySet()) {
        if (LOG.isTraceEnabled()) {
          LOG.trace(String.format("Returning diff for element '%s': %s", diff.getKey(), diff.getValue()));
        } else if (LOG.isDebugEnabled()) {
          LOG.debug(String.format("Returning diff for element '%s'", diff.getKey()));
        }
        result.writeMember(diff.getKey(), diff.getValue());
      }
      result.writeObjectEnd();
    } finally {
      result.close();
    }
  }
}
