<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:svg="http://www.w3.org/2000/svg"  xmlns:ibex="http://www.xmlpdf.com/2003/ibex/Format" >
<!--
	Author: 	M. Joosen (Everest)
	Date:		2009-01-19
	Description:	General stylesheet for xsl-fo for Aquima Documents

	Version history:
	20110726 2.2 M. Joosen		RenderSpecificBackgroundimage and added clickable links
	20110308 2.1 M. Joosen		Split the renders and the includelist
	20110304 2.0 M. Joosen		Specific renderer stuff in separate directory
	20101220 1.5 M. Joosen		Adding namespaces and pdf-a
	20101216 1.4 M. Joosen		Adding bookmarks
	20100809 1.3 M. Joosen		Adding container
	20100802 1.2 M. Joosen		Adding paragraph settings 
	20100616 1.1 M. Joosen		Adding watermark placeholder and new organization of files 
	20100421 1.0 M. Joosen		Adding fields
	20100111 0.9 M. Joosen		Adding references
	20091209 0.8 M. Joosen		Strip spaces
	20090128 0.6 M. Joosen		Include instead of import	
	20090127 0.5 M. Joosen		
					- changed the separators in chapters
					- removed commonfooter (part of footer)
	20090126 0.4 M. Joosen		
					- added an extra contentstyle "TEXT" 
					- placed some headerstuff to header.xsl
					- placed errorchecking tables to table.xsl
					- placed errorchecking lists to list.xsl
	20090122 0.3 J. van Leuven 
					- Xsl split into multiple xsl files with xsl:include
					- some select="//tagname" constructions removed for better performance
				       	- Image template added for Aquima internal images
	20090120 0.2 M. Joosen		Added some new styles and fixed some names
	20090119 0.1 M. Joosen		Creation

-->

	<!-- Loading the custom and generic includes -->
	<xsl:include href="../custom/includelist.xsl"/>

	<!-- IBEX rendering styles -->
	<xsl:template match="*" mode="renderspecific">
		<xsl:apply-templates select="." mode="mode_IBEX"/>
	</xsl:template>

	<xsl:template name="RenderSpecificEmptylines">
		<xsl:call-template name="EmptyLines_IBEX"/>
	</xsl:template>

	<xsl:template name="RenderSpecificBackgroundimage">
		<xsl:call-template name="Backgroundimage_IBEX"/>
	</xsl:template>

	<xsl:template name="RenderSpecificProcessLink">
		<xsl:param name="id"/>
		<xsl:param name="anchor"/>
		<xsl:param name="anchorname"/>
		<xsl:call-template name="ProcessLink_IBEX">
			<xsl:with-param name="id" select="$id"/>
			<xsl:with-param name="anchor" select="$anchor"/>
			<xsl:with-param name="anchorname" select="$anchorname"/>
	</xsl:call-template>
	</xsl:template>

	<xsl:include href="renderer-ibex.xsl"/>

	<xsl:output method="xml" encoding="UTF-8" indent="no"/>
	<xsl:strip-space elements="*"/>

</xsl:stylesheet>
