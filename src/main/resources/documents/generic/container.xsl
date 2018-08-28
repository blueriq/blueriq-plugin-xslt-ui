<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:svg="http://www.w3.org/2000/svg">
	<!-- 
	Author: 	M. Joosen (Everest)
	Date:		2010-02-10
	Description:	container fo-sheet for Aquima Documents

	Version history:
	20100809 1.1 M. Joosen		Deal with containerDisplayName
	20100619 1.0 M. Joosen		Version 1.0
	20100602 0.2 J. van Leuven	AQU-4152: source indentation dependency fix 
	20100210 0.1 M. Joosen 		Creation based on mastersheet
	-->

	<!-- Template container -->
	<xsl:template match="CONTAINER">
		<xsl:if test="CONTAINER-DISPLAY-TEXT/TEXT">
			<fo:block keep-with-next="always" width="100%" space-before="2em">
				<xsl:call-template name="apply_appearence_style">
					<xsl:with-param name="stijl">textcontainertitle</xsl:with-param>
				</xsl:call-template>
				<xsl:apply-templates select="CONTAINER-DISPLAY-TEXT" />
			</fo:block>
		</xsl:if>
		<fo:block widows="2" orphans="2">
			<xsl:call-template name="apply_appearence"/>
			<xsl:apply-templates select="*[not(name()='CONTAINER-DISPLAY-TEXT') ]"/>
		</fo:block>
	</xsl:template>

</xsl:stylesheet>
