<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:template match="failed-element">
		<div class="aq-element-error-container">
			<xsl:apply-templates mode="failed-element"/>
		</div>
	</xsl:template>
	<xsl:template match="message" mode="failed-element">
		<div class="aq-error-header-top" />
		<div class="aq-element-error">
			<xsl:value-of select="../@type"/> element "<xsl:value-of select="../@name"/>" resulted in an error: <xsl:value-of select="."/>
		</div>
		<div class="aq-error-header-bottom" />
	</xsl:template>
	<xsl:template match="stacktrace" mode="failed-element">
		<a href="javascript:void(0);"><xsl:attribute name="onclick">$("#<xsl:value-of select="../@id"/>").toggle();</xsl:attribute>Stacktrace</a>
		<div class="aq-stacktrace">
			<xsl:attribute name="id"><xsl:value-of select="../@id"/></xsl:attribute>
			<pre>
				<xsl:value-of select="."/>
			</pre>
		</div>
	</xsl:template>
	<xsl:template match="containerDisplayName" mode="failed-element"/>
</xsl:stylesheet>
