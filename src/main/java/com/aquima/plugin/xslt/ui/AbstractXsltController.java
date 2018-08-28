package com.aquima.plugin.xslt.ui;

import com.aquima.interactions.composer.IPage;
import com.aquima.interactions.framework.renderer.IRuntimeKeyPrinter;
import com.aquima.interactions.portal.PortalEvent;
import com.aquima.plugin.xslt.util.IXsltPathHelper;
import com.aquima.web.api.exception.FlowEndedException;
import com.aquima.web.ui.IRuntimeKeyMapper;
import com.aquima.web.ui.PageWard;
import com.aquima.web.ui.RenderContext;
import com.aquima.web.util.UrlHelper;

import com.blueriq.component.api.IAquimaSession;
import com.blueriq.component.api.IAquimaSessionsMap;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.context.request.ServletWebRequest;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.View;

import javax.servlet.http.HttpServletRequest;

/**
 * This class is an abstract controller for the UIs based on Xslt.
 * 
 * @author Danny Roest
 * @since 8.0
 */
public abstract class AbstractXsltController {

  private static final Logger LOG = LoggerFactory.getLogger(AbstractXsltController.class);

  private final AbstractXsltUi ui;
  private final IAquimaSessionsMap sessionManager;
  private final IRuntimeKeyMapper runtimeKeyMapper;
  private final IXsltPathHelper helper;

  /**
   * Constructs a new XsltController.
   * 
   * @param renderer the xsltui
   * @param sessionManager the session manager
   * @param helper the XsltRedirectHelper
   * @param runtimeKeyMapper the runtime key mapping strategy to use
   */
  public AbstractXsltController(AbstractXsltUi renderer, IAquimaSessionsMap sessionManager, IXsltPathHelper helper,
      IRuntimeKeyMapper runtimeKeyMapper) {
    ui = renderer;
    this.sessionManager = sessionManager;
    this.helper = helper;
    this.runtimeKeyMapper = runtimeKeyMapper;
  }

  /**
   * The pageName path variable is only for display purposes, the current page from the AquimaSession will always be
   * composed.
   */
  @RequestMapping(path = "/{pageName}.html", method = RequestMethod.GET)
  public View compose(HttpServletRequest request, @RequestParam(value = "sessionId", required = false) String sessionId,
      @PathVariable(value = "pageName") String pageName) {
    return compose(request, sessionId);
  }

  public View compose(HttpServletRequest request, String sessionId) {
    IAquimaSession session = sessionManager.getSession(sessionId);

    IPage currentPage = session.getCurrentPage();
    if (currentPage == null) {
      LOG.warn("No current page available, flow has ended or there are no pages in the flow");
      throw new FlowEndedException();
    }

    IRuntimeKeyPrinter keyPrinter = runtimeKeyMapper.getPrinter(currentPage);

    if (LOG.isDebugEnabled()) {
      LOG.debug(String.format("[compose] page='%s', language='%s', theme='%s', user='%s'",
          session.getCurrentPage() != null ? session.getCurrentPage().getName() : "No page",
          session.getCurrentLanguage().getCode(), session.getTheme(), session.getCurrentUser()));
    }

    RenderContext context = new RenderContext(session, keyPrinter);
    context.setPageWard(PageWard.acquire(request.getSession(), context.getApplicationId(), context.getSessionId()));
    context.setParameter("maxInactiveInterval", request.getSession().getMaxInactiveInterval());
    context.setParameter("contextPath", request.getContextPath());
    context.setParameter("bodyOnly", "true".equals(request.getParameter("bodyOnly")));
    context.setParameter("csrfToken", session.getCsrfToken());

    // full form url can be very useful when Aquima is running in a div for example
    String fullUrl = request.getRequestURL().toString();
    String url = fullUrl.substring(0, fullUrl.lastIndexOf('/') + 1);
    context.setParameter("formUrl", url);

    ui.addDefaultParameters(context);
    addXsltRenderParameters(request, context);

    if ("true".equals(request.getParameter("htmlDiff"))) { // AQUB-882
      return new JsonHtmlDiffView(ui, currentPage, context);
    }

    return new XsltViewRenderer(ui, currentPage, context);
  }

  /**
   * Override this method to add custom render parameters.
   * 
   * @param request the current request
   * @param context the current context
   */
  protected void addXsltRenderParameters(HttpServletRequest request, RenderContext context) {

  }

  @RequestMapping(path = "/{pageName}.html", method = RequestMethod.POST)
  public ModelAndView handle(HttpServletRequest request,
      @RequestParam(value = "sessionId", required = false) String sessionId) throws Exception {
    IAquimaSession session = sessionManager.getSession(sessionId);
    IPage currentPage = session.getCurrentPage();

    PortalEventParser parser = new PortalEventParser(new ServletWebRequest(request), currentPage, runtimeKeyMapper);
    PortalEvent portalEvent = parser.parseRequest(
        PageWard.acquire(request.getSession(), session.getProjectDetails().getId(), session.getSessionId()));

    if (portalEvent != null) {
      session.handleEvent(portalEvent);
    }

    // redirect relatively from servlet path to work under WebSphere .1
    if (session.getCurrentPage() == null) {
      LOG.warn("No current page available, flow has ended!");
      throw new FlowEndedException();
    }

    // for AJAX refreshes
    if ("true".equals(request.getParameter("htmlDiff"))) {
      // AQR-3588 do not redirect: return composed html diffs
      return new ModelAndView(this.compose(request, sessionId, currentPage.getName()));
    }

    // for AJAX refreshes. backwards compatible with 8.x, Html diff should now be used
    if ("true".equals(request.getParameter("bodyOnly"))) {
      // AQR-3588 do not redirect: return composed html
      return new ModelAndView(this.compose(request, sessionId, currentPage.getName()));
    }

    return redirect(session, request);
  }

  public ModelAndView redirect(IAquimaSession session, HttpServletRequest request) {
    return new ModelAndView(UrlHelper.absoluteRedirect(helper.getPagePath(session)));
  }

  @RequestMapping(path = "/{pageName}.html", method = RequestMethod.GET, params = { "flow" })
  public View startFlow(HttpServletRequest request, @RequestParam("flow") String flowName,
      @RequestParam(value = "sessionId", required = false) String sessionId) throws Exception {
    IAquimaSession session = sessionManager.getSession(sessionId);
    session.startFlow(flowName);
    IPage currentPage = session.getCurrentPage();
    return this.compose(request, sessionId, currentPage.getName());
  }

  protected AbstractXsltUi getRenderer() {
    return ui;
  }

  protected IAquimaSessionsMap getSessionManager() {
    return sessionManager;
  }

  protected IRuntimeKeyMapper getRuntimeKeyMapper() {
    return runtimeKeyMapper;
  }

}
