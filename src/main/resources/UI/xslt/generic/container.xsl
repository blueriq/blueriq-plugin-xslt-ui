<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  	<xsl:template match="container">
		<div id="{$idPrefix}{@id}" class="aq-container {@format}">
			<xsl:apply-templates/>
		</div>
	</xsl:template>

	<xsl:template match="listplusheader">
		<div id="{$idPrefix}{@id}">
			
		</div>
	</xsl:template>
	

  	<xsl:template match="listplusfooter">
		<div id="{$idPrefix}{@id}" class="listplusfooter {@format}">
			<xsl:apply-templates/>
		</div>
	</xsl:template>


	<xsl:template match="containerDisplayName">
		<xsl:if test="string-length(.) > 0">
			<h2><xsl:value-of select="."/></h2>
			<div class="aq-container-header-bottom" />
		</xsl:if>
	</xsl:template>

	<xsl:template match="properties">
		<!-- Default render mode: Ignore properties of containers -->
	</xsl:template>
</xsl:stylesheet>