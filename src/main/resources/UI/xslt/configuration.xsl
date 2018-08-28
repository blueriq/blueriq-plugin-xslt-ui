<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<!-- Generic imports -->
	<xsl:import href="generic/page.xsl"/>
	<xsl:import href="generic/genericerror.xsl"/>
	<xsl:import href="generic/parameters.xsl"/>
	<xsl:import href="generic/button.xsl"/>
	<xsl:import href="generic/field.xsl"/>
	<xsl:import href="generic/asset.xsl"/>
	<xsl:import href="generic/container.xsl"/>
	<xsl:import href="generic/failed-element.xsl"/>
	<xsl:import href="generic/instanceselector.xsl"/>
	<xsl:import href="generic/breadcrumb.xsl"/>
	<xsl:import href="generic/instanceiterator.xsl"/>
	<xsl:import href="generic/instancelinker.xsl"/>
	<xsl:import href="generic/table.xsl"/>
	<xsl:import href="generic/document-link.xsl"/>
	<xsl:import href="generic/textitem.xsl"/>
	<xsl:import href="generic/image.xsl"/>
	<xsl:import href="generic/list.xsl"/>
	<xsl:import href="generic/menubar.xsl"/>
	<xsl:import href="generic/externalcontent.xsl"/>
	<xsl:import href="generic/fileupload.xsl"/>
	<xsl:import href="generic/filedownload.xsl"/>
	<xsl:import href="generic/listplus.xsl"/>

	<!-- Add your custom project specific xsl here -->
	<!-- 
	<xsl:import href="custom/mycomponent.xsl" />
	-->

	<!-- Default parameters and variables-->
	<!-- the current session id (not the http session id) -->
	<xsl:param name="sessionId"/>
	<xsl:param name="csrfToken"/>
	<!-- the action that should be used to post data to -->
	<xsl:param name="formAction"/>
	<!-- the current selected theme -->
	<xsl:param name="theme"/>
	<!-- path to the webresources -->
	<xsl:param name="webResourcesPath"/>
	<!-- Server side session timeout in seconds -->
	<xsl:param name="maxInactiveInterval"/>
	<!-- field prefix (Often empty. Can be used for portlets) -->
	<xsl:param name="idPrefix"/>
	<!-- The Context path -->
	<xsl:param name="contextPath"/>
	<!-- A unique id that can be used in an url to avoid response caching -->
	<xsl:param name="cache-killer"/>

	<xsl:param name="widgetContext"/>

	<xsl:param name="cssPath" select="'css'"/>
	<xsl:param name="scriptPath" select="'js'"/>
	<xsl:param name="imgPath" select="'images'"/>
	<xsl:param name="themeFolder" select="'xslt/themes'"/>
	<xsl:param name="dynamicWebResourcesPath" select="'../js'"/>

	<xsl:variable name="themeFolderPath">
		<xsl:choose>
			<xsl:when test="$themeFolder">
				<xsl:value-of select="$webResourcesPath"/><xsl:value-of select="$themeFolder"/>
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
</xsl:stylesheet>
