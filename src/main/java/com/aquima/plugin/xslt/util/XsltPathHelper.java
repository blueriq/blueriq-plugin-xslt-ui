package com.aquima.plugin.xslt.util;

import com.aquima.plugin.xslt.ui.XsltController;

import com.blueriq.component.api.IAquimaSession;

import org.springframework.web.servlet.mvc.method.annotation.MvcUriComponentsBuilder;
import org.springframework.web.util.UriComponentsBuilder;

public class XsltPathHelper implements IXsltPathHelper {

  private final UriComponentsBuilder base;

  public XsltPathHelper(UriComponentsBuilder base) {
    this.base = base;
  }

  @Override
  public final String getPagePath(IAquimaSession aquimaSession) {
    try {
      XsltController controller = MvcUriComponentsBuilder.on(XsltController.class);
      controller.compose(null, aquimaSession.getSessionId(), aquimaSession.getCurrentPage().getName());
      return MvcUriComponentsBuilder.fromMethodCall(base, controller).build().toUriString();
    } catch (Exception ex) {
      throw new IllegalStateException("Could not build XSLT page path", ex);
    }
  }

  @Override
  public final String getXsltUiPath(String aquimaSessionId) {
    try {
      XsltController controller = MvcUriComponentsBuilder.on(XsltController.class);
      controller.compose(null, aquimaSessionId, "start");
      return MvcUriComponentsBuilder.fromMethodCall(base, controller).build().toUriString();
    } catch (Exception ex) {
      throw new IllegalStateException("Could not build XSLT UI path", ex);
    }
  }
}
