package com.aquima.plugin.xslt;

import static org.junit.Assert.assertTrue;

import com.aquima.interactions.composer.model.Asset;
import com.aquima.interactions.composer.model.Button;
import com.aquima.interactions.composer.model.ComposerErrorMessage;
import com.aquima.interactions.composer.model.Container;
import com.aquima.interactions.composer.model.Element;
import com.aquima.interactions.composer.model.Field;
import com.aquima.interactions.composer.model.FieldValidation;
import com.aquima.interactions.composer.model.Page;
import com.aquima.interactions.composer.model.TextElement;
import com.aquima.interactions.composer.model.TextItem;
import com.aquima.interactions.composer.model.TextValueNode;
import com.aquima.interactions.foundation.DataType;
import com.aquima.interactions.foundation.Version;
import com.aquima.interactions.foundation.text.MultilingualText;
import com.aquima.interactions.foundation.types.StringValue;
import com.aquima.interactions.framework.renderer.IXmlRenderer;
import com.aquima.interactions.framework.renderer.page.r6.PageR6XmlRenderer;
import com.aquima.interactions.portal.ApplicationID;
import com.aquima.interactions.test.templates.project.ProjectTemplate;
import com.aquima.plugin.xslt.ui.XsltConfiguration;
import com.aquima.plugin.xslt.ui.XsltUi;
import com.aquima.plugin.xslt.util.XsltLinkHelper;
import com.aquima.plugin.xslt.util.XsltRedirectHelper;
import com.aquima.web.boot.ServerConfig;
import com.aquima.web.config.CacheKeyService;
import com.aquima.web.config.ResourceUrlConfiguration;
import com.aquima.web.config.properties.WebResourcesProperties;
import com.aquima.web.ui.RenderContext;

import org.junit.Before;
import org.junit.Test;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;
import org.springframework.web.util.UriComponentsBuilder;

import java.io.StringWriter;
import java.util.HashMap;

/**
 * This test case verifies that (XSS) profile values are escaped correct when rendered via the Xslt UI.
 * 
 * @author Jon van Leuven
 * @since 8.4
 */
public class XssTestCase {
  @Mock
  private WebResourcesProperties webResourcesProperties;

  @InjectMocks
  private CacheKeyService cacheKeyService;

  @Mock
  private ResourceUrlConfiguration resourceUrlConfiguration;

  @Before
  public void setUp() throws Exception {
    MockitoAnnotations.initMocks(this);
  }

  /**
   * This testcase verifies that an asset that may contain TSL (that may contain profile values) are escaped.
   */
  @Test
  public void renderAsset() throws Exception {
    Asset element = new Asset("test", "type", new MultilingualText("<script>alert();</script>"));

    String result = renderHtml(element);

    assertTrue(result.contains("&lt;script&gt;alert();&lt;/script&gt;"));
  }

  /**
   * This testcase verifies that the explain, question, message and validation of a field that may contain TSL (that may
   * contain profile values) are escaped.
   */
  @Test
  public void renderField() throws Exception {
    Field element = new Field("test", DataType.STRING, false, new MultilingualText("<script>alert(1);</script>"),
        new MultilingualText("<script>alert(2);</script>"));
    element.addMessage(new ComposerErrorMessage("test", new MultilingualText("<script>alert(3);</script>")));
    element.addValidation(
        new FieldValidation("type", false, true, new MultilingualText("<script>alert(4);</script>"), null));

    String result = renderHtml(element);

    assertTrue(result.contains("&lt;script&gt;alert(1);&lt;/script&gt;"));
    assertTrue(result.contains("&lt;script&gt;alert(2);&lt;/script&gt;"));
    assertTrue(result.contains("&lt;script&gt;alert(3);&lt;/script&gt;"));
    // not rendered to html assertTrue( result.contains("&lt;script&gt;alert(4);&lt;/script&gt;") );
  }

  /**
   * This testcase verifies that the displaytext of a container that may contain TSL (that may contain profile values)
   * are escaped.
   */
  @Test
  public void renderContainer() throws Exception {
    Container element = new Container("test");
    element.setDisplayText(new MultilingualText("<script>alert();</script>"));

    String result = renderHtml(element);

    assertTrue(result.contains("&lt;script&gt;alert();&lt;/script&gt;"));
  }

  /**
   * This testcase verifies that the caption of a button that may contain TSL (that may contain profile values) are
   * escaped.
   */
  @Test
  public void renderButton() throws Exception {
    Button element = new Button("test", new MultilingualText("test\" onclick=alert();"));

    String result = renderHtml(element);

    assertTrue(result.contains(">test\" onclick=alert();"));
  }

  /**
   * This testcase verifies that the values of a text item that contain profile value(s) are escaped.
   */
  @Test
  public void renderTextItem() throws Exception {
    TextItem element = new TextItem("test");
    TextElement textElement = new TextValueNode(new StringValue("<test>alert();</test>"));
    element.addNode(textElement, ProjectTemplate.DEFAULT_LANGUAGE.toLanguage());

    String result = renderHtml(element);

    assertTrue(result.contains("&lt;test&gt;alert();&lt;/test&gt;"));
  }

  private String renderHtml(Element element) throws Exception {
    IXmlRenderer renderer = PageR6XmlRenderer.createFor(new HashMap(), false, false, true, true);
    XsltConfiguration config = XsltConfiguration.createInstance("UI/xslt", "web.xsl", "default");
    XsltUi ui =
        new XsltUi(renderer, config, getRedirectHelper(), getLinkHelper(), resourceUrlConfiguration, cacheKeyService);
    ui.resetCache();
    Page page = new Page("name");
    page.addElement(element);
    StringWriter result = new StringWriter();
    RenderContext ctx = new RenderContext(new ApplicationID("test", Version.valueOf("1.0")),
        ProjectTemplate.DEFAULT_LANGUAGE.toLanguage(), "id", "default", page.getName(), "http:/blaa", null);
    ui.writeHtml(result, page, ctx);
    StringWriter xml = new StringWriter();
    ui.writeSource(page, ctx, xml);

    return result.toString();
  }

  private XsltRedirectHelper getRedirectHelper() {
    return new XsltRedirectHelper(UriComponentsBuilder.fromPath(ServerConfig.SERVLET_PATH));
  }

  private XsltLinkHelper getLinkHelper() {
    return new XsltLinkHelper(UriComponentsBuilder.fromPath(ServerConfig.SERVLET_PATH));
  }
}
