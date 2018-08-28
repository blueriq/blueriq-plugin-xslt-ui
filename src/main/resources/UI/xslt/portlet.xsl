<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:import href="configuration.xsl" />
	
	<xsl:param name="bodyOnly" />

	<xsl:output method="html" encoding="UTF-8" />

	<xsl:template match="/application-page">
		<xsl:choose>
			<xsl:when test="$bodyOnly">
				<xsl:apply-templates select="page" mode="body" />
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="page" mode="full" />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="page" mode="full">
		<div id="{$idPrefix}aquima" class="aquima">
			<xsl:call-template name="scripts" />
			<input type="hidden" name="{$idPrefix}sessionId" value="{$sessionId}" />
			<xsl:apply-templates select="." mode="body" />
		</div>
	</xsl:template>

	<xsl:template match="page" mode="body">
		<xsl:apply-templates select="." mode="formBody" />
	</xsl:template>
</xsl:stylesheet>