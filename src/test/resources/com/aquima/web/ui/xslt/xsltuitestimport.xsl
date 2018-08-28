<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" >

	<xsl:template match="/application-page/page">
		OK_IMPORT
		<xsl:apply-templates />
	</xsl:template>

	<xsl:template match="button">FAIL</xsl:template>
	<xsl:template match="content">FAIL</xsl:template>
	<xsl:template match="field">FAIL</xsl:template>
    
</xsl:stylesheet>