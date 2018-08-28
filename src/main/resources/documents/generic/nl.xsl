<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:svg="http://www.w3.org/2000/svg">

	<!-- 
	Author: 	J. van Leuven (Everest)
	Date:		2009-01-22
	Description:	table fo-sheet for Aquima Documents

	Version history:
	20100809 1.1 M. Joosen		Deal also with html breaks
	20100608 1.0 M. Joosen		Version 1.0
	20091209 0.3 M. Joosen		Removed output format
	20090127 0.2 M. Joosen		Adding also support for the contentstyle NEWLINE/LINEFEED (synoniems for NL)
	20090122 0.1 J. van Leuven 	Creation based on mastersheet
	-->

	<!-- Template NL -->
	<xsl:template match="NL|NEWLINE|LINEFEED|BR">
		<fo:block/>
	</xsl:template>
	
</xsl:stylesheet>
