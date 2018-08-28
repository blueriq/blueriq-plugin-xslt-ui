<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:svg="http://www.w3.org/2000/svg">
	<!-- 
	Author: 	J. van Leuven (Everest)
	Date:		2009-01-22
	Description:	presentationstyles fo-sheet for Aquima Documents

	Version history:
	20110726 1.18 M. Joosen		Allow padding in blcks
	20110722 1.18 M. Joosen		Allow start-indent in blcks
	20110717 1.17 M. Joosen		Allow inline statements
	20110616 1.16 M. Joosen		Ignore starting with kdr_ , std_ , brd_ and vertline_
	20110316 1.15 M. Joosen		First the table ignore
	20110222 1.14 M. Joosen		Still do textstandard and then the overrule
	20110218 1.13 M. Joosen		Allow pagereference and extend hidden
	20101129 1.12 M. Joosen		Bugfix verticalcenter
	20101125 1.11 M. Joosen		Keeptogether also as presentationstyle and verticalcenter
	20101110 1.10 M. Joosen		Ignore rule and hdng styles
	20100929 1.9 M. Joosen		Fix pagefromto bug and add toc_over_documents.
	20100831 1.8 M. Joosen		Better blck customization automatic padding with color
	20100824 1.7 M. Joosen		Better blck customization
	20100819 1.6 M. Joosen		fix for text standard setting
	20100817 1.5 M. Joosen		Adding orient_, bcolor_ width_, color_ to allow further customization
	20100621 1.4 M. Joosen		Allow page-breaks
	20100621 1.4 M. Joosen		Allow span for textblocks
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


	<!-- Template apply_appearence -->
	<xsl:template name="apply_appearence">
		<xsl:variable name="nodename" select="local-name()"/>

		<xsl:if test="$nodename='BODY' or contains($nodename,'HEADER') ">
			<xsl:call-template name="apply_appearence_style">
				<xsl:with-param name="stijl">
					<xsl:value-of select="'textstandard'"/>
				</xsl:with-param>
			</xsl:call-template>
		</xsl:if>

		<xsl:call-template name="apply_appearence_style">
			<xsl:with-param name="stijl">
				<xsl:choose>
					<xsl:when test="@style">
						<xsl:value-of select="@style"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>geen</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<!-- Template apply_appearence_style -->
	<xsl:template name="apply_appearence_style_standard">
		<xsl:param name="style"/>
		<xsl:choose>
			<!-- ignore table-stuff -->
			<xsl:when test="starts-with($style,'table')"/>

			<!-- super and subscript -->
			<xsl:when test="$style='textsuperscript'">
				<xsl:attribute name="baseline-shift">super</xsl:attribute>
				<xsl:attribute name="font-size">0.6em</xsl:attribute>
			</xsl:when>
			<xsl:when test="$style='textsubscript'">
				<xsl:attribute name="baseline-shift">sub</xsl:attribute>
				<xsl:attribute name="font-size">0.6em</xsl:attribute>
			</xsl:when>

			<!-- hyphenate -->
			<xsl:when test="$style='hyphenate'">
				<xsl:attribute name="hyphenate">true</xsl:attribute>
			</xsl:when>
			<!-- fontsizes -->
			<xsl:when test="starts-with($style,'fontsize')">
				<xsl:attribute name="font-size">
					<xsl:value-of select="concat(substring-after($style, '_'),'pt')"/>
				</xsl:attribute>
			</xsl:when>
			<!-- font-families -->
			<xsl:when test="contains($style,'fontfamily')">
				<xsl:attribute name="font-family"><xsl:value-of select="translate(substring-after($style,'_'),'_',' ')"/></xsl:attribute>
			</xsl:when>
			<!-- position styles -->
			<xsl:when test="$style='verticalcenter'">
				<xsl:attribute name="display-align">center</xsl:attribute>
			</xsl:when>
			<xsl:when test="$style='rightaligned'">
				<xsl:attribute name="text-align">right</xsl:attribute>
			</xsl:when>
			<xsl:when test="$style='leftaligned'">
				<xsl:attribute name="text-align">left</xsl:attribute>
			</xsl:when>
			<xsl:when test="$style='center'">
				<xsl:attribute name="text-align">center</xsl:attribute>
			</xsl:when>
			<xsl:when test="$style='bottomaligned'">
				<xsl:attribute name="display-align">after</xsl:attribute>
			</xsl:when>
			<xsl:when test="$style='topaligned'">
				<xsl:attribute name="display-align">before</xsl:attribute>
			</xsl:when>
			<xsl:when test="$style='keeptogether'">
				<xsl:attribute name="keep-together">always</xsl:attribute>
			</xsl:when>
			<xsl:when test="contains($style,'blck') or contains($style,'inline')">
				<xsl:if test="contains($style,'bg_')">
					<xsl:attribute name="background"><xsl:value-of select="concat('#',substring-before(substring-after($style,'bg_'),'_'))"/></xsl:attribute>
					<xsl:attribute name="padding-start">0.5mm</xsl:attribute>
				</xsl:if>
				<xsl:if test="contains($style,'pa_')">
					<xsl:attribute name="padding"><xsl:value-of select="concat(substring-before(substring-after($style,'pa_'),'_'),'mm')"/></xsl:attribute>
				</xsl:if>
				<xsl:if test="contains($style,'pl_')">
					<xsl:attribute name="padding-start"><xsl:value-of select="concat(substring-before(substring-after($style,'pl_'),'_'),'mm')"/></xsl:attribute>
				</xsl:if>
				<xsl:if test="contains($style,'pr_')">
					<xsl:attribute name="padding-left"><xsl:value-of select="concat(substring-before(substring-after($style,'pr_'),'_'),'mm')"/></xsl:attribute>
				</xsl:if>
				<xsl:if test="contains($style,'pt_')">
					<xsl:attribute name="padding-top"><xsl:value-of select="concat(substring-before(substring-after($style,'pt_'),'_'),'mm')"/></xsl:attribute>
				</xsl:if>
				<xsl:if test="contains($style,'pb_')">
					<xsl:attribute name="padding-bottom"><xsl:value-of select="concat(substring-before(substring-after($style,'pb_'),'_'),'mm')"/></xsl:attribute>
				</xsl:if>
				<xsl:if test="contains($style,'tw_')">
					<xsl:attribute name="width"><xsl:value-of select="concat(substring-before(substring-after($style,'tw_'),'_'),'%')"/></xsl:attribute>
				</xsl:if>
				<xsl:if test="contains($style,'ta_')">
					<xsl:attribute name="text-align"><xsl:value-of select="substring-before(substring-after($style,'ta_'),'_')"/></xsl:attribute>
				</xsl:if>
				<xsl:if test="contains($style,'tc_')">
					<xsl:attribute name="color"><xsl:value-of select="concat('#',substring-before(substring-after($style,'tc_'),'_'))"/></xsl:attribute>
				</xsl:if>
				<xsl:if test="contains($style,'bc_')">
					<xsl:attribute name="border"><xsl:value-of select="concat('0.5pt solid #',substring-before(substring-after($style,'bc_'),'_'))"/></xsl:attribute>
				</xsl:if>
				<xsl:if test="contains($style,'si_')">
					<xsl:attribute name="start-indent"><xsl:value-of select="concat(substring-before(substring-after($style,'si_'),'_'),'mm')"/></xsl:attribute>
				</xsl:if>
			</xsl:when>

			<!-- pagenumbering styles -->
			<xsl:when test="$style='page'">
				<fo:page-number/>
			</xsl:when>
			<xsl:when test="$style='pagereference'">
				<xsl:variable name="reference">
					<xsl:call-template name="replaceCharsInString">
						<xsl:with-param name="stringIn" select="concat('anchor_',string(.//TEXT/T))"/>
						<xsl:with-param name="charsIn" select="' '"/>
				 		<xsl:with-param name="charsOut" select="''"/>
					</xsl:call-template>
				</xsl:variable>
				<fo:basic-link>
					<xsl:attribute name="internal-destination"><xsl:value-of select="$reference"/></xsl:attribute>
					<fo:page-number-citation>
						<xsl:attribute name="ref-id">
							<xsl:value-of select="$reference"/>
						</xsl:attribute>
					</fo:page-number-citation>
				</fo:basic-link>
			</xsl:when>
			<xsl:when test="$style='pageto'">
				<fo:page-number-citation>
					<xsl:attribute name="ref-id">lastpage<xsl:call-template name="generateid_basetype"/></xsl:attribute>
				</fo:page-number-citation>
			</xsl:when>
			<xsl:when test="$style='pagefromto'">
				<fo:page-number/>
				<xsl:value-of select="$int_pagenumber_from"/>
				<fo:page-number-citation>
					<xsl:attribute name="ref-id">lastpage<xsl:call-template name="generateid_basetype"/></xsl:attribute>
				</fo:page-number-citation>
			</xsl:when>
			<!-- newline -->
			<xsl:when test="$style='newline'">
				<fo:block/>
			</xsl:when>
			<!-- span -->
			<xsl:when test="contains($style,'_span_')">
				<xsl:attribute name="span">
					<xsl:value-of select="substring-before(substring-after($style,'span_'),'_')"/>
				</xsl:attribute>
			</xsl:when>
			<!-- ignoring -->
			<xsl:when test="$style='dotted'" />
			<xsl:when test="starts-with($style,'list')"/>
			<xsl:when test="starts-with($style,'META') or starts-with($style,'meta') "/>
			<xsl:when test="starts-with($style,'HIDDEN') or starts-with($style,'hidden') or contains($style,'hidden')"/>
			<xsl:when test="starts-with($style,'COLUMNS') or starts-with($style,'columns')"/>
			<xsl:when test="starts-with($style,'pagebreak')"/>
			<xsl:when test="starts-with($style,'plc_')"/>
			<xsl:when test="starts-with($style,'rule')"/>
			<xsl:when test="starts-with($style,'hdng_')"/>
			<xsl:when test="starts-with($style,'toc_')"/>
			<!-- begin people could use table specific styles without using table --> 
			<xsl:when test="starts-with($style,'std_') and (contains(name(),'TABLE'))"/>
			<xsl:when test="starts-with($style,'kdr_') and (contains(name(),'TABLE'))"/>
			<xsl:when test="starts-with($style,'brd_') and (contains(name(),'TABLE'))"/>
			<xsl:when test="starts-with($style,'vertline_') and (contains(name(),'TABLE'))"/>
			<!-- end people could use table specific styles without using table --> 
			<xsl:when test="contains($style,'start_value') or contains($style,'automatic_count') "/>
			<xsl:when test="contains($style,'no_heading_numbering')  "/>
			<xsl:when test="contains($style,'continuously') "/>
			<xsl:when test="contains($style,'pagenumbercontinue') "/>
			<xsl:when test="contains($style,'maintain_space') or contains(@style,'maintain_space')"/>
			<xsl:when test="contains($style,'rowmajor') or contains(@style,'rowmajor')"/>
			<xsl:when test="not($style)"/>
			<xsl:when test="$style='geen'"/>
			<xsl:when test="not(@style)"/>
			<xsl:otherwise>
				<xsl:attribute name="font-family">Courier</xsl:attribute>
				<xsl:attribute name="color">red</xsl:attribute>
				<xsl:text>ERROR ON STYLE=</xsl:text>
				<xsl:value-of select="$style"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
</xsl:stylesheet>
