<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:svg="http://www.w3.org/2000/svg">

	<!-- 
	Author: 	J. van Leuven (Everest)
	Date:		2009-01-22
	Description:	attributelist fo-sheet for Aquima Documents

	Version history:
	20100609 1.0 M. Joosen		Version 1.0 position shifted to custom
	20100602 0.4 J. van Leuven	AQU-4152: source indentation dependency fix 
	20091209 0.3 M. Joosen		Removed output format
	20090126 0.2 M. Joosen		Using english terms 		
	20090122 0.1 J. van Leuven 	Creation based on mastersheet
	-->

	<!-- Template ATTRIBUTELIST and ATTRIBUTE -->
	<xsl:template match="ATTRIBUTELIST" mode="page1">
		<fo:block-container absolute-position="fixed">
			<xsl:apply-templates select="." mode="position"/>
			<fo:table table-layout="auto">
				<xsl:call-template name="apply_appearence_style">
					<xsl:with-param name="stijl">textattribute</xsl:with-param>
				</xsl:call-template>
				<fo:table-body>
					<xsl:apply-templates select="ATTRIBUTE"/>
				</fo:table-body>
			</fo:table>
		</fo:block-container>
	</xsl:template>
	<xsl:template match="ATTRIBUTELIST" mode="page2">
		<fo:block-container absolute-position="fixed">
			<xsl:apply-templates select="." mode="position"/>
			<fo:table table-layout="auto">
				<xsl:call-template name="apply_appearence_style">
					<xsl:with-param name="stijl">textattribute</xsl:with-param>
				</xsl:call-template>
				<fo:table-body>
					<xsl:apply-templates select="ATTRIBUTE"/>
				</fo:table-body>
			</fo:table>
		</fo:block-container>
	</xsl:template>
	<xsl:template match="ATTRIBUTE">
		<fo:table-row>
			<fo:table-cell column-number="1" >
			<xsl:apply-templates select="." mode="position"/>
				<xsl:for-each select="ATTRIBUTETITLE">
					<fo:block>
						<xsl:apply-templates select="*"/>
					</fo:block>
				</xsl:for-each>
			</fo:table-cell>
			<fo:table-cell column-number="2" padding-start="1mm" padding-end="1mm">
				<fo:block>:</fo:block>
			</fo:table-cell>
			<fo:table-cell column-number="3">
				<xsl:apply-templates select="ATTRIBUTEVALUE"/>
			</fo:table-cell>
		</fo:table-row>
	</xsl:template>

	<xsl:template match="ATTRIBUTETITLE | ATTRIBUTEVALUE">
		<fo:block>
			<xsl:call-template name="apply_appearence"/>
			<xsl:apply-templates select="*"/>
		</fo:block>
	</xsl:template>


	
</xsl:stylesheet>
