<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	
	<xsl:template name="head-listplus">
		<link rel="stylesheet" type="text/css" href="{$themePath}/css/listplus.css" /> 
	</xsl:template>
	
	<xsl:template name="listplus">
		<xsl:apply-templates select="*[not(self::containerDisplayName) and not(self::container[@name='searchContainer'])]"/>
	</xsl:template>
	
</xsl:stylesheet>