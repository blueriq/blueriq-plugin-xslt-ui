package com.aquima.plugin.xslt;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.fail;

import com.aquima.interactions.foundation.utility.EncodingUtil;
import com.aquima.interactions.test.templates.ResourceManagerTemplate;
import com.aquima.plugin.xslt.ui.HtmlDiff;
import com.aquima.plugin.xslt.ui.HtmlDiffClassNameHandler;

import org.custommonkey.xmlunit.XMLAssert;
import org.junit.Assert;
import org.junit.Test;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.w3c.dom.Node;

import java.util.Map;

/**
 * Test case for the Html Diff class.
 * 
 * @author Danny Roest
 * @author Jon van Leuven
 * @since 9.0
 */
public class HtmlDiffTestCase {

  private static final Logger LOG = LoggerFactory.getLogger(HtmlDiffTestCase.class);

  @Test
  public void noDiff() throws Exception {
    // Setup
    String before = "<html><body><div id='1'>old</div></body></html>";
    String after = "<html><body><div id='1'>old</div></body></html>";

    // SUT
    Map<String, String> differences = new HtmlDiff().getDifferences(before, after);

    // Verify
    assertEquals(0, differences.size());
  }

  @Test
  public void simpleDiff() throws Exception {
    // Setup
    String before = "<html><body><div id='oNe'>old</div></body></html>";
    String after = "<html><body><div id='oNe'>new</div></body></html>";

    // SUT
    Map<String, String> differences = new HtmlDiff().getDifferences(before, after);

    // Verify
    assertEquals(1, differences.size());
    XMLAssert.assertXMLEqual("<div id=\"oNe\">new</div>", differences.get("oNe"));
  }

  @Test
  public void simpleMultipleDiffs() throws Exception {
    // Setup
    String before = "<html><body><div id='1'>old</div>foo<div id='2'>old2</div></body></html>";
    String after = "<html><body><div id='1'>new</div>foo<div id='2'>new2</div></body></html>";

    // SUT
    Map<String, String> differences = new HtmlDiff().getDifferences(before, after);

    // Verify
    assertEquals(2, differences.size());
    XMLAssert.assertXMLEqual("<div id=\"1\">new</div>", differences.get("1"));
    XMLAssert.assertXMLEqual("<div id=\"2\">new2</div>", differences.get("2"));
  }

  @Test
  public void simpleNestedDiffs() throws Exception {
    // Setup
    String before = "<html><body><div id='1' value='old'><div id='2'>old</div></div></body></html>";
    String after = "<html><body><div id='1' value='new'><div id='2'>new</div></div></body></html>";

    // SUT
    Map<String, String> differences = new HtmlDiff().getDifferences(before, after);

    // Verify
    assertEquals(1, differences.size());
    XMLAssert.assertXMLEqual("<div id=\"1\" value=\"new\"><div id=\"2\">new</div></div>", differences.get("1"));
  }

  @Test
  public void changedAttributeValue() throws Exception {
    // Setup
    String before = "<html><body><div id='1' name='old'/></body></html>";
    String after = "<html><body><div id='1' name='new'/></body></html>";

    // SUT
    Map<String, String> differences = new HtmlDiff().getDifferences(before, after);

    // Verify
    assertEquals(1, differences.size());
    XMLAssert.assertXMLEqual("<div id=\"1\" name=\"new\"/>", differences.get("1"));
  }

  @Test
  public void elementRemoved() throws Exception {
    // Setup
    String before = "<div id='1'><span>text</span><div id='2'>byebye</div></div>";
    String after = "<div id='1'><span>text</span></div>";

    // SUT
    Map<String, String> differences = new HtmlDiff().getDifferences(before, after);

    // Verify
    this.logDiffs(differences);
    assertEquals(1, differences.size());
    XMLAssert.assertXMLEqual("<div id=\"1\"><span>text</span></div>", differences.get("1"));
  }

  @Test
  public void oneOfTheChildrenRemoved() throws Exception {
    // Setup
    String before = "<div id='1'><span>text</span><div id='2'>byebye</div><span>othertext</span></div>";
    String after = "<div id='1'><span>text</span><span>othertext</span></div>";

    // SUT
    Map<String, String> differences = new HtmlDiff().getDifferences(before, after);

    // Verify
    this.logDiffs(differences);
    assertEquals(1, differences.size());
    XMLAssert.assertXMLEqual("<div id=\"1\"><span>text</span><span>othertext</span></div>", differences.get("1"));
  }

  @Test
  public void simpleTextUpdated() throws Exception {
    // Setup
    String before = "<div id='1'>old</div>";
    String after = "<div id='1'>new</div>";

    // SUT
    Map<String, String> differences = new HtmlDiff().getDifferences(before, after);

    // Verify
    this.logDiffs(differences);
    assertEquals(1, differences.size());
    XMLAssert.assertXMLEqual("<div id=\"1\">new</div>", differences.get("1"));
  }

  @Test
  public void childTextUpdated() throws Exception {
    // Setup
    String before = "<div id='1'><span>old text<span></div>";
    String after = "<div id='1'><span>new text</span></div>";

    // SUT
    Map<String, String> differences = new HtmlDiff().getDifferences(before, after);

    // Verify
    this.logDiffs(differences);
    assertEquals(1, differences.size());
    XMLAssert.assertXMLEqual("<div id=\"1\"><span>new text</span></div>", differences.get("1"));
  }

  @Test
  public void textRemoved() throws Exception {
    // Setup
    String before = "<div id='1'>foo<div>old<div id=\"2\">bar</div><div></div>";
    String after = "<div id='1'>foo<div><div id=\"2\">bar</div></div></div>";

    // SUT
    Map<String, String> differences = new HtmlDiff().getDifferences(before, after);

    // Verify
    assertEquals(1, differences.size());
    XMLAssert.assertXMLEqual("<div id=\"1\">foo<div><div id=\"2\">bar</div></div></div>", differences.get("1"));
  }

  @Test
  public void onlyIdChanged() throws Exception {
    // Setup
    String before = "<html><body><div id='aquima'><div id='1'>foo</div></div></body></html>";
    String after = "<html><body><div id='aquima'><div id='2'>foo</div></div></body></html>";

    // SUT
    Map<String, String> differences = new HtmlDiff().getDifferences(before, after);

    // Verify
    assertEquals(1, differences.size());
    LOG.info(differences.toString());
    XMLAssert.assertXMLEqual("<div id=\"aquima\"><div id=\"2\">foo</div></div>", differences.get("aquima"));
  }

  @Test
  public void elementInserted() throws Exception {
    // Setup
    String before = "<html><body><div id='aquima'><span>text</span><div id='2'>foo</div></div></body></html>";
    String after =
        "<html><body><div id='aquima'><span>text</span><div id='1'>bar</div><div id='2'>foo</div></div></body></html>";

    // SUT
    Map<String, String> differences = new HtmlDiff().getDifferences(before, after);

    // Verify
    assertEquals(1, differences.size());
    this.logDiffs(differences);
    XMLAssert.assertXMLEqual("<div id=\"aquima\"><span>text</span><div id=\"1\">bar</div><div id=\"2\">foo</div></div>",
        differences.get("aquima"));
  }

  @Test
  public void elementInsertedAndIdUpdated() throws Exception {
    // Setup
    String before =
        "<html><body><div id='aquima'><div id='3'><span>text</span><div id='2'>foo</div></div></div></body></html>";
    String after =
        "<html><body><div id='aquima'><div id='4'><span>text</span><div id='1'>bar</div><div id='2'>foo</div></div></div></body></html>";

    // SUT
    Map<String, String> differences = new HtmlDiff().getDifferences(before, after);

    // Verify
    assertEquals(1, differences.size());
    this.logDiffs(differences);
    XMLAssert.assertXMLEqual(
        "<div id=\"aquima\"><div id=\"4\"><span>text</span><div id=\"1\">bar</div><div id=\"2\">foo</div></div></div>",
        differences.get("aquima"));
  }

  @Test
  public void classIsUpdatable() throws Exception {
    // Setup
    String before = "<div class='widget' id='onlyUpdateMe'><div id='1'>foo</div></div>";
    String after = "<div class='widget' id='onlyUpdateMe'><div id='1'>bar</div></div>";

    // SUT
    Map<String, String> differences =
        new HtmlDiff(new HtmlDiffClassNameHandler("widget", true)).getDifferences(before, after);

    // Verify
    assertEquals(1, differences.size());
    this.logDiffs(differences);
    XMLAssert.assertXMLEqual("<div class=\"widget\" id=\"onlyUpdateMe\"><div id=\"1\">bar</div></div>",
        differences.get("onlyUpdateMe"));
  }

  @Test
  public void classIsUpdatableIdChanged() throws Exception {
    // Setup
    String before = "<div class='widget' id='onlyUpdateMe'><div id='1'>foo</div></div>";
    String after = "<div class='widget' id='onlyUpdateMe'><div id='2'>foo</div></div>";

    // SUT
    Map<String, String> differences =
        new HtmlDiff(new HtmlDiffClassNameHandler("widget", true)).getDifferences(before, after);

    // Verify
    assertEquals(1, differences.size());
    this.logDiffs(differences);
    XMLAssert.assertXMLEqual("<div class=\"widget\" id=\"onlyUpdateMe\"><div id=\"2\">foo</div></div>",
        differences.get("onlyUpdateMe"));
  }

  @Test
  public void classIsUpdatableMultipleClasses() throws Exception {
    // Setup
    String before = "<div class='class1 widget class2' id='onlyUpdateMe'><div id='1'>foo</div></div>";
    String after = "<div class='class1 widget class2' id='onlyUpdateMe'><div id='1'>bar</div></div>";

    // SUT
    Map<String, String> differences =
        new HtmlDiff(new HtmlDiffClassNameHandler("widget", true)).getDifferences(before, after);

    // Verify
    assertEquals(1, differences.size());
    this.logDiffs(differences);
    XMLAssert.assertXMLEqual("<div class=\"class1 widget class2\" id=\"onlyUpdateMe\"><div id=\"1\">bar</div></div>",
        differences.get("onlyUpdateMe"));
  }

  @Test
  public void classIsNotUpdatable() throws Exception {
    // Setup
    String before = "<div id='onlyUpdateMe'><div class='dontUpdate' id='1'>foo</div></div>";
    String after = "<div id='onlyUpdateMe'><div class='dontUpdate' id='1'>bar</div></div>";

    // SUT
    Map<String, String> differences =
        new HtmlDiff(new HtmlDiffClassNameHandler("dontUpdate", false)).getDifferences(before, after);

    // Verify
    assertEquals(1, differences.size());
    this.logDiffs(differences);
    XMLAssert.assertXMLEqual("<div id=\"onlyUpdateMe\"><div class=\"dontUpdate\" id=\"1\">bar</div></div>",
        differences.get("onlyUpdateMe"));
  }

  @Test
  public void classIsNotUpdatableMultipleClasses() throws Exception {
    // Setup
    String before = "<div id='onlyUpdateMe'><div class='class1 dontUpdate' id='1'>foo</div></div>";
    String after = "<div id='onlyUpdateMe'><div class='class1 dontUpdate' id='1'>bar</div></div>";

    // SUT
    Map<String, String> differences =
        new HtmlDiff(new HtmlDiffClassNameHandler("dontUpdate", false)).getDifferences(before, after);

    // Verify
    assertEquals(1, differences.size());
    this.logDiffs(differences);
    XMLAssert.assertXMLEqual("<div id=\"onlyUpdateMe\"><div class=\"class1 dontUpdate\" id=\"1\">bar</div></div>",
        differences.get("onlyUpdateMe"));
  }

  @Test(expected = IllegalStateException.class)
  public void noParentWithId() throws Exception {
    // Setup
    String before = "<div>old</div>";
    String after = "<div>new</div>";

    // SUT
    new HtmlDiff().getDifferences(before, after);
  }

  @Test
  public void noParentWithIdWithCustomErrorHandler() throws Exception {
    // Setup
    String before = "<div>old</div>";
    String after = "<div>new</div>";
    HtmlDiff htmlDiff = new HtmlDiff();
    CustomHandler handler = new CustomHandler();
    htmlDiff.setErrorHandler(handler);

    // SUT
    htmlDiff.getDifferences(before, after);

    // verify
    Assert.assertTrue(handler.isCalled());
  }

  @Test(expected = IllegalStateException.class)
  public void parentWithEmptyId() throws Exception {
    // Setup
    String before = "<div id=''>old</div>";
    String after = "<div id=''>new</div>";

    // SUT
    new HtmlDiff().getDifferences(before, after);
  }

  @Test(expected = IllegalStateException.class)
  public void diffInHead() throws Exception {
    // Setup
    String before = "<html><head>old</head><body></body></html>";
    String after = "<html><head>new</head><body></body></html>";

    // SUT
    new HtmlDiff().getDifferences(before, after);
  }

  @Test(expected = IllegalStateException.class)
  public void diffWithIdInHead() throws Exception {
    // Setup
    String before = "<html><head><link id='1' href='old'/></head><body></body></html>";
    String after = "<html><head><link id='1' href='new'></link></head><body></body></html>";

    // SUT
    new HtmlDiff().getDifferences(before, after);
  }

  @Test(expected = IllegalStateException.class)
  public void diffInHeadWithId() throws Exception {
    // Setup
    String before = "<html><head id='test'>old</head><body></body></html>";
    String after = "<html><head id='test'>new</head><body></body></html>";

    // SUT
    new HtmlDiff().getDifferences(before, after);
  }

  @Test(expected = IllegalStateException.class)
  public void idNotUnique() throws Exception {
    // Setup
    String before = "<div id='oNe'>old</div><div><div id='OnE'>old</div></div>";
    String after = "<div id='oNe'>new</div><div><div id='OnE'>new</div></div>";

    // SUT
    new HtmlDiff().getDifferences(before, after);
  }

  @Test
  public void prettyPrintNodeIndex() throws Exception {
    // Setup
    String before = "<div>text</div><span>t</span><div>old</div>";
    String after = "<div>text</div><span>t</span><div>new</div>";

    // SUT
    try {
      new HtmlDiff().getDifferences(before, after);
      fail("Exception expected");
    } catch (IllegalStateException e) {
      assertEquals("Could not determine a parent within the body with an id attribute. Element: '/html/body/div[2]'",
          e.getMessage());
    }
  }

  @Test
  public void prettyPrintNodeId() throws Exception {
    // Setup
    String before = "<html><head><link id='1' href='old'></head><body></body></html>";
    String after = "<html><head><link id='1' href='new'></head><body></body></html>";

    // SUT
    try {
      new HtmlDiff().getDifferences(before, after);
      fail("Exception expected");
    } catch (IllegalStateException e) {
      assertEquals("Could not update changes that are not in the body. Element: '/html/head/link[@id='1']'",
          e.getMessage());
    }
  }

  @Test
  public void performanceTestForHandlers() throws Exception {
    StringBuilder a = new StringBuilder();
    StringBuilder b = new StringBuilder();
    a.append("<html><head><title/></head><body>");
    b.append("<html><head><title/></head><body>");
    for (int i = 0; i < 100; i++) {
      a.append(String.format("<div id='P1-C%s' class='foo'>value%s</div>", i, i));
      b.append(String.format("<div id='P1-C%s' class='foo'>newvalue%s</div>", i, i));
    }
    a.append("</body></html>");
    b.append("</body></html>");
    // call html diff to make sure all classes are loaded to get correct timing info:
    new HtmlDiff().getDifferences(a.toString(), b.toString());

    StringBuilder summary = new StringBuilder();

    HtmlDiff.IIncludeElementHandler classNameHandler = new HtmlDiffClassNameHandler("foo", true);
    HtmlDiff.IIncludeElementHandler xpathHandler = new HtmlDiffXPathHandler("@class='foo'");

    performance(null, a.toString(), b.toString(), "noHandler", summary);
    performance(classNameHandler, a.toString(), b.toString(), "classNameHandler", summary);
    performance(xpathHandler, a.toString(), b.toString(), "xpathHandler", summary);

    LOG.info("\n===============\n" + summary);
  }

  private static void performance(HtmlDiff.IIncludeElementHandler handler, String before, String after,
      String handlerName, StringBuilder timingSummary) throws Exception {
    HtmlDiff diff = new HtmlDiff(handler);
    long start = System.currentTimeMillis();
    Map<String, String> differences = diff.getDifferences(before.toString(), after.toString());
    timingSummary.append("time for handler " + handlerName + ": " + (System.currentTimeMillis() - start) + "ms.\n");
    assertEquals(100, differences.size());
  }

  @Test
  public void carinsuranceIntegrationTest() throws Exception {
    // Setup
    HtmlDiff diff = new HtmlDiff();

    {
      // sut
      Map<String, String> result =
          diff.getDifferences(this.getPageContent("page1.html"), this.getPageContent("page2.html"));

      // verify
      this.logDiffs(result);
      assertEquals(2, result.size());
    }
    {
      // sut
      Map<String, String> result =
          diff.getDifferences(this.getPageContent("page2.html"), this.getPageContent("page3.html"));

      // verify
      this.logDiffs(result);
      assertEquals(2, result.size());
    }
    {
      // sut
      Map<String, String> result =
          diff.getDifferences(this.getPageContent("page3.html"), this.getPageContent("page4.html"));

      // verify
      this.logDiffs(result);
      assertEquals(3, result.size());
    }
  }

  @Test
  public void reproduceIssueWithLabel() throws Exception {
    // setup
    String before = "<div id='P977-C1-F1'><label>old</label></div>";
    String after = "<div id='P977-C1-F1'><label>new</label></div>";

    // sut
    Map<String, String> differences = new HtmlDiff().getDifferences(before, after);

    // verify
    this.logDiffs(differences);
    assertEquals(1, differences.size());
    XMLAssert.assertXMLEqual("<div id=\"P977-C1-F1\"><label>new</label></div>", differences.get("P977-C1-F1"));
  }

  @Test
  public void reproduceIssueWithLabels() throws Exception {
    // setup
    String before = "<div id='P977-C1-F1'><label for='P977-C1-F1'><span>old</span></label><label>t</label></div>";
    String after = "<div id='P977-C1-F1'><label for='P977-C1-F1'><span>new</span></label><label>t</label></div>";

    // sut
    Map<String, String> differences = new HtmlDiff().getDifferences(before, after);

    // verify
    this.logDiffs(differences);
    assertEquals(1, differences.size());
    XMLAssert.assertXMLEqual(
        "<div id=\"P977-C1-F1\"><label for=\"P977-C1-F1\"><span>new</span></label><label>t</label></div>",
        differences.get("P977-C1-F1"));
  }

  @Test
  public void testHtml5() throws Exception {
    // setup
    String before = "<canvas id=\"example\" width=\"200\" height=\"200\">content</canvas>";
    String after = "<canvas id=\"example\" width=\"200\" height=\"200\">new</canvas>";

    // sut
    Map<String, String> differences = new HtmlDiff().getDifferences(before, after);

    // verify
    this.logDiffs(differences);
    assertEquals(1, differences.size());
    XMLAssert.assertXMLEqual("<canvas id=\"example\" width=\"200\" height=\"200\">new</canvas>",
        differences.get("example"));
  }

  @Test
  public void testHtml5Video() throws Exception {
    // setup
    String before = "<video id='1'>" + "<source src=\"old.mp4\" type=\"video/mp4\" />"
        + "Your browser does not support the video tag." + "</video>";
    String after = "<video id='1'>" + "<source src=\"new.mp4\" type=\"video/mp4\" />"
        + "Your browser does not support the video tag." + "</video>";

    // sut
    Map<String, String> differences = new HtmlDiff().getDifferences(before, after);

    // verify
    this.logDiffs(differences);
    assertEquals(1, differences.size());
    XMLAssert.assertXMLEqual(after, differences.get("1"));
  }

  @Test
  public void testNonHtmlElement() throws Exception {
    // setup
    String before = "<div id='1'><nonHtmlElement>old</nonHtmlElement></div>";
    String after = "<div id='1'><nonHtmlElement>new</nonHtmlElement></div>";

    // sut
    Map<String, String> differences = new HtmlDiff().getDifferences(before, after);

    // verify
    assertEquals(1, differences.size());
    XMLAssert.assertXMLEqual("<div id='1'>new</div>", differences.get("1"));
  }

  @Test
  public void testComment() throws Exception {
    // setup
    String before = "<div id=\"1\"><!-- comment --></div>";
    String after = "<div id=\"1\"><!-- new --></div>";

    // sut
    Map<String, String> differences = new HtmlDiff().getDifferences(before, after);

    // verify
    this.logDiffs(differences);
    assertEquals(1, differences.size());
    XMLAssert.assertXMLEqual("<div id=\"1\"><!-- new --></div>", differences.get("1"));
  }

  /**
   * Empty elements are dropped by JTidy with default configuration.
   * 
   * @throws Exception Unexpected exception.
   */
  @Test
  public void testEmptyElement() throws Exception {
    // setup
    String before = "<div id=\"1\"><span></span><span>old</span></div>";
    String after = "<div id=\"1\"><span></span><span>new</span></div>";

    // sut
    Map<String, String> differences = new HtmlDiff().getDifferences(before, after);

    // verify
    this.logDiffs(differences);
    assertEquals(1, differences.size());
    XMLAssert.assertXMLEqual(after, differences.get("1"));
  }

  /**
   * Empty paragraphs are dropped by JTidy with default configuration.
   * 
   * @throws Exception Unexpected exception.
   */
  @Test
  public void testEmptyParagraph() throws Exception {
    // setup
    String before = "<div id=\"1\"><p></p><p>old</p></div>";
    String after = "<div id=\"1\"><p></p><p>new</p></div>";

    // sut
    Map<String, String> differences = new HtmlDiff().getDifferences(before, after);

    // verify
    this.logDiffs(differences);
    assertEquals(1, differences.size());
    XMLAssert.assertXMLEqual(after, differences.get("1"));
  }

  private void logDiffs(Map<String, String> result) {
    LoggerFactory.getLogger(this.getClass()).info("*********");
    for (Map.Entry<String, String> entry : result.entrySet()) {
      LoggerFactory.getLogger(this.getClass()).info(entry.getKey() + " -> " + entry.getValue());
    }
  }

  private String getPageContent(String fileName) {
    return EncodingUtil.decodeUTF8String(ResourceManagerTemplate.getContent("/com/aquima/web/ui/xslt/" + fileName));
  }

  class CustomHandler implements HtmlDiff.IErrorHandler {

    private boolean mHandlerCalled;

    @Override
    public void noParentFound(Node node, String userFriendlyMessage) {
      if (node == null) {
        throw new AssertionError("Node should not be null");
      }
      if (userFriendlyMessage == null) {
        throw new AssertionError("userFriendlyMessage should not be null");
      }

      this.mHandlerCalled = true;
    }

    protected boolean isCalled() {
      return this.mHandlerCalled;
    }
  }
}
