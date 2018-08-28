<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:svg="http://www.w3.org/2000/svg">

	<!-- 
	Author: 	M. Joosen (Everest)
	Date:		2010-06-09
	Description:	reference position fo-sheet for Aquima Documents

	Version history:
	20100802 1.1 M. Joosen		Adapatable for spacing
	20100609 1.0 M. Joosen		Creation for positon
	-->

	<!-- Template REFERENCE -->
	<xsl:template match="REFERENCE" mode="position">
		<xsl:attribute name="left"  >34mm</xsl:attribute>
		<xsl:attribute name="top"   >93mm</xsl:attribute>
		<xsl:attribute name="width" >160mm</xsl:attribute>
	</xsl:template>

	<xsl:template match="REFERENCE[ancestor::*[(local-name()='NORMAL' or local-name()='LETTER' or local-name()='COLUMN') and @style='LABEL'] ]" mode="position">
		<xsl:attribute name="left"  >30mm</xsl:attribute>
		<xsl:attribute name="top"   >80mm</xsl:attribute>
		<xsl:attribute name="width" >155mm</xsl:attribute>
	</xsl:template>

	<xsl:template match="REFERENCE" mode="spacing">
		<xsl:attribute name="space-before">3mm</xsl:attribute>
	</xsl:template>

	<xsl:template match="REFERENCE[ancestor::*[(local-name()='NORMAL' or local-name()='LETTER' or local-name()='COLUMN') and @style='LABEL'] ]" mode="spacing">
		<xsl:attribute name="space-before">0mm</xsl:attribute>
	</xsl:template>

</xsl:stylesheet>
