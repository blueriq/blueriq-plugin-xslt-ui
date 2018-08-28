<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:svg="http://www.w3.org/2000/svg">

	<!-- 
	Author: 	J. van Leuven (Everest)
	Date:		2009-01-22
	Description:	page fo-sheet for Aquima Documents

	Version history:
	20100622 1.1 M. Joosen		mode pagelast
	20100611 1.0 M. Joosen		Version 1.0
	20100421 0.5 M. Joosen		Allowing page xml
	20091209 0.4 M. Joosen		Removed output format
	20090128 0.3 M. Joosen		
					- dealing with more than one basetype in a xml structure for pagenumbering
					- consistent names (header, footer_last)
	20090126 0.2 M. Joosen		Using english terms 		
	20090122 0.1 J. van Leuven 	Creation based on mastersheet
	-->


	<!-- begin setting page setup -->
	
	<xsl:template name="page_portrait">
		<fo:static-content flow-name="header_first">
			<xsl:choose>
				<xsl:when test="HEADERFIRST">
					<xsl:apply-templates select="HEADERFIRST" mode="page1"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:apply-templates select="HEADER" mode="page1"/>
				</xsl:otherwise>
			</xsl:choose>
		</fo:static-content>
		<fo:static-content flow-name="header">
			<xsl:apply-templates select="HEADER" mode="page2"/>
		</fo:static-content>
		<fo:static-content flow-name="header_last">
			<xsl:choose>
				<xsl:when test="HEADERLAST">
					<xsl:apply-templates select="HEADERLAST" mode="pagelast"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:apply-templates select="HEADER" mode="pagelast"/>
				</xsl:otherwise>
			</xsl:choose>
		</fo:static-content>
		<!-- static -->
		<fo:static-content flow-name="footer_first">
			<xsl:call-template name="pagenumber_placement">
				<xsl:with-param name="flow">footerfirst</xsl:with-param>
			</xsl:call-template>
			<xsl:choose>
				<xsl:when test="FOOTERFIRST">
					<xsl:apply-templates select="FOOTERFIRST"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:apply-templates select="FOOTER"/>
				</xsl:otherwise>
			</xsl:choose>
		</fo:static-content>
		<fo:static-content flow-name="footer">
			<xsl:call-template name="pagenumber_placement">
				<xsl:with-param name="flow">footer</xsl:with-param>
			</xsl:call-template>
			<xsl:apply-templates select="FOOTER"/>
		</fo:static-content>
		<fo:static-content flow-name="footer_last">
			<xsl:call-template name="pagenumber_placement">
				<xsl:with-param name="flow">footerlast</xsl:with-param>
			</xsl:call-template>
			<xsl:choose>
				<xsl:when test="FOOTERLAST">
					<xsl:apply-templates select="FOOTERLAST"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:apply-templates select="FOOTER"/>
				</xsl:otherwise>
			</xsl:choose>
		</fo:static-content>
		<fo:flow flow-name="body">
			<xsl:apply-templates select="BODY"/>
			<fo:block>
				<xsl:attribute name="id">lastpage<xsl:call-template name="generateid_basetype"/></xsl:attribute>
			</fo:block>
		</fo:flow>
	</xsl:template>

	<xsl:template name="page_xml">
		<fo:static-content flow-name="header_first">
			<xsl:choose>
				<xsl:when test="CONTAINER[@style='HEADERFIRST']">
					<xsl:apply-templates select="CONTAINER[@style='HEADERFIRST']" mode="page1"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:apply-templates select="CONTAINER[@style='HEADER']" mode="page1"/>
				</xsl:otherwise>
			</xsl:choose>
		</fo:static-content>
		<fo:static-content flow-name="header">
			<xsl:apply-templates select="CONTAINER[@style='HEADER']" mode="page2"/>
		</fo:static-content>
		<fo:static-content flow-name="header_last">
			<xsl:choose>
				<xsl:when test="CONTAINER[@style='HEADERLAST']">
					<xsl:apply-templates select="CONTAINER[@style='HEADERLAST']" mode="page2"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:apply-templates select="CONTAINER[@style='HEADER']" mode="page2"/>
				</xsl:otherwise>
			</xsl:choose>
		</fo:static-content>
		<!-- static -->
		<fo:static-content flow-name="footer_first">
			<xsl:call-template name="pagenumber_placement">
				<xsl:with-param name="flow">footerfirst</xsl:with-param>
			</xsl:call-template>
			<xsl:choose>
				<xsl:when test="CONTAINER[@style='FOOTERFIRST']">
					<xsl:apply-templates select="CONTAINER[@style='FOOTERFIRST']"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:apply-templates select="CONTAINER[@style='FOOTER']"/>
				</xsl:otherwise>
			</xsl:choose>
		</fo:static-content>
		<fo:static-content flow-name="footer">
			<xsl:call-template name="pagenumber_placement">
				<xsl:with-param name="flow">footer</xsl:with-param>
			</xsl:call-template>
			<xsl:apply-templates select="CONTAINER[@style='FOOTER']"/>
		</fo:static-content>
		<fo:static-content flow-name="footer_last">
			<xsl:call-template name="pagenumber_placement">
				<xsl:with-param name="flow">footerlast</xsl:with-param>
			</xsl:call-template>
			<xsl:choose>
				<xsl:when test="CONTAINER[@style='FOOTERLAST']">
					<xsl:apply-templates select="CONTAINER[@style='FOOTERLAST']"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:apply-templates select="CONTAINER[@style='FOOTER']"/>
				</xsl:otherwise>
			</xsl:choose>
		</fo:static-content>
		<fo:flow flow-name="body">
			<xsl:choose>
				<xsl:when test="CONTAINER[@style='BODY']">
					<xsl:apply-templates select="CONTAINER[@style='BODY']"/>
				</xsl:when>
				<xsl:otherwise>
					<fo:block>
						<xsl:apply-templates select="*"/>
					</fo:block>
				</xsl:otherwise>
			</xsl:choose>
			<fo:block>
				<xsl:attribute name="id">lastpage<xsl:call-template name="generateid_basetype"/></xsl:attribute>
			</fo:block>
		</fo:flow>
	</xsl:template>


</xsl:stylesheet>
