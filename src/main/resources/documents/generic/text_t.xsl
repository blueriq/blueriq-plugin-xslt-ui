<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:svg="http://www.w3.org/2000/svg">
<!--
	Author: 	M. Joosen (Everest)
	Date:		2010-06-08
	Description:	text_t stylesheet for xsl-fo for Aquima Documents

	Version history:
	20110203 1.1 M. Joosen		Fix the maintain_space with only a space
	20100608 1.0 M. Joosen		Separate file for T
-->

	<!-- Template T -->
	<xsl:template match="T">
		<xsl:apply-templates mode="filtercodes"/>
		<xsl:if test="not(normalize-space(.)) and (contains(ancestor::*/@style,'maintain_space') or contains(ancestor::STYLE/@name,'maintain_space'))">
			<xsl:text>&#xa0;</xsl:text>
		</xsl:if>
	</xsl:template>

</xsl:stylesheet>
