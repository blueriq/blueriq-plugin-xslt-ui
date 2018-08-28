<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:template match="content-item">
		<div>
			<xsl:attribute name="id"><xsl:value-of select="$idPrefix"/><xsl:value-of select="@id"/></xsl:attribute>
			<xsl:attribute name="class"><xsl:value-of select="@content-style"/></xsl:attribute>
			<xsl:apply-templates select="*"/>
		</div>
	</xsl:template>

</xsl:stylesheet>