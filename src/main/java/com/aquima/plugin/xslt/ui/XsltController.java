package com.aquima.plugin.xslt.ui;

import com.aquima.plugin.xslt.util.XsltRedirectHelper;
import com.aquima.web.ui.IRuntimeKeyMapper;

import com.blueriq.component.api.IAquimaSessionsMap;
import com.blueriq.component.api.annotation.ServerContext;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

/**
 * This class is controller for the Xslt UI.
 * 
 * @author Danny Roest
 * @since 8.0
 */
@Controller
@RequestMapping("/xslt")
@ServerContext
public class XsltController extends AbstractXsltController {

  /**
   * Constructs a new XsltController.
   * 
   * @param ui the xsltui
   * @param sessionManager the session manager
   * @param helper the XsltRedirectHelper
   * @param runtimeKeyMapper used to map runtime keys to different value
   */
  @Autowired
  public XsltController(XsltUi ui, IAquimaSessionsMap sessionManager, XsltRedirectHelper helper,
      IRuntimeKeyMapper runtimeKeyMapper) {
    super(ui, sessionManager, helper, runtimeKeyMapper);
  }
}
