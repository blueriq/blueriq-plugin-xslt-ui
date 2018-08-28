<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:svg="http://www.w3.org/2000/svg">

	<!-- 
	Author: 	M. Joosen (Everest)
	Date:		2010-06-09
	Description:	attributelist position fo-sheet for Aquima Documents

	Version history:
	20100609 1.0 M. Joosen		Creation for positon
	-->

	<!-- Template ATTRIBUTELIST -->
	<xsl:template match="ATTRIBUTELIST" mode="position">
		<xsl:attribute name="left"  >35mm</xsl:attribute>
		<xsl:attribute name="top"   >15mm</xsl:attribute>
		<xsl:attribute name="width" >119mm</xsl:attribute>
		<xsl:attribute name="height">15mm</xsl:attribute>
	</xsl:template>

	<xsl:template match="ATTRIBUTELIST[ancestor::*[(local-name()='NORMAL' or local-name()='LETTER' or local-name()='COLUMN') and (@style='LABEL')] ]" mode="position">
		<xsl:attribute name="left"  >100cm</xsl:attribute>
		<xsl:attribute name="top"   >100cm</xsl:attribute>
		<xsl:attribute name="width" >100cm</xsl:attribute>
		<xsl:attribute name="height">100cm</xsl:attribute>
	</xsl:template>

	<!-- Template ATTRIBUTE -->
	<xsl:template match="ATTRIBUTE" mode="position">
		<xsl:attribute name="min-width">18mm</xsl:attribute>
	</xsl:template>

	<xsl:template match="ATTRIBUTE[ancestor::*[(local-name()='NORMAL' or local-name()='LETTER' or local-name()='COLUMN') and (@style='LABEL')] ]" mode="position">
		<xsl:attribute name="min-width">18mm</xsl:attribute>
	</xsl:template>

</xsl:stylesheet>
