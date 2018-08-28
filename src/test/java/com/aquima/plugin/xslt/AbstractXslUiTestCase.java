package com.aquima.plugin.xslt;

import static org.junit.Assert.assertFalse;

import com.aquima.interactions.composer.IPage;
import com.aquima.interactions.foundation.DataType;
import com.aquima.interactions.foundation.Version;
import com.aquima.interactions.foundation.text.ILanguage;
import com.aquima.interactions.foundation.utility.SystemProperties;
import com.aquima.interactions.framework.renderer.page.r6.PageR6XmlRenderer;
import com.aquima.interactions.portal.ApplicationID;
import com.aquima.interactions.test.templates.ApplicationTemplate;
import com.aquima.interactions.test.templates.composer.ContainerTemplate;
import com.aquima.interactions.test.templates.project.ProjectTemplate;
import com.aquima.interactions.test.templates.session.PortalSessionTestFacade;
import com.aquima.plugin.xslt.ui.DynamicXsltLoader;
import com.aquima.plugin.xslt.ui.XsltConfiguration;
import com.aquima.plugin.xslt.ui.XsltUi;
import com.aquima.plugin.xslt.util.XsltLinkHelper;
import com.aquima.plugin.xslt.util.XsltRedirectHelper;
import com.aquima.web.boot.ServerConfig;
import com.aquima.web.config.CacheKeyService;
import com.aquima.web.config.ResourceUrlConfiguration;
import com.aquima.web.config.properties.WebResourcesProperties;
import com.aquima.web.ui.RenderContext;

import org.apache.commons.io.FileUtils;
import org.junit.After;
import org.junit.Before;
import org.junit.Test;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;
import org.springframework.web.util.UriComponentsBuilder;

import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.io.StringWriter;
import java.util.Collections;

/**
 * TestCase for the AbstractXsltUI.
 *
 * @author Danny Roest
 * @since 9.0
 */
public class AbstractXslUiTestCase {

  private static File xsltFolder;
  private static File dynamicFolder;
  private static final File USER_HOME = new File(System.getProperty("user.home"));
  @Mock
  private WebResourcesProperties webResourcesProperties;

  @InjectMocks
  private CacheKeyService cacheKeyService;

  @Mock
  private ResourceUrlConfiguration resourceUrlConfiguration;

  @Before
  public void setUp() throws Exception {
    MockitoAnnotations.initMocks(this);
    SystemProperties.setConfigurationLocation(USER_HOME);
    xsltFolder = new File(SystemProperties.getConfigurationLocation(), "temp");
    dynamicFolder = new File(xsltFolder, "dynamic");
    cleanup();
    xsltFolder.mkdir();
    dynamicFolder.mkdir();
  }

  @After
  public void cleanup() throws IOException {
    FileUtils.deleteDirectory(xsltFolder);
  }

  /**
   * This method tests whether the AbstractAquimaUI loads the xslts correctly.
   *
   * @throws Exception when something went wrong
   */
  @Test
  public void renderingWithDynamicStylesheets() throws Exception {
    // Setup
    ApplicationID appId = new ApplicationID("carinsurance", Version.valueOf("1.0"));
    ILanguage language = ProjectTemplate.DEFAULT_LANGUAGE.toLanguage();

    ApplicationTemplate app = new ApplicationTemplate();
    app.getMetaModel().addEntity("person", null, true).addAttribute("name", DataType.STRING, false);
    ContainerTemplate container = app.getComposer().addPage("page").addContainer("container1").getContainer();
    container.addButton("button");
    container.addAsset("asset");
    container.addField("person.name");

    app.getFlowEngine().addFlow("start").addPage("page");

    PortalSessionTestFacade session = new PortalSessionTestFacade(app);
    session.startFlow("start");

    PageR6XmlRenderer renderer = PageR6XmlRenderer.createFor(Collections.emptyMap(), true, false, true, false);
    XsltConfiguration config = XsltConfiguration.createInstance("com/aquima/web/ui/xslt/", "xsltuitest.xsl",
        new String[] { "theme1", "theme2" }, "temp/dynamic", null, null, null, null, null, null, null, null, null);

    IPage page = session.getCurrentPage();
    RenderContext context = new RenderContext(appId, language, "1", "default", page.getName(), "/war", null);
    XsltUi ui =
        new XsltUi(renderer, config, getRedirectHelper(), getLinkHelper(), resourceUrlConfiguration, cacheKeyService);

    // SUT
    DynamicXsltLoader xsltLoader = new DynamicXsltLoader();

    // add the dynamic xslts
    // Register an xslt
    xsltLoader.registerXslt("com/aquima/web/ui/xslt/xsltuitest_register.xsl"); // renders the button

    // create dynamic xslts on file system
    // 1.xsl should only render the field, because the content should be rendered by 2.xsl because of the ordering
    createXsltInAquimaHome("1.xsl",
        "<xsl:template match='field'>OK_DYNAMIC </xsl:template><xsl:template match='content'>FAIL</xsl:template>");
    createXsltInAquimaHome("2.xsl", "<xsl:template match='content'>OK_ORDERING </xsl:template>");

    ui.setDynamicXsltLoader(xsltLoader);
    ui.afterPropertiesSet();

    // Verify
    StringWriter w = new StringWriter();
    ui.writeHtml(w, page, context);
    assertFalse(w.toString().contains("FAIL"));
  }

  public void createXsltInAquimaHome(String xslFileName, String xslBody) throws IOException {

    String xsl = "<xsl:stylesheet version='1.0' xmlns:xsl='http://www.w3.org/1999/XSL/Transform' >";
    xsl += xslBody;
    xsl += "</xsl:stylesheet>";
    FileWriter writer;
    try {
      writer = new FileWriter(new File(dynamicFolder, xslFileName));
      writer.write(xsl);
      writer.close();
    } catch (IOException e) {
      e.printStackTrace();
    }
  }

  private XsltRedirectHelper getRedirectHelper() {
    return new XsltRedirectHelper(UriComponentsBuilder.fromPath(ServerConfig.SERVLET_PATH));
  }

  private XsltLinkHelper getLinkHelper() {
    return new XsltLinkHelper(UriComponentsBuilder.fromPath(ServerConfig.SERVLET_PATH));
  }
}
