<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:svg="http://www.w3.org/2000/svg">

	<!-- 
	Author: 	M. Joosen (Everest)
	Date:		2010-06-09
	Description:	documenttitle position fo-sheet for Aquima Documents

	Version history:
	20100609 1.0 M. Joosen		Creation for positon
	-->

	<!-- Template DOCUMENTTITLE -->
	<xsl:template match="DOCUMENTTITLE" mode="position">
		<xsl:attribute name="left"  >35mm</xsl:attribute>
		<xsl:attribute name="top"   >10mm</xsl:attribute>
		<xsl:attribute name="width" >119mm</xsl:attribute>
		<xsl:attribute name="height">5mm</xsl:attribute>
	</xsl:template>

	<xsl:template match="DOCUMENTTITLE[ancestor::*[(local-name()='NORMAL' or local-name()='LETTER' or local-name()='COLUMN') and @style='LABEL'] ]" mode="position">
		<xsl:attribute name="left"  >30mm</xsl:attribute>
		<xsl:attribute name="top"   >10mm</xsl:attribute>
		<xsl:attribute name="width" >155mm</xsl:attribute>
		<xsl:attribute name="height">5mm</xsl:attribute>
	</xsl:template>

</xsl:stylesheet>
