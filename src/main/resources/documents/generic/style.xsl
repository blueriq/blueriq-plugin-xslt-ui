<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:svg="http://www.w3.org/2000/svg">
	<!-- 
	Author: 	J. van Leuven (Everest)
	Date:		2009-01-22
	Description:	style fo-sheet for Aquima Documents

	Version history:
	20110717 1.3 M. Joosen		Allow inline styles
	20110218 1.2 M. Joosen		Ignore stuff that starts with page
	20101111 1.1 M. Joosen	 	Solution to matching bug in aquima
	20100609 1.0 M. Joosen	 	Version 1.0, separate file
	20100602 0.2 J. van Leuven	AQU-4152: source indentation dependency fix 
	20090122 0.1 J. van Leuven 	Creation based on mastersheet
	-->

	<!-- Template STYLE -->
	<xsl:template match="style|STYLE">
		<xsl:choose>
			<xsl:when test="@name='field'">
				<fo:block>
					<xsl:call-template name="apply_appearence_style">
						<xsl:with-param name="stijl" select="@name"/>
					</xsl:call-template>
					<xsl:if test="not (starts-with(@style,'box'))">
						<xsl:apply-templates select="*"/>
					</xsl:if>
				</fo:block>
			</xsl:when>
			<xsl:when test="@name='boxempty' or @name='boxticked'">
				<fo:inline>
					<xsl:call-template name="apply_appearence_style">
						<xsl:with-param name="stijl" select="@name"/>
					</xsl:call-template>
				</fo:inline>
			</xsl:when>
			<xsl:when test="starts-with(@name,'page')">
				<fo:inline>
					<xsl:call-template name="apply_appearence_style">
						<xsl:with-param name="stijl" select="@name"/>
					</xsl:call-template>
				</fo:inline>
			</xsl:when>
			<xsl:when test="@name='textsubscript' or @name='textsuperscript' or starts-with(@name,'inline')">
				<fo:inline>
					<xsl:call-template name="apply_appearence_style">
						<xsl:with-param name="stijl" select="@name"/>
					</xsl:call-template>
					<xsl:apply-templates select="*"/>
				</fo:inline>
			</xsl:when>
			<xsl:when test="@name='link'">
				<xsl:call-template name="processlink"/>
			</xsl:when>
			<xsl:otherwise>
				<fo:wrapper>
					<xsl:call-template name="apply_appearence_style">
						<xsl:with-param name="stijl" select="@name"/>
					</xsl:call-template>
					<xsl:apply-templates select="*"/>
				</fo:wrapper>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

</xsl:stylesheet>
