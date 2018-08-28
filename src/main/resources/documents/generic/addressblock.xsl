<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:svg="http://www.w3.org/2000/svg">

	<!-- 
	Author: 	J. van Leuven (Everest)
	Date:		2009-01-22
	Description:	addressblock fo-sheet for Aquima Documents

	Version history:
	20100608 1.0 M. Joosen		Version 1.0 specifying position
	20100602 0.4 J. van Leuven	AQU-4152: source indentation dependency fix 
	20091209 0.3 M. Joosen		Removed output format
	20090126 0.2 M. Joosen		Using english terms 		
	20090122 0.1 J. van Leuven 	Creation based on mastersheet
	-->

	<!-- Template ADDRESSBLOCK -->
	<xsl:template match="ADDRESSBLOCK" mode="page1">
		<fo:block-container absolute-position="fixed" >
			<xsl:apply-templates select="." mode="position"/>
			<fo:block padding="0" space-before="0" space-after="0">
				<xsl:call-template name="apply_appearence"/>
				<xsl:apply-templates select="*"/>
			</fo:block>
		</fo:block-container>
	</xsl:template>
	<xsl:template match="ADDRESSBLOCK" mode="page2"/>

	<xsl:template match="ADDRESSLINE">
		<fo:block>
			<xsl:call-template name="apply_appearence"/>
			<xsl:apply-templates select="*"/>
		</fo:block>
	</xsl:template>


</xsl:stylesheet>
