<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:svg="http://www.w3.org/2000/svg">

	<!-- 
	Author: 	J. van Leuven (Everest)
	Date:		2009-01-22
	Description:	tabelofcontents fo-sheet for Aquima Documents

	Version history:
	20100929 1.1 M. Joosen		Fix different page-sequences
	20100608 1.0 M. Joosen		Version 1.0
	20100602 0.4 J. van Leuven	AQU-4152: source indentation dependency fix 
	20091209 0.3 M. Joosen		Removed output format
	20090128 0.2 M. Joosen		Fixing typo in tablefooter	 
	20090122 0.1 J. van Leuven 	Creation based on mastersheet
	-->

	<!-- Template TABLEOFCONTENTS -->
	<xsl:template match="TABLEOFCONTENTS">
		<fo:block >
			<xsl:call-template name="TABLEOFCONTENTS_HEADER"/>
			<fo:table width="100%" table-layout="auto" space-before="1em">
				<xsl:call-template name="apply_appearence_style">
					<xsl:with-param name="stijl">linespacingextra</xsl:with-param>
				</xsl:call-template>
				<fo:table-column column-width="20mm" text-align="left"/>
				<fo:table-column column-width="proportional-column-width(1)"/>
				<fo:table-column column-width="5mm"/>
				<fo:table-body>
					<xsl:choose>
						<xsl:when test="contains(@style,'over_documents')">
							<xsl:apply-templates select="//*[name()='HEADING1' or name()='HEADING2' or name()='HEADING3' ]" mode="toc"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:apply-templates select="ancestor::*[name()='DOCUMENT' or name()='NORMAL' or name()='LETTER' or name()='COLUMN']//*[name()='HEADING1' or name()='HEADING2' or name()='HEADING3' ]" mode="toc"/>
						</xsl:otherwise>
					</xsl:choose>
				</fo:table-body>
			</fo:table>
			<xsl:apply-templates select="TABLEOFCONTENTS_FOOTER"/>
		</fo:block>
		<fo:block break-before="page"/>
	</xsl:template>

	<xsl:template name="TABLEOFCONTENTS_HEADER">
		<xsl:if test="normalize-space(*[not(name(.)='TABLEOFCONTENTS_FOOTER')])!=''">
			<fo:block>
				<xsl:call-template name="apply_appearence_style">
					<xsl:with-param name="stijl">texttoc</xsl:with-param>
				</xsl:call-template>
				<xsl:apply-templates select="*[not(name(.)='TABLEOFCONTENTS_FOOTER')]"/>
			</fo:block>
		</xsl:if>
	</xsl:template>
	<xsl:template match="TABLEOFCONTENTS_FOOTER">
		<fo:block widows="2" orphans="2">
			<xsl:attribute name="space-before">1em</xsl:attribute>
			<xsl:call-template name="apply_appearence"/>
			<xsl:apply-templates select="*"/>
		</fo:block>
	</xsl:template>
	
</xsl:stylesheet>
