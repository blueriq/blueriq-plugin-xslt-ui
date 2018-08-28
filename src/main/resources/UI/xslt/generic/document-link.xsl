<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:param name="documentLink" select="'../Document'" />
	<xsl:param name="documentLinkAdditionalArgs" />

	<xsl:template match="document-link">
		<xsl:variable name="documentUrl"><xsl:value-of select="$documentLink" />?<xsl:apply-templates select="parameters"
						mode="document-link" />sessionId=<xsl:value-of
						select="$sessionId" />&amp;ckid=<xsl:value-of select="$cache-killer" /><xsl:value-of
						select="$documentLinkAdditionalArgs" /></xsl:variable>
		<div class="aq-document">
			<div class="aq-saveas">
				<a class="aq-document-link" href="{$documentUrl}&amp;document-saveas=true"><xsl:value-of select="text" /></a>
			</div>
			<!-- use link below to let the user open the document in the browser
			<div class="aq-save">
				<a class="aq-document-link" href="{$documentUrl}&amp;document-saveas=false"><xsl:value-of select="text" /></a>
			</div> -->
		</div>
	</xsl:template>

	<xsl:template match="parameters" mode="document-link"><xsl:apply-templates select="parameter" mode="document-link"/></xsl:template>
	<xsl:template match="parameter" mode="document-link"><xsl:value-of select="@name"/>=<xsl:value-of select="."/>&amp;</xsl:template>
</xsl:stylesheet>