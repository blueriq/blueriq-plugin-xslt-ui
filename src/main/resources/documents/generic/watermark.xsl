<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:svg="http://www.w3.org/2000/svg" >

	<!-- 
	Author: 	M. Joosen (Everest)
	Date:		2010-06-16
	Description:	watermark fo-sheet for Aquima Documents

	Version history:
	20110726 1.1 M. Joosen		Use RenderSpecificBackgroundimage 
	20100811 1.1 M. Joosen		Fix to bug 
	20100616 1.0 M. Joosen		Creation to watermark documents
	-->

	<!-- Template WATERMARK-->

	<!-- ignore the normal watermark, only in the direct page areas-->
	<xsl:template match="WATERMARK" />

	<xsl:template match="WATERMARK" mode="pagearea">
		<xsl:call-template name="RenderSpecificBackgroundimage"/>
	</xsl:template>

</xsl:stylesheet>
