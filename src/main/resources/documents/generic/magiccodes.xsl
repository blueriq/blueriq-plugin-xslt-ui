<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:svg="http://www.w3.org/2000/svg">

	<!-- 
	Author: 	M. Joosen (Everest)
	Date:		2009-10-01
	Description:	replaceMagicCodes fo-sheet for Aquima Documents

	Version history:
	20100608 1.0 M. Joosen		Version 1.0
	20100325 0.5 M. Joosen		Added the maintain_spaces
	20100218 0.4 J. van Leuven	Soft enters bug fixed, see AQU-3169 
	20091030 0.3 M. Joosen		Normalising the space for all special characters
	20091029 0.2 M. Joosen		Dealing with ibex refusal for the leader
	20091001 0.1 M. Joosen		Creation based on mastersheet
	-->

	<xsl:template match="text()" mode="filtercodes">
		<xsl:call-template name="replaceMagicCodes">
			<xsl:with-param name="string">
				<xsl:value-of select="."/>
			</xsl:with-param>
			<xsl:with-param name="nrofcalls" select="'0'"/>
		</xsl:call-template>
	</xsl:template>

	<xsl:template match="text()">
		<xsl:value-of select="."/>
	</xsl:template>

	<xsl:template name="replaceMagicCodes">
		<xsl:param name="string"/>
		<xsl:param name="nrofcalls"/>
		<xsl:choose>
			<xsl:when test="($nrofcalls != '1') and ( contains(ancestor::*/@style,'maintain_space') or contains(ancestor::STYLE/@name,'maintain_space')) ">
				<xsl:variable name="replacedString">
					<xsl:call-template name="replaceCharsInString">
					  <xsl:with-param name="stringIn" select="string($string)"/>
					  <xsl:with-param name="charsIn" select="' '"/>
					  <xsl:with-param name="charsOut" select="'&#xa0;'"/>
					</xsl:call-template>
				</xsl:variable>
				<xsl:call-template name="replaceMagicCodes">
					<xsl:with-param name="string" select="$replacedString"/>
					<xsl:with-param name="nrofcalls" select="'1'"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="contains($string,'[ENTER]')">
				<xsl:variable name="toreplace" select="'[ENTER]'"/>
				<xsl:variable name="stringBefore" select="substring-before($string,$toreplace)"/>
				<xsl:variable name="stringAfter" select="substring-after($string,$toreplace)"/>
				<xsl:call-template name="replaceMagicCodes">
					<xsl:with-param name="string" select="$stringBefore"/>
				</xsl:call-template>
				<fo:block/>
				<xsl:if test="starts-with(normalize-space($stringAfter),$toreplace)">
					<xsl:call-template name="RenderSpecificEmptylines"/>
				</xsl:if>
				<xsl:call-template name="replaceMagicCodes">
					<xsl:with-param name="string" select="$stringAfter"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="contains($string,'&#x0D;')">
				<xsl:variable name="replacedString">
					<xsl:call-template name="replaceCharsInString">
					  <xsl:with-param name="stringIn" select="string($string)"/>
					  <xsl:with-param name="charsIn" select="'&#x0D;'"/>
					  <xsl:with-param name="charsOut" select="'[ENTER]'"/>
					</xsl:call-template>
				</xsl:variable>
				<xsl:call-template name="replaceMagicCodes">
					<xsl:with-param name="string" select="$replacedString"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="contains($string,'&#x0A;')">
				<xsl:variable name="replacedString">
					<xsl:call-template name="replaceCharsInString">
					  <xsl:with-param name="stringIn" select="string($string)"/>
					  <xsl:with-param name="charsIn" select="'&#x0A;'"/>
					  <xsl:with-param name="charsOut" select="'[ENTER]'"/>
					</xsl:call-template>
				</xsl:variable>
				<xsl:call-template name="replaceMagicCodes">
					<xsl:with-param name="string" select="$replacedString"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="contains($string,'&#8364; ')">
				<xsl:variable name="toreplace" select="'&#8364; '"/>
				<xsl:variable name="stringBefore" select="substring-before($string,$toreplace)"/>
				<xsl:variable name="stringAfter" select="substring-after($string,$toreplace)"/>
				<xsl:call-template name="replaceMagicCodes">
					<xsl:with-param name="string" select="$stringBefore"/>
				</xsl:call-template>
				<xsl:text>&#8364;&#xa0;</xsl:text>
				<xsl:call-template name="replaceMagicCodes">
					<xsl:with-param name="string" select="$stringAfter"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$string"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="replaceCharsInString">
	  <xsl:param name="stringIn"/>
	  <xsl:param name="charsIn"/>
	  <xsl:param name="charsOut"/>
	  <xsl:choose>
		  <xsl:when test="contains($stringIn,$charsIn) and string-length(substring-before($stringIn,$charsIn))=0">
			  <xsl:value-of select="$charsOut"/>
			  <xsl:call-template name="replaceCharsInString">
				<xsl:with-param name="stringIn" select="substring-after($stringIn,$charsIn)"/>
				<xsl:with-param name="charsIn" select="$charsIn"/>
				<xsl:with-param name="charsOut" select="$charsOut"/>
		  	</xsl:call-template>
		</xsl:when>
		<xsl:when test="contains($stringIn,$charsIn)">
		  <xsl:value-of select="concat(substring-before($stringIn,$charsIn),$charsOut)"/>
		  <xsl:call-template name="replaceCharsInString">
			<xsl:with-param name="stringIn" select="substring-after($stringIn,$charsIn)"/>
			<xsl:with-param name="charsIn" select="$charsIn"/>
			<xsl:with-param name="charsOut" select="$charsOut"/>
		  </xsl:call-template>
		</xsl:when>
		<xsl:otherwise>
		  <xsl:value-of select="$stringIn"/>
		</xsl:otherwise>
	  </xsl:choose>
	</xsl:template>

</xsl:stylesheet>


