<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:svg="http://www.w3.org/2000/svg">
<!--
	Author: 	M. Joosen (Everest)
	Date:		2010-06-08
	Description:	text_r stylesheet for xsl-fo for Aquima Documents

	Version history:
	20100608 1.0 M. Joosen		Separate file for R
-->

	<xsl:template match="R">
		<xsl:choose>
			<xsl:when test="$idb='yes'">
				<fo:wrapper>
					<xsl:call-template name="apply_appearence_style">
						<xsl:with-param name="stijl">textremoved</xsl:with-param>
					</xsl:call-template>
					<xsl:apply-templates />
				</fo:wrapper>
			</xsl:when>
			<xsl:otherwise>
				<!-- niet opmaken -->
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

</xsl:stylesheet>
