<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:svg="http://www.w3.org/2000/svg">
	<!-- 
	Author: 	M. Joosen (Everest)
	Date:		2010-06-08
	Description:	pagenumber_placement fo-sheet for Aquima Documents

	Version history:
	20110727 1.4 M. Joosen		New fix pagenumber
	20110302 1.3 M. Joosen		refix the pagenumber
	20110218 1.2 M. Joosen		Better bugfix on pagenumber placement
	20101027 1.1 M. Joosen		Bugfix placement
	20100608 1.0 M. Joosen		Version 1.0 customization pagenumberplacement
	-->

	<!-- Template pagenumber_placement -->
	<xsl:template name="pagenumber_placement">
		<xsl:param name="flow"/>
		<fo:block-container absolute-position="fixed" >
				<!-- begin strange code for backwards compatibility -->
				<xsl:choose>
					<xsl:when test="*[contains(local-name(),'FOOTER')]/PAGENUMBER">
						<xsl:apply-templates select="*/PAGENUMBER" mode="position_pagenumber"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:apply-templates select="./*" mode="position_pagenumber"/>
					</xsl:otherwise>
				</xsl:choose>
				<!-- end strange code for backwards compatibility -->
				<fo:block text-align="right">
					<xsl:variable name="stripped_style">
						<xsl:choose>
							<xsl:when test="$flow='footer' and FOOTER/PAGENUMBER">
								<xsl:call-template name="pagenumber_strip">
									<xsl:with-param name="style" select="FOOTER/PAGENUMBER/@style"/>
								</xsl:call-template>
							</xsl:when>
							<xsl:when test="$flow='footerfirst' and FOOTERFIRST/PAGENUMBER">
								<xsl:call-template name="pagenumber_strip">
									<xsl:with-param name="style" select="FOOTERFIRST/PAGENUMBER/@style"/>
								</xsl:call-template>
							</xsl:when>
							<xsl:when test="$flow='footerfirst' and not(FOOTERFIRST) and FOOTER/PAGENUMBER">
								<xsl:call-template name="pagenumber_strip">
									<xsl:with-param name="style" select="FOOTER/PAGENUMBER/@style"/>
								</xsl:call-template>
							</xsl:when>
							<xsl:when test="$flow='footerlast' and FOOTERLAST/PAGENUMBER ">
								<xsl:call-template name="pagenumber_strip">
									<xsl:with-param name="style" select="FOOTERLAST/PAGENUMBER/@style"/>
								</xsl:call-template>
							</xsl:when>
							<xsl:when test="$flow='footerlast' and not(FOOTERLAST) and FOOTER/PAGENUMBER">
								<xsl:call-template name="pagenumber_strip">
									<xsl:with-param name="style" select="FOOTER/PAGENUMBER/@style"/>
								</xsl:call-template>
							</xsl:when>
							<xsl:otherwise>
								<!-- no match so standard -->
								<xsl:text>page</xsl:text>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>
					<xsl:call-template name="apply_appearence_style">
						<xsl:with-param name="stijl">textpagenumber</xsl:with-param>
					</xsl:call-template>
					<xsl:call-template name="apply_appearence_style">
						<xsl:with-param name="stijl" select="$stripped_style"/>
					</xsl:call-template>
				</fo:block>
			</fo:block-container>
	</xsl:template>

	<!-- pagenumber_strip is necessary because the pagenumberstyles have been extended -->
	<xsl:template name="pagenumber_strip">
		<xsl:param name="style"/>
		<xsl:choose>
			<xsl:when test="contains($style,'pagenumbercontinue')">
				<xsl:value-of select="substring-after($style,'pagenumbercontinue_')"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$style"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

</xsl:stylesheet>
