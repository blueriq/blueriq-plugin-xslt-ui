<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:svg="http://www.w3.org/2000/svg">
	<!-- 
	Author: 	M. Joosen (Everest)
	Date:		2010-06-10
	Description:	presentationstyles fo-sheet for Aquima Documents

	Version history:
	20141127 1.2 T. Middeldorp	Presentation style 'texttransparant' changed to 'texttransparent'
	20100809 1.1 M. Joosen		Containertitle style added
	20100611 1.0 M. Joosen		Creation for positon
	-->

	<!-- 
		To create new behavior for a new label, just copy the <xsl:when> part and change the labelname. 
		The otherwise indicates the default behavior 
	-->

	<xsl:template name="textstandard" >
		<xsl:param name="label"/>
		<xsl:choose>
			<xsl:when test="$label='labelname' ">
				<xsl:attribute name="font-family">univers medium</xsl:attribute>
				<xsl:attribute name="font-weight">normal</xsl:attribute>
				<xsl:attribute name="font-style">normal</xsl:attribute>
				<xsl:attribute name="font-size">9.5pt</xsl:attribute>
				<xsl:attribute name="color">black</xsl:attribute>
				<xsl:attribute name="text-decoration">none</xsl:attribute>
			</xsl:when> 
			<xsl:otherwise>
				<xsl:attribute name="font-family">arial</xsl:attribute>
				<xsl:attribute name="font-weight">normal</xsl:attribute>
				<xsl:attribute name="font-style">normal</xsl:attribute>
				<xsl:attribute name="font-size">9pt</xsl:attribute>
				<xsl:attribute name="color">black</xsl:attribute>
				<xsl:attribute name="text-decoration">none</xsl:attribute>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>


	<xsl:template name="textsmall"  >
		<xsl:param name="label"/>
		<xsl:choose>
			<xsl:when test="$label='labelname' ">
				<xsl:attribute name="font-size">7pt</xsl:attribute>
				<xsl:attribute name="line-height">9.5pt</xsl:attribute>
			</xsl:when>
			<xsl:otherwise>
				<xsl:attribute name="font-size">7pt</xsl:attribute>
				<xsl:attribute name="line-height">9pt</xsl:attribute>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="textemphasis" >
		<xsl:param name="label"/>
		<xsl:choose>
			<xsl:when test="$label='labelname' ">
				<xsl:attribute name="font-weight">bold</xsl:attribute>
			</xsl:when>
			<xsl:otherwise>
				<xsl:attribute name="font-weight">bold</xsl:attribute>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="textunderlined" >
		<xsl:param name="label"/>
		<xsl:choose>
			<xsl:when test="$label='labelname' ">
				<xsl:attribute name="text-decoration">underline</xsl:attribute>
			</xsl:when>
			<xsl:otherwise>
				<xsl:attribute name="text-decoration">underline</xsl:attribute>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="textexplanation" >
		<xsl:param name="label"/>
		<xsl:choose>
			<xsl:when test="$label='labelname' ">
				<xsl:attribute name="text-decoration">underline</xsl:attribute>
			</xsl:when>
			<xsl:otherwise>
				<xsl:attribute name="text-decoration">underline</xsl:attribute>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="textquestiontitle" >
		<xsl:param name="label"/>
		<xsl:choose>
			<xsl:when test="$label='labelname' ">
				<xsl:attribute name="font-weight">bold</xsl:attribute>
			</xsl:when>
			<xsl:otherwise>
				<xsl:attribute name="font-weight">bold</xsl:attribute>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="textquestionhelp" >
		<xsl:param name="label"/>
		<xsl:choose>
			<xsl:when test="$label='labelname' ">
				<xsl:attribute name="font-style">italic</xsl:attribute>
			</xsl:when>
			<xsl:otherwise>
				<xsl:attribute name="font-style">italic</xsl:attribute>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="textcontainertitle" >
		<xsl:param name="label"/>
		<xsl:choose>
			<xsl:when test="$label='labelname' ">
				<xsl:attribute name="font-weight">bold</xsl:attribute>
			</xsl:when>
			<xsl:otherwise>
				<xsl:attribute name="font-weight">bold</xsl:attribute>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="textpagenumber" >
		<xsl:param name="label"/>
		<xsl:choose>
			<xsl:when test="$label='labelname' ">
				<xsl:attribute name="font-size">7pt</xsl:attribute>
				<xsl:attribute name="line-height">9.5pt</xsl:attribute>
			</xsl:when>
			<xsl:otherwise>
				<xsl:attribute name="font-size">7pt</xsl:attribute>
				<xsl:attribute name="line-height">9pt</xsl:attribute>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="textfooter" >
		<xsl:param name="label"/>
		<xsl:choose>
			<xsl:when test="$label='labelname' ">
				<xsl:attribute name="font-family">arial</xsl:attribute>
				<xsl:attribute name="font-size">10pt</xsl:attribute>
			</xsl:when>
			<xsl:otherwise>
				<xsl:attribute name="font-family">arial</xsl:attribute>
				<xsl:attribute name="font-size">7pt</xsl:attribute>
				<xsl:attribute name="line-height">9pt</xsl:attribute>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="textattribute" >
		<xsl:param name="label"/>
		<xsl:choose>
			<xsl:when test="$label='labelname' ">
				<xsl:attribute name="font-size">7pt</xsl:attribute>
				<xsl:attribute name="line-height">9.5pt</xsl:attribute>
			</xsl:when>
			<xsl:otherwise>
				<xsl:attribute name="font-size">7pt</xsl:attribute>
				<xsl:attribute name="line-height">9pt</xsl:attribute>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="textcolophon" >
		<xsl:param name="label"/>
		<xsl:choose>
			<xsl:when test="$label='labelname' ">
				<xsl:attribute name="font-size">7pt</xsl:attribute>
				<xsl:attribute name="line-height">9.5pt</xsl:attribute>
			</xsl:when>
			<xsl:otherwise>
				<xsl:attribute name="font-size">7pt</xsl:attribute>
				<xsl:attribute name="line-height">9pt</xsl:attribute>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="linespacingextra" >
		<xsl:param name="label"/>
		<xsl:choose>
			<xsl:when test="$label='labelname' ">
				<xsl:attribute name="line-height">1.3333</xsl:attribute>
			</xsl:when>
			<xsl:otherwise>
				<xsl:attribute name="line-height">1.3333</xsl:attribute>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="textdocumenttitle" >
		<xsl:param name="label"/>
		<xsl:choose>
			<xsl:when test="$label='labelname' ">
				<xsl:attribute name="font-weight">bold</xsl:attribute>
				<xsl:attribute name="font-size">11pt</xsl:attribute>
			</xsl:when>
			<xsl:otherwise>
				<xsl:attribute name="font-weight">bold</xsl:attribute>
				<xsl:attribute name="font-size">10pt</xsl:attribute>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- heading styles -->
	<xsl:template name="textheadingbig" >
		<xsl:param name="label"/>
		<xsl:choose>
			<xsl:when test="$label='labelname' ">
				<!-- houd 1 lege regel aan ten opzichte van voorgaande -->
				<xsl:attribute name="space-before">1em</xsl:attribute>
				<xsl:attribute name="font-weight">bold</xsl:attribute>
				<xsl:attribute name="font-size">12pt</xsl:attribute>
				<xsl:attribute name="keep-with-next">always</xsl:attribute>
			</xsl:when>
			<xsl:otherwise>
				<!-- houd 1 lege regel aan ten opzichte van voorgaande -->
				<xsl:attribute name="space-before">1em</xsl:attribute>
				<xsl:attribute name="font-weight">bold</xsl:attribute>
				<xsl:attribute name="font-size">12pt</xsl:attribute>
				<xsl:attribute name="keep-with-next">always</xsl:attribute>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="textheading1" >
		<xsl:param name="label"/>
		<xsl:choose>
			<xsl:when test="$label='labelname' ">
				<!-- houd 1 lege regel aan ten opzichte van voorgaande -->
				<xsl:attribute name="space-before">1em</xsl:attribute>
				<xsl:attribute name="font-weight">bold</xsl:attribute>
				<xsl:attribute name="font-size">12pt</xsl:attribute>
				<xsl:attribute name="keep-with-next">always</xsl:attribute>
			</xsl:when>
			<xsl:otherwise>
				<!-- houd 1 lege regel aan ten opzichte van voorgaande -->
				<xsl:attribute name="space-before">1em</xsl:attribute>
				<xsl:attribute name="font-weight">bold</xsl:attribute>
				<xsl:attribute name="font-size">12pt</xsl:attribute>
				<xsl:attribute name="keep-with-next">always</xsl:attribute>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="textheading" >
		<xsl:param name="label"/>
		<xsl:choose>
			<xsl:when test="$label='labelname' ">
				<xsl:attribute name="font-weight">bold</xsl:attribute>
				<xsl:attribute name="font-size">11pt</xsl:attribute>
				<xsl:attribute name="keep-with-next">always</xsl:attribute>
			</xsl:when>
			<xsl:otherwise>
				<xsl:attribute name="font-weight">bold</xsl:attribute>
				<xsl:attribute name="font-size">10pt</xsl:attribute>
				<xsl:attribute name="keep-with-next">always</xsl:attribute>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="textheading2" >
		<xsl:param name="label"/>
		<xsl:choose>
			<xsl:when test="$label='labelname' ">
				<xsl:attribute name="font-weight">bold</xsl:attribute>
				<xsl:attribute name="font-size">11pt</xsl:attribute>
				<xsl:attribute name="keep-with-next">always</xsl:attribute>
			</xsl:when>
			<xsl:otherwise>
				<xsl:attribute name="font-weight">bold</xsl:attribute>
				<xsl:attribute name="font-size">10pt</xsl:attribute>
				<xsl:attribute name="keep-with-next">always</xsl:attribute>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="textheading3" >
		<xsl:param name="label"/>
		<xsl:choose>
			<xsl:when test="$label='labelname' ">
				<xsl:attribute name="text-decoration">underline</xsl:attribute>
			</xsl:when>
			<xsl:otherwise>
				<xsl:attribute name="text-decoration">underline</xsl:attribute>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="textremoved" >
		<xsl:param name="label"/>
		<xsl:choose>
			<xsl:when test="$label='labelname' ">
				<xsl:attribute name="text-decoration">line-through</xsl:attribute>
				<xsl:attribute name="color">red</xsl:attribute>
			</xsl:when>
			<xsl:otherwise>
				<xsl:attribute name="text-decoration">line-through</xsl:attribute>
				<xsl:attribute name="color">red</xsl:attribute>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="textchanged" >
		<xsl:param name="label"/>
		<xsl:choose>
			<xsl:when test="$label='labelname' ">
				<xsl:attribute name="text-decoration">underline</xsl:attribute>
				<xsl:attribute name="color">green</xsl:attribute>
			</xsl:when>
			<xsl:otherwise>
				<xsl:attribute name="text-decoration">underline</xsl:attribute>
				<xsl:attribute name="color">green</xsl:attribute>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- toc style -->
	<xsl:template name="texttoc" >
		<xsl:param name="label"/>
		<xsl:choose>
			<xsl:when test="$label='labelname' ">
				<xsl:attribute name="font-weight">bold</xsl:attribute>
				<xsl:attribute name="keep-with-next">always</xsl:attribute>
			</xsl:when>
			<xsl:otherwise>
				<xsl:attribute name="font-weight">bold</xsl:attribute>
				<xsl:attribute name="keep-with-next">always</xsl:attribute>
 			</xsl:otherwise>
 		</xsl:choose>
 	</xsl:template>
 
 	<xsl:template name="textreferencetitle"  >
 		<xsl:param name="label"/>
 		<xsl:choose>
 			<xsl:when test="$label='labelname'">
 				<xsl:attribute name="font-size">7pt</xsl:attribute>
 				<xsl:attribute name="line-height">9.5pt</xsl:attribute>
 			</xsl:when>
 			<xsl:otherwise>
 				<xsl:attribute name="font-size">7pt</xsl:attribute>
 				<xsl:attribute name="line-height">9pt</xsl:attribute>
 			</xsl:otherwise>
 		</xsl:choose>
 	</xsl:template>
 
 	<xsl:template name="textreferencevalue"  >
 		<xsl:param name="label"/>
 		<xsl:choose>
 			<xsl:when test="$label='labelname'">
 			</xsl:when>
 			<xsl:otherwise>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- special styles -->
	<xsl:template name="field" >
		<xsl:param name="label"/>
		<xsl:choose>
			<xsl:when test="$label='labelname' ">
				<xsl:attribute name="border-after-width">0.1mm</xsl:attribute>
				<xsl:attribute name="border-after-style">dotted</xsl:attribute>
				<xsl:attribute name="border-after-color">black</xsl:attribute>
				<xsl:attribute name="color">white</xsl:attribute>
			</xsl:when>
			<xsl:otherwise>
				<xsl:attribute name="border-after-width">0.1mm</xsl:attribute>
				<xsl:attribute name="border-after-style">dotted</xsl:attribute>
				<xsl:attribute name="border-after-color">black</xsl:attribute>
				<xsl:attribute name="color">white</xsl:attribute>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="texttransparent" >
		<xsl:param name="label"/>
		<xsl:choose>
			<xsl:when test="$label='labelname' ">
				<xsl:attribute name="color">white</xsl:attribute>
			</xsl:when>
			<xsl:otherwise>
				<xsl:attribute name="color">white</xsl:attribute>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- special character styles -->
	<xsl:template name="boxempty" >
		<xsl:param name="label"/>
		<xsl:choose>
			<xsl:when test="$label='labelname' ">
				<!-- under ibex dotnet no fo:instream-foreign-object -->
				<fo:wrapper font="10pt 'fontawesome regular'">&#xf096;</fo:wrapper>
			</xsl:when>
			<xsl:otherwise>
				<!-- under ibex dotnet no fo:instream-foreign-object -->
				<fo:wrapper font="10pt 'fontawesome regular'">&#xf096;</fo:wrapper>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="boxticked" >
		<xsl:param name="label"/>
		<xsl:choose>
			<xsl:when test="$label='labelname' ">
				<!-- under ibex dotnet no fo:instream-foreign-object -->
				<fo:wrapper font="10pt 'fontawesome regular'">&#xf046;</fo:wrapper>
			</xsl:when>
			<xsl:otherwise>
				<!-- under ibex dotnet no fo:instream-foreign-object -->
				<fo:wrapper font="10pt 'fontawesome regular'">&#xf046;</fo:wrapper>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

</xsl:stylesheet>
