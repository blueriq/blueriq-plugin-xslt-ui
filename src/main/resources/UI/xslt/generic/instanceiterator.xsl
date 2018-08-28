<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:template match="instanceiterator">
		<div class="aq-instanceiterator" id="{$idPrefix}{@id}">
			<xsl:if test="string-length(./containerDisplayName) > 0">
				<h2><xsl:value-of select="./containerDisplayName" /></h2>
			</xsl:if>
			<xsl:apply-templates/>
		</div>
	</xsl:template>
	
	<xsl:template match="instance">
		<div class="aq-instance {@format}" id="{$idPrefix}{@id}">
			<xsl:apply-templates/> 
		</div>
	</xsl:template>

</xsl:stylesheet>
