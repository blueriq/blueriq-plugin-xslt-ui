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
				<xsl:value-of select="$webResourcesPath" />/<xsl:value-of select="$themeFolder" />
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$webResourcesPath" />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>

	<xsl:variable name="themePath">
		<xsl:choose>
			<xsl:when test="$theme">
				<xsl:value-of select="$themeFolderPath" />/<xsl:value-of select="$theme" />
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$themeFolderPath" />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
  
  <xsl:output method="html" encoding="UTF-8" doctype-system="http://www.w3.org/TR/html4/loose.dtd" doctype-public="-//W3C//DTD HTML 4.01 Transitional//EN"/>
  <xsl:template match="/application/timeout">
    <html>
      <head>
        <title>
          <xsl:value-of select="pageDisplayName"/>
        </title>
    	<link rel="shortcut icon" href="{$themePath}/{$imgPath}/favicon.ico" />
       	<link rel="stylesheet" type="text/css" href="{$themePath}/{$cssPath}/styles.css" />
      </head>
      <body>
      	<div class="runtime">
	        <div class="aq-header">
				<div class="aq-logo"></div>
			</div>
	        <div class="aq-page">
				<h1>Session expired</h1>
				<div class="aq-page-header-bottom" />
				<div class="aq-container">
					<div class="aq-textitem">
						Your session has been expired, please restart the application.
					</div>
				</div>
				<div class="aq-footer">Copyright 2013 &#169; Aquima BV. All rights reserved.</div>                
	        </div>
	        
        </div>
      </body>
    </html>
  </xsl:template>
</xsl:stylesheet>