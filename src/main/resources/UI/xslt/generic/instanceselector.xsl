<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:template match="instance_selector">
		<div id="{$idPrefix}{@id}" class="aq-container aq-instanceselector {@format}">
			<xsl:apply-templates select="containerDisplayName"/>
			<table class="aq-instanceselector">
				<xsl:apply-templates select="header" mode="instance_selector"/>
				<xsl:apply-templates select="instance" mode="instance_selector"/>
			</table>
			<xsl:apply-templates select="container"/>
			<div class="aq-container">
				<xsl:apply-templates select="buttons"/>
			</div>
		</div>
	</xsl:template>
	<xsl:template match="header" mode="instance_selector">
		<tr>
			<xsl:if test="not(../@type='instanceselectorplus') and not(../@readonly='true')">
				<th> </th>
			</xsl:if>
			<xsl:apply-templates select="content" mode="instance_selector"/>
		</tr>
	</xsl:template>
	<xsl:template match="content" mode="instance_selector">
		<th>
			<xsl:value-of select="."/>
		</th>
	</xsl:template>
	<xsl:template match="instance" mode="instance_selector">
		<tr>
			<xsl:attribute name="class">
				<xsl:choose>
					<xsl:when test="position() mod 2 = 1">aq-odd</xsl:when>
					<xsl:otherwise>aq-even</xsl:otherwise>		
				</xsl:choose>
			</xsl:attribute>
			<xsl:if test="not(../@type='instanceselectorplus') and not(../@readonly='true')">
				<td>
					<input type="radio" name="{@idName}" value="{$idPrefix}{@id}">
						<xsl:if test="../selected/@id=@id">
							<xsl:attribute name="checked">checked</xsl:attribute>
						</xsl:if>
					</input>
				</td>
			</xsl:if>
			<xsl:apply-templates select="*" mode="instance_selector"/>
		</tr>
	</xsl:template>
	<xsl:template match="field" mode="instance_selector">
		<td>
			<xsl:apply-templates select="." mode="field"/>
			<xsl:apply-templates select="error" mode="field"/>
		</td>
	</xsl:template>
	<xsl:template match="container" mode="instance_selector">
		<xsl:apply-templates mode="instance_selector"/>
	</xsl:template>
	<xsl:template match="*" mode="instance_selector">
		<td>
			<xsl:apply-templates select="."/>
		</td>
	</xsl:template>
</xsl:stylesheet>