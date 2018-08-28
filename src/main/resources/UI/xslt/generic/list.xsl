<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:template match="worklist">
		<div class="aq-worklist" id="{$idPrefix}{@id}">
			<xsl:call-template name="listplus"/>
		</div>
	</xsl:template>
	
	<xsl:template match="caselist">
		<div class="aq-caselist" id="{$idPrefix}{@id}">
			<xsl:call-template name="listplus"/>
		</div>
	</xsl:template>
	
	<xsl:template match="instancelist">
		<div class="aq-instanceselector" id="{$idPrefix}{@id}">
			<xsl:call-template name="abstractList"/>
		</div>
	</xsl:template>

	<xsl:template name="abstractList">
		<div class="listHeader">
			<xsl:apply-templates select="container[@name='searchContainer']"/>
			<xsl:apply-templates select="containerDisplayName"/>
		</div>
		<xsl:apply-templates select="*[not(self::containerDisplayName) and not(self::container[@name='searchContainer'])]"/>
	</xsl:template>
	
	<xsl:template match="container[@name='searchContainer']/field[@format='searchField']">
		<input type="text" id="{$idPrefix}{@id}" name="{@name}">
			<xsl:attribute name="value"><xsl:value-of select="value" /></xsl:attribute>
		</input>
		<script type="text/javascript">
		$("#<xsl:value-of select="$idPrefix"/><xsl:value-of select="@id"/>").keypress(function(e) {
		  if ( event.which == 13 ) {
		  	Runtime.refresh(this, '<xsl:value-of select="$idPrefix" />');
		  }
		});
		</script>
	</xsl:template>
	
	<xsl:template match="container[@name='navigationContainer']/field[@format='paginationNumber']">
		<select id="{$idPrefix}{@id}" name="{$idPrefix}{@id}">
			<xsl:attribute name="onchange">Runtime.refresh(this, '<xsl:value-of select="$idPrefix" />');</xsl:attribute>
			
			<xsl:for-each select="domain/domainValue[@valid='true']">
				<option value="{@value}">
					<xsl:if test="@selected='true'">
						<xsl:attribute name="selected">selected</xsl:attribute>
					</xsl:if>
					<xsl:value-of select="." />
				</option>
			</xsl:for-each>
		</select>
	</xsl:template>
</xsl:stylesheet>