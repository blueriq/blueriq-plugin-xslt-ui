<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:svg="http://www.w3.org/2000/svg">
	<!-- 
	Author: 	J. van Leuven (Everest)
	Date:		2009-01-22
	Description:	horizontalline fo-sheet for Aquima Documents

	Version history:
	20101012 1.1 M. Joosen		Allow flexibel rule-styles
	20100608 1.0 M. Joosen		Version 1.0
	20091209 0.2 M. Joosen		Removed output format
	20090122 0.1 J. van Leuven 	Creation based on mastersheet
	-->

	<!-- Template HORIZONTALLINE -->
	<xsl:template match="HORIZONTALLINE">
		<fo:block height="0.1mm" text-align-last="justify">
			<fo:leader leader-pattern="rule" leader-length="100%" rule-thickness="0.1pt" color="black">
				<xsl:choose>
					<xsl:when test="@style='dottedline'">
						<xsl:attribute name="rule-style">dotted</xsl:attribute>
					</xsl:when>
					<xsl:when test="starts-with(@style,rule)">
						<xsl:attribute name="rule-style">
							<xsl:value-of select="substring-after(@style,'rule_')"/>
						</xsl:attribute>
					</xsl:when>
					<xsl:otherwise>
						<xsl:attribute name="rule-style">solid</xsl:attribute>
					</xsl:otherwise>
				</xsl:choose>
			</fo:leader>
		</fo:block>
	</xsl:template>
	
</xsl:stylesheet>
