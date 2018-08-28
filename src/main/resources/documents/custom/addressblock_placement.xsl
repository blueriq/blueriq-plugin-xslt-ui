<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:svg="http://www.w3.org/2000/svg">

	<!-- 
	Author: 	M. Joosen (Everest)
	Date:		2010-06-09
	Description:	addressblock position fo-sheet for Aquima Documents

	Version history:
	20100609 1.0 M. Joosen		Creation for positon
	-->

	<!-- Template ADDRESSBLOCK -->
	<xsl:template match="ADDRESSBLOCK" mode="position">
		<xsl:attribute name="left"  >34mm</xsl:attribute>
		<xsl:attribute name="top"   >54mm</xsl:attribute>
		<xsl:attribute name="width" >100mm</xsl:attribute>
		<xsl:attribute name="height">54mm</xsl:attribute>
	</xsl:template>

	<xsl:template match="ADDRESSBLOCK[ancestor::*[(local-name()='NORMAL' or local-name()='LETTER' or local-name()='COLUMN') and @style='LABEL'] ]" mode="position">
		<xsl:attribute name="left"  >30mm</xsl:attribute>
		<xsl:attribute name="top"   >50mm</xsl:attribute>
		<xsl:attribute name="width" >100mm</xsl:attribute>
		<xsl:attribute name="height">25mm</xsl:attribute>
	</xsl:template>

</xsl:stylesheet>
