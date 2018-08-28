<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:svg="http://www.w3.org/2000/svg">

	<!-- 
	Author: 	M. Joosen (Everest)
	Date:		2009-01-22
	Description:	BACKGROUNDIMAGE fo-sheet for Aquima Documents

	Version history:
	20110726 1.1 M. Joosen		Use RenderSpecificBackgroundimage 
	20110717 1.0 M. Joosen		Creation based on mastersheet
	-->

	<!-- Template BACKGROUNDIMAGE -->

	<!-- Ignore call without proper modus -->
	<xsl:template match="BACKGROUNDIMAGE">
	</xsl:template>		

	<xsl:template match="BACKGROUNDIMAGE" mode="foblock">
		<xsl:call-template name="RenderSpecificBackgroundimage"/>
		<xsl:if test="contains(@style,'vpos_')">
			<xsl:attribute name="background-position-vertical"><xsl:value-of select="concat(substring-before(substring-after(@style,'vpos_'),'_'),'%')"/></xsl:attribute>
		</xsl:if>
		<xsl:if test="contains(@style,'hpos_')">
			<xsl:attribute name="background-position-horizontal"><xsl:value-of select="concat(substring-before(substring-after(@style,'hpos_'),'_'),'%')"/></xsl:attribute>
		</xsl:if>
	</xsl:template>		

</xsl:stylesheet>
