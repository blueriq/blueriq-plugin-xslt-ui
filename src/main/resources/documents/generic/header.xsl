<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:svg="http://www.w3.org/2000/svg">

	<!-- 
	Author: 	J. van Leuven (Everest)
	Date:		2009-01-22
	Description:	header fo-sheet for Aquima Documents

	Version history:
	20100608 1.0 M. Joosen		Version 1.0 moved ADDRESSLINE, ATTRIBUTETITLE and ATTRIBUTEVALUE 
	20100518 0.6 M. Joosen		ColophonLine to colophon.xsl
	20100421 0.5 M. Joosen		Enable page xml
	20091209 0.4 M. Joosen		Removed output format
	20090128 0.3 M. Joosen		Removed not needed ATTRIBUTEONDERWERP
	20090126 0.2 M. Joosen		
					- Using english terms
					- adding additional matches (else it doesnt work)		
	20090122 0.1 J. van Leuven 	Creation based on mastersheet
	-->

	<!-- Template HEADER -->
	<xsl:template match="HEADER | HEADERFIRST|CONTAINER[@style='HEADERFIRST']|CONTAINER[@style='HEADER']" mode="page1">
		<fo:block>
			<xsl:call-template name="apply_appearence"/>
			<xsl:apply-templates select="*" mode="page1"/>
		</fo:block>
	</xsl:template>
	<xsl:template match="HEADER |CONTAINER[@style='HEADER'] " mode="page2">
		<fo:block>
			<xsl:call-template name="apply_appearence"/>
			<xsl:apply-templates select="*" mode="page2"/>
		</fo:block>
	</xsl:template>

	<xsl:template match="HEADER | HEADERLAST|CONTAINER[@style='HEADERLAST']|CONTAINER[@style='HEADER']" mode="pagelast">
		<fo:block>
			<xsl:call-template name="apply_appearence"/>
			<xsl:apply-templates select="*" mode="pagelast"/>
		</fo:block>
	</xsl:template>
	
	<xsl:template match="*" mode="page1">
		<xsl:apply-templates select="."/>
	</xsl:template>

	<xsl:template match="*" mode="page2">
		<xsl:apply-templates select="."/>
	</xsl:template>

	<xsl:template match="*" mode="pagelast">
		<xsl:apply-templates select="."/>
	</xsl:template>


</xsl:stylesheet>
