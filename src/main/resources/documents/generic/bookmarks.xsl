<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:svg="http://www.w3.org/2000/svg">

	<!-- 
	Author: 	M. Joosen (Everest)
	Date:		2009-01-22
	Description:	bookmarks fo-sheet for Aquima Documents

	Version history:
	20101216 1.0 M. Joosen		Version 1.0 based on table of contents
	-->

	<!-- Template BOOKMARKS -->
	<xsl:template match="BOOKMARKS"/>

	<xsl:template match="BOOKMARKS" mode="create">
		<fo:bookmark-tree >
			<xsl:apply-templates select="//*[name()='HEADING1' or name()='HEADING2' or name()='HEADING3' ]" mode="bookmarks"/>
		</fo:bookmark-tree>
	</xsl:template>

</xsl:stylesheet>
