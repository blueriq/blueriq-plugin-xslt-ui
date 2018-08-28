<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:template match="externalcontent">
		<iframe width="100%" class="aq-external-content-frame">
			<xsl:attribute name="src"><xsl:value-of select="field[@name = 'URL']/value" /></xsl:attribute>
		</iframe>
	</xsl:template>
</xsl:stylesheet>