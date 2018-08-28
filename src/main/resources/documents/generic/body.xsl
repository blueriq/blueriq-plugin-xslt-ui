<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:svg="http://www.w3.org/2000/svg">

	<!-- 
	Author: 	J. van Leuven (Everest)
	Date:		2009-01-22
	Description:	body fo-sheet for Aquima Documents

	Version history:
	20101007 1.3 M. Joosen		indicate body-id
	20100802 1.2 M. Joosen		skip rest from span and body for pages in lower case
	20100621 1.1 M. Joosen		Allow span on textblocks
	20100608 1.0 M. Joosen		Version 1.0
	20100421 0.4 M. Joosen		Match on page
	20091209 0.3 M. Joosen		Removed output format
	20090202 0.2 M. Joosen	 	Simplify body and apply templates at BODY
	20090122 0.1 J. van Leuven 	Creation based on mastersheet
	-->

	<!-- Template BODY -->
	<xsl:template match="BODY">
		<xsl:choose>
			<xsl:when test="count(*[contains(@style,'span_')]) &gt; 0">
				<xsl:for-each select="*">
					<fo:block>
						<xsl:call-template name="apply_appearence"/>
						<xsl:choose>
							<xsl:when test="contains(@style,'span_')"> 
								<xsl:apply-templates select="*"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:apply-templates select="."/>
							</xsl:otherwise>
						</xsl:choose>
					</fo:block>
				</xsl:for-each>
			</xsl:when>
			<xsl:otherwise>
				<fo:block >
					<xsl:attribute name="id">body_<xsl:call-template name="generateid_basetype"/></xsl:attribute>
					<xsl:call-template name="apply_appearence"/>
					<xsl:for-each select="*">
						<fo:block>
							<xsl:call-template name="apply_appearence"/>
							<xsl:apply-templates select="."/>
						</fo:block>
					</xsl:for-each>
				</fo:block>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="CONTAINER[@style='BODY']|CONTAINER[@style='body']">
		<xsl:choose>
			<xsl:when test="count(*[contains(@style,'span_')]) &gt; 0">
				<xsl:for-each select="*">
					<fo:block>
						<xsl:apply-templates select="."/>
					</fo:block>
				</xsl:for-each>
			</xsl:when>
			<xsl:otherwise>
				<fo:block>
					<xsl:call-template name="apply_appearence_style">
						<xsl:with-param name="stijl" select="'textstandard'"/>
					</xsl:call-template>
					<xsl:for-each select="*">
						<fo:block>
							<xsl:apply-templates select="."/>
						</fo:block>
					</xsl:for-each>
				</fo:block>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

</xsl:stylesheet>
