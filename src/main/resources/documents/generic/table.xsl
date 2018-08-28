<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:svg="http://www.w3.org/2000/svg">

	<!-- 
	Author: 	J. van Leuven (Everest)
	Date:		2009-01-22
	Description:	table fo-sheet for Aquima Documents

	Version history:
	20110726 2.3 M. Joosen		Small fixes to deal with colorcodes
	20110316 2.2 M. Joosen		Do always a apply appearance
	20110124 2.1 M. Joosen		adding bottomline
	20110111 2.0 M. Joosen		Moved renderer specific information to other place
	20101216 1.13 M. Joosen		Do a right-align in a table using xmlmind
	20101216 1.12 M. Joosen		Place in a empty cell a non-breakable space for equal lining.
	20101201 1.11 M. Joosen		keep-together conditional
	20101129 1.10 M. Joosen		Bugfix verticalcenter
	20101125 1.9 M. Joosen		Added nopad/nopadding option for table, and verticalalign, fixed bug on rightalign
 	20101020 1.8 M. Joosen		added background color on row and cells
 	20100811 1.7 M. Joosen		fix left padding on the first cell if there is bordering
 	20100809 1.6 M. Joosen		Deal with html code
 	20100805 1.5 M. Joosen		fix for ibex bug
 	20100621 1.4 M. Joosen		using padding-left
 	20100616 1.3 M. Joosen		AQU-4192: fix ancestor problem 
 	20100602 1.2 J. van Leuven	AQU-4152: source indentation dependency fix 
	20100602 1.1 M. Joosen		Introducing rowmajor grouping
	20100518 1.0 M. Joosen		Introducing a subprocedure TableMakeColspan
	20100506 0.9 M. Joosen		No left padding at the first cell
	20100421 0.8 M. Joosen		Introduced the style automatic_count and start_value (AQU-2380)
	20100309 0.7 M. Joosen		Introduced the style brd
	20100303 0.6 M. Joosen		Introduced the style vertline
	20091209 0.5 M. Joosen		Removed output format
	20090219 0.4 M. Joosen		Allowing bottomaligned and topaligned styles
	20090127 0.3 M. Joosen		Updated errorchecking			
	20090126 0.2 M. Joosen			
					- Making kdr work 
					- placed errorchecking tables here
	20090122 0.1 J. van Leuven 	Creation based on mastersheet
	-->

	<!-- Template TABLE -->
	<xsl:template match="table|TABLE">
		<fo:table border-collapse="collapse" >
			<xsl:if test="contains(@style,'wdprc') ">
				<xsl:attribute name="width"><xsl:value-of select="concat(substring-before(substring-after(@style,'wdprc_'),'_'),'%')"/></xsl:attribute>
			</xsl:if>
			<xsl:if test="not(contains(@style,'nokeep')) ">
				<xsl:attribute name="keep-together">always</xsl:attribute>
			</xsl:if>
			<xsl:if test="contains(@style,'kdr') or contains(@style,'brd')">
				<xsl:attribute name="border">0.5pt solid black</xsl:attribute>
			</xsl:if>
			<xsl:if test="contains(@style,'cols_')">
				<xsl:call-template name="TableMakeColumn">
					<xsl:with-param name="distribution" select="substring-after(@style,'cols_')"/>
				</xsl:call-template>
			</xsl:if>
			<!-- Do a style check -->
			<xsl:call-template name="apply_appearence"/>
			<xsl:if test="TABLEHEADER">
				<fo:table-header>
					<xsl:choose>
						<xsl:when test="contains(@style,'std')">
							<xsl:attribute name="border-bottom">0.5pt solid black</xsl:attribute>
							<xsl:attribute name="border-top">0.5pt solid black</xsl:attribute>
						</xsl:when>
						<xsl:otherwise>
						</xsl:otherwise>
					</xsl:choose>
					<xsl:apply-templates select="TABLEHEADER"/>
				</fo:table-header>
			</xsl:if>
			<fo:table-body>
				<xsl:apply-templates select="TABLEROW"/>
			</fo:table-body>
			<xsl:if test="TABLEFOOTER">
				<fo:table-footer>
					<xsl:apply-templates select="TABLEFOOTER"/>
				</fo:table-footer>
			</xsl:if>
		</fo:table>
	</xsl:template>

	<!-- Template TABLEROW -->
	<xsl:template match="TABLEROW|TABLEHEADER|TABLEFOOTER">
		<fo:table-row >
			<xsl:if test="not(contains(@style,'nokeep')) ">
				<xsl:attribute name="keep-together">always</xsl:attribute>
			</xsl:if>
			<xsl:if test="(count(following-sibling::*)=0) and (contains(ancestor::TABLE[1]/@style,'std'))">
				<xsl:attribute name="border-bottom">0.5pt solid black</xsl:attribute>
			</xsl:if>
			<xsl:if test="contains(ancestor::TABLE[1]/@style,'kdr')">
				<xsl:attribute name="border">0.5pt solid black</xsl:attribute>
			</xsl:if>
			<xsl:if test="contains(@style,'brd')">
				<xsl:attribute name="border-bottom">0.5pt solid black</xsl:attribute>
			</xsl:if>
			<xsl:if test="contains(@style,'bottomline')">
				<xsl:attribute name="border-bottom">0.5pt solid black</xsl:attribute>
			</xsl:if>

			<xsl:if test="contains(@style,'bg_')">
				<xsl:attribute name="background"><xsl:value-of select="concat('#',substring-before(substring-after(@style,'bg_'),'_'))"/></xsl:attribute>
			</xsl:if>
			<xsl:if test="contains(@style,'tc_')">
				<xsl:attribute name="color"><xsl:value-of select="concat('#',substring-before(substring-after(@style,'tc_'),'_'))"/></xsl:attribute>
			</xsl:if>
			<xsl:if test="contains(@style,'bc_')">
				<xsl:attribute name="border"><xsl:value-of select="concat('0.5pt solid #',substring-before(substring-after(@style,'bc_'),'_'))"/></xsl:attribute>
			</xsl:if>
			<!-- Do a style check -->
			<xsl:call-template name="apply_appearence"/>
			<xsl:apply-templates select="TABLECELL"/>
		</fo:table-row>
	</xsl:template>

	<xsl:template match="TABLEROW[contains(@style,'rowmajor')]">
		<xsl:call-template name="ROWMAJOR">
			<xsl:with-param name="style">
				<xsl:choose>
					<xsl:when test="(count(following-sibling::*)=0) and (contains(ancestor::TABLE[1]/@style,'std'))"> 
						<xsl:text>std</xsl:text>
					</xsl:when>
					<xsl:when test="contains(ancestor::TABLE[1]/@style,'kdr')"> 
						<xsl:text>kdr</xsl:text>
					</xsl:when>
					<xsl:when test="contains(@style,'brd')"> 
						<xsl:text>brd</xsl:text>
					</xsl:when>
					<xsl:otherwise/>
				</xsl:choose>
			</xsl:with-param>
			<xsl:with-param name="maxcolumn" select="substring-before(substring-after(@style,'rowmajor_'),'_')"/>
			<xsl:with-param name="startcolumn" select="'1'"/>
			<xsl:with-param name="endcolumn" select="count(TABLECELL)"/>
		</xsl:call-template>
	</xsl:template>

	<!-- Template TABLECELL -->
	<xsl:template match="TABLECELL">
		<fo:table-cell >
			<xsl:apply-templates select="." mode="renderspecific"/>
			<xsl:choose>
				<!-- no padding -->
				<xsl:when test="contains(ancestor::TABLE[1]/@style,'nopad') or contains(@style,'nopadding')">
				</xsl:when>
				<!-- no left padding for first cell except when bordering is on -->
				<xsl:when test="count(preceding-sibling::*)='0' and not(contains(ancestor::TABLE[1]/@style,'kdr') or contains(ancestor::TABLE[1]/@style,'brd') or contains(ancestor::TABLE[1]/@style,'std'))">
					<xsl:attribute name="padding-left">0.0mm</xsl:attribute>
					<xsl:attribute name="padding-right">0.5mm</xsl:attribute>
					<xsl:attribute name="padding-top">0.5mm</xsl:attribute>
					<xsl:attribute name="padding-bottom">0.5mm</xsl:attribute>
				</xsl:when>
				<xsl:otherwise>
					<xsl:attribute name="padding">0.5mm</xsl:attribute>
				</xsl:otherwise>
			</xsl:choose>

			<xsl:choose>
				<xsl:when test="contains(parent::*/parent::TABLE/@style,'rightaligned') and not(contains(@style,'leftaligned')  or contains(@style,'center'))">
					<xsl:attribute name="text-align">right</xsl:attribute>
				</xsl:when>
				<xsl:when test="contains(parent::*/parent::TABLE/@style,'leftaligned') and not(contains(@style,'rightaligned') or contains(@style,'center'))">
					<xsl:attribute name="text-align">left</xsl:attribute>
				</xsl:when>
				<xsl:when test="contains(parent::*/parent::TABLE/@style,'center') and not(contains(@style,'leftaligned') or contains(@style,'rightaligned'))">
					<xsl:attribute name="text-align">center</xsl:attribute>
				</xsl:when>
				<!-- Allow only to copy if there is a cols definition -->
				<xsl:when test="(contains(parent::*/parent::TABLE/@style,'cols') or contains(parent::*/@style,'rowmajor')) and (not(descendant::*[contains(local-name(),'LIST') or contains(local-name(),'TABLE') ])) and (count(ancestor::TABLE)='1') ">
					<xsl:apply-templates select="." mode="renderspecific"/>
				</xsl:when>
				<xsl:otherwise>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:if test="contains(parent::*/parent::TABLE/@style,'kdr')">
				<xsl:attribute name="border">0.5pt solid black</xsl:attribute>
			</xsl:if>
			<!-- BEGIN automatic counting -->
			<xsl:if test="contains(@style,'automatic_count')">
				<xsl:variable name="MyTable" select="generate-id(ancestor::TABLE)"/>
				<xsl:variable name="StartValue">
					<xsl:choose>
						<xsl:when test="preceding::*[name()='TABLECELL' and contains(@style,'start_value')][generate-id(ancestor::TABLE) = $MyTable ] ">
							<xsl:value-of select="number(preceding::*[name()='TABLECELL' and contains(@style,'start_value')][generate-id(ancestor::TABLE) = $MyTable]/TEXT/T)"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:number value="0"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:variable name="NrElement">
					<xsl:value-of select="count(preceding::*[name()='TABLECELL' and contains(@style,'automatic_count')][generate-id(ancestor::TABLE) = $MyTable ]) + 1"/>
				</xsl:variable>
				<fo:block>
					<xsl:value-of select="$StartValue + $NrElement"/>
				</fo:block>
			</xsl:if>
			<!-- END automatic counting -->
			<xsl:if test="contains(@style,'brd')">
				<xsl:attribute name="border">0.5pt solid black</xsl:attribute>
			</xsl:if>
			<xsl:if test="contains(@style,'bottomline')">
				<xsl:attribute name="border-bottom">0.5pt solid black</xsl:attribute>
			</xsl:if>
			<xsl:if test="contains(parent::TABLEHEADER/@style,'vertline_') or contains(parent::TABLEFOOTER/@style,'vertline_') or contains(parent::TABLEROW/@style,'vertline_') or contains(parent::*/parent::TABLE/@style,'vertline_')">
				<xsl:variable name="containcolumns">
					<xsl:choose>
						<xsl:when test="contains(parent::*/parent::TABLE/@style,'vertline_')" >
							<xsl:value-of  select="substring-after(parent::*/parent::TABLE/@style,'vertline')" />
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of  select="substring-after(parent::*/@style,'vertline')" />
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:variable name="columnnumber">
					<xsl:text>_</xsl:text>
					<xsl:choose>
						<xsl:when test="parent::TABLEHEADER" >
							<xsl:number level="any" from="TABLEHEADER" count="TABLECELL"/>
						</xsl:when>
						<xsl:when test="parent::TABLEFOOTER" >
							<xsl:number level="any" from="TABLEFOOTER" count="TABLECELL"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:number level="any" from="TABLEROW" count="TABLECELL"/>
						</xsl:otherwise>
					</xsl:choose>
					<xsl:text>_</xsl:text>
				</xsl:variable>
				<xsl:if test="contains($containcolumns,$columnnumber)">
				<xsl:attribute name="border-right">0.5pt solid black</xsl:attribute>
				</xsl:if>
			</xsl:if>

			<xsl:if test="contains(@style,'colspan_')">
				<xsl:call-template name="TableMakeColspan"/>
			</xsl:if>
			<xsl:if test="contains(@style,'rowspan_')">
				<xsl:variable name="after_rowspan">
					<xsl:value-of select="substring-after(@style,'rowspan_')"/>
				</xsl:variable>
				<xsl:variable name="rowspan">
					<xsl:choose>
						<xsl:when test="contains($after_rowspan,'_')">
							<xsl:value-of select="substring-before($after_rowspan,'_')"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="$after_rowspan"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:attribute name="number-rows-spanned"><xsl:value-of select="$rowspan"/></xsl:attribute>
			</xsl:if>
			<xsl:if test="contains(@style,'topaligned')">
				<xsl:attribute name="display-align">before</xsl:attribute>
			</xsl:if>
			<xsl:if test="contains(@style,'verticalcenter')">
				<xsl:attribute name="display-align">center</xsl:attribute>
			</xsl:if>
			<xsl:if test="contains(@style,'bottomaligned')">
				<xsl:attribute name="display-align">after</xsl:attribute>
			</xsl:if>
			<xsl:if test="contains(@style,'leftaligned')">
				<xsl:attribute name="text-align">left</xsl:attribute>
			</xsl:if>
			<xsl:if test="contains(@style,'rightaligned')">
				<xsl:attribute name="text-align">right</xsl:attribute>
			</xsl:if>
			<xsl:if test="contains(@style,'_center')">
				<xsl:attribute name="text-align">center</xsl:attribute>
			</xsl:if>
			<xsl:if test="contains(@style,'brd')">
				<xsl:attribute name="border-bottom">0.5pt solid black</xsl:attribute>
			</xsl:if>
			<xsl:if test="contains(@style,'bg_')">
				<xsl:attribute name="background"><xsl:value-of select="concat('#',substring-before(substring-after(@style,'bg_'),'_'))"/></xsl:attribute>
			</xsl:if>
			<xsl:if test="contains(@style,'tc_')">
				<xsl:attribute name="color"><xsl:value-of select="concat('#',substring-before(substring-after(@style,'tc_'),'_'))"/></xsl:attribute>
			</xsl:if>
			<xsl:if test="contains(@style,'bc_')">
				<xsl:attribute name="border"><xsl:value-of select="concat('0.5pt solid #',substring-before(substring-after(@style,'bc_'),'_'))"/></xsl:attribute>
			</xsl:if>
			<!-- Do a style check -->
			<xsl:call-template name="apply_appearence"/>
			<xsl:choose>
				<xsl:when test="contains(@style,'automatic_count')" >
				</xsl:when>
				<xsl:when test="starts-with(normalize-space(text()),'&#x20ac;')">
					<fo:block>
						<xsl:call-template name="MakeEuroCell"/>
					</fo:block>
				</xsl:when>
				<xsl:otherwise>
					<fo:block>
						<xsl:if test="@style='field'">
							<xsl:attribute name="space-before">1em</xsl:attribute>
						</xsl:if>
						<xsl:call-template name="apply_appearence"/>
						<!-- In a empty cell place a nonbreakable space to get identical spacing -->
						<xsl:if test="not(child::*)">
							<xsl:text>&#xa0;</xsl:text>
						</xsl:if>
						<xsl:apply-templates select="*"/>
					</fo:block>
				</xsl:otherwise>
			</xsl:choose>
		</fo:table-cell>
	</xsl:template>

	<xsl:template name="TableMakeColumn">
		<xsl:param name="distribution"/>
		<xsl:if test="string-length($distribution) > 0">
			<xsl:variable name="column">
				<xsl:choose>
					<xsl:when test="contains($distribution,'_')">
						<xsl:value-of select="substring-before($distribution, '_')"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$distribution"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:variable name="value_indent">
				<xsl:choose>
					<xsl:when test="contains($column, 'i')">5mm</xsl:when>
					<xsl:otherwise>0mm</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:variable name="value_align">
				<xsl:choose>
					<xsl:when test="contains($column, 'r')">right</xsl:when>
					<xsl:when test="contains($column, 'c')">center</xsl:when>
					<xsl:otherwise>left</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:variable name="value_width">
				<xsl:value-of select="number(substring-after($column, 'k'))"/>
			</xsl:variable>
			<fo:table-column>
				<xsl:attribute name="text-align"><xsl:value-of select="$value_align"/></xsl:attribute>
				<xsl:attribute name="text-indent"><xsl:value-of select="$value_indent"/></xsl:attribute>
				<xsl:attribute name="column-width"><xsl:value-of select="$value_width"/>mm</xsl:attribute>
			</fo:table-column>
			<xsl:call-template name="TableMakeColumn">
				<xsl:with-param name="distribution" select="substring-after($distribution, '_')"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>

	<xsl:template name="TableMakeColspan">
		<xsl:variable name="after_colspan">
			<xsl:value-of select="substring-after(@style,'colspan_')"/>
		</xsl:variable>
		<xsl:variable name="colspan">
			<xsl:choose>
				<xsl:when test="contains($after_colspan,'_')">
					<xsl:value-of select="substring-before($after_colspan,'_')"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$after_colspan"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:attribute name="number-columns-spanned"><xsl:value-of select="$colspan"/></xsl:attribute>
	</xsl:template>

	<xsl:template name="MakeEuroCell">
		<fo:table width="100%" table-layout="auto" border="0pt" margin="0" start-indent="0" text-indent="0">
			<fo:table-column column-number="1" column-width="1em"/>
			<fo:table-column column-number="2" column-width="proportional-column-width(1)"/>
			<fo:table-body>
				<fo:table-row>
					<fo:table-cell text-align="left">
						<fo:block>
							<xsl:call-template name="apply_appearence"/>
							<xsl:value-of select="'&#x20ac;'"/>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell text-align="right">
						<fo:block>
							<xsl:call-template name="apply_appearence"/>
							<xsl:value-of select="substring-after(normalize-space(text()),'&#x20ac;')"/>
						</fo:block>
					</fo:table-cell>
				</fo:table-row>
			</fo:table-body>
		</fo:table>
	</xsl:template>

	<xsl:template name="ROWMAJOR">
		<xsl:param name="style"/>
		<xsl:param name="maxcolumn"/>
		<xsl:param name="startcolumn"/>
		<xsl:param name="endcolumn"/>
		<fo:table-row keep-together="always">
			<xsl:if test="$style='std' and ($endcolumn &lt; ($startcolumn + $maxcolumn))">
				<xsl:attribute name="border-bottom">0.5pt solid black</xsl:attribute>
			</xsl:if>
			<xsl:if test="$style='kdr'">
				<xsl:attribute name="border">0.5pt solid black</xsl:attribute>
			</xsl:if>
			<xsl:if test="$style='brd'">
				<xsl:attribute name="border-bottom">0.5pt solid black</xsl:attribute>
			</xsl:if>

			<xsl:apply-templates select="TABLECELL[(position() &gt; ($startcolumn - 1)) and (position() &lt; ($startcolumn + $maxcolumn)) ]"/>

		</fo:table-row>
		<xsl:if test="($endcolumn &gt;= ($startcolumn + $maxcolumn))">
			<xsl:call-template name="ROWMAJOR">
				<xsl:with-param name="style" select="$style"/>
				<xsl:with-param name="maxcolumn" select="$maxcolumn"/>
				<xsl:with-param name="startcolumn" select="$startcolumn + $maxcolumn"/>
				<xsl:with-param name="endcolumn" select="$endcolumn"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>

	<!-- Template TABLEROW -->
	<xsl:template match="tr|TR">
		<fo:table-row keep-together="always">
			<xsl:apply-templates select="*"/>
		</fo:table-row>
	</xsl:template>

	<!-- Template TABLECELL -->
	<xsl:template match="td|TD">
		<fo:table-cell padding="0.5mm">
			<fo:block>
				<xsl:apply-templates select="*"/>
			</fo:block>
		</fo:table-cell>
	</xsl:template>

	<xsl:template name="GetColumnStyle">
		<xsl:param name="nr" />
		<xsl:param name="str" />
		<xsl:choose>
			<xsl:when test="$nr = 1">
				<xsl:choose>
					<xsl:when test="contains($str,'_')">
						<xsl:value-of select="substring-before($str,'_')"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$str"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="GetColumnStyle">
					<xsl:with-param name="nr" select="$nr - 1"/>
					<xsl:with-param name="str" select="substring-after($str,'_')"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- Template Error-Checking tables -->
	<xsl:template match="TABLEROW[not(parent::TABLE) ] | TABLEHEADER[not(parent::TABLE) ] | TABLEFOOTER[not(parent::TABLE) ]">
		<xsl:if test="$testing='yes'">
			<fo:table>
				<fo:table-header>
					<fo:table-row>
						<fo:table-cell>
							<fo:block color="red">
								ERROR
								<xsl:value-of select="name(.)"/>
                                                                found outside of TABLE
                                                        </fo:block>
						</fo:table-cell>
					</fo:table-row>
				</fo:table-header>
				<fo:table-body>
					<fo:table-row keep-together="always">
						<xsl:apply-templates select="CEL"/>
					</fo:table-row>
				</fo:table-body>
			</fo:table>
		</xsl:if>
		<xsl:comment>ERROR <xsl:value-of select="name(.)"/> found outside of TABLE</xsl:comment>
	</xsl:template>

	<xsl:template match="TABLECELL[not(parent::TABLEROW) and not(parent::TABLEHEADER) and not(parent::TABLEFOOTER) ]">
		<xsl:if test="$testing='yes'">
			<fo:block color="red">
				ERROR TABLECELL must be a daughter element of TABLEROW/TABLEHEADER/TABLEFOOTER
                                <xsl:value-of select="."/>
			</fo:block>
		</xsl:if>
		<xsl:if test="$testing!='yes'">
			<xsl:comment>ERROR TABLECELL must be a daughter element of TABLEROW/TABLEHEADER/TABLEFOOTER</xsl:comment>
		</xsl:if>
	</xsl:template>
	<xsl:template match="TABLE[not(descendant::TABLEROW)]">
		<xsl:if test="$testing='yes'">
			<fo:block color="red">
                                ERROR TABLE must have a daughter element of TABLEROW
                                <xsl:value-of select="."/>
			</fo:block>
		</xsl:if>
		<xsl:if test="$testing!='yes'">
			<xsl:comment>ERROR TABLE must have a daughter element of TABLEROW</xsl:comment>
		</xsl:if>
	</xsl:template>
	<xsl:template match="TABLEROW[not(descendant::TABLECELL)]">
		<xsl:if test="$testing='yes'">
			<fo:block color="red">
                                ERROR TABLEROW must have a daughter element of TABLECELL
                                <xsl:value-of select="."/>
			</fo:block>
		</xsl:if>
		<xsl:if test="$testing!='yes'">
			<xsl:comment>ERROR TABLEROW must have a daughter element of TABLECELL</xsl:comment>
		</xsl:if>
	</xsl:template>

	
</xsl:stylesheet>
