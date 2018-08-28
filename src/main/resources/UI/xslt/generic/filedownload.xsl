<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" >
	<xsl:param name="fileDownloadLink" select="'../FileDownloadController'"/>
				
	<xsl:template match="filedownload">
		<div id="{$idPrefix}{@id}" class="aq-filedownload">
			<a>
				<xsl:attribute name="href">
					<xsl:value-of select="$fileDownloadLink"/>?<xsl:value-of select="$idPrefix"/>sessionId=<xsl:value-of select="$sessionId"/>&amp;configurationId=<xsl:value-of select="properties/property[@name='configurationid']"/> 
				</xsl:attribute>
				<xsl:value-of select="button[@name='downloadButton']/@caption" />
			</a>
		</div>
	</xsl:template>
</xsl:stylesheet>