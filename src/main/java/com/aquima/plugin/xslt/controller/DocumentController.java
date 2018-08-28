package com.aquima.plugin.xslt.controller;

import com.aquima.interactions.foundation.exception.InvalidStateException;
import com.aquima.interactions.framework.handler.document.DocumentResult;
import com.aquima.interactions.framework.handler.document.GenerateDocumentHandler;
import com.aquima.interactions.portal.IPortalSession;

import com.blueriq.component.api.IAquimaSession;
import com.blueriq.component.api.IAquimaSessionsMap;
import com.blueriq.component.api.annotation.ServerContext;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.context.request.WebRequest;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletResponse;

/**
 * This controller is used to generate documents.
 * <p>
 * Requires a license and a commercial version of Aquima.
 *
 * @author O. Kerpershoek
 * @since 6.0
 */
@Controller(value = "DeprecatedDocumentController")
@RequestMapping({ "/Document.*", "/Document" })
@ServerContext
public class DocumentController {

  @Autowired
  private IAquimaSessionsMap sessionManager;

  /**
   * This method is invoked whenever a document should be generated.
   *
   * @param httpRequest The HTTP request that caused the invocation of this controller.
   * @param httpResponse The HTTP response where the style resource should be written to.
   *
   * @throws Exception This exception is thrown when the document could not be created.
   */
  @RequestMapping(method = RequestMethod.GET)
  public void get(WebRequest httpRequest, HttpServletResponse httpResponse,
      @RequestParam(value = "sessionId", required = false) String sessionId) throws Exception {

    IAquimaSession mainSession = this.sessionManager.getSession(sessionId);
    IPortalSession session = mainSession.getPortalSession();

    outputDocument(session, httpRequest, httpResponse);
  }

  /**
   * This method is generates a document and outputs it to the browser.
   *
   * @param session The current portal session.
   * @param httpRequest The HTTP request that caused the invocation of this controller.
   * @param httpResponse The HTTP response where the style resource should be written to.
   *
   * @throws Exception This exception is thrown when the document could not be created.
   */
  private static void outputDocument(IPortalSession session, WebRequest httpRequest, HttpServletResponse httpResponse)
      throws Exception {
    if (httpRequest.getParameter("document-name") == null && httpRequest.getParameter("page-name") == null) {
      throw new InvalidStateException(
          "Unable to create a document, missing request parameter, 'document-name' or 'page-name' is mandatory");
    }
    Map<String, String> parameters = new HashMap<String, String>();
    if (httpRequest.getParameter("document-name") != null) {
      parameters.put("document-name", httpRequest.getParameter("document-name"));
    }
    if (httpRequest.getParameter("page-name") != null) {
      parameters.put("page-name", httpRequest.getParameter("page-name"));
    }
    parameters.put("output-format", httpRequest.getParameter("document-type"));
    parameters.put("language-code", session.getCurrentLanguage().getCode());

    DocumentResult document = (DocumentResult) session.executeAction(GenerateDocumentHandler.NAME, parameters);

    // Manually override Spring's default caching headers
    // If caching is disabled, the download link will not work over SSL
    httpResponse.setHeader("Cache-control", "must-revalidate");
    httpResponse.setHeader("Pragma", "public");
    httpResponse.setDateHeader("Expires", 1);

    httpResponse.setHeader("Content-disposition",
        ("true".equals(httpRequest.getParameter("document-saveas")) ? "attachment" : "inline") + "; filename="
            + document.getName() + "." + document.getOutputFormat().getExtension());
    String contentType = document.getOutputFormat().getContentType();
    if (contentType != null) {
      httpResponse.setContentType(contentType);
    }
    httpResponse.setContentLength(document.getContents().length);
    httpResponse.getOutputStream().write(document.getContents());
  }
}
