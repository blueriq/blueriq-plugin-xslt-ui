package com.aquima.plugin.xslt;

import com.aquima.interactions.composer.IPage;
import com.aquima.interactions.foundation.Version;
import com.aquima.interactions.foundation.io.IResource;
import com.aquima.interactions.foundation.text.ILanguage;
import com.aquima.interactions.framework.renderer.page.r6.PageR6XmlRenderer;
import com.aquima.interactions.portal.ApplicationID;
import com.aquima.interactions.test.templates.ApplicationExportTemplate;
import com.aquima.interactions.test.templates.ResourceManagerTemplate;
import com.aquima.interactions.test.templates.project.ProjectTemplate;
import com.aquima.interactions.test.templates.session.PortalSessionTestFacade;
import com.aquima.interactions.test.templates.session.RequestTemplate;
import com.aquima.plugin.xslt.ui.AbstractXsltUi;
import com.aquima.plugin.xslt.ui.TidyParser;
import com.aquima.plugin.xslt.ui.XsltConfiguration;
import com.aquima.plugin.xslt.ui.XsltUi;
import com.aquima.plugin.xslt.util.XsltLinkHelper;
import com.aquima.plugin.xslt.util.XsltRedirectHelper;
import com.aquima.web.boot.ServerConfig;
import com.aquima.web.config.CacheKeyService;
import com.aquima.web.config.ResourceUrlConfiguration;
import com.aquima.web.config.properties.WebResourcesProperties;
import com.aquima.web.ui.RenderContext;

import org.junit.After;
import org.junit.Assert;
import org.junit.Before;
import org.junit.Test;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.util.UriComponentsBuilder;
import org.w3c.tidy.TidyMessage;
import org.w3c.tidy.TidyMessage.Level;
import org.w3c.tidy.TidyMessageListener;

import java.io.StringReader;
import java.io.StringWriter;
import java.util.ArrayList;
import java.util.HashMap;

/**
 * Testcase that validates the html created by the xslt UI.
 * 
 * @author Jon van Leuven
 * @since 9.0
 */
public class XsltTestCase {

  private static final Logger LOG = LoggerFactory.getLogger(XsltTestCase.class);
  private PortalSessionTestFacade session;
  private AbstractXsltUi ui;

  @Mock
  private WebResourcesProperties webResourcesProperties;

  @InjectMocks
  private CacheKeyService cacheKeyService;

  @Mock
  private ResourceUrlConfiguration resourceUrlConfiguration;

  @Before
  public void setUp() throws Exception {
    MockitoAnnotations.initMocks(this);
    PageR6XmlRenderer renderer = PageR6XmlRenderer.createFor(new HashMap(), true, false, true, false);
    ui = new XsltUi(renderer, XsltConfiguration.createInstance("UI/xslt", "web.xsl", "default"), getRedirectHelper(),
        getLinkHelper(), resourceUrlConfiguration, cacheKeyService);
    ui.setResourceManager(new ResourceManagerTemplate());
    ui.afterPropertiesSet(); // load stylesheets
  }

  @After
  public void tearDown() {
    if (session != null) {
      session.close();
      session = null;
    }
  }

  /**
   * This testcase verifies that the html rendered for the carinsurance is valid.
   */
  @Test
  public void testCarInsurance() {
    // setup
    IResource export = ResourceManagerTemplate.getTestResource("CarInsurance.zip");
    ApplicationExportTemplate app = ApplicationExportTemplate.createWithR8ZipExport(export);
    session = new PortalSessionTestFacade(app);

    // 1
    session.startFlow("CarQuote");
    Assert.assertEquals("DriverData", session.getCurrentPage(false).getName());
    validateHtml(renderHtml(session.getCurrentPage(false)));

    // 2
    session.handleButtonEvent("next", null);
    Assert.assertEquals("DriverData", session.getCurrentPage(false).getName());
    validateHtml(renderHtml(session.getCurrentPage(false)));

    // 3
    session.handleButtonEvent("next",
        createInputFirstPage("1970-01-01", "11", "11", "1", "false", "private", "k2", "1000AA"));
    Assert.assertEquals("CarData", session.getCurrentPage(false).getName());
    validateHtml(renderHtml(session.getCurrentPage(false)));

    // 4
    session.handleButtonEvent("next",
        createInputSecondPage("CarModel|CarModel.VolvoV50|VolvoV50", "p", "class_1", "ve_150", "y", "y", "y", "y"));
    Assert.assertEquals("InsuranceAccepted", session.getCurrentPage(false).getName());
    validateHtml(renderHtml(session.getCurrentPage(false)), 0);
  }

  private static RequestTemplate createInputFirstPage(String birthdate, String yearsInsured, String driversLicense,
      String noClaim, String disqualified, String carUse, String mileage, String zipCode) {
    RequestTemplate result = new RequestTemplate();
    result.addFieldValue("Driver.date_of_birth", birthdate);
    result.addFieldValue("Driver.years_insured", yearsInsured);
    result.addFieldValue("Driver.years_driverslicence", driversLicense);
    result.addFieldValue("Driver.years_no_claim_discount", noClaim);
    result.addFieldValue("Driver.disqualified", disqualified);
    result.addFieldValue("Driver.car_use", carUse);
    result.addFieldValue("Driver.mileage", mileage);
    result.addFieldValue("Driver.zip_code", zipCode);
    return result;
  }

  private static RequestTemplate createInputSecondPage(String carModel, String fuel, String securityDevice,
      String voluntaryExcess, String comprehensive, String collision, String additionalPassengers,
      String legalProtection) {
    RequestTemplate result = new RequestTemplate();
    result.addFieldValue("Car.model", carModel);
    result.addFieldValue("Car.fuel", fuel);
    result.addFieldValue("Car.security_device", securityDevice);
    result.addFieldValue("Cover.VoluntaryExcess", voluntaryExcess);
    result.addFieldValue("Cover.Comprehensive", comprehensive);
    result.addFieldValue("Cover.Collision", collision);
    result.addFieldValue("Cover.AdditionalPassengers", additionalPassengers);
    result.addFieldValue("Cover.LegalProtection", legalProtection);
    return result;
  }

  private static void validateHtml(String renderHtml) {
    validateHtml(renderHtml, 0);
  }

  private static void validateHtml(String renderHtml, int expectedWarnings) {
    TidyMessages result = new TidyMessages();
    new TidyParser(result).parseHtml(new StringReader(renderHtml));
    result.logMessages(LOG);
    try {
      Assert.assertEquals("No errors expected", 0, result.getErrorCount());
      Assert.assertEquals("No warnings expected", expectedWarnings, result.getWarningCount());
    } catch (AssertionError e) {
      String[] split = renderHtml.split("\n");
      for (int i = 0; i < split.length; i++) {
        LOG.info(String.format("%3d %s", i + 1, split[i].substring(0, split[i].length() - 1)));
      }
      throw e;
    }
  }

  private String renderHtml(IPage page) {
    StringWriter result = new StringWriter();
    ApplicationID appId = new ApplicationID("carinsurance", Version.valueOf("1.0"));
    ILanguage language = ProjectTemplate.DEFAULT_LANGUAGE.toLanguage();
    ui.writeHtml(result, page, new RenderContext(appId, language, "1", "default", page.getName(), "/war", null));
    return result.toString();
  }

  private XsltRedirectHelper getRedirectHelper() {
    return new XsltRedirectHelper(UriComponentsBuilder.fromPath(ServerConfig.SERVLET_PATH));
  }

  private XsltLinkHelper getLinkHelper() {
    return new XsltLinkHelper(UriComponentsBuilder.fromPath(ServerConfig.SERVLET_PATH));
  }
}


class TidyMessages implements TidyMessageListener {

  private final ArrayList<TidyMessage> messages = new ArrayList<>();

  public int getErrorCount() {
    return filter(TidyMessage.Level.ERROR).size();
  }

  public int getWarningCount() {
    return filter(TidyMessage.Level.WARNING).size();
  }

  public void logMessages(Logger log) {
    for (TidyMessage m : messages) {
      if (m.getLine() > 0 && m.getColumn() > 0) {
        log.info(String.format("%s: %s (%s, %s)", m.getLevel().toString().toUpperCase(), m.getMessage(), m.getLine(),
            m.getColumn()));
      } else {
        log.info(String.format("%s: %s", m.getLevel().toString().toUpperCase(), m.getMessage()));
      }
    }
  }

  private ArrayList<TidyMessage> filter(Level level) {
    ArrayList<TidyMessage> result = new ArrayList<>();
    for (TidyMessage m : messages) {
      if (m.getLevel() == level) {
        result.add(m);
      }
    }
    return result;
  }

  @Override
  public void messageReceived(TidyMessage message) {
    messages.add(message);
  }

}
