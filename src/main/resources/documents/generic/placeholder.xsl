<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:svg="http://www.w3.org/2000/svg">

	<!-- 
	Author: 	M. Joosen (Everest)
	Date:		2010-06-07
	Description:	placeholder fo-sheet for Aquima Documents

	Version history:
	20100817 1.1 M. Joosen		Allow setting of orientation
	20100607 1.0 M. Joosen		Creation
	-->

	<!-- Template PLACEHOLDER -->
	<xsl:template match="PLACEHOLDER">
		<xsl:variable name="marginleft"   select="concat(substring-before(substring-after(@style,'_ml_'),'_'),'mm')"/>
		<xsl:variable name="marginright"  select="concat(substring-before(substring-after(@style,'_mr_'),'_'),'mm')"/>
		<xsl:variable name="margintop"    select="concat(substring-before(substring-after(@style,'_mt_'),'_'),'mm')"/>
		<xsl:variable name="marginbottom" select="concat(substring-before(substring-after(@style,'_mb_'),'_'),'mm')"/>
		<xsl:variable name="marginwidth"  select="concat(substring-before(substring-after(@style,'_mw_'),'_'),'mm')"/>
		<xsl:variable name="marginheight" select="concat(substring-before(substring-after(@style,'_mh_'),'_'),'mm')"/>
		<fo:block-container absolute-position="fixed" >
			<xsl:if test="string-length($marginleft) &gt; 2">		
				<xsl:attribute name="left"  ><xsl:value-of select="$marginleft"/></xsl:attribute>
			</xsl:if>
			<xsl:if test="string-length($marginright) &gt; 2">		
				<xsl:attribute name="right"  ><xsl:value-of select="$marginright"/></xsl:attribute>
			</xsl:if>
			<xsl:if test="string-length($margintop) &gt; 2">		
				<xsl:attribute name="top"  ><xsl:value-of select="$margintop"/></xsl:attribute>
			</xsl:if>
			<xsl:if test="string-length($marginbottom) &gt; 2">		
				<xsl:attribute name="bottom"  ><xsl:value-of select="$marginbottom"/></xsl:attribute>
			</xsl:if>
			<xsl:if test="string-length($marginwidth) &gt; 2">		
				<xsl:attribute name="width"  ><xsl:value-of select="$marginwidth"/></xsl:attribute>
			</xsl:if>
			<xsl:if test="string-length($marginheight) &gt; 2">		
				<xsl:attribute name="height"  ><xsl:value-of select="$marginheight"/></xsl:attribute>
			</xsl:if>
			<xsl:if test="contains(@style,'orient')">
				<xsl:attribute name="reference-orientation"><xsl:value-of select="substring-before(substring-after(@style,'orient_'),'_')"/></xsl:attribute>
			</xsl:if>
			<fo:block>
				<xsl:apply-templates select="*" />
			</fo:block>
		</fo:block-container>

	</xsl:template>

</xsl:stylesheet>
