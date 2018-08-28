<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:param name="fileUploadLink" select="'../FileUploadHandler.html'" />

	<xsl:template name="head-fileupload">
		<!-- Library -->
		<script type="text/javascript"
			src="{$themePath}/lib/fileupload/js/jquery.ui.widget.js"></script>
		<script type="text/javascript"
			src="{$themePath}/lib/fileupload/js/jquery.fileupload.js"></script>
		<script type="text/javascript"
			src="{$themePath}/lib/fileupload/js/jquery.fileupload-process.js"></script>
		<script type="text/javascript"
			src="{$themePath}/lib/fileupload/js/jquery.fileupload-validate.js"></script>
		<script type="text/javascript"
			src="{$themePath}/lib/fileupload/js/jquery.iframe-transport.js"></script>
		<link rel="stylesheet" type="text/css"
			href="{$themePath}/lib/fileupload/css/jquery.fileupload.css" />
		<!-- Application -->
		<script type="text/javascript" src="{$themePath}/js/fileupload.js"></script>
		<link rel="stylesheet" type="text/css" href="{$themePath}/css/fileupload.css" />
	</xsl:template>

	<xsl:template match="fileupload">
		<div id="{$idPrefix}{@id}" class="aq-fileupload">
			<xsl:attribute name="data-idPrefix">
				<xsl:value-of select="$idPrefix" />
			</xsl:attribute>
			
			<xsl:attribute name="data-url">
				<xsl:value-of select="$fileUploadLink" />?<xsl:value-of	select="$idPrefix" />sessionId=<xsl:value-of select="$sessionId" />&amp;configurationId=<xsl:value-of select="properties/property[@name='configurationid']" />&amp;htmlDiff=true
			</xsl:attribute>
			<xsl:attribute name="data-singleFileMode">
				<xsl:value-of select="properties/property[@name='singlefilemode']" />
			</xsl:attribute>
			<xsl:attribute name="data-allowedExtensions">
				<xsl:value-of select="properties/property[@name='allowedextensions']" />
			</xsl:attribute>
			<xsl:attribute name="data-maxFileSize">
				<xsl:value-of select="properties/property[@name='maxfilesize']" />
			</xsl:attribute>
			<xsl:attribute name="data-singleUploadLabel">
				<xsl:value-of select="properties/property[@name='singleuploadlabel']" />
			</xsl:attribute>
			<xsl:attribute name="data-multiUploadLabel">
				<xsl:value-of select="properties/property[@name='multiuploadlabel']" />
			</xsl:attribute>
			<xsl:attribute name="data-fileSizeDescription">
				<xsl:value-of select="properties/property[@name='filesizedescription']" />
			</xsl:attribute>
			<xsl:attribute name="data-extensionDescription">
				<xsl:value-of select="properties/property[@name='extensiondescription']" />
			</xsl:attribute>
			<xsl:attribute name="data-fileSizeValidationMessage">
				<xsl:value-of select="properties/property[@name='filesizevalidationmessage']" />
			</xsl:attribute>
			<xsl:attribute name="data-extensionValidationMessage">
				<xsl:value-of select="properties/property[@name='extensionvalidationmessage']" />
			</xsl:attribute>
			<xsl:attribute name="data-uploadFailedMessage">
				<xsl:value-of select="properties/property[@name='uploadfailedmessage']" />
			</xsl:attribute>

			<span class="btn btn-success fileinput-button">
				<span class="fileUploadLabel"></span>
				<input class="fileUploadInput" type="file"></input>
			</span>
			<p class="muted">
				<small class="fileUploadDescription"></small>
			</p>
			<div class="progress progress-striped active" style="margin-bottom: 0;">
				<div class="bar"></div>
			</div>
	
			<table class="invalidFileTable table table-striped">
				<caption class="text-error invalidFileTableCaption">No files were uploaded because the following files do not meet all conditions:</caption>
			    <tbody>		    
			    </tbody>
			</table>
			
			<xsl:apply-templates select="container"/>
		</div>
	</xsl:template>
</xsl:stylesheet>