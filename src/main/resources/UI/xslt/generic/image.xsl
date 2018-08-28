<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:param name="imageSource" select="'../Image'" />
	<xsl:param name="imageSourceAdditionalArgs" />

	<xsl:template match="image-item">
		<xsl:variable name="imageSrc"><xsl:value-of select="$imageSource" />?name=<xsl:value-of select="@name" />&amp;key=<xsl:value-of select="@key" />&amp;sessionId=<xsl:value-of select="$sessionId" />&amp;ckid=<xsl:value-of select="$cache-killer" /><xsl:value-of select="$imageSourceAdditionalArgs" /></xsl:variable>

		<xsl:choose>
			<xsl:when test="@type = 'SVG'">
				<embed id="{$idPrefix}{@id}" class="aq-image {@format}" src="{$imageSrc}" type="image/svg+xml">
					<xsl:if test="@height">
						<xsl:attribute name="height"><xsl:value-of select="@height" />px</xsl:attribute>
					</xsl:if>
					<xsl:if test="@width">
						<xsl:attribute name="width"><xsl:value-of select="@width" />px</xsl:attribute>
					</xsl:if>
				</embed>	
			</xsl:when>
			<xsl:otherwise>
				<img id="{$idPrefix}{@id}" class="aq-image {@format}" src="{$imageSrc}">
					<xsl:if test="@height">
						<xsl:attribute name="height"><xsl:value-of select="@height" />px</xsl:attribute>
					</xsl:if>
					<xsl:if test="@width">
						<xsl:attribute name="width"><xsl:value-of select="@width" />px</xsl:attribute>
					</xsl:if>
				</img>				
			</xsl:otherwise>			
		</xsl:choose>
		
	</xsl:template>

</xsl:stylesheet>