package com.aquima.plugin.xslt.controller;

import com.aquima.interactions.portal.IPortalSession;
import com.aquima.web.api.service.SessionService;
import com.aquima.web.components.filedownload.controller.FileDownloadResponseUtil;
import com.aquima.web.components.filedownload.service.FileDownloadResult;
import com.aquima.web.components.filedownload.service.FileDownloadService;

import com.blueriq.component.api.IAquimaSessionsMap;
import com.blueriq.component.api.annotation.ServerContext;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import java.io.IOException;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Controller for downloading files
 * 
 * @author m.naberink
 * @since 9.3
 */
@Controller(value = "XsltFileDownloadController")
@RequestMapping({ "/FileDownloadController.*", "/FileDownloadController" })
@ServerContext
public class FileDownloadController {

  private final IAquimaSessionsMap sessionManager;
  private final FileDownloadService fileDownloadService;
  private final SessionService sessionService;

  @Autowired
  public FileDownloadController(IAquimaSessionsMap sessionManager, FileDownloadService contentDownloadService,
      SessionService sessionService) {
    this.sessionManager = sessionManager;
    this.fileDownloadService = contentDownloadService;
    this.sessionService = sessionService;
  }

  @RequestMapping(method = RequestMethod.GET)
  public void get(HttpServletRequest request, HttpServletResponse httpResponse,
      @RequestParam("sessionId") String sessionId, @RequestParam("configurationId") String configurationId)
      throws IOException {

    IPortalSession session = this.sessionManager.getSession(sessionId).getPortalSession();

    FileDownloadResult fileDownloadResult = this.fileDownloadService.retrieveFile(session, configurationId);
    FileDownloadResponseUtil.configureResponse(session, sessionService, httpResponse, fileDownloadResult);

  }

  @RequestMapping(value = "/checkauthorization", method = RequestMethod.GET)
  public void checkAuthorization(HttpServletRequest request, HttpServletResponse httpResponse,
      @RequestParam("sessionId") String sessionId, @RequestParam("configurationId") String configurationId)
      throws IOException {

    IPortalSession session = this.sessionManager.getSession(sessionId).getPortalSession();
    if (this.fileDownloadService.isAuthorized(session, configurationId)) {
      FileDownloadResponseUtil.configureIsAuthorizedResponse(session, httpResponse);
    } else {
      FileDownloadResponseUtil.configureIsUnauthorizedResponse(session, httpResponse);
    }
  }

}
