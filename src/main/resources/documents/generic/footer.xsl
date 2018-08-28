<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:svg="http://www.w3.org/2000/svg">
	<!-- 
	Author: 	J. van Leuven (Everest)
	Date:		2009-11-11
	Description:	footer fo-sheet for Aquima Documents

	Version history:
	20100608 1.0 M. Joosen		Version 1.0 only footer code (pagenumber code is moved)
	20090122 0.1 J. van Leuven 	Creation based on mastersheet
	-->
	<!-- Template FOOTER -->
	<xsl:template match="FOOTER|FOOTERFIRST|FOOTERLAST|CONTAINER[@style='FOOTERFIRST']|CONTAINER[@style='FOOTER']|CONTAINER[@style='FOOTERLAST']">
		<fo:block>
			<xsl:call-template name="apply_appearence_style">
				<xsl:with-param name="stijl">textfooter</xsl:with-param>
			</xsl:call-template>
			<xsl:apply-templates select="*[not(local-name()='PAGENUMBER')]"/>
		</fo:block>
	</xsl:template>

</xsl:stylesheet>
