<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:import href="configuration.xsl"/>

	<xsl:output method="html" encoding="UTF-8" doctype-system="http://www.w3.org/TR/html4/loose.dtd"
				doctype-public="-//W3C//DTD HTML 4.01 Transitional//EN"/>

	<xsl:template match="/application-page">
		<xsl:choose>
			<xsl:when test="$widgetContext">
				<xsl:apply-templates mode="widget"/>
			</xsl:when>
			<xsl:otherwise>
				<html>
					<head>
						<xsl:call-template name="head"/>
						<xsl:call-template name="scripts"/>
						<xsl:apply-templates select="*" mode="plugins"/>
						<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
					</head>
					<body>
						<xsl:apply-templates select="*" mode="body"/>
					</body>
				</html>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="head">
		<title>
			<xsl:value-of select="*/pageDisplayName"/>
		</title>
		<link rel="shortcut icon" href="{$themePath}/{$imgPath}/favicon.ico"/>
		<link rel="stylesheet" type="text/css" href="{$themePath}/{$cssPath}/styles.css"/>
	</xsl:template>

	<xsl:template match="*" mode="plugins">
		<!-- overridden when dynamic xslts are used -->
	</xsl:template>

	<xsl:template name="scripts">
		<script type="text/javascript" src="{$webResourcesPath}styles/default/{$scriptPath}/jquery.js"></script>
		<script type="text/javascript" src="{$webResourcesPath}styles/default/{$scriptPath}/jquery.cookie.js"></script>
		<script type="text/javascript" src="{$webResourcesPath}styles/default/{$scriptPath}/jqueryui.js"></script>
		<script type="text/javascript" src="{$webResourcesPath}styles/default/{$scriptPath}/runtime.js"></script>

		<xsl:call-template name="head-fileupload"/>
		<xsl:call-template name="head-listplus"/>
	</xsl:template>

	<xsl:template match="presentationStyle"/>
</xsl:stylesheet>
