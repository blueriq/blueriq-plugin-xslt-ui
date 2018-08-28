<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" >
	
	<xsl:template match="page" mode="body">
		<div id="{$idPrefix}runtime" class="runtime">
			
			<div class="aq-header">
				<div class="aq-logo"></div>
			</div>

			<div class="aq-page" id="{$idPrefix}{@id}">
				<form method="post" name="{$idPrefix}aq-form" id="{$idPrefix}aq-form" action="{$formAction}" class="aq-form">
					<xsl:apply-templates select="pageDisplayName" mode="page"/>
					<xsl:apply-templates select="breadcrumbcontainer" mode="breadcrumb" />
					<xsl:apply-templates />
					<input type="hidden" id="{$idPrefix}event" name="{$idPrefix}event" />
					<input type="hidden" id="x-csrf-token" name="X-CSRF-Token" value="{$csrfToken}" />
				</form>
				<script type="text/javascript">Runtime.keepAlive('<xsl:value-of select="$sessionId" />', <xsl:value-of select="$maxInactiveInterval" /> * 500);</script>
			</div>
		</div>
	</xsl:template>
	
	<xsl:template match="pageDisplayName" mode="page">
		<h1><xsl:value-of select="."/></h1>
		<div class="aq-page-header-bottom" />
	</xsl:template>	

	<xsl:template match="/application-page/page/pageDisplayName" />

	
</xsl:stylesheet>