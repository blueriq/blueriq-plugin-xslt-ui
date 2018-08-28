<?xml version="1.0" encoding="utf-8"?>
<!-- This xslt file is for use in the .NET webapp -->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" >
  <xsl:param name="sessionId"/>
  <xsl:param name="theme"/>
  <xsl:param name="webResourcesPath"/>

  <xsl:param name="cssPath" select="'css'"/>
  <xsl:param name="imgPath" select="'images'"/>
  <xsl:param name="themeFolder" select="'themes'"/>

  <xsl:variable name="themeFolderPath">
    <xsl:choose>
      <xsl:when test="$themeFolder">
        <xsl:value-of select="$webResourcesPath"/>/<xsl:value-of select="$themeFolder"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$webResourcesPath"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="themePath">
    <xsl:choose>
      <xsl:when test="$theme">
        <xsl:value-of select="$themeFolderPath"/>/<xsl:value-of select="$theme"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$themeFolderPath"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  
  <xsl:output method="html" encoding="UTF-8"/>
  <xsl:template match="/application">
    <html>
      <head>
        <title>
          <xsl:value-of select="pageDisplayName"/>
        </title>
	      <link rel="shortcut icon" href="{$themePath}/{$imgPath}/favicon.ico" />
        <link rel="stylesheet" type="text/css" href="{$themePath}/{$cssPath}/styles.css" />
        <xsl:text disable-output-escaping="yes">
						&lt;!--[if IE 7]&gt;&lt;link rel="stylesheet" type="text/css" href="
					</xsl:text>
        <xsl:value-of select="$themePath" />
        <xsl:text disable-output-escaping="yes">
						/css/ie7.css" /&gt;&lt;![endif]--&gt;
			        </xsl:text>
      </head>
      <body>
        <div class="aq-header">
          <div id="aq-logo"/>
        </div>
        <div class="aq-page">
          <div class="aq-page-caption">
            <span>An unexpected error has occured</span>
          </div>
          <div class="aq-page-content">
            <div class="aq-container">
              <div class="aq-container-caption">
                <xsl:value-of select="errorcode/text()"/>
              </div>
              <div class="aq-container-content">
                <br/>
                <div style="margin-left: 20px">
                  <p>
                    <pre>
                      <code style="font-weight: bold; font-size: 8pt; font-family: courier">                
		                   <xsl:value-of select="message/text()"/>
		                  </code>
                    </pre>
                  </p>
                
                  <span>StackTrace:</span>

                  <p>
                    <pre>
                      <code style="font-size: 8pt; font-family: courier">
                        <xsl:value-of select="stacktrace/text()"/>
                      </code>
                    </pre>
                  </p>
                </div>
	            </div>
            </div>                
          </div>
        </div>
        <div class="aq-footer">Copyright 2011 &#169; Everest bv. All rights reserved.</div>
      </body>
    </html>
  </xsl:template>
</xsl:stylesheet>