<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:svg="http://www.w3.org/2000/svg">
	<!-- 
	Author: 	M. Joosen (Everest)
	Date:		2010-02-10
	Description:	field fo-sheet for Aquima Documents	

	Version history:
	20100608 1.0 M. Joosen		Version 1.0, made implementation independent
	20100218 0.2 J. van Leuven	Use Windings 2 font for ticked boxes, more info see AQU-1971
	20100210 0.1 M. Joosen		Creation based on the generic stylesheet
	-->

	<!-- The optionseparator: this is decided by the implementation -->

	<!-- Template field -->
	<xsl:template match="FIELD">
		<fo:table border-collapse="collapse" keep-together="always" width="100%" space-before="1em">
			<fo:table-column column-number="1" column-width="proportional-column-width(60)"/>
			<fo:table-column column-number="2" column-width="proportional-column-width(40)"/>
			<fo:table-body>
				<fo:table-row keep-together="always">
					<fo:table-cell >
						<xsl:attribute name="padding-left">0.0mm</xsl:attribute>
						<xsl:attribute name="padding-right">0.5mm</xsl:attribute>
						<xsl:attribute name="padding-top">0.5mm</xsl:attribute>
						<xsl:attribute name="padding-bottom">0.5mm</xsl:attribute>
						<!-- QUESTIONTITLE -->
						<fo:block>
							<xsl:call-template name="apply_appearence_style">
								<xsl:with-param name="stijl">textquestiontitle</xsl:with-param>
							</xsl:call-template>
							<xsl:apply-templates select="QUESTION"/>
						</fo:block>
						<!-- QUESTIONHELP -->
						<xsl:if test="count(EXPLAIN) &gt; 0 ">
							<fo:block>
								<xsl:call-template name="apply_appearence_style">
									<xsl:with-param name="stijl">textquestionhelp</xsl:with-param>
								</xsl:call-template>
								<xsl:apply-templates select="EXPLAIN" />
							</fo:block>
						</xsl:if>
					</fo:table-cell>
					<fo:table-cell padding="0.5mm" >
						<!-- QUESTIONOPTIONS and QUESTIONCHOICE -->
						<xsl:choose>
							<xsl:when test="count(DOMAIN) &gt; 0">
								<fo:table keep-together="always" table-layout="fixed">
									<fo:table-column column-number="1" column-width="1em"/>
									<fo:table-column column-number="2" column-width="proportional-column-width(99)"/>
									<fo:table-body>
										<xsl:call-template name="PrintDomainOptions"/>
									</fo:table-body>
								</fo:table>
							</xsl:when>
							<xsl:otherwise>
								<fo:table keep-together="always" table-layout="fixed">
									<fo:table-body>
										<xsl:call-template name="PrintOptions"/>
									</fo:table-body>
								</fo:table>
							</xsl:otherwise>
						</xsl:choose>
					</fo:table-cell>
				</fo:table-row>
			</fo:table-body>
		</fo:table>
	</xsl:template>

	<xsl:template name="PrintDomainOptions">
		<xsl:for-each select="DOMAIN/VALUE">
			<fo:table-row>
				<!-- Setting the checkbox -->
				<fo:table-cell >
					<fo:block font-family="arial" font-size="9pt">
						<xsl:choose>
							<xsl:when test="@selected='true'">
								<xsl:call-template name="apply_appearence_style">
									<xsl:with-param name="stijl" select="'boxticked'"/>
								</xsl:call-template>
							</xsl:when>
							<xsl:otherwise>
								<xsl:call-template name="apply_appearence_style">
									<xsl:with-param name="stijl" select="'boxempty'"/>
								</xsl:call-template>
							</xsl:otherwise>
						</xsl:choose>
					</fo:block>
				</fo:table-cell>
				<!-- Setting the option -->
				<fo:table-cell >
					<fo:block >
						<xsl:value-of select="."/>
					</fo:block>
				</fo:table-cell>
			</fo:table-row>
		</xsl:for-each>
	</xsl:template>

	<xsl:template name="PrintOptions">
		<xsl:for-each select="VALUES/VALUE">
			<fo:table-row>
				<fo:table-cell >
					<fo:block >
						<xsl:value-of select="."/>
					</fo:block>
				</fo:table-cell>
			</fo:table-row>
		</xsl:for-each>
	</xsl:template>
</xsl:stylesheet>
