<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:svg="http://www.w3.org/2000/svg">
	<!-- 
	Author: 	J. van Leuven (Everest)
	Date:		2009-01-22
	Description:	pagebreak fo-sheet for Aquima Documents

	Version history:
	20100804 1.1 M. Joosen		pagebreak with different styles
	20100608 1.0 M. Joosen		Version 1.0
	20091209 0.2 M. Joosen		Removed output format
	20090122 0.1 J. van Leuven 	Creation based on mastersheet
	-->

	<!-- Template PAGEBREAK -->
	<xsl:template match="PAGEBREAK">
		<fo:block>
			<xsl:choose>
				<xsl:when test="contains(@style,'column')">
					<xsl:attribute name="break-before">column</xsl:attribute>
				</xsl:when>
				<xsl:when test="contains(@style,'page')">
					<xsl:attribute name="break-before">page</xsl:attribute>
				</xsl:when>
				<xsl:when test="contains(@style,'even')">
					<xsl:attribute name="break-before">even-page</xsl:attribute>
				</xsl:when>
				<xsl:when test="contains(@style,'odd')">
					<xsl:attribute name="break-before">odd-page</xsl:attribute>
				</xsl:when>
				<xsl:otherwise>
					<xsl:attribute name="break-before">page</xsl:attribute>
				</xsl:otherwise>
			</xsl:choose>
		</fo:block>
	</xsl:template>
	
</xsl:stylesheet>
