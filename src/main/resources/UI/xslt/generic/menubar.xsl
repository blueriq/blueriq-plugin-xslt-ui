<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:template match="menubar">
		<div class="aq-menubar">
			<xsl:apply-templates select="containerDisplayName" />
			<xsl:apply-templates select="button" mode="menubar" />
		</div>
	</xsl:template>
	
	<xsl:template match="button" mode="menubar">
		<button id="{$idPrefix}{@id}" type="button" class="aq-menubar-button">
			<xsl:attribute name="onclick">Runtime.submit(this, '<xsl:value-of select="$idPrefix" />')</xsl:attribute>
			<xsl:choose>
				<xsl:when test="@disabled">
					<xsl:attribute name="disabled">disabled</xsl:attribute>
					<xsl:attribute name="class">aq-menubar-button disabled</xsl:attribute>
				</xsl:when>
				<xsl:when test="presentationStyle = 'MenuBarButtonHighlighted'">
					<xsl:attribute name="class">aq-menubar-button aq-menubar-button-highlighted</xsl:attribute>
				</xsl:when>
			</xsl:choose>
			<xsl:value-of select="@caption"/>
		</button>
	</xsl:template>
 
</xsl:stylesheet>