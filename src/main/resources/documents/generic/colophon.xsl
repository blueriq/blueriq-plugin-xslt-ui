<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:svg="http://www.w3.org/2000/svg">
	<!-- 
	Author: 	J. van Leuven (Everest)
	Date:		2009-01-22
	Description:	colophon fo-sheet for Aquima Documents

	Version history:
	20100609 1.0 M. Joosen		Version 1.0 and positioning
	20100602 0.4 J. van Leuven	AQU-4152: source indentation dependency fix 
	20100518 0.5 M. Joosen		Widthen the colophon and introducing the colophonline with padding
	20100506 0.4 M. Joosen		Reconfigured the position
	20091209 0.3 M. Joosen		Removed output format
	20090126 0.2 M. Joosen		Using english terms 		
	20090122 0.1 J. van Leuven 	Creation based on mastersheet
	-->


	<!-- Template COLOPHON -->
	<xsl:template match="COLOPHON" mode="page1">
		<fo:block-container absolute-position="fixed" >
			<xsl:apply-templates select="." mode="position"/>
			<xsl:call-template name="apply_appearence_style">
				<xsl:with-param name="stijl">textcolophon</xsl:with-param>
			</xsl:call-template>
			<fo:block padding="0" space-before="0" space-after="0">
				<xsl:call-template name="apply_appearence"/>
				<xsl:apply-templates select="*"/>
			</fo:block>
		</fo:block-container>
	</xsl:template>
	<xsl:template match="COLOPHON" mode="page2"/>

	<xsl:template match="COLOPHONLINE">
		<fo:block  >
			<!-- conditional padding to deal with possible table padding -->
			<xsl:choose>
				<xsl:when test="count(preceding-sibling::*[1]/TABLE) &gt; '0'">
					<xsl:attribute name="padding-before">0mm</xsl:attribute>
				</xsl:when>
				<xsl:otherwise>
					<xsl:attribute name="padding-before">0.5mm</xsl:attribute>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:choose>
				<xsl:when test="count(descendant::TABLE) &gt; '0'">
					<xsl:attribute name="padding-after">0mm</xsl:attribute>
				</xsl:when>
				<xsl:otherwise>
					<xsl:attribute name="padding-after">0.5mm</xsl:attribute>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:call-template name="apply_appearence"/>
			<xsl:apply-templates select="*"/>
		</fo:block>
	</xsl:template>

</xsl:stylesheet>
