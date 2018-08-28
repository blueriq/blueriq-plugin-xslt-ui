package com.aquima.plugin.xslt.ui;

import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.cloud.context.config.annotation.RefreshScope;
import org.springframework.stereotype.Component;

import java.util.HashMap;
import java.util.Map;

@Component
@ConfigurationProperties(prefix = "blueriq.xslt")
@RefreshScope
public class XsltProperties {

  public static final String DEFAULT_STYLE_FOLDER = "UI/xslt";
  public static final String DEFAULT_STYLE_SHEET = "web.xsl";
  public static final String[] DEFAULT_THEMES = new String[] { "blueriq" };
  public static final boolean DEFAULT_ENABLE_CONTAINER_MESSAGE = false;
  public static final boolean DEFAULT_INCLUDE_CONTAINER_PROPERTIES = false;
  public static final boolean DEFAULT_SORT_DOMAIN_VALUES = false;
  public static final boolean DEFAULT_INCLUDE_PRESENTATION_STYLES = true;
  public static final boolean DEFAULT_IS_AJAX_ENABLED = true;
  public static final String DEFAULT_HTML_DIFF_CLASS_NAME = HtmlDiff.class.getName();

  private String styleFolder = DEFAULT_STYLE_FOLDER;
  private String styleSheet = DEFAULT_STYLE_SHEET;
  private String[] themes = DEFAULT_THEMES;
  private String dynamicStyleFolder;
  private boolean enableContainerMessages = DEFAULT_ENABLE_CONTAINER_MESSAGE;
  private boolean includeContainerProperties = DEFAULT_INCLUDE_CONTAINER_PROPERTIES;
  private boolean sortDomainValues = DEFAULT_SORT_DOMAIN_VALUES;
  private boolean includePresentationStyles = DEFAULT_INCLUDE_PRESENTATION_STYLES;
  private boolean isAjaxEnabled = DEFAULT_IS_AJAX_ENABLED;
  private String htmlDiffClassName = DEFAULT_HTML_DIFF_CLASS_NAME;
  private boolean htmlDiffIsUpdatable;
  private String transformerFactory;
  private Map<String, String> xsltParameters = new HashMap<String, String>();

  public String getStyleFolder() {
    return styleFolder;
  }

  public void setStyleFolder(String styleFolder) {
    this.styleFolder = styleFolder;
  }

  public String getStyleSheet() {
    return styleSheet;
  }

  public void setStyleSheet(String styleSheet) {
    this.styleSheet = styleSheet;
  }

  public String[] getThemes() {
    return themes;
  }

  public void setThemes(String[] themes) {
    this.themes = themes;
  }

  public String getDynamicStyleFolder() {
    return dynamicStyleFolder;
  }

  public void setDynamicStyleFolder(String dynamicStyleFolder) {
    this.dynamicStyleFolder = dynamicStyleFolder;
  }

  public boolean isEnableContainerMessages() {
    return enableContainerMessages;
  }

  public void setEnableContainerMessages(boolean enableContainerMessages) {
    this.enableContainerMessages = enableContainerMessages;
  }

  public boolean isIncludeContainerProperties() {
    return includeContainerProperties;
  }

  public void setIncludeContainerProperties(boolean includeContainerProperties) {
    this.includeContainerProperties = includeContainerProperties;
  }

  public boolean isSortDomainValues() {
    return sortDomainValues;
  }

  public void setSortDomainValues(boolean sortDomainValues) {
    this.sortDomainValues = sortDomainValues;
  }

  public boolean isIncludePresentationStyles() {
    return includePresentationStyles;
  }

  public void setIncludePresentationStyles(boolean includePresentationStyles) {
    this.includePresentationStyles = includePresentationStyles;
  }

  public boolean isAjaxEnabled() {
    return isAjaxEnabled;
  }

  public void setAjaxEnabled(boolean isAjaxEnabled) {
    this.isAjaxEnabled = isAjaxEnabled;
  }

  public String getHtmlDiffClassName() {
    return htmlDiffClassName;
  }

  public void setHtmlDiffClassName(String htmlDiffClassName) {
    this.htmlDiffClassName = htmlDiffClassName;
  }

  public boolean isHtmlDiffIsUpdatable() {
    return htmlDiffIsUpdatable;
  }

  public void setHtmlDiffIsUpdatable(boolean htmlDiffIsUpdatable) {
    this.htmlDiffIsUpdatable = htmlDiffIsUpdatable;
  }

  public String getTransformerFactory() {
    return transformerFactory;
  }

  public void setTransformerFactory(String transformerFactory) {
    this.transformerFactory = transformerFactory;
  }

  public Map<String, String> getXsltParameters() {
    return xsltParameters;
  }

  public void setXsltParameters(Map<String, String> xsltParameters) {
    this.xsltParameters = xsltParameters;
  }
}
