<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:svg="http://www.w3.org/2000/svg">

	<!-- 
	Author: 	M. Joosen (Everest)
	Date:		2010-06-09
	Description:	paragraph settings fo-sheet for Aquima Documents

	Version history:
	20100802 1.0 M. Joosen		Creation for settings
	-->

	<!-- Template DOCUMENTTITLE -->
	<xsl:template match="PARAGRAPH" mode="setting">
		<xsl:attribute name="widows" >2</xsl:attribute>
		<xsl:attribute name="orphans">2</xsl:attribute>
		<xsl:choose>
			<xsl:when test="contains(@style,'continuously')">
				<xsl:attribute name="space-before">0em</xsl:attribute>
			</xsl:when>
			<xsl:otherwise>
				<xsl:attribute name="space-before">1em</xsl:attribute>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="PARAGRAPH[ancestor::*[(local-name()='NORMAL' or local-name()='LETTER' or local-name()='COLUMN') and @style='LABEL'] ]" mode="setting">
		<xsl:attribute name="widows" >2</xsl:attribute>
		<xsl:attribute name="orphans">2</xsl:attribute>
		<xsl:choose>
			<xsl:when test="contains(@style,'continuously')">
				<xsl:attribute name="space-before">0em</xsl:attribute>
			</xsl:when>
			<xsl:otherwise>
				<xsl:attribute name="space-before">1em</xsl:attribute>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
</xsl:stylesheet>
