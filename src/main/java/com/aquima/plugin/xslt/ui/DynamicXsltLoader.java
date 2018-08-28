package com.aquima.plugin.xslt.ui;

import com.aquima.interactions.foundation.io.IResource;
import com.aquima.interactions.foundation.io.IResourceManager;
import com.aquima.interactions.foundation.io.ResourceException;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Component;

import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.FilenameFilter;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Comparator;
import java.util.List;

import javax.xml.transform.Source;
import javax.xml.transform.stream.StreamSource;

@Component
public class DynamicXsltLoader implements IDynamicXsltLoader {

  private static final Logger LOG = LoggerFactory.getLogger(DynamicXsltLoader.class);

  private final List<String> registeredStyleSheets = new ArrayList<>();

  @Override
  public void registerXslt(String fileName) {
    LOG.debug("Registering xslt: " + fileName);
    this.registeredStyleSheets.add(fileName);
  }

  /**
   * {@inheritDoc}
   * 
   * This method creates a xslt source that imports/includes in that order:
   * 
   * <ol>
   * <li>the main xslt as configured in the xslt configuration</li>
   * <li>the registered xslts {@link #registerXslt(String)}</li>
   * <li>the xslts found in the dynamic xslt folder {@link XsltConfiguration#getDynamicStyleFolder()} order by
   * filename</li>
   * <ol>
   * For every xslt there is also a template (name is head-FILENAME-WITHOUT_EXTENSION) created that can be used to add
   * html to the head.
   * 
   * Example output:
   * 
   * <pre>
   * {@code
   * <xsl:stylesheet version='1.0' xmlns:xsl='http://www.w3.org/1999/XSL/Transform' >
   *     <xsl:import href='aquima:main.xsl'/>
   *     
   *     <!-- per plugin a empty head and the include of the xsl -->
   *     <xsl:template match='page' mode='head-treecontainer' />
   *     <xsl:include href='aquima:com/mycompany/myplugin/treecontainer.xsl'/>
   *     
   *     <xsl:template match='page' mode='head-specialbutton' />
   *     <xsl:include href='aquima:xslui/dynamic/specialbutton.xsl'/>
   *     
   *     <!-- call all the head templates -->
   *     <xsl:template match='page' mode='plugins'>
   *         <xsl:apply-templates select='.' mode='head-treecontainer' />
   *         <xsl:apply-templates select='.' mode='head-specialbutton.xsl' />
   *     </xsl:template>
   * 
   * </xsl:stylesheet>
   * }
   * </pre>
   * 
   * Example to include custom css in your custom <i>button.xsl</i>:
   * 
   * <pre>
   * {@code
   * <xsl:template match="page" mode="head-button">
   * <link rel="stylesheet" type="text/css" href="mycustom.css" />
   * </xsl:template> 
   * }
   * </pre>
   */
  public Source createRootXslt(IResourceManager resourceManager, XsltConfiguration xsltConfiguration, String theme) {
    List<String> dynamicStyleSheets = this.getDynamicStyleSheets(xsltConfiguration, resourceManager, theme);
    if (dynamicStyleSheets.size() == 0 && this.registeredStyleSheets.size() == 0) {
      LOG.debug("No dynamic xslts found");
      IResource resource = resourceManager.getResource(xsltConfiguration.getStyleSheet(theme));
      return XsltURIResolver.asResource(resource);
    }
    dynamicStyleSheets.addAll(0, this.registeredStyleSheets);
    StringBuilder xsl = new StringBuilder();
    xsl.append("<xsl:stylesheet version='1.0' xmlns:xsl='http://www.w3.org/1999/XSL/Transform' >");
    xsl.append("<xsl:import href='aquima:").append(xsltConfiguration.getStyleSheet(theme)).append("'/>");

    // Include the stylesheets
    for (String styleSheet : dynamicStyleSheets) {
      // Add empty match as fallback if the xsl has no head template
      xsl.append("<xsl:template match='page' mode='head-" + getName(styleSheet) + "' />");
      xsl.append("<xsl:include href='aquima:").append(styleSheet).append("'/>");
    }

    // call the head templates
    xsl.append("<xsl:template match='page' mode='plugins'>");
    for (String styleSheet : dynamicStyleSheets) {
      xsl.append("<xsl:apply-templates select='.' mode='head-" + getName(styleSheet) + "' />");
    }
    xsl.append("</xsl:template>");

    xsl.append("</xsl:stylesheet>");
    LOG.debug("Created dynamic stylesheet: " + xsl.toString());
    return new StreamSource(new ByteArrayInputStream(xsl.toString().getBytes()));
  }

  private static String getName(String styleSheet) {
    int index = styleSheet.lastIndexOf("/");
    if (index == -1) {
      index = styleSheet.lastIndexOf("\\");
    }
    index++;
    return styleSheet.substring(index, styleSheet.lastIndexOf("."));

  }

  private List<String> getDynamicStyleSheets(XsltConfiguration xsltConfiguration, IResourceManager resourceManager,
      String theme) {
    List<String> dynamicStyleSheets = new ArrayList<>();
    for (File file : this.getStylesheetsInDynamicDir(xsltConfiguration, resourceManager, theme)) {
      String fileName = xsltConfiguration.getDynamicStyleFolder(theme) + file.getName();
      LOG.debug("Found dynamic xslt: " + fileName);
      dynamicStyleSheets.add(fileName);
    }
    return dynamicStyleSheets;
  }

  private File[] getStylesheetsInDynamicDir(XsltConfiguration xsltConfiguration, IResourceManager resourceManager,
      String theme) {
    IResource resource;
    try {
      resource = resourceManager.getResource(xsltConfiguration.getDynamicStyleFolder(theme));
    } catch (ResourceException e) {
      LOG.debug("Dynamic xslt folder '{}' does not exist", xsltConfiguration.getDynamicStyleFolder(theme));
      return new File[0];
    }

    File dynamicFolder = new File(resource.getInfo().getURI());
    LOG.debug("Checking {} for xsl files", dynamicFolder.getAbsolutePath());
    File[] files = dynamicFolder.listFiles(new FilenameFilter() {

      @Override
      public boolean accept(File dir, String name) {
        return name.toLowerCase().endsWith(".xsl");
      }
    });
    Arrays.sort(files, new Comparator<File>() {

      @Override
      public int compare(File o1, File o2) {
        return o1.getName().compareTo(o2.getName());
      }
    });
    return files;
  }

}
