<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:svg="http://www.w3.org/2000/svg">
<!--
	Author: 	M. Joosen (Everest)
	Date:		2010-06-08
	Description:	settings stylesheet for xsl-fo for Aquima Documents

	Version history:
	20101217 1.2 M. Joosen		Deal with renders and images
	20100811 1.1 M. Joosen		Deal with multilangual
	20100608 1.0 M. Joosen		default settings

-->

	<!-- Param settings -->

	<!-- when $idb = 'yes' then A and R elments are marked in the text, else they are ignored. -->
	<xsl:param name="idb">yes</xsl:param>
	<!--when $testing='yes' stylesheet errors are highlighted. -->
	<xsl:param name="testing">yes</xsl:param>
	
	<!-- Tuning parameters -->
	<xsl:variable name="int_heading1_sep" select="' '" />
	<xsl:variable name="int_heading1-2_sep" select="'.'" />
	<xsl:variable name="int_heading2_sep" select="' '" />
	<xsl:variable name="int_heading2-3_sep" select="'.'" />
	<xsl:variable name="int_heading3_sep" select="' '" />
	<xsl:variable name="int_heading_sep" select="'.'" />

	<xsl:variable name="language" select="/DOCUMENT/@language"/>

	<xsl:variable name="int_listcomma_and" >
		<xsl:choose>
			<xsl:when test="$language='nl-NL'">
				<xsl:text> en </xsl:text>
			</xsl:when>
			<xsl:when test="$language='en-GB'">
				<xsl:text> and </xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text> and </xsl:text>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>

	<xsl:variable name="int_listcomma_or" >
		<xsl:choose>
			<xsl:when test="$language='nl-NL'">
				<xsl:text> of </xsl:text>
			</xsl:when>
			<xsl:when test="$language='en-GB'">
				<xsl:text> or </xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text> or </xsl:text>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>

	<xsl:variable name="int_listcomma_andor" >
		<xsl:choose>
			<xsl:when test="$language='nl-NL'">
				<xsl:text> en/of </xsl:text>
			</xsl:when>
			<xsl:when test="$language='en-GB'">
				<xsl:text> and/or </xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text> and/or </xsl:text>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>

	<xsl:variable name="int_pagenumber_from" >
		<xsl:choose>
			<xsl:when test="$language='nl-NL'">
				<xsl:text> van </xsl:text>
			</xsl:when>
			<xsl:when test="$language='en-GB'">
				<xsl:text> from </xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text> from </xsl:text>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>

	<xsl:variable name="_OptionSeparator" select="';'"/>

	<xsl:variable name="RendererName">
		<xsl:choose>
			<xsl:when test="/DOCUMENT/@renderer">
				<xsl:value-of select="/DOCUMENT/@renderer"/>
			</xsl:when>
			<xsl:when test="string-length(/DOCUMENT/@renderer) = '0'">
				<xsl:text>XMLMIND</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>IBEX</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>

	<xsl:variable name="ImagePath" select="'../images/'"/>

	<xsl:variable name="ImageExtension" select="'.jpg'"/>

	<xsl:variable name="ColorSchemeLocation" select="'generic/AdobeRGB1998.icc'"/>

	<!-- Dummy matches -->
	<xsl:template match="CONTROL_PARAMETERS | DOCUMENT_NAME | DOCUMENT_TYPE | EVENT_NAME | EVENT_ID | USER_ID"/>

</xsl:stylesheet>
