package com.aquima.plugin.xslt.controller;

import com.aquima.interactions.composer.ImageType;
import com.aquima.interactions.foundation.text.StringUtil;
import com.aquima.interactions.framework.handler.image.ImageActionHandler;
import com.aquima.interactions.framework.handler.image.ImageActionHandlerResult;
import com.aquima.interactions.portal.IPortalSession;

import com.blueriq.component.api.IAquimaSession;
import com.blueriq.component.api.IAquimaSessionsMap;
import com.blueriq.component.api.annotation.ServerContext;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * This controller is used to retrieve images that are defined in an Aquima application.
 * 
 * @author Jon van Leuven
 * @since 8.0
 */
@Controller(value = "DeprecatedImageController")
@RequestMapping({ "/Image.*", "/Image" })
@ServerContext
public class ImageController {

  private static final Logger LOG = LoggerFactory.getLogger(ImageController.class);
  @Autowired
  private IAquimaSessionsMap sessionManager;

  /**
   * This method is invoked whenever an image should be retrieved.
   * 
   * @param httpRequest The HTTP request that caused the invocation of this controller.
   * @param httpResponse The HTTP response where the style resource should be written to.
   * 
   * @throws Exception This exception is thrown when the image could not be retrieved.
   */
  @RequestMapping(method = RequestMethod.GET)
  public void get(HttpServletRequest httpRequest, HttpServletResponse httpResponse,
      @RequestParam(value = "sessionId", required = false) String sessionId,
      @RequestParam(value = "name", required = false) String name,
      @RequestParam(value = "key", required = false) String key) throws Exception {
    if (StringUtil.isEmpty(name)) {
      LOG.warn("Unable to retrieve with empty name");
      return;
    }

    IAquimaSession mainSession = this.sessionManager.getSession(sessionId);
    IPortalSession session = mainSession.getPortalSession();

    outputImage(session, name, key, httpResponse);
  }

  private static void outputImage(IPortalSession session, String imageName, String key,
      HttpServletResponse httpResponse) throws Exception {

    Map<String, String> parameters = new HashMap<String, String>(1);
    parameters.put("imageName", imageName);
    if (key != null) {
      parameters.put("key", key);
    }
    ImageActionHandlerResult data = (ImageActionHandlerResult) session
        .executeInlineAction(new ImageActionHandler(session.getCurrentPage()), parameters);

    // Manually override Spring's default caching headers
    // If caching is disabled, the download link will not work over SSL
    httpResponse.setHeader("Cache-control", "must-revalidate");
    httpResponse.setHeader("Pragma", "public");
    httpResponse.setDateHeader("Expires", 1);

    if (data.getImageType() == ImageType.SVG)
      httpResponse.setContentType("image/svg+xml");
    else if (data.getImageType() == ImageType.JPEG)
      httpResponse.setContentType("image/jpeg");
    else
      httpResponse.setContentType("image/*");

    httpResponse.setContentLength(data.getImageData().length);
    httpResponse.getOutputStream().write(data.getImageData());
  }
}
