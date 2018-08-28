<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:template match="content">
		<p id="{$idPrefix}{@id}" class="aq-asset {@content-type} {@format}">
			<xsl:value-of select="."/>
		</p>
	</xsl:template>
</xsl:stylesheet>
