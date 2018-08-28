<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:svg="http://www.w3.org/2000/svg">
	<!-- 
	Author: 	J. van Leuven (Everest)
	Date:		2009-01-22
	Description:	paragraph fo-sheet for Aquima Documents

	Version history:
	20110717 1.2 M. Joosen		Call BackGroundImage
	20100802 1.1 M. Joosen		setting for widows and orphans
	20100608 1.0 M. Joosen		Version 1.0
	20100519 0.3 M. Joosen		Presentationstyle continuously 
	20091209 0.2 M. Joosen		Removed output format
	20090122 0.1 J. van Leuven 	Creation based on mastersheet
	-->

	<!-- Template PARAGRAPH -->
	<xsl:template match="PARAGRAPH">
		<fo:block >
			<xsl:apply-templates select="." mode="setting"/>
			<xsl:apply-templates select="BACKGROUNDIMAGE" mode="foblock"/>
			<xsl:call-template name="apply_appearence"/>
			<xsl:apply-templates select="*"/>
		</fo:block>
	</xsl:template>

</xsl:stylesheet>
