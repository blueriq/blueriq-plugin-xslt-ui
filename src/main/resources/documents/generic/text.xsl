<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:svg="http://www.w3.org/2000/svg">
	<!-- 
	Author: 	M. Joosen (Everest)
	Date:		2009-01-26
	Description:	text fo-sheet for Aquima Documents

	Version history:
	20110717 1.4 M. Joosen		Call BackgroundImage and allow inline
	20110218 1.3 M. Joosen		Ignore stuff that starts with page
	20100817 1.2 M. Joosen		Allow block settings
	20100802 1.1 M. Joosen		First Text under heading becomes also a block
	20100608 1.0 M. Joosen		Version 1.0
	20100602 0.6 J. van Leuven	AQU-4152: source indentation dependency fix 
	20100602 0.5 J. van Leuven	AQU-4152: source indentation dependency fix 
	20100210 0.4 M. Joosen		Removed output format
	20090216 0.3 M. Joosen		Adding extra styles for block
	20090127 0.2 M. Joosen		Made a conditional choice between block and wrapper, depending on the style
	20090126 0.1 M. Joosen		Creation
	-->

	<!-- Template TEXT -->
	<xsl:template match="TEXT">
		<xsl:choose>
			<xsl:when test="@style='field' or @style='center' or @style='rightaligned' or @style='leftaligned' or starts-with(@style,'blck') or (parent::*[contains(name(),'HEADING') and not (contains(name(),'TITLE'))] and count(preceding-sibling::TEXT)='0')">
				<fo:block>
					<xsl:call-template name="apply_appearence_style">
						<xsl:with-param name="stijl" select="@style"/>
					</xsl:call-template>
					<xsl:apply-templates select="BACKGROUNDIMAGE" mode="foblock"/>
					<xsl:if test="not (starts-with(@style,'box'))">
						<xsl:apply-templates select="*"/>
					</xsl:if>
				</fo:block>
			</xsl:when>
			<xsl:when test="starts-with(@style,'inline')">
				<fo:inline>
					<xsl:call-template name="apply_appearence_style">
						<xsl:with-param name="stijl" select="@style"/>
					</xsl:call-template>
					<xsl:apply-templates select="*"/>
				</fo:inline>
			</xsl:when>
			<xsl:otherwise>
				<fo:wrapper>
					<xsl:call-template name="apply_appearence_style">
						<xsl:with-param name="stijl" select="@style"/>
					</xsl:call-template>
					<xsl:if test="not(starts-with(@style,'box')) or not(starts-with(@style,'page'))">
						<xsl:apply-templates select="*"/>
					</xsl:if>
				</fo:wrapper>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
</xsl:stylesheet>
