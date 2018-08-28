<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:svg="http://www.w3.org/2000/svg" >

	<!-- 
	Author: 	J. van Leuven (Everest)
	Date:		2009-01-22
	Description:	document (type definitions) fo-sheet for Aquima Documents

	Version history:
	20101220 1.5 M. Joosen		Allowing PDF-A
	20101216 1.4 M. Joosen		Allowing bookmarks
	20100824 1.3 M. Joosen		Allowing a really empty page and fixing column page count
	20100804 1.2 M. Joosen		Dealing with force-page-count
	20100617 1.1 M. Joosen		Fixed bug for not letter/normal/column
	20100611 1.0 M. Joosen		Robust way of page definitions (no customizations in this file necessary)
	20100421 0.8 M. Joosen		Match on page
	20100309 0.7 M. Joosen		Adapting the normal layout (body start higher)
	20100112 0.6 M. Joosen		Adapting the letterlayout (body start lower)
	20091212 0.5 M. Joosen		Adapting the letterlayout
	20091209 0.4 M. Joosen		Adapting the letterlayout and removed output format
	20090128 0.3 M. Joosen		
					- adding template to deal with pagenumbers
					- consistent names (header, footer_last)
	20090127 0.2 M. Joosen		- adding the NORMAL documenttype			
					- making kdr work 
					- placed errorchecking tables here
	20090122 0.1 J. van Leuven 	Creation based on mastersheet
	-->

	<xsl:template match="DOCUMENT|DOC_BODY">
		<xsl:call-template name="root_document">
			<xsl:with-param name="type" select="'document'"/>
		</xsl:call-template>
	</xsl:template>

	<xsl:template match="PAGE">
		<xsl:call-template name="root_document">
			<xsl:with-param name="type" select="'page'"/>
		</xsl:call-template>
	</xsl:template>

	<!-- Begin new document -->
	<xsl:template name="root_document">
		<xsl:param name="type"/>
		<fo:root>
			<xsl:call-template name="apply_appearence_style">
				<xsl:with-param name="stijl">textstandard</xsl:with-param>
			</xsl:call-template>
			<!-- secure document if necessary -->
			<xsl:apply-templates select="PDFA" mode="create"/>
			<xsl:apply-templates select="SECURITY" />
			<fo:layout-master-set>
				<!-- Allowing blank pages -->
				<xsl:if test="*/PAGEBREAK[contains(@style,'even') or contains(@style,'odd')]">
					<fo:simple-page-master master-name="BlankPage" page-width="210mm" page-height="297mm">
						<fo:region-body />
					</fo:simple-page-master>
				</xsl:if>
				<xsl:for-each select="LETTER|NORMAL|COLUMN">
					<xsl:apply-templates select="." mode="pagemaster"/>
				</xsl:for-each>
				<xsl:if test="not(LETTER|NORMAL|COLUMN)">
					<xsl:call-template name="normalpages_default"/>
				</xsl:if>
			</fo:layout-master-set>
			<xsl:if test="BOOKMARKS">
				<xsl:apply-templates select="BOOKMARKS" mode="create"/>
			</xsl:if>
			<xsl:for-each select="LETTER|NORMAL|COLUMN">
				<fo:page-sequence>
					<xsl:attribute name="force-page-count">
						<xsl:choose>
							<xsl:when test="./PAGEBREAK[contains(@style,'even')]">end-on-even</xsl:when>
							<xsl:when test="./PAGEBREAK[contains(@style,'odd')]">end-on-odd</xsl:when>
							<xsl:otherwise>no-force</xsl:otherwise>
						</xsl:choose>
					</xsl:attribute>
					<xsl:if test="not(.//PAGENUMBER[contains(@style,'pagenumbercontinue')])">
						<xsl:attribute name="initial-page-number">1</xsl:attribute>
					</xsl:if>
					<!-- deal with the letter/normal/column -->
					<xsl:choose>
						<xsl:when test="local-name()='LETTER'">
							<xsl:attribute name="master-reference">
								<xsl:value-of select="local-name()"/>
								<xsl:number level="any" count="LETTER"/>
								<xsl:text>Pages</xsl:text>
							</xsl:attribute>
						</xsl:when>
						<xsl:when test="local-name()='NORMAL'">
							<xsl:attribute name="master-reference">
								<xsl:value-of select="local-name()"/>
								<xsl:number level="any" count="NORMAL"/>
								<xsl:text>Pages</xsl:text>
							</xsl:attribute>
						</xsl:when>
						<xsl:when test="local-name()='COLUMN'">
							<xsl:attribute name="master-reference">
								<xsl:value-of select="local-name()"/>
								<xsl:number level="any" count="COLUMN"/>
								<xsl:text>Pages</xsl:text>
							</xsl:attribute>
						</xsl:when>
						<xsl:otherwise/>
					</xsl:choose>
					<xsl:call-template name="page_portrait"/>
				</fo:page-sequence>
			</xsl:for-each>
			<xsl:if test="(count(LETTER)+count(NORMAL)+count(COLUMN))= 0">
				<fo:page-sequence master-reference="NORMALPages" force-page-count="no-force">
					<xsl:if test="not(.//PAGENUMBER[contains(@style,'pagenumbercontinue')])">
						<xsl:attribute name="initial-page-number">1</xsl:attribute>
					</xsl:if>
					<xsl:choose>
						<xsl:when test="$type='page'">
							<xsl:call-template name="page_xml"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:call-template name="page_portrait"/>
						</xsl:otherwise>
					</xsl:choose>
				</fo:page-sequence>
			</xsl:if>
		</fo:root>
	</xsl:template>

	<!-- end chosing page sequence -->

	<!-- Template generateid-basetype -->
	<!-- This template creates a basetype id. So referring to the set of possible types of documents -->

	<xsl:template name="generateid_basetype">
		<xsl:value-of select="concat(generate-id(ancestor-or-self::LETTER),generate-id(ancestor-or-self::NORMAL),generate-id(ancestor-or-self::COLUMN))"/>
	</xsl:template>

</xsl:stylesheet>
