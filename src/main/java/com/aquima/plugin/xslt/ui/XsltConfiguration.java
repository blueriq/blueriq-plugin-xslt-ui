package com.aquima.plugin.xslt.ui;

 
import com.aquima.interactions.foundation.text.StringUtil;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cloud.context.config.annotation.RefreshScope;
import org.springframework.stereotype.Component;

import java.util.HashMap;
import java.util.Map;
import java.util.Properties;

/**
 * Class containing xslt specific configuration.
 * 
 * @author Jon van Leuven
 * @since 8.2
 */
@Component
@RefreshScope
public class XsltConfiguration {

  private final String styleFolder;
  private final String styleSheet;
  private final String[] themes;
  private final String dynamicStyleFolder;
  private final boolean enableContainerMessages;
  private final boolean includeContainerProperties;
  private final boolean sortDomainValues;
  private final boolean includePresentationStyles;
  private final boolean isAjaxEnabled;
  private final String htmlDiffClassName;
  private final boolean htmlDiffIsUpdatable;
  private final String transformerFactory;
  private final Map<String, String> xsltParameters;

  public static XsltConfiguration createInstance(String styleFolder, String styleSheet, String[] themes,
      String dynamicStyleFolder, Boolean enableContainerMessages, Boolean includeContainerProperties,
      Boolean sortDomainValues, Boolean includePresentationStyles, Boolean isAjaxEnabled, String htmlDiffClassName,
      Boolean htmlDiffIsUpdatable, String transformerFactory, Map<String, String> xsltParameters) {
    return new XsltConfiguration(styleFolder, styleSheet, themes, dynamicStyleFolder,
        toBoolean(enableContainerMessages, false), toBoolean(includeContainerProperties, false),
        toBoolean(sortDomainValues, false), toBoolean(includePresentationStyles, true), toBoolean(isAjaxEnabled, true),
        htmlDiffClassName, toBoolean(htmlDiffIsUpdatable, false), transformerFactory, xsltParameters);
  }

  public static XsltConfiguration createInstance(String styleFolder, String styleSheet, String... themes) {
    return createInstance(styleFolder, styleSheet, themes, null, null, null, null, null, null, null, null, null, null);
  }

  @Autowired
  public XsltConfiguration(XsltProperties properties) {
    this(properties.getStyleFolder(), properties.getStyleSheet(), properties.getThemes(),
        properties.getDynamicStyleFolder(), properties.isEnableContainerMessages(),
        properties.isIncludeContainerProperties(), properties.isSortDomainValues(),
        properties.isIncludePresentationStyles(), properties.isAjaxEnabled(), properties.getHtmlDiffClassName(),
        properties.isHtmlDiffIsUpdatable(), properties.getTransformerFactory(), properties.getXsltParameters());
  }

  public XsltConfiguration(String styleFolder, String styleSheet, String[] themes, String dynamicStyleFolder,
      boolean enableContainerMessages, boolean includeContainerProperties, boolean sortDomainValues,
      boolean includePresentationStyles, boolean isAjaxEnabled, String htmlDiffClassName, boolean htmlDiffIsUpdatable,
      String transformerFactory, Map<String, String> xsltParameters) {
    if (StringUtil.isEmpty(styleFolder)) {
      throw new IllegalArgumentException("Style folder is mandatory");
    }
    if (StringUtil.isEmpty(styleSheet)) {
      throw new IllegalArgumentException("Style sheet location is mandatory");
    }

    if (!styleFolder.endsWith("/")) {
      styleFolder = styleFolder + "/";
    }
    this.styleFolder = styleFolder;
    if (StringUtil.isEmpty(dynamicStyleFolder)) {
      this.dynamicStyleFolder = styleFolder + "dynamic/";
    } else {
      if (!dynamicStyleFolder.endsWith("/")) {
        dynamicStyleFolder += "/";
      }
      this.dynamicStyleFolder = dynamicStyleFolder;
    }

    this.styleSheet = styleFolder + styleSheet;

    this.themes = themes;
    this.enableContainerMessages = enableContainerMessages;
    this.includeContainerProperties = includeContainerProperties;
    this.sortDomainValues = sortDomainValues;
    this.includePresentationStyles = includePresentationStyles;
    this.isAjaxEnabled = isAjaxEnabled;
    this.xsltParameters = xsltParameters;
    this.transformerFactory = transformerFactory;
    this.htmlDiffClassName = htmlDiffClassName;
    this.htmlDiffIsUpdatable = htmlDiffIsUpdatable;
  }

  public String getTransformerFactory() {
    return this.transformerFactory;
  }

  public String getStyleFolder() {
    return this.styleFolder;
  }

  public String getStyleSheet(String theme) {
    return StringUtil.replaceInString(this.styleSheet, "%theme%", theme);
  }

  public String[] getThemes() {
    return this.themes;
  }

  public String getDynamicStyleFolder(String theme) {
    return StringUtil.replaceInString(this.dynamicStyleFolder, "%theme%", theme);
  }

  public boolean isEnableContainerMessages() {
    return this.enableContainerMessages;
  }

  public boolean isIncludeContainerProperties() {
    return this.includeContainerProperties;
  }

  public boolean isSortDomainValues() {
    return this.sortDomainValues;
  }

  public boolean isIncludePresentationStyles() {
    return this.includePresentationStyles;
  }

  public boolean isAjaxEnabled() {
    return this.isAjaxEnabled;
  }

  public HtmlDiff.IIncludeElementHandler getHtmlDiffHandler() {
    if (StringUtil.isEmpty(this.htmlDiffClassName)) {
      return null;
    }
    // make HtmlDiffClassNameHandler a bean?
    return new HtmlDiffClassNameHandler(this.htmlDiffClassName, this.htmlDiffIsUpdatable);
  }

  public Map<String, String> getXsltParameters() {
    if (this.xsltParameters == null) {
      return new HashMap<String, String>(0);
    }

    return this.xsltParameters;
  }

  private static boolean toBoolean(Boolean value, boolean defaultValue) {
    if (value == null) {
      return defaultValue;
    }
    return value.booleanValue();
  }

  public static Map<String, String> parseXsltParameters(Properties properties) {
    Map<String, String> result = new HashMap<String, String>();
    for (Object key : properties.keySet()) {
      String name = (String) key;
      if (!name.startsWith("xslt.xsltparameter.")) {
        continue;
      }
      result.put(name.substring("xslt.xsltparameter.".length()), properties.getProperty((String) key));
    }
    return result;
  }
}
