<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:template match="table">
		<xsl:apply-templates select="tableDisplayName" mode="table" />
		<div class="aq-table-wrapper">
			<table class="aq-table">
				<xsl:attribute name="id"><xsl:value-of select="$idPrefix" /><xsl:value-of select="@id" /></xsl:attribute>
				<xsl:if test="@format">
					<xsl:attribute name="class"><xsl:value-of select="@format" /></xsl:attribute>
				</xsl:if>
				<xsl:apply-templates select="header" mode="table" />
				<xsl:apply-templates select="row" mode="table" />
			</table>
		</div>
	</xsl:template>
	<xsl:template match="tableDisplayName" mode="table">
		<h2>
			<xsl:value-of select="." />
		</h2>
	</xsl:template>
	<xsl:template match="header" mode="table">
		<thead>
			<xsl:if test="@format">
				<xsl:attribute name="class"><xsl:value-of select="@format" /></xsl:attribute>
			</xsl:if>
			<tr>
				<xsl:apply-templates mode="header" />
			</tr>
		</thead>
	</xsl:template>
	<xsl:template match="row" mode="table">
		<tr>
			<xsl:attribute name="class">
				<xsl:choose>
					<xsl:when test="position() mod 2 = 1">aq-odd</xsl:when>
					<xsl:otherwise>aq-even</xsl:otherwise>		
				</xsl:choose>
			</xsl:attribute>
			<xsl:if test="@format">
				<xsl:attribute name="class"><xsl:value-of select="@format" /></xsl:attribute>
			</xsl:if>
			<xsl:apply-templates mode="row" />
		</tr>
	</xsl:template>
	<xsl:template match="cell" mode="header">
		<th>
			<xsl:if test="@colspan">
				<xsl:attribute name="colspan"><xsl:value-of select="@colspan" /></xsl:attribute>
			</xsl:if>
			<xsl:if test="@align">
				<xsl:attribute name="align"><xsl:value-of select="@align" /></xsl:attribute>
			</xsl:if>
			<xsl:if test="@format">
				<xsl:attribute name="class"><xsl:value-of select="@format" /></xsl:attribute>
			</xsl:if>
			
			<span>
				<xsl:apply-templates mode="cellcontent" />
			</span>
		</th>
	</xsl:template>
	<xsl:template match="cell" mode="row">
		<td>
			<xsl:if test="@colspan">
				<xsl:attribute name="colspan"><xsl:value-of select="@colspan" /></xsl:attribute>
			</xsl:if>
			<xsl:if test="@align">
				<xsl:attribute name="align"><xsl:value-of select="@align" /></xsl:attribute>
			</xsl:if>
			<xsl:if test="@format">
				<xsl:attribute name="class"><xsl:value-of select="@format" /></xsl:attribute>
			</xsl:if>
			<xsl:apply-templates mode="cellcontent" />
		</td>
	</xsl:template>
	<xsl:template match="field" mode="cellcontent">
		<xsl:apply-templates select="." mode="field" /> <!-- see field.xsl -->
		<xsl:apply-templates select="error" mode="field" /> <!-- see field.xsl -->
	</xsl:template>
	<xsl:template match="*" mode="cellcontent">
		<xsl:apply-templates select="." />
	</xsl:template>

	<xsl:template match="presentationStyle" mode="table" />
	<xsl:template match="presentationStyle" mode="row" />
	<xsl:template match="presentationStyle" mode="header" />
</xsl:stylesheet>
