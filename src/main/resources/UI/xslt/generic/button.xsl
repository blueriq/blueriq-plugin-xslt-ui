<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
 	<xsl:template match="button">
		<xsl:variable name="lowercase" select="'abcdefghijklmnopqrstuvwxyz'" />
		<xsl:variable name="uppercase" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'" />
		<xsl:variable name="buttonClassName" select="concat('aq-button-', translate(@name, $uppercase, $lowercase))" />
		<button id="{$idPrefix}{@id}" name="{$idPrefix}{@id}" type="button">
			<xsl:choose>
				<xsl:when test="@disabled">
					<xsl:attribute name="disabled">disabled</xsl:attribute>
					<xsl:attribute name="class">aq-button <xsl:value-of select="@format" /><xsl:value-of select="' '" /><xsl:value-of select="$buttonClassName" /> aq-button-disabled</xsl:attribute>
				</xsl:when>
				<xsl:otherwise>
					<xsl:attribute name="class">aq-button <xsl:value-of select="@format" /><xsl:value-of select="' '" /><xsl:value-of select="$buttonClassName" /></xsl:attribute>
					<xsl:choose>
						<xsl:when test="@refresh='true'">
							<xsl:attribute name="onclick">Runtime.refresh(this, '<xsl:value-of select="$idPrefix" />')</xsl:attribute>
						</xsl:when>
						<xsl:when test="$widgetContext">
							<xsl:attribute name="onclick">Runtime.widgetSubmit(this, '<xsl:value-of select="$idPrefix" />')</xsl:attribute>
						</xsl:when>
						<xsl:otherwise>
							<xsl:attribute name="onclick">Runtime.submit(this, '<xsl:value-of select="$idPrefix" />')</xsl:attribute>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:value-of select="@caption"/>
		</button>
	</xsl:template>
</xsl:stylesheet>