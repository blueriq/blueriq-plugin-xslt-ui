<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:svg="http://www.w3.org/2000/svg">

	<!-- 
	Author: 	M. Joosen (Everest)
	Date:		2010-06-07
	Description:	pagemaster fo-sheet for Aquima Documents

	Version history:
	20100824 1.3 M. Joosen		Allowing blankpages
	20100621 1.2 M. Joosen		Fix columns
	20100616 1.1 M. Joosen		Adding watermark properties
	20100607 1.0 M. Joosen		Creation
	-->

	<!-- Template PAGEMASTER -->
	<xsl:template name="PAGEMASTER">
		<xsl:param name="type" />
		<xsl:param name="nr" />
		<xsl:param name="pw" />
		<xsl:param name="ph" />
		<xsl:param name="pml" />
		<xsl:param name="pmr" />
		<xsl:param name="pmb" />
		<xsl:param name="pmt" />
		<xsl:param name="mfb" />
		<xsl:param name="mft" />
		<xsl:param name="mrb" />
		<xsl:param name="mrt" />
		<xsl:param name="mlb" />
		<xsl:param name="mlt" />
		<xsl:param name="cc" />
		<xsl:param name="cg" />
		<xsl:param name="hf" />
		<xsl:param name="hr" />
		<xsl:param name="hl" />
		<xsl:param name="ff" />
		<xsl:param name="fr" />
		<xsl:param name="fl" />

		<fo:simple-page-master>
			<xsl:attribute name="master-name">
				<xsl:value-of select="concat($type,$nr,'First')"/>
			</xsl:attribute>
			<xsl:attribute name="margin-left">
				<xsl:value-of select="$pml"/>
			</xsl:attribute>
			<xsl:attribute name="margin-right" >
				<xsl:value-of select="$pmr"/>
			</xsl:attribute>
			<xsl:attribute name="margin-bottom" >
				<xsl:value-of select="$pmb"/>
			</xsl:attribute>
			<xsl:attribute name="margin-top">
				<xsl:value-of select="$pmt"/>
			</xsl:attribute>
			<xsl:attribute name="page-width">
				<xsl:value-of select="$pw"/>
			</xsl:attribute>
			<xsl:attribute name="page-height">
				<xsl:value-of select="$ph"/>
			</xsl:attribute>
			<fo:region-body region-name="body">
				<xsl:attribute name="margin-bottom" >
					<xsl:value-of select="$mfb"/>
				</xsl:attribute>
				<xsl:attribute name="margin-top">
					<xsl:value-of select="$mft"/>
				</xsl:attribute>
				<xsl:if test="$type='COLUMN'">
					<xsl:attribute name="column-count">
						<xsl:value-of select="$cc"/>
					</xsl:attribute>
					<xsl:attribute name="column-gap">
						<xsl:value-of select="$cg"/>
					</xsl:attribute>
				</xsl:if>	
				<xsl:apply-templates select=".//BODY/WATERMARK" mode="pagearea"/>
			</fo:region-body>
			<fo:region-before region-name="header_first">
				<xsl:attribute name="extent">
					<xsl:value-of select="$hf"/>
				</xsl:attribute>
				<xsl:apply-templates select=".//HEADERFIRST/WATERMARK" mode="pagearea"/>
			</fo:region-before>
			<fo:region-after region-name="footer_first">
				<xsl:attribute name="extent">
					<xsl:value-of select="$ff"/>
				</xsl:attribute>
				<xsl:apply-templates select=".//FOOTERFIRST/WATERMARK" mode="pagearea"/>
			</fo:region-after>
		</fo:simple-page-master>
		<fo:simple-page-master>
			<xsl:attribute name="master-name">
				<xsl:value-of select="concat($type,$nr,'Rest')"/>
			</xsl:attribute>
			<xsl:attribute name="margin-left">
				<xsl:value-of select="$pml"/>
			</xsl:attribute>
			<xsl:attribute name="margin-right" >
				<xsl:value-of select="$pmr"/>
			</xsl:attribute>
			<xsl:attribute name="margin-bottom" >
				<xsl:value-of select="$pmb"/>
			</xsl:attribute>
			<xsl:attribute name="margin-top">
				<xsl:value-of select="$pmt"/>
			</xsl:attribute>
			<xsl:attribute name="page-width">
				<xsl:value-of select="$pw"/>
			</xsl:attribute>
			<xsl:attribute name="page-height">
				<xsl:value-of select="$ph"/>
			</xsl:attribute>
			<fo:region-body region-name="body">
				<xsl:attribute name="margin-bottom" >
					<xsl:value-of select="$mrb"/>
				</xsl:attribute>
				<xsl:attribute name="margin-top">
					<xsl:value-of select="$mrt"/>
				</xsl:attribute>
				<xsl:if test="$type='COLUMN'">
					<xsl:attribute name="column-count">
						<xsl:value-of select="$cc"/>
					</xsl:attribute>
					<xsl:attribute name="column-gap">
						<xsl:value-of select="$cg"/>
					</xsl:attribute>
				</xsl:if>	
				<xsl:apply-templates select=".//BODY/WATERMARK" mode="pagearea"/>
			</fo:region-body>
			<fo:region-before region-name="header">
				<xsl:attribute name="extent">
					<xsl:value-of select="$hr"/>
				</xsl:attribute>
				<xsl:apply-templates select=".//HEADER/WATERMARK" mode="pagearea"/>
			</fo:region-before>
			<fo:region-after region-name="footer">
				<xsl:attribute name="extent">
					<xsl:value-of select="$fr"/>
				</xsl:attribute>
				<xsl:apply-templates select=".//FOOTER/WATERMARK" mode="pagearea"/>
			</fo:region-after>
		</fo:simple-page-master>
		<fo:simple-page-master>
			<xsl:attribute name="master-name">
				<xsl:value-of select="concat($type,$nr,'Last')"/>
			</xsl:attribute>
			<xsl:attribute name="margin-left">
				<xsl:value-of select="$pml"/>
			</xsl:attribute>
			<xsl:attribute name="margin-right" >
				<xsl:value-of select="$pmr"/>
			</xsl:attribute>
			<xsl:attribute name="margin-bottom" >
				<xsl:value-of select="$pmb"/>
			</xsl:attribute>
			<xsl:attribute name="margin-top">
				<xsl:value-of select="$pmt"/>
			</xsl:attribute>
			<xsl:attribute name="page-width">
				<xsl:value-of select="$pw"/>
			</xsl:attribute>
			<xsl:attribute name="page-height">
				<xsl:value-of select="$ph"/>
			</xsl:attribute>
			<fo:region-body region-name="body">
				<xsl:attribute name="margin-bottom" >
					<xsl:value-of select="$mlb"/>
				</xsl:attribute>
				<xsl:attribute name="margin-top">
					<xsl:value-of select="$mlt"/>
				</xsl:attribute>
				<xsl:if test="$type='COLUMN'">
					<xsl:attribute name="column-count">
						<xsl:value-of select="$cc"/>
					</xsl:attribute>
					<xsl:attribute name="column-gap">
						<xsl:value-of select="$cg"/>
					</xsl:attribute>
				</xsl:if>	
				<xsl:apply-templates select=".//BODY/WATERMARK" mode="pagearea"/>
			</fo:region-body>
			<fo:region-before region-name="header_last">
				<xsl:attribute name="extent">
					<xsl:value-of select="$hl"/>
				</xsl:attribute>
				<xsl:apply-templates select=".//HEADERLAST/WATERMARK" mode="pagearea"/>
			</fo:region-before>
			<fo:region-after region-name="footer_last">
				<xsl:attribute name="extent">
					<xsl:value-of select="$fl"/>
				</xsl:attribute>
				<xsl:apply-templates select=".//FOOTERLAST/WATERMARK" mode="pagearea"/>
			</fo:region-after>
		</fo:simple-page-master>
		<fo:page-sequence-master>
			<xsl:attribute name="master-name">
				<xsl:value-of select="concat($type,$nr,'Pages')"/>
			</xsl:attribute>
			<fo:repeatable-page-master-alternatives>
				<fo:conditional-page-master-reference page-position="first">
					<xsl:attribute name="master-reference">
						<xsl:value-of select="concat($type,$nr,'First')"/>
					</xsl:attribute>
				</fo:conditional-page-master-reference>
				<fo:conditional-page-master-reference page-position="rest">
					<xsl:attribute name="master-reference">
						<xsl:value-of select="concat($type,$nr,'Rest')"/>
					</xsl:attribute>
				</fo:conditional-page-master-reference>
				<fo:conditional-page-master-reference page-position="last">
					<xsl:if test="./PAGEBREAK[contains(@style,'even') or contains(@style,'odd')]">
						<xsl:attribute name="blank-or-not-blank">
							<xsl:text>not-blank</xsl:text>
						</xsl:attribute>
					</xsl:if>
					<xsl:attribute name="master-reference">
						<xsl:value-of select="concat($type,$nr,'Last')"/>
					</xsl:attribute>
				</fo:conditional-page-master-reference>
				<xsl:if test="./PAGEBREAK[contains(@style,'even') or contains(@style,'odd')]">
					<fo:conditional-page-master-reference blank-or-not-blank="blank" page-position="last" master-reference="BlankPage"/>
				</xsl:if>
			</fo:repeatable-page-master-alternatives>
		</fo:page-sequence-master>
	</xsl:template>

</xsl:stylesheet>
