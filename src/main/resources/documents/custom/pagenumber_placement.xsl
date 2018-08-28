<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:svg="http://www.w3.org/2000/svg">

	<!-- 
	Author: 	M. Joosen (Everest)
	Date:		2010-06-09
	Description:	pagenumber position fo-sheet for Aquima Documents

	Version history:
	20100609 1.0 M. Joosen		Creation for positon
	-->

	<!-- Template PAGENUMBER -->
	<xsl:template match="PAGENUMBER" mode="position_pagenumber">
		<xsl:attribute name="right" >20mm</xsl:attribute>
		<xsl:attribute name="top"   >269mm</xsl:attribute>
		<xsl:attribute name="width" >8em</xsl:attribute>
		<xsl:attribute name="height">1em</xsl:attribute>
	</xsl:template>

	<xsl:template match="PAGENUMBER[ancestor::*[(local-name()='NORMAL' or local-name()='LETTER' or local-name()='COLUMN') and @style='LABEL'] ]" mode="position_pagenumber">
		<xsl:attribute name="right" >25mm</xsl:attribute>
		<xsl:attribute name="top"   >282mm</xsl:attribute>
		<xsl:attribute name="width" >8em</xsl:attribute>
		<xsl:attribute name="height">1em</xsl:attribute>
	</xsl:template>

	<xsl:template match="*" mode="position_pagenumber">
		<xsl:attribute name="right" >20mm</xsl:attribute>
		<xsl:attribute name="top"   >269mm</xsl:attribute>
		<xsl:attribute name="width" >8em</xsl:attribute>
		<xsl:attribute name="height">1em</xsl:attribute>
	</xsl:template>

</xsl:stylesheet>
