<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:svg="http://www.w3.org/2000/svg">
	<!-- 
	Author: 	M. Joosen (Everest)
	Date:		2010-06-08
	Description:	link fo-sheet for Aquima Documents

	Version history:
	20110726 1.6 M. Joosen		Allow clickable links
	20110218 1.5 M. Joosen		Moved renderspecific code to renderer
	20101111 1.4 M. Joosen		Generic solution to deal with matching bug aquima
	20101110 1.3 M. Joosen		More specific match
	20101007 1.2 M. Joosen		Deal with different renderers
	20101005 1.1 M. Joosen		quick fix rtf
	20100608 1.0 M. Joosen		Creation based on mastersheet
	-->

	<!-- Template LINK -->
	<xsl:template match="LINK|STYLE[@name='link']" >
		<xsl:call-template name="processlink"/>
	</xsl:template>
	
	<xsl:template name="processlink">
		<xsl:variable name="anchorname">
			<xsl:call-template name="replaceCharsInString">
				<xsl:with-param name="stringIn" select="string(.//TEXT/T)"/>
				<xsl:with-param name="charsIn" select="' '"/>
				 <xsl:with-param name="charsOut" select="''"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:call-template name="RenderSpecificProcessLink">
			<xsl:with-param name="id" select="concat('link_',$anchorname)" />
			<xsl:with-param name="anchor">
				<xsl:call-template name="FindAnchor">
					<xsl:with-param name="anchorname" select="$anchorname"/>
				</xsl:call-template>
			</xsl:with-param>
			<xsl:with-param name="anchorname" select="concat('anchor_',$anchorname)" />
		</xsl:call-template>
	</xsl:template>

	<xsl:template name="FindAnchor">
		<xsl:param name="anchorname"/>
		<xsl:for-each select="//*[name()='ANCHOR' or @name='anchor']">
			<xsl:variable name="checkanchorname">
				<xsl:call-template name="replaceCharsInString">
					<xsl:with-param name="stringIn" select="string(.//TEXT/T)"/>
					<xsl:with-param name="charsIn" select="' '"/>
			 		<xsl:with-param name="charsOut" select="''"/>
				</xsl:call-template>
			</xsl:variable>
			<xsl:if test="$checkanchorname=$anchorname">
				<xsl:apply-templates select="ancestor::*[contains(name(),'HEADING')][1]" mode="reference" />
			</xsl:if>
		</xsl:for-each>
	</xsl:template>
	
</xsl:stylesheet>
