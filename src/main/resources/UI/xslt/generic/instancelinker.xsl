<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:template match="instance_linker">
		<div id="{$idPrefix}{@id}">
			<xsl:apply-templates select="field"/>
		</div>
	</xsl:template>
</xsl:stylesheet>