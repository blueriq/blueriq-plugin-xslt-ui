<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:svg="http://www.w3.org/2000/svg">
	<!-- 
	Author: 	M. Joosen (Everest)
	Date:		2010-06-09
	Description:	colophon position fo-sheet for Aquima Documents

	Version history:
	20100609 1.0 M. Joosen		Creation for positon
	-->

	<!-- Template COLOPHON -->
	<xsl:template match="COLOPHON" mode="position">
		<xsl:attribute name="right" >31.5mm</xsl:attribute>
		<xsl:attribute name="top"   >41mm</xsl:attribute>
		<xsl:attribute name="width" >40mm</xsl:attribute>
		<xsl:attribute name="height">54mm</xsl:attribute>
	</xsl:template>

	<xsl:template match="COLOPHON[ancestor::*[(local-name()='NORMAL' or local-name()='LETTER' or local-name()='COLUMN') and @style='LABEL' ] ]" mode="position">
		<xsl:attribute name="right" >25mm</xsl:attribute>
		<xsl:attribute name="top"   >37mm</xsl:attribute>
		<xsl:attribute name="width" >40mm</xsl:attribute>
		<xsl:attribute name="height">30mm</xsl:attribute>
	</xsl:template>

</xsl:stylesheet>
