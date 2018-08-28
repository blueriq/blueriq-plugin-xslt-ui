<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" >
<!--
	Author: 	M. Joosen (Everest)
	Date:		2009-01-19
	Description:	includelist stylesheet for xsl-fo for Aquima Documents

	Version history:
	20110726 1.1 M. Joosen		Adding BackgroundImage
	20090119 1.0 M. Joosen		Creation

-->

	<!-- Custom Aquima styles -->

	<xsl:include href="settings.xsl"/>
	<xsl:include href="addressblock_placement.xsl"/>
	<xsl:include href="attributelist_placement.xsl"/>
	<xsl:include href="colophon_placement.xsl"/>
	<xsl:include href="column.xsl"/>
	<xsl:include href="documenttitle_placement.xsl"/>
	<xsl:include href="letter.xsl"/>
	<xsl:include href="normal.xsl"/>
	<xsl:include href="paragraph_settings.xsl"/>
	<xsl:include href="pagenumber_placement.xsl"/>
	<xsl:include href="presentationstyles_settings.xsl"/>
	<xsl:include href="presentationstyles_customization.xsl"/>
	<xsl:include href="reference_placement.xsl"/>

	<!-- Standard Aquima styles -->
	<xsl:include href="../generic/addressblock.xsl"/>
	<xsl:include href="../generic/anchor.xsl"/>
	<xsl:include href="../generic/attributelist.xsl"/>
	<xsl:include href="../generic/backgroundimage.xsl"/>
	<xsl:include href="../generic/body.xsl"/>
	<xsl:include href="../generic/bookmarks.xsl"/>
	<xsl:include href="../generic/colophon.xsl"/>
	<xsl:include href="../generic/columnbreak.xsl"/>
	<xsl:include href="../generic/container.xsl"/>
	<xsl:include href="../generic/document.xsl"/>
	<xsl:include href="../generic/documenttitle.xsl"/>
	<xsl:include href="../generic/emptyline.xsl"/>
	<xsl:include href="../generic/fields.xsl"/>
	<xsl:include href="../generic/footer.xsl"/>
	<xsl:include href="../generic/header.xsl"/>
	<xsl:include href="../generic/heading.xsl"/>
	<xsl:include href="../generic/heading1.xsl"/>
	<xsl:include href="../generic/heading2.xsl"/>
	<xsl:include href="../generic/heading3.xsl"/>
	<xsl:include href="../generic/hidden.xsl"/>
	<xsl:include href="../generic/horizontalline.xsl"/>
	<xsl:include href="../generic/image.xsl"/>
	<xsl:include href="../generic/keeptogether.xsl"/>
	<xsl:include href="../generic/link.xsl"/>
	<xsl:include href="../generic/list.xsl"/>
	<xsl:include href="../generic/magiccodes.xsl"/>	
	<xsl:include href="../generic/meta.xsl"/>	
	<xsl:include href="../generic/nl.xsl"/>
	<xsl:include href="../generic/page.xsl"/>
	<xsl:include href="../generic/pagebreak.xsl"/>
	<xsl:include href="../generic/pagenumber.xsl"/>
	<xsl:include href="../generic/pagemaster.xsl"/>
	<xsl:include href="../generic/paragraph.xsl"/>
	<xsl:include href="../generic/pdf-a.xsl"/>
	<xsl:include href="../generic/placeholder.xsl"/>
	<xsl:include href="../generic/presentationstyles.xsl"/>
	<xsl:include href="../generic/reference.xsl"/>
	<xsl:include href="../generic/security.xsl"/>
	<xsl:include href="../generic/style.xsl"/>
	<xsl:include href="../generic/table.xsl"/>
	<xsl:include href="../generic/tableofcontents.xsl"/>
	<xsl:include href="../generic/text.xsl"/>
	<xsl:include href="../generic/text_a.xsl"/>
	<xsl:include href="../generic/text_r.xsl"/>
	<xsl:include href="../generic/text_t.xsl"/>
	<xsl:include href="../generic/watermark.xsl"/>

</xsl:stylesheet>
