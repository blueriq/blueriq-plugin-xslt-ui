<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:svg="http://www.w3.org/2000/svg">

	<!-- 
	Author: 	M. Joosen (Everest)
	Date:		2010-06-16
	Description:	heading fo-sheet for Aquima Documents

	Version history:
	20100616 1.0 M. Joosen		Creation based on mastersheet
	-->

	<!-- Template HEADING1 -->
	<xsl:template match="HEADING">
		<xsl:variable name="count_any_level_heading">
			<xsl:number level="any" count="HEADING"/>
		</xsl:variable>
		<!-- try to keep this block with the next -->
		<fo:block id="" space-before="2em"  keep-with-next="always">
			<xsl:attribute name="id">heading_<xsl:value-of select="$count_any_level_heading"/></xsl:attribute>
			<xsl:call-template name="apply_appearence_style">
				<xsl:with-param name="stijl">textheading</xsl:with-param>
			</xsl:call-template>
			<xsl:if test="not(contains(@style,'no_heading_numbering'))">
				<xsl:variable name="headingnumber">
					<xsl:call-template name="countheadings">
						<xsl:with-param name="stringsofar" select="''"/>
					</xsl:call-template>
				</xsl:variable>
				<xsl:value-of select="$headingnumber"/>
			</xsl:if>
			<xsl:apply-templates select="HEADINGTITLE/*"/>
			<xsl:apply-templates select="*[name()='ANCHOR' or @name='anchor']"/>
			<fo:block space-before="1em" />
		</fo:block>
		<xsl:apply-templates select="*[not(name()='HEADINGTITLE' or name()='ANCHOR' or @name='anchor')]"/>
	</xsl:template>

	<xsl:template match="HEADINGCONTENT">
		<xsl:apply-templates select="*"/>
	</xsl:template>

	<xsl:template match="HEADING" mode="toc">
		<xsl:variable name="count_any_level_heading">
			<xsl:number level="any" count="HEADING"/>
		</xsl:variable>
		<fo:table-row>
			<xsl:choose>
				<xsl:when test="position()=1"/>
				<xsl:otherwise>
					<xsl:attribute name="space-before">1em</xsl:attribute>
				</xsl:otherwise>
			</xsl:choose>
			<fo:table-cell hyphenate="false">
				<fo:block>
					<xsl:if test="not(contains(@style,'no_heading_numbering'))">
						<xsl:text>&#160;</xsl:text>
						<xsl:variable name="headingnumber">
							<xsl:call-template name="countheadings">
								<xsl:with-param name="stringsofar" select="''"/>
							</xsl:call-template>
						</xsl:variable>
						<xsl:value-of select="$headingnumber"/>
						<xsl:text>&#160;-&#160;</xsl:text>
					</xsl:if>
				</fo:block>
			</fo:table-cell>
			<fo:table-cell>
				<fo:block margin-left="0.5em">
					<fo:wrapper>
						<xsl:apply-templates select="HEADINGTITLE/*"/>
					</fo:wrapper>
				</fo:block>
			</fo:table-cell>
			<fo:table-cell>
				<fo:block text-align="right">
					<fo:page-number-citation>
						<xsl:attribute name="ref-id">heading_<xsl:value-of select="$count_any_level_heading"/></xsl:attribute>
					</fo:page-number-citation>
				</fo:block>
			</fo:table-cell>
		</fo:table-row>
	</xsl:template>

	<xsl:template match="HEADING" mode="reference">
		<xsl:variable name="headingnumber">
			<xsl:call-template name="countheadings">
				<xsl:with-param name="stringsofar" select="''"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:value-of select="$headingnumber"/>
	</xsl:template>

	<xsl:template name="countheadings" >
		<xsl:param name="stringsofar"/>
		<xsl:variable name="countthislevel">
			<xsl:value-of select="count(preceding-sibling::HEADING)+1"/>
			<xsl:value-of select="$int_heading_sep"/>
			<xsl:value-of select="$stringsofar"/>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="ancestor::HEADING[1]">
				<xsl:for-each select="ancestor::HEADING[1]">
					<xsl:call-template name="countheadings">
						<xsl:with-param name="stringsofar" select="$countthislevel"/>
					</xsl:call-template>
				</xsl:for-each>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$countthislevel"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

</xsl:stylesheet>
