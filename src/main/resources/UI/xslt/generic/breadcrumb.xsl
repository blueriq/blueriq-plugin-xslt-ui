<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:param name="breadCrumbUrl" select="$formAction" />

	<xsl:template match="breadcrumbcontainer" mode="breadcrumb">
		<ol class="aq-breadcrumbs">
			<xsl:for-each select="breadcrumb">
				<xsl:choose>
					<xsl:when test="@passed='true' ">
						<li class="aq-breadcrumb aq-breadcrumb-passed">
							<xsl:choose>
								<xsl:when test="../@readonly='true'">
									<xsl:value-of select="@displayname" />
								</xsl:when>
								<xsl:otherwise>
									<a href="{$breadCrumbUrl}&amp;{$idPrefix}flow={@flowname}"><xsl:value-of select="@displayname" /></a>
								</xsl:otherwise>
							</xsl:choose>
						</li>
					</xsl:when>
					<xsl:when test="@current='true' ">
						<li class="aq-breadcrumb aq-breadcrumb-current">
							<xsl:value-of select="@displayname" />
						</li>
					</xsl:when>
					<xsl:otherwise>
						<li class="aq-breadcrumb aq-breadcrumb-disabled">
							<xsl:value-of select="@displayname" />
						</li>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:for-each>
		</ol>
	</xsl:template>

	<xsl:template match="breadcrumbcontainer" />
</xsl:stylesheet>