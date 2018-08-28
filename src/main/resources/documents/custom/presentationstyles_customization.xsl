<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:svg="http://www.w3.org/2000/svg">
	<!-- 
	Author: 	J. van Leuven (Everest)
	Date:		2009-01-22
	Description:	presentationstyles fo-sheet for Aquima Documents

	Version history:
	20141127 2.2 T. Middeldorp	Presentation style 'texttransparant' changed to 'texttransparent'
	20100809 2.1 M. Joosen		Containertitle style added

	20100611 2.0 M. Joosen		New way to deal with presentation styles
	20100520 1.3 M. Joosen		Ignore _continuously
	20100428 1.2 M. Joosen		Ignore no_heading_numbering
	20100302 1.1 Jon van Leuven	AQU-3671: .NET crash fix: "Attribute and namespace nodes cannot be added to the parent element
       					after a text, comment, pi, or sub-element node has already been added."
	20091209 1.0 M. Joosen		Removed output format
	20091028 0.9 M. Joosen		Allowing font-family changes by using a style fontfamily_ (after the _ a family name)
	20090219 0.8 M. Joosen		Allowing bottomaligned and topaligned styles
	20090213 0.7 M. Joosen		Temporary hack to enable newlines
	20090212 0.6 M. Joosen	 	
					- adding comments
					- made a conditional choice between block and wrapper at STYLE
					- adding extra headingstyles to enable generalization
	20090202 0.5 M. Joosen	 	
					- new fix for boxes
					- allowing fontsize switches
	20090129 0.4 M. Joosen	 	Temporary fix for the inline svg
	20090128 0.3 M. Joosen	 	
					- fixing the skipping of styles
					- improving error messages
					- dealing with more basetypes in one xml-structure
	20090126 0.2 M. Joosen	 
					- skipping the table styles
					- boxempty and boxticked work
	20090122 0.1 J. van Leuven 	Creation based on mastersheet
	-->


	<!-- Template apply_appearence_style -->
	<xsl:template name="apply_appearence_style">
		<xsl:param name="stijl"/>
		<xsl:variable name="label" select="ancestor::*[(local-name()='NORMAL' or local-name()='LETTER' or local-name()='COLUMN')]/@style"/>
		<xsl:choose>
			<!-- special styles -->
			<xsl:when test="$stijl='textstandard' ">
				<xsl:call-template name="textstandard" >	
					<xsl:with-param name="label" select="$label"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$stijl='textsmall' ">
				<xsl:call-template name="textsmall" >	
					<xsl:with-param name="label" select="$label"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$stijl='textemphasis' ">
				<xsl:call-template name="textemphasis" >	
					<xsl:with-param name="label" select="$label"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$stijl='textunderlined' ">
				<xsl:call-template name="textunderlined" >	
					<xsl:with-param name="label" select="$label"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$stijl='textexplanation' ">
				<xsl:call-template name="textexplanation" >	
					<xsl:with-param name="label" select="$label"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$stijl='textquestiontitle' ">
				<xsl:call-template name="textquestiontitle" >	
					<xsl:with-param name="label" select="$label"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$stijl='textquestionhelp' ">
				<xsl:call-template name="textquestionhelp" >	
					<xsl:with-param name="label" select="$label"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$stijl='textcontainertitle' ">
				<xsl:call-template name="textcontainertitle" >	
					<xsl:with-param name="label" select="$label"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$stijl='textpagenumber' ">
				<xsl:call-template name="textpagenumber" >	
					<xsl:with-param name="label" select="$label"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$stijl='textfooter' ">
				<xsl:call-template name="textfooter" >	
					<xsl:with-param name="label" select="$label"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$stijl='textattribute' ">
				<xsl:call-template name="textattribute" >	
					<xsl:with-param name="label" select="$label"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$stijl='textcolophon' ">
				<xsl:call-template name="textcolophon" >	
					<xsl:with-param name="label" select="$label"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$stijl='linespacingextra' ">
				<xsl:call-template name="linespacingextra" >	
					<xsl:with-param name="label" select="$label"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$stijl='textdocumenttitle' ">
				<xsl:call-template name="textdocumenttitle" >	
					<xsl:with-param name="label" select="$label"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$stijl='textheadingbig' ">
					<xsl:call-template name="textheadingbig" >	
					<xsl:with-param name="label" select="$label"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$stijl='textheading1' ">
				<xsl:call-template name="textheading1" >	
					<xsl:with-param name="label" select="$label"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$stijl='textheading' ">
				<xsl:call-template name="textheading" >	
					<xsl:with-param name="label" select="$label"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$stijl='textheading2' ">
				<xsl:call-template name="textheading2" >	
					<xsl:with-param name="label" select="$label"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$stijl='textheading3' ">
				<xsl:call-template name="textheading3" >	
					<xsl:with-param name="label" select="$label"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$stijl='textremoved' ">
				<xsl:call-template name="textremoved" >	
					<xsl:with-param name="label" select="$label"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$stijl='textchanged' ">
				<xsl:call-template name="textchanged" >	
					<xsl:with-param name="label" select="$label"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$stijl='texttoc' ">
				<xsl:call-template name="texttoc" >	
					<xsl:with-param name="label" select="$label"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$stijl='textreferencetitle' ">
				<xsl:call-template name="textreferencetitle" >	
					<xsl:with-param name="label" select="$label"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$stijl='textreferencevalue' ">
				<xsl:call-template name="textreferencevalue" >	
					<xsl:with-param name="label" select="$label"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$stijl='field' ">
				<xsl:call-template name="field" >	
					<xsl:with-param name="label" select="$label"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$stijl='texttransparent' ">
				<xsl:call-template name="texttransparent" >	
					<xsl:with-param name="label" select="$label"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$stijl='boxempty' ">
				<xsl:call-template name="boxempty" >	
					<xsl:with-param name="label" select="$label"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$stijl='boxticked' ">
				<xsl:call-template name="boxticked" >	
					<xsl:with-param name="label" select="$label"/>
				</xsl:call-template>
			</xsl:when>
			<!-- add new custom presentation styles here -->
			<xsl:otherwise>
				<xsl:call-template name="apply_appearence_style_standard">
					<xsl:with-param name="style" select="$stijl"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
</xsl:stylesheet>
