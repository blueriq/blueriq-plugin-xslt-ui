<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:template match="parameter">
		<input type="hidden" id="{$idPrefix}{@name}" name="{$idPrefix}{@name}">
			<xsl:attribute name="value"><xsl:value-of select="."/></xsl:attribute>
		</input>
	</xsl:template>
	<xsl:template match="parameter[@name='application-mode']"/>
</xsl:stylesheet>
