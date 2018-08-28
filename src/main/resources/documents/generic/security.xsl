<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:svg="http://www.w3.org/2000/svg" >

	<!-- 
	Author: 	M. Joosen (Everest)
	Date:		2010-06-10
	Description:	security fo-sheet for Aquima Documents

	Version history:
	20110727 2.1 M. Joosen		Removed renderspecific namespace
	20110111 2.0 M. Joosen		Moved renderer specific information to other place
	20101220 1.1 M. Joosen		Use capitals
	20100610 1.0 M. Joosen		Creation to secure documents
	-->

	<!-- Template SECURITY-->
	<xsl:template match="SECURITY" >
		<xsl:apply-templates select="." mode="renderspecific"/>
	</xsl:template>


</xsl:stylesheet>
