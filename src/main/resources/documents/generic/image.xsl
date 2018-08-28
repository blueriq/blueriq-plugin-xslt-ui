<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:svg="http://www.w3.org/2000/svg">

	<!-- 
	Author: 	J. van Leuven (Everest)
	Date:		2009-01-22
	Description:	IMAGE fo-sheet for Aquima Documents

	Version history:
	20170127 2.1 P. Galanton	Added DYNAMIC_IMAGE
	20110111 2.0 M. Joosen		Moved renderer specific information to other place
	20101216 1.1 M. Joosen		Allow other renderers to get the image from other places
	20100608 1.0 M. Joosen		Version 1.0
	20100602 0.4 J. van Leuven	AQU-4152: source indentation dependency fix 
	20100421 0.3 M. Joosen		Synchronize with main
	20091209 0.2 M. Joosen		Removed output format
	20090122 0.1 J. van Leuven 	Creation based on mastersheet
	-->

	<!-- Template IMAGE -->
	<xsl:template match="IMAGE">
		<fo:block>
			<fo:external-graphic>
				<xsl:apply-templates select="." mode="renderspecific"/>
				<xsl:if test="@height and @width">
					<xsl:attribute name="scaling">non-uniform</xsl:attribute>				
				</xsl:if>
				<xsl:if test="@height">
					<xsl:attribute name="content-height"><xsl:value-of select="@height"/>mm</xsl:attribute>
				</xsl:if>
				<xsl:if test="@width">
					<xsl:attribute name="content-width"><xsl:value-of select="@width"/>mm</xsl:attribute>
				</xsl:if>
			</fo:external-graphic>
		</fo:block>
	</xsl:template>

	<xsl:template match="DYNAMIC_IMAGE">
		<fo:block>
			<fo:external-graphic>
				<xsl:apply-templates select="." mode="renderspecific"/>
				<xsl:if test="@height and @width">
					<xsl:attribute name="scaling">non-uniform</xsl:attribute>
				</xsl:if>
				<xsl:if test="@height">
					<xsl:attribute name="content-height"><xsl:value-of select="@height"/>mm</xsl:attribute>
				</xsl:if>
				<xsl:if test="@width">
					<xsl:attribute name="content-width"><xsl:value-of select="@width"/>mm</xsl:attribute>
				</xsl:if>
			</fo:external-graphic>
		</fo:block>
	</xsl:template>

	<!-- Template PICTURE -->
	<!-- Backwards compatable -->
	<xsl:template match="PICTURE">
		<xsl:variable name="picture">
			<xsl:apply-templates select="*"/>
		</xsl:variable>
		<fo:block>
			<fo:external-graphic>
				<xsl:apply-templates select="." mode="renderspecific"/>
				<xsl:if test="@height and @width">
					<xsl:attribute name="scaling">non-uniform</xsl:attribute>				
				</xsl:if>
				<xsl:if test="@height">
					<xsl:attribute name="content-height"><xsl:value-of select="@height"/>mm</xsl:attribute>
				</xsl:if>
				<xsl:if test="@width">
					<xsl:attribute name="content-width"><xsl:value-of select="@width"/>mm</xsl:attribute>
				</xsl:if>
			</fo:external-graphic>
		</fo:block>
	</xsl:template>		

</xsl:stylesheet>
