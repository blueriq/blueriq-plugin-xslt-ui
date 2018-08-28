package com.aquima.plugin.xslt.controller;

import com.aquima.interactions.foundation.IValueFormatter;
import com.aquima.interactions.foundation.text.StringUtil;
import com.aquima.interactions.foundation.types.EntityValue;
import com.aquima.interactions.framework.renderer.IRuntimeKeyPrinter;
import com.aquima.interactions.portal.IPortalSession;
import com.aquima.interactions.portal.PortalEvent;
import com.aquima.interactions.project.impl.XssSafeValueFormatter;
import com.aquima.plugin.xslt.ui.XsltController;
import com.aquima.web.api.exception.FlowEndedException;
import com.aquima.web.api.model.page.PageEvent;
import com.aquima.web.api.model.page.converters.PageEventConverter;
import com.aquima.web.components.fileupload.configuration.FileUploadConfiguration;
import com.aquima.web.components.fileupload.controller.MultipartRequestWrapper;
import com.aquima.web.components.fileupload.service.FileUploadService;
import com.aquima.web.components.fileupload.service.FileUploadStatus;
import com.aquima.web.components.fileupload.service.IFileDefinition;
import com.aquima.web.components.fileupload.service.PortalSessionWrap;
import com.aquima.web.ui.IRuntimeKeyMapper;
import com.aquima.web.ui.IRuntimeKeyParser;

import com.blueriq.component.api.IAquimaSessionsMap;
import com.blueriq.component.api.annotation.AquimaSessionId;
import com.blueriq.component.api.annotation.ServerContext;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.ModelAndView;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletResponse;

/**
 * Controller for uploading files
 *
 * @author n.van.noorloos
 * @since 9.3
 */
@Controller(value = "XsltFileUploadController")
@RequestMapping({ "/FileUploadHandler.*", "/FileUploadHandler" })
@ServerContext
public class FileUploadController {
  private final IAquimaSessionsMap sessionManager;
  private final FileUploadService uploadService;
  private final XsltController xsltController;
  private final IRuntimeKeyMapper runtimeKeyMapper;

  @Autowired
  public FileUploadController(IAquimaSessionsMap sessionManager, XsltController xsltController,
      FileUploadService uploadService, IRuntimeKeyMapper runtimeKeyMapper) {
    this.sessionManager = sessionManager;
    this.xsltController = xsltController;
    this.uploadService = uploadService;
    this.runtimeKeyMapper = runtimeKeyMapper;
  }

  @RequestMapping(method = RequestMethod.POST)
  public ModelAndView handle(MultipartHttpServletRequest request, HttpServletResponse httpResponse,
      @RequestParam(value = "sessionId") @AquimaSessionId String sessionId,
      @RequestParam(value = "configurationId") String configurationId) throws Exception {

    MultipartRequestWrapper wrapper = new MultipartRequestWrapper(request);
    handleFileUpload(configurationId, sessionId, wrapper.getFiles(), wrapper.getPageEvent());

    return new ModelAndView(xsltController.compose(request, sessionId));
  }

  private void handleFileUpload(String configurationId, String sessionId, List<IFileDefinition> files,
      PageEvent pageEvent) {
    IPortalSession session = sessionManager.getSession(sessionId).getPortalSession();

    FileUploadConfiguration configResult =
        uploadService.retrieveConfiguration(new PortalSessionWrap(session), configurationId);

    // AQ-3710: Store the instances active for the upload container, so we can retrieve which container was active.
    // During the refreshes the container is changed, but the same instances should be active for the new container
    List<EntityValue> activeInstancesForUploadContainer =
        uploadService.getActiveInstancesForUploadContainer(session.getCurrentPage().getElements(), configurationId,
            configResult.getContainerName(), new ArrayList<EntityValue>());

    // AQ-4258: do not lose field values
    handlePageEvent(pageEvent, session);

    IRuntimeKeyPrinter printer = runtimeKeyMapper.getPrinter(session.getCurrentPage());

    FileUploadStatus uploadStatus = uploadService.upload(new PortalSessionWrap(session), configurationId, files,
        activeInstancesForUploadContainer, printer);

    // this is needed because uploading files requires recompose (the profile is changed)
    recomposePage(session);

    setEventButtonKeys(session, configResult, activeInstancesForUploadContainer, uploadStatus);

    handleEvents(session, uploadStatus);

    if (session.getCurrentPage() == null) {
      throw new FlowEndedException();
    }
  }

  private void setEventButtonKeys(IPortalSession session, FileUploadConfiguration configResult,
      List<EntityValue> activeInstancesForUploadContainer, FileUploadStatus uploadStatus) {
    // Obtain new printer to set the correct buttonkeys after the recompose
    IRuntimeKeyPrinter printer = runtimeKeyMapper.getPrinter(session.getCurrentPage());

    uploadService.setEventButtonKeys(uploadStatus, session.getCurrentPage().getElements(),
        configResult.getContainerName(), activeInstancesForUploadContainer, printer);
  }

  private void handlePageEvent(PageEvent pageEvent, IPortalSession session) {
    IValueFormatter defaultFormatter = session.getCurrentLanguage().getDefaultFormatter();
    XssSafeValueFormatter formatter = new XssSafeValueFormatter(defaultFormatter);

    IRuntimeKeyParser parser = runtimeKeyMapper.getParser(session.getCurrentPage());
    PortalEvent portalEvent = PageEventConverter.withFormatter(formatter).toPortalEvent(pageEvent, parser);

    session.handleEvent(portalEvent);
  }

  private void recomposePage(IPortalSession session) {
    session.handleEvent(new PortalEvent());
  }

  private void handleEvents(IPortalSession session, FileUploadStatus uploadStatus) {
    if (!StringUtil.isEmpty(uploadStatus.getButtonKey())) {
      handlePageEvent(new PageEvent(uploadStatus.getButtonKey()), session);
    } else if (!StringUtil.isEmpty(uploadStatus.getUnauthorizedEventButtonKey())) {
      handlePageEvent(new PageEvent(uploadStatus.getUnauthorizedEventButtonKey()), session);
    } else if (!StringUtil.isEmpty(uploadStatus.getFileUploadedEventButtonKey())) {
      handlePageEvent(new PageEvent(uploadStatus.getFileUploadedEventButtonKey()), session);
    }
  }
}
