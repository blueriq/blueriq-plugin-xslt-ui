<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:svg="http://www.w3.org/2000/svg"  >

	<!-- 
	Author: 	M. Joosen (Everest)
	Date:		2010-12-20
	Description:	pdf-a fo-sheet for Aquima Documents

	Version history:
	20110111 2.0 M. Joosen		Moved renderer specific information to other place
	20101220 1.0 M. Joosen		Creation to pdf-a documents
	-->

	<!-- Template PDFA-->
	<xsl:template match="PDFA" />

	<xsl:template match="PDFA" mode="create">
		<xsl:apply-templates select="." mode="renderspecific"/>
	</xsl:template>

</xsl:stylesheet>
