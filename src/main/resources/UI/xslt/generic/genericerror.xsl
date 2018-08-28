<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:template match="/application-page/page/error">
		<xsl:apply-templates mode="genericerror"/>
	</xsl:template>

	<xsl:template match="message" mode="genericerror">
		<div class="aq-page-{@level}">
			<xsl:value-of select="."/>
		</div>
	</xsl:template>
</xsl:stylesheet>
