<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:svg="http://www.w3.org/2000/svg">

	<!-- 
	Author: 	J. van Leuven (Everest)
	Date:		2009-01-22
	Description:	heading1 fo-sheet for Aquima Documents

	Version history:
	20160516 1.6 B. Mihai		reverted Josen's chnges(disabled links due to pdfa bug)
	20151026 1.5 M. Joosen		disabled links due to pdfa bug
	20110203 1.4 M. Joosen		Delete space after
	20101222 1.3 M. Joosen		fix bug in non-block
	20101216 1.2 M. Joosen		Add bookmarks mode
	20100921 1.1 M. Joosen		Reset headings in COLUMN, LETTER, NORMAL
	20100608 1.0 M. Joosen		Version 1.0 fixed numbering, and adding reference
	20100602 0.5 J. van Leuven	AQU-4152: source indentation dependency fix
	20100421 0.4 M. Joosen		Enable nonumbering
	20091209 0.3 M. Joosen		Removed output format
	20090212 0.2 M. Joosen		Changed the headingstyle to textheading1 for generalization
	20090122 0.1 J. van Leuven 	Creation based on mastersheet
	-->

	<!-- Template HEADING1 -->
	<xsl:template match="HEADING1">
		<xsl:variable name="count_level_heading_1">
			<xsl:number level="any" count="HEADING1"/>
		</xsl:variable>
		<xsl:variable name="count_any_level_heading_1">
			<xsl:call-template name="CountHeading1"/>
		</xsl:variable>
		<!-- try to keep this block with the next -->
		<fo:block id="" space-before="2em"  keep-with-next="always">
			<xsl:attribute name="id">heading1_<xsl:value-of select="$count_level_heading_1"/></xsl:attribute>
			<xsl:call-template name="apply_appearence_style">
				<xsl:with-param name="stijl">textheading1</xsl:with-param>
			</xsl:call-template>
			<xsl:if test="not(contains(@style,'no_heading_numbering'))">
				<xsl:value-of select="$count_any_level_heading_1"/>
				<xsl:value-of select="$int_heading1_sep"/>
			</xsl:if>
			<xsl:apply-templates select="HEADING1TITLE/*"/>
			<xsl:apply-templates select="*[name()='ANCHOR' or @name='anchor']"/>
		</fo:block>
		<fo:block>
			<xsl:apply-templates select="*[not(name()='HEADING1TITLE' or name()='ANCHOR' or @name='anchor')]"/>
		</fo:block>
	</xsl:template>

	<xsl:template match="HEADING1CONTENT">
		<xsl:apply-templates select="*"/>
	</xsl:template>

	<xsl:template match="HEADING1" mode="toc">
		<xsl:variable name="count_level_heading_1">
			<xsl:number level="any" count="HEADING1"/>
		</xsl:variable>
		<xsl:variable name="count_any_level_heading_1">
			<xsl:call-template name="CountHeading1"/>
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
						<xsl:value-of select="$count_any_level_heading_1"/>
						<xsl:text>&#160;-&#160;</xsl:text>
					</xsl:if>
				</fo:block>
			</fo:table-cell>
			<fo:table-cell>
				<fo:block margin-left="0.5em">
					<fo:basic-link>
						<xsl:attribute name="internal-destination">heading1_<xsl:value-of select="$count_level_heading_1"/></xsl:attribute>
						<fo:wrapper>
							<xsl:apply-templates select="HEADING1TITLE/*"/>
						</fo:wrapper>
					</fo:basic-link>
				</fo:block>
			</fo:table-cell>
			<fo:table-cell>
				<fo:block text-align="right">
					<fo:page-number-citation>
						<xsl:attribute name="ref-id">heading1_<xsl:value-of select="$count_level_heading_1"/></xsl:attribute>
					</fo:page-number-citation>
				</fo:block>
			</fo:table-cell>
		</fo:table-row>
	</xsl:template>

	<xsl:template match="HEADING1" mode="bookmarks">
		<xsl:variable name="count_level_heading_1">
			<xsl:number level="any" count="HEADING1"/>
		</xsl:variable>
		<xsl:variable name="count_any_level_heading_1">
			<xsl:call-template name="CountHeading1"/>
		</xsl:variable>
		<fo:bookmark starting-state="show">
			<xsl:attribute name="internal-destination">heading1_<xsl:value-of select="$count_level_heading_1"/></xsl:attribute>
			<fo:bookmark-title><xsl:apply-templates select="HEADING1TITLE//TEXT/*"/></fo:bookmark-title>
		</fo:bookmark>
	</xsl:template>


	<xsl:template match="HEADING1" mode="reference">
		<xsl:variable name="count_level_heading_1">
			<xsl:number level="any" count="HEADING1"/>
		</xsl:variable>
		<xsl:variable name="count_any_level_heading_1">
			<xsl:call-template name="CountHeading1"/>
		</xsl:variable>
		<xsl:value-of select="$count_any_level_heading_1"/>
		<xsl:value-of select="$int_heading1_sep"/>
	</xsl:template>

	<xsl:template name="CountHeading1">
		<xsl:choose>
			<xsl:when test="ancestor::NORMAL[not(contains(@style,'continue_heading'))]">
				<xsl:number level="any" from="NORMAL" count="HEADING1"/>
			</xsl:when>
			<xsl:when test="ancestor::COLUMN[not(contains(@style,'continue_heading'))]">
				<xsl:number level="any" from="COLUMN" count="HEADING1"/>
			</xsl:when>
			<xsl:when test="ancestor::LETTER[not(contains(@style,'continue_heading'))]">
				<xsl:number level="any" from="LETTER" count="HEADING1"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:number level="any" count="HEADING1"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

</xsl:stylesheet>
