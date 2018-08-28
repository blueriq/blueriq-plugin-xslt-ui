<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:svg="http://www.w3.org/2000/svg">
	<!-- 
	Author: 	J. van Leuven (Everest)
	Date:		2009-01-22
	Description:	list fo-sheet for Aquima Documents

	Version history:
	20110323 1.5 M. Joosen		added extra presentationstyle listromancapital
	20110304 1.4 M. Joosen		added extra presentationstyle option enter
	20110302 1.3. Joosen		added extra presentationstyle option for endcomma and do a 100% width value
	20110113 1.2 M. Joosen		restructured calculating of listwidth for reuse and calling renderspecific info at listelement
	20101216 1.1 M. Joosen		Cleanup of closing signs, using generic functions
	20100616 1.0 M. Joosen		Version 1.0 moved dutch words to custom
	20100602 0.4 J. van Leuven	AQU-4152: source indentation dependency fix 
	20100210 0.3 M. Joosen		Removed output format
	20090126 0.2 M. Joosen		Placed errorchecking lists here
	20090122 0.1 J. van Leuven 	Creation based on mastersheet
	-->
	
	<!-- Template LIST -->
	<xsl:template match="LIST[@style='listcommaseparated']">
		<xsl:for-each select="LISTELEMENT">
			<xsl:apply-templates select="*"/>
			<xsl:call-template name="PlaceFollowSigns">
				<xsl:with-param name="element"  select="'LISTELEMENT'"/>
				<xsl:with-param name="moresign" select="', '"/>
				<xsl:with-param name="onesign"  select="$int_listcomma_and"/>
				<xsl:with-param name="zerosign" select="''"/>
			</xsl:call-template>
		</xsl:for-each>
	</xsl:template>

	<xsl:template match="LIST|LISTCLOSINGSIGN">
		<xsl:if test="count(LISTELEMENT) &gt; 0">
			<fo:table width="100%" table-layout="fixed">
				<fo:table-column column-width="100%" column-number="1"/>
				<fo:table-body>
					<fo:table-row>
						<fo:table-cell column-number="1">
							<fo:table start-indent="0" >
								<xsl:apply-templates select="." mode="renderspecific"/>
								<xsl:variable name="CalcWidth">
									<xsl:call-template name="CalculatingListWidth">
										<xsl:with-param name="Style" select="@style"/>
										<xsl:with-param name="NrElements" select="count(LISTELEMENT)"/>
									</xsl:call-template>
								</xsl:variable>
								<fo:table-column column-width="{$CalcWidth}em"/>
								<fo:table-body>
									<xsl:for-each select="LISTELEMENT">
										<xsl:apply-templates select="."/>
									</xsl:for-each>
								</fo:table-body>
							</fo:table>
						</fo:table-cell>
					</fo:table-row>
				</fo:table-body>
			</fo:table>
		</xsl:if>
	</xsl:template>

	<!-- Template LISTELEMENT -->
	<xsl:template match="LISTELEMENT">
		<fo:table-row>
			<fo:table-cell padding-end="0.5em">
				<fo:block>
					<xsl:if test="not(@style='listnosign')">
						<xsl:call-template name="MakeListSign"/>
					</xsl:if>
				</fo:block>
			</fo:table-cell>
			<fo:table-cell width="100%">
				<fo:block>
					<xsl:apply-templates select="*"/>
					<xsl:if test="(parent::LISTCLOSINGSIGN) ">
						<xsl:call-template name="PlaceClosingSigns">
							<xsl:with-param name="element"  select="'LISTELEMENT'"/>
						</xsl:call-template>
					</xsl:if>
				</fo:block>
			</fo:table-cell>
		</fo:table-row>
	</xsl:template>
	
	<xsl:template name="CalculatingListWidth">
		<xsl:param name="Style"/>
		<xsl:param name="NrElements"/>
		<xsl:choose>
			<xsl:when test="$Style='listroman' ">
				<xsl:choose>
					<xsl:when test="$NrElements &lt; 7">1.2</xsl:when>
					<xsl:when test="$NrElements &gt; 6 and $NrElements &lt; 17">1.7</xsl:when>
					<xsl:when test="$NrElements &gt; 16 and $NrElements &lt; 27">2.2</xsl:when>
					<xsl:when test="$NrElements &gt; 26 and $NrElements &lt; 37">2.7</xsl:when>
					<xsl:when test="$NrElements &gt; 36 and $NrElements &lt;80">3</xsl:when>
					<xsl:otherwise>3.5</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="starts-with($Style,'listletter') ">
				<xsl:choose>
					<xsl:when test="$NrElements &lt; 26">1.57</xsl:when>
					<xsl:otherwise>2.36</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="$Style='listnumber' ">
				<xsl:choose>
					<xsl:when test="$NrElements &lt; 100">1.57</xsl:when>
					<!-- halve cm, als factor van 9pt-->
					<xsl:when test="$NrElements &gt; 99 and $NrElements &lt; 1000">2.36</xsl:when>
					<!-- 0.75 cm, als factor van 9pt-->
					<xsl:otherwise>3.14</xsl:otherwise>
					<!-- hele cm, als factor van 9pt-->
				</xsl:choose>
			</xsl:when>
			<xsl:when test="$Style='listnumberperiod' ">
				<xsl:choose>
					<xsl:when test="$NrElements &lt; 100">2.36</xsl:when>
					<!-- halve cm, als factor van 9pt-->
					<xsl:when test="$NrElements &gt; 99 and $NrElements &lt; 1000">3.14</xsl:when>
					<!-- 0.75 cm, als factor van 9pt-->
					<xsl:otherwise>3.93</xsl:otherwise>
					<!-- hele cm, als factor van 9pt-->
				</xsl:choose>
			</xsl:when>
			<xsl:when test="contains($Style,'period')">
				<xsl:text>2.36</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>1.57</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="MakeListSign">
		<xsl:variable name="VarStyle" select="@style"/>
		<!-- doorlopende lijsten door het hele document heen kun je koppelen met een LIST_SEQUENCE -->
		<xsl:variable name="myparent" select="generate-id(parent::node())"/>
		<xsl:variable name="NrElem">
			<xsl:value-of select="count(preceding::*[name()='LISTELEMENT'][generate-id(parent::*) = $myparent or (parent::*/LIST_SEQUENCE !='' ) ][not(starts-with(@style,'listnosign'))])+1"/>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="contains($VarStyle,'listbullet')">
				<xsl:text>&#x2022;</xsl:text>
			</xsl:when>
			<xsl:when test="contains($VarStyle,'listplus')">
				<xsl:text>+</xsl:text>
			</xsl:when>
			<xsl:when test="contains($VarStyle,'listplusminus')">
				<xsl:text>&#x00B1;</xsl:text>
			</xsl:when>
			<xsl:when test="contains($VarStyle,'listdash')">
				<xsl:text>-</xsl:text>
			</xsl:when>
			<xsl:when test="contains($VarStyle,'listnumberemphasis')">
				<fo:wrapper>
					<xsl:call-template name="apply_appearence_style">
						<xsl:with-param name="stijl">textemphasis</xsl:with-param>
					</xsl:call-template>
					<xsl:number value="$NrElem"/>
				</fo:wrapper>
			</xsl:when>
			<xsl:when test="contains($VarStyle,'listnumber')">
				<xsl:number value="$NrElem"/>
			</xsl:when>
			<xsl:when test="contains($VarStyle,'listletter')">
				<xsl:number value="$NrElem" format="a"/>
			</xsl:when>
			<xsl:when test="contains($VarStyle,'listcapital')">
				<xsl:number value="$NrElem" format="A"/>
			</xsl:when>
			<xsl:when test="contains($VarStyle,'listromancapital')">
				<xsl:number value="$NrElem" format="I"/>
			</xsl:when>
			<xsl:when test="contains($VarStyle,'listroman')">
				<xsl:number value="$NrElem" format="i"/>
			</xsl:when>
			<xsl:when test="$VarStyle='listnosign'"/>
			<xsl:otherwise>
				<xsl:text>&#x2022;</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:if test="contains($VarStyle,'period')">
			<xsl:text>. </xsl:text>
		</xsl:if>
		<!-- Outlining fails for super and subscript. Unfortunately XEP doesn't relative-align="baseline" hence this hack -->
		<xsl:if test=".//style[@name='textsubscript']| .//STYLE[@name='textsubscript']| .//style[@name='textsuperscript']| .//STYLE[@name='textsuperscript']">
			<fo:inline baseline-shift="sub" font-size="0.6em"/><fo:inline baseline-shift="super" font-size="0.6em"/>
		</xsl:if>
	</xsl:template>

	<xsl:template name="PlaceFollowSigns">
		<xsl:param name="element"/>
		<xsl:param name="moresign"/>
		<xsl:param name="onesign"/>
		<xsl:param name="zerosign"/>

		<xsl:variable name="NrSibling" select="count(following-sibling::*[local-name()=$element])"/>
		<xsl:choose>
			<xsl:when test="$NrSibling = 0">
				<xsl:value-of select="$zerosign"/>
			</xsl:when>
			<xsl:when test="$NrSibling = 1">
				<xsl:value-of select="$onesign"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$moresign"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="PlaceClosingSigns">
		<xsl:param name="element" />

		<xsl:variable name="moresign">
			<xsl:choose>
				<xsl:when test="contains(parent::*/@style,'no_sign')">
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>;</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="onesign">
			<xsl:choose>
				<xsl:when test="contains(parent::*/@style,'sign_and_')">
					<xsl:text>;</xsl:text>
					<xsl:value-of select="$int_listcomma_and"/>
				</xsl:when>
				<xsl:when test="contains(parent::*/@style,'sign_andor_')">
					<xsl:text>;</xsl:text>
					<xsl:value-of select="$int_listcomma_andor"/>
				</xsl:when>
				<xsl:when test="contains(parent::*/@style,'sign_or_')">
					<xsl:text>;</xsl:text>
					<xsl:value-of select="$int_listcomma_or"/>
				</xsl:when>
				<xsl:when test="contains(parent::*/@style,'no_sign')">
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>;</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="zerosign">
			<xsl:choose>
				<xsl:when test="contains(parent::*/@style,'endcomma')">
					<xsl:text>,</xsl:text>
				</xsl:when>
				<xsl:when test="contains(parent::*/@style,'no_sign')">
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>.</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:call-template name="PlaceFollowSigns">
			<xsl:with-param name="element"  select="$element"/>
			<xsl:with-param name="moresign" select="$moresign"/>
			<xsl:with-param name="onesign"  select="$onesign"/>
			<xsl:with-param name="zerosign" select="$zerosign"/>
		</xsl:call-template>
		<xsl:if test="contains(parent::*/@style,'enter') or contains(@style,'enter') ">
			<xsl:call-template name="RenderSpecificEmptylines"/>
		</xsl:if>
	</xsl:template>

	<!-- Template LIST error checking -->
	<xsl:template match="LISTELEMENT[not(parent::LIST or parent::LISTCLOSINGSIGN) ]">
		<xsl:if test="$testing='yes'">
			<fo:block color="red">
                                ERROR LISTELEMENT must be a daughter element of LIST or LISTCLOSINGSIGN
                                <xsl:value-of select="."/>
			</fo:block>
		</xsl:if>
		<xsl:if test="$testing!='yes'">
			<xsl:comment>ERROR LISTELEMENT must be a daughter element of LIST or LISTCLOSINGSIGN</xsl:comment>
		</xsl:if>
	</xsl:template>

</xsl:stylesheet>
