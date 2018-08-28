<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:template match="text-item">
		<p id="{$idPrefix}{@id}" class="aq-textitem {@format}">
			<xsl:apply-templates select="*" mode="textitem"/>
		</p>
	</xsl:template>

	<xsl:template match="t|v" mode="textitem">
		<xsl:call-template name="replaceNewLines">
        	<xsl:with-param name="string" select="."/>
    	</xsl:call-template>
	</xsl:template>

	<xsl:template match="style" mode="textitem">
		<span class="{@name}">
			<xsl:apply-templates select="*" mode="textitem"/>
		</span>
	</xsl:template>
	
	<xsl:template match="presentationStyle" mode="textitem"/>

	<xsl:template name="replaceNewLines">
	    <xsl:param name="string"/>
	    <xsl:choose>
	        <xsl:when test="contains($string,'&#10;')">
	            <xsl:value-of select="substring-before($string,'&#10;')"/>
	            <br/>
	            <xsl:call-template name="replaceNewLines">
	                <xsl:with-param name="string" select="substring-after($string,'&#10;')"/>
	            </xsl:call-template>
	        </xsl:when>
	        <xsl:otherwise>
	            <xsl:value-of select="$string"/>
	        </xsl:otherwise>
	    </xsl:choose>
	</xsl:template>

</xsl:stylesheet>