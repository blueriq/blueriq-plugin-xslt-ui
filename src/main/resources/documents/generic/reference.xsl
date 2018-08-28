<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:svg="http://www.w3.org/2000/svg">
	<!-- 
	Author: 	M. Joosen (Everest)
	Date:		2010-01-11
	Description:	references fo-sheet for Aquima Documents

	Version history:
	20101110 1.3 M. Joosen		made more configurable
	20101109 1.2 M. Joosen		xmlmind trips over empty table, made conditional.
	20100802 1.1 M. Joosen		Spacing made configurable
	20100609 1.0 M. Joosen		Version 1.0 positioning
	20100519 0.3 M. Joosen		Allowing cols and colspan
	20100113 0.2 M. Joosen		Spaces between tables is smaller (3mm)
	20100112 0.1 M. Joosen		Creation based on mastersheet
	-->


	<!-- Template REFERENCES -->
	<xsl:template match="REFERENCES" mode="page1">
		<xsl:variable name="ColsPrescribed" select="contains(@style,'cols_') and not(contains(@style,'nrcols_'))"/>
		<xsl:variable name="NrCols">
			<xsl:choose>
				<xsl:when test="number(substring-before(substring-after(@style,'nrcols_'),'_'))">
					<xsl:value-of select="substring-before(substring-after(@style,'nrcols_'),'_')"/>
				</xsl:when>
				<xsl:when test="$ColsPrescribed">
					<xsl:call-template name="CalculateTableMakeColumn">
						<xsl:with-param name="distribution" select="substring-after(@style,'cols_')"/>
						<xsl:with-param name="nr" select="'0'"/>
					</xsl:call-template>
				</xsl:when>
				<xsl:otherwise>3</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="ColsWidth">
			<xsl:choose>
				<xsl:when test="$NrCols &gt; 0">
					<xsl:value-of select="155 div $NrCols"/>
				</xsl:when>
				<xsl:otherwise>155</xsl:otherwise>
			</xsl:choose>	
			<xsl:text>mm</xsl:text>
		</xsl:variable>
		<fo:block-container absolute-position="fixed" >
			<xsl:apply-templates select="." mode="position"/>
			<fo:table table-layout="auto">
				<xsl:if test="$ColsPrescribed">
					<xsl:call-template name="TableMakeColumn">
						<xsl:with-param name="distribution" select="substring-after(@style,'cols_')"/>
					</xsl:call-template>
				</xsl:if>
				<fo:table-body>
					<fo:table-row>
						<xsl:for-each select="REFERENCE[position() &lt;= $NrCols]">
							<xsl:variable name="idx" select="position()"/>
							<fo:table-cell>
								<xsl:attribute name="column-number"><xsl:value-of select="$idx"/></xsl:attribute>
								<xsl:if test="not($ColsPrescribed)">
									<xsl:attribute name="width"><xsl:value-of select="$ColsWidth"/></xsl:attribute>
								</xsl:if>
								<xsl:if test="contains(@style,'colspan_')">
									<xsl:call-template name="TableMakeColspan"/>
								</xsl:if>
								<fo:block>
									<xsl:call-template name="apply_appearence_style">
										<xsl:with-param name="stijl">textreferencetitle</xsl:with-param>
									</xsl:call-template>
									<xsl:apply-templates select="REFERENCETITLE"/>
								</fo:block>
							</fo:table-cell>
						</xsl:for-each>
					</fo:table-row>
					<fo:table-row>
						<xsl:for-each select="REFERENCE[position() &lt;= $NrCols]">
							<xsl:variable name="idx" select="position()"/>
							<fo:table-cell>
								<xsl:attribute name="column-number"><xsl:value-of select="$idx"/></xsl:attribute>
								<xsl:if test="not($ColsPrescribed)">
									<xsl:attribute name="width"><xsl:value-of select="$ColsWidth"/></xsl:attribute>
								</xsl:if>
								<xsl:if test="contains(@style,'colspan_')">
									<xsl:call-template name="TableMakeColspan"/>
								</xsl:if>
								<fo:block>
									<xsl:call-template name="apply_appearence_style">
										<xsl:with-param name="stijl">textreferencevalue</xsl:with-param>
									</xsl:call-template>
									<xsl:apply-templates select="REFERENCEVALUE"/>
								</fo:block>
							</fo:table-cell>
						</xsl:for-each>
					</fo:table-row>
				</fo:table-body>
			</fo:table>
			<!-- create only if exists -->
			<xsl:if test="REFERENCE[position() &gt; $NrCols]">
				<fo:table table-layout="auto">
					<xsl:apply-templates select="." mode="spacing"/>
					<xsl:if test="$ColsPrescribed">
						<xsl:call-template name="TableMakeColumn">
							<xsl:with-param name="distribution" select="substring-after(@style,'cols_')"/>
						</xsl:call-template>
					</xsl:if>
					<fo:table-body>
						<fo:table-row>
							<xsl:for-each select="REFERENCE[position() &gt; $NrCols]">
								<xsl:variable name="idx" select="position()"/>
								<fo:table-cell>
									<xsl:attribute name="column-number"><xsl:value-of select="$idx"/></xsl:attribute>
									<xsl:if test="not($ColsPrescribed)">
										<xsl:attribute name="width"><xsl:value-of select="$ColsWidth"/></xsl:attribute>
									</xsl:if>
									<xsl:if test="contains(@style,'colspan_')">
										<xsl:call-template name="TableMakeColspan"/>
									</xsl:if>
									<fo:block>
										<xsl:call-template name="apply_appearence_style">
											<xsl:with-param name="stijl">textreferencetitle</xsl:with-param>
										</xsl:call-template>
										<xsl:apply-templates select="REFERENCETITLE"/>
									</fo:block>
								</fo:table-cell>
							</xsl:for-each>
						</fo:table-row>
						<fo:table-row>
							<xsl:for-each select="REFERENCE[position() &gt; $NrCols]">
								<xsl:variable name="idx" select="position()"/>
								<fo:table-cell>
									<xsl:attribute name="column-number"><xsl:value-of select="$idx"/></xsl:attribute>
									<xsl:if test="not($ColsPrescribed)">
										<xsl:attribute name="width"><xsl:value-of select="$ColsWidth"/></xsl:attribute>
									</xsl:if>
									<xsl:if test="contains(@style,'colspan_')">
										<xsl:call-template name="TableMakeColspan"/>
									</xsl:if>
									<fo:block>
										<xsl:call-template name="apply_appearence_style">
											<xsl:with-param name="stijl">textreferencevalue</xsl:with-param>
										</xsl:call-template>
										<xsl:apply-templates select="REFERENCEVALUE"/>
									</fo:block>
								</fo:table-cell>
							</xsl:for-each>
						</fo:table-row>
					</fo:table-body>
				</fo:table>
			</xsl:if>
		</fo:block-container>
	</xsl:template>

	<xsl:template match="REFERENCES" mode="page2"/>

	<xsl:template name="CalculateTableMakeColumn">
		<xsl:param name="distribution"/>
		<xsl:param name="nr"/>
		<xsl:choose>
			<xsl:when test="string-length($distribution) = 0">
				<xsl:value-of select="$nr"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="CalculateTableMakeColumn">
					<xsl:with-param name="distribution" select="substring-after($distribution, '_')"/>
					<xsl:with-param name="nr" select="$nr + 1"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
</xsl:stylesheet>
