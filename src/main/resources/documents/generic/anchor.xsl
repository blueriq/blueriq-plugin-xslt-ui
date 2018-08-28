<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:svg="http://www.w3.org/2000/svg">
	<!-- 
	Author: 	M. Joosen (Everest)
	Date:		2010-06-08
	Description:	anchor fo-sheet for Aquima Documents

	Version history:
	20110218 1.2 M. Joosen		Deal with renderer differences
	20101110 1.1 M. Joosen		More specific match
	20100608 1.0 M. Joosen		Creation based on mastersheet
	-->

	<!-- Template ANCHOR -->
	<xsl:template match="ANCHOR|STYLE[@name='anchor']" >
		<xsl:apply-templates select="." mode="renderspecific"/>

	</xsl:template>

</xsl:stylesheet>
