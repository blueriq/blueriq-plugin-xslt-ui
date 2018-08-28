<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:svg="http://www.w3.org/2000/svg">

	<!-- 
	Author: 	M. Joosen (Everest)
	Date:		2010-06-07
	Description:	column fo-sheet for Aquima Documents

	Version history:
	20100607 1.0 M. Joosen		Column definitions
	-->

	<!-- 
		coding
		pw	page-width
		ph	page-height
		pml	page-margin-left
		pmr	page-margin-right
		pmb	page-margin-bottom
		pmt	page-margin-top
		mfb	body-margin-firstpage-bottom
		mft	body-margin-firstpage-top
		mrb	body-margin-restpage-bottom
		mrt	body-margin-restpage-top
		mlb	body-margin-lastpage-bottom
		mlt	body-margin-lastpage-top
		cc	columns-count
		cg	columns-gap
		hf	header-firstpage
		hr	header-restpage
		hl	header-lastpage
		ff	footer-firstpage
		fr	footer-restpage
		fl	footer-lastpage
	-->

	<xsl:template match="COLUMN" mode="pagemaster">
		<xsl:call-template name="PAGEMASTER">
			<xsl:with-param name="type"  select="'COLUMN'"/>
			<xsl:with-param name="nr">
				<xsl:number level="any" count="COLUMN"/>
			</xsl:with-param>
			<xsl:with-param name="pw"   select="'210mm'"/>
			<xsl:with-param name="ph"   select="'297mm'"/>
			<xsl:with-param name="pml"  select="'25mm'"/>
			<xsl:with-param name="pmr"  select="'25mm'"/>
			<xsl:with-param name="pmb"  select="'10mm'"/>
			<xsl:with-param name="pmt"  select="'12mm'"/>
			<xsl:with-param name="mfb"  select="'10mm'"/>
			<xsl:with-param name="mft"  select="'20mm'"/>
			<xsl:with-param name="mrb"  select="'10mm'"/>
			<xsl:with-param name="mrt"  select="'20mm'"/>
			<xsl:with-param name="mlb"  select="'10mm'"/>
			<xsl:with-param name="mlt"  select="'20mm'"/>
			<xsl:with-param name="cc"   select="'2'"/>
			<xsl:with-param name="cg"   select="'10mm'"/>
			<xsl:with-param name="hf"   select="'20mm'"/>
			<xsl:with-param name="hr"   select="'20mm'"/>
			<xsl:with-param name="hl"   select="'20mm'"/>
			<xsl:with-param name="ff"   select="'10mm'"/>
			<xsl:with-param name="fr"   select="'10mm'"/>
			<xsl:with-param name="fl"   select="'10mm'"/>
		</xsl:call-template>
	</xsl:template>

	<xsl:template match="COLUMN[@style='LABEL']" mode="pagemaster">
		<xsl:call-template name="PAGEMASTER">
			<xsl:with-param name="type"  select="'COLUMN'"/>
			<xsl:with-param name="nr">
				<xsl:number level="any" count="COLUMN"/>
			</xsl:with-param>
			<xsl:with-param name="pw"   select="'210mm'"/>
			<xsl:with-param name="ph"   select="'297mm'"/>
			<xsl:with-param name="pml"  select="'30mm'"/>
			<xsl:with-param name="pmr"  select="'25mm'"/>
			<xsl:with-param name="pmb"  select="'10mm'"/>
			<xsl:with-param name="pmt"  select="'10mm'"/>
			<xsl:with-param name="mfb"  select="'15mm'"/>
			<xsl:with-param name="mft"  select="'40mm'"/>
			<xsl:with-param name="mrb"  select="'5mm'"/>
			<xsl:with-param name="mrt"  select="'30mm'"/>
			<xsl:with-param name="mlb"  select="'5mm'"/>
			<xsl:with-param name="mlt"  select="'30mm'"/>
			<xsl:with-param name="cc"   select="'2'"/>
			<xsl:with-param name="cg"   select="'10mm'"/>
			<xsl:with-param name="hf"   select="'40mm'"/>
			<xsl:with-param name="hr"   select="'30mm'"/>
			<xsl:with-param name="hl"   select="'30mm'"/>
			<xsl:with-param name="ff"   select="'15mm'"/>
			<xsl:with-param name="fr"   select="'5mm'"/>
			<xsl:with-param name="fl"   select="'5mm'"/>
		</xsl:call-template>
	</xsl:template>
	
</xsl:stylesheet>
