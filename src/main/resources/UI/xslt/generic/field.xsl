<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<!-- the field container -->
	<xsl:template match="field">
		<xsl:if test="not(parent::listplus_search_domain)">
			<div id="field-{$idPrefix}{@id}">
				<xsl:choose>
					<xsl:when test="count(error/message)>0">
						<xsl:attribute name="class">aq-field aq-field-error <xsl:value-of select="@format" /></xsl:attribute>
					</xsl:when>
					<xsl:otherwise>
						<xsl:attribute name="class">aq-field <xsl:value-of select="@format" /></xsl:attribute>
					</xsl:otherwise>
				</xsl:choose>
				<xsl:apply-templates select="." mode="question" />
				<xsl:apply-templates select="." mode="answer" />
				<div class="aq-field-info">
					<xsl:apply-templates select="." mode="required" />
					<xsl:apply-templates select="." mode="explain" />
				</div>
				<xsl:if test="not(@readonly = 'true')">
					<xsl:apply-templates select="error" mode="field" />
				</xsl:if>
			</div>
		</xsl:if>
	</xsl:template>

	<!--  question for a field  -->
	<xsl:template match="field" mode="question">
		<div class="aq-question" id="question-{$idPrefix}{@id}">
			<!--  labels for text fields and dropdowns -->
			<xsl:choose>
				<xsl:when test="not(@domain) or @domain='false' or (@domain='true' and not(@multivalue))">
					<label for="{$idPrefix}{@id}"><xsl:value-of select="question" /></label>
				</xsl:when>
					<xsl:otherwise><xsl:value-of select="question" />
				</xsl:otherwise>
			</xsl:choose>
		</div>
	</xsl:template>
	<!-- answer for a field -->
	<xsl:template match="field" mode="answer">
		<div class="aq-answer" id="answer-{$idPrefix}{@id}">
			<xsl:choose>
				<xsl:when test="@readonly = 'true'">
					<xsl:attribute name="class">aq-answer aq-answer-readonly</xsl:attribute>
				</xsl:when>
				<xsl:otherwise>
					<xsl:attribute name="class">aq-answer</xsl:attribute>
				</xsl:otherwise>
			</xsl:choose>			
			<xsl:apply-templates select="." mode="field" />
		</div>
	</xsl:template>
	<!--  required for a field -->
	<xsl:template match="field" mode="required">
		<xsl:if test="@required and not(@readonly)">
			<div class="aq-required">*</div>
		</xsl:if>
	</xsl:template>
	<!--  explain for a field -->
	<xsl:template match="field" mode="explain">
		<xsl:if test="explain and string-length(explain) > 0">
			<div class="aq-explain" id="explain-{$idPrefix}{@id}">
				<div class="aq-explain-trigger" onclick="Runtime.toggleExplain(this, 'aq-explain-text-{$idPrefix}{@id}')">
				</div>
				<div class="aq-explain-text" id="aq-explain-text-{$idPrefix}{@id}" onclick="Runtime.toggleExplain(null, 'aq-explain-text-{$idPrefix}{@id}')">
					<xsl:value-of select="explain" />
				</div>
			</div>
		</xsl:if>
	</xsl:template>

	<!--  errors for a field -->
	<xsl:template match="error" mode="field">
		<div class="aq-error">
			<xsl:apply-templates select="message" mode="field" />
		</div>
	</xsl:template>
	<!--  error message -->
	<xsl:template match="error/message" mode="field">
		<div class="aq-error-message">
			<xsl:value-of select="." />
		</div>
	</xsl:template>

	<!-- select the actual field for the answer -->
	<xsl:template match="field" mode="field">
		<xsl:choose>
			<xsl:when test="(@domain='true' and count(domain/domainValue[@valid='true']) &lt; 5 and count(domain/domainValue[@valid='true']) &gt; 0 and not(@multivalue))">
				<xsl:apply-templates select="." mode="radio" />
			</xsl:when>
			<xsl:when test="@basetype='boolean' or (@domain='true' and @multivalue='true')">
				<xsl:apply-templates select="." mode="checkbox" />
			</xsl:when>
			<xsl:when test="@domain='true' and not(@multivalue)">
				<xsl:apply-templates select="." mode="dropdown" />
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="." mode="text" />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!--  memo field -->
	<xsl:template match="field[@format='memo']" mode="text">
		<xsl:choose>
			<xsl:when test="@readonly">
				<xsl:value-of select="value" />
			</xsl:when>
			<xsl:otherwise>
				<textarea id="{$idPrefix}{@id}" name="{$idPrefix}{@id}" class="aq-input aq-memo">
					<xsl:if test="@length">
						<xsl:attribute name="size"><xsl:value-of select="@length" /></xsl:attribute>
					</xsl:if>
					<xsl:if test="@refresh='true'">
						<xsl:attribute name="onchange">Runtime.refresh(this, '<xsl:value-of select="$idPrefix" />');</xsl:attribute>
					</xsl:if>
					<xsl:choose>
						<xsl:when test="string(rejectedvalue)">
							<xsl:value-of select="string(rejectedvalue)" />
						</xsl:when>
						<xsl:when test="value">
							<xsl:value-of select="value" />
						</xsl:when>
					</xsl:choose>
				</textarea>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- Text field -->
	<xsl:template match="field" mode="text">
		<xsl:apply-templates select="." mode="beforetextinput" />
		<xsl:choose>
			<xsl:when test="@readonly">
				<xsl:apply-templates select="." mode="textreadonly" />
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="." mode="textinput" />
			</xsl:otherwise>
		</xsl:choose>
		<xsl:apply-templates select="." mode="aftertextinput" />
	</xsl:template>

	<!--  Readonly field -->
	<xsl:template match="field" mode="textreadonly">
		<xsl:choose>
			<xsl:when test="@readonly and value/@display">
				<xsl:value-of select="value/@display" />
			</xsl:when>
			<xsl:when test="@readonly and @multivalue='true'">
				<xsl:for-each select="value">
					<xsl:value-of select="." /><br />
				</xsl:for-each>
			</xsl:when>
			<xsl:otherwise>
				<xsl:for-each select="value">
				   <xsl:value-of select="."/>
				   <xsl:if test="position() != last()">
				      <xsl:text>, </xsl:text>
				   </xsl:if>
				</xsl:for-each>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!--  Text input field -->
	<xsl:template match="field" mode="textinput">
		<input class="aq-input" id="{$idPrefix}{@id}" name="{$idPrefix}{@id}">
			<xsl:choose>
				<xsl:when test="@basetype='date'">
					<xsl:attribute name="class">aq-input aq-<xsl:value-of select="@basetype" /></xsl:attribute>
				</xsl:when>
				<xsl:otherwise>
					<xsl:attribute name="class">aq-input</xsl:attribute>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:apply-templates select="." mode="datatype" />
			<xsl:attribute name="value">
				<xsl:choose>
					<xsl:when test="string(rejectedvalue)">
						<xsl:value-of select="string(rejectedvalue)" />
					</xsl:when>
					<xsl:when test="value">
						<xsl:value-of select="value" />
					</xsl:when>
				</xsl:choose>
			</xsl:attribute>
			<xsl:if test="@length">
				<xsl:attribute name="size"><xsl:value-of select="@length" /></xsl:attribute>
			</xsl:if>
			<xsl:if test="@refresh='true'">
				<xsl:attribute name="onchange">Runtime.refresh(this, '<xsl:value-of select="$idPrefix" />');</xsl:attribute>
			</xsl:if>
		</input>
	</xsl:template>
	<xsl:template match="field" mode="datatype">
		<xsl:choose>
			<xsl:when test="@format='password'">
				<xsl:attribute name="type">password</xsl:attribute>
			</xsl:when>
			 <!-- html 5 types -->
			<!-- Only 
			<xsl:when test="@basetype='date'">
				<xsl:attribute name="type">date</xsl:attribute>
			</xsl:when>
			<xsl:when test="@basetype='datetime'"> 
				<xsl:attribute name="type">datetime-local</xsl:attribute>
			</xsl:when> -->
			<xsl:when test="integer"> 
				<xsl:attribute name="type">number</xsl:attribute>
			</xsl:when>
			<xsl:when test="contains(@name, 'email')"> 
				<xsl:attribute name="type">email</xsl:attribute>
			</xsl:when>

			<xsl:otherwise>
				<xsl:attribute name="type">text</xsl:attribute>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- Element before a textinput -->
	<xsl:template match="field" mode="beforetextinput">
		<xsl:choose>
			<xsl:when test="@basetype='currency'">
				<span class="aq-field-before"><xsl:value-of select="'&amp;euro;'" disable-output-escaping="yes" /></span>
			</xsl:when>
		</xsl:choose>
	</xsl:template>

	<!-- Element after a textinput -->
	<xsl:template match="field" mode="aftertextinput">
		<xsl:choose>
			<xsl:when test="@basetype='percentage'">
				<span class="aq-field-after">%</span>
			</xsl:when>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="field" mode="checkbox">
		<xsl:choose>
			<xsl:when test="count(domain/domainValue[@valid='true']) &gt; 0">
				<xsl:choose>
					<xsl:when test="@basetype='currency'">
						<span class="aq-field-domain-before"><xsl:value-of select="'&amp;euro;'" disable-output-escaping="yes" /></span>
					</xsl:when>
					<xsl:when test="@basetype='percentage'">
						<span class="aq-field-domain-after">%</span>
					</xsl:when>
				</xsl:choose>
				<ul class="aq-field-domain">
					<xsl:for-each select="domain/domainValue[@valid='true']">
						<li>
							<input type="checkbox" value="{@value}">
								<xsl:attribute name="id"><xsl:value-of select="$idPrefix" /><xsl:value-of select="../../@id" />-<xsl:value-of
									select="position()" /></xsl:attribute>
								<xsl:attribute name="name"><xsl:value-of select="$idPrefix" /><xsl:value-of select="../../@id" /></xsl:attribute>

								<xsl:if test="@selected='true'">
									<xsl:attribute name="checked">checked</xsl:attribute>
								</xsl:if>
								<xsl:if test="../../@readonly or @valid='false'">
									<xsl:attribute name="disabled">disabled</xsl:attribute>
								</xsl:if>
								<xsl:if test="../../@refresh='true'">
									<xsl:attribute name="onclick">Runtime.refresh(this, '<xsl:value-of select="$idPrefix" />');</xsl:attribute>
								</xsl:if>
							</input>
							<label>
								<xsl:attribute name="for"><xsl:value-of select="$idPrefix" /><xsl:value-of select="../../@id" />-<xsl:value-of
									select="position()" /></xsl:attribute>
								<xsl:value-of select="." />
							</label>
						</li>
					</xsl:for-each>
				</ul>
			</xsl:when>
			<xsl:when test="count(value) &gt; 0">
				<input type="checkbox" id="{$idPrefix}{@id}" name="{$idPrefix}{@id}">
					<xsl:if test="value = 'true'">
						<xsl:attribute name="checked">checked</xsl:attribute>
					</xsl:if>
					<xsl:if test="@readonly">
						<xsl:attribute name="disabled">disabled</xsl:attribute>
					</xsl:if>
					<xsl:if test="@refresh='true'">
						<xsl:attribute name="onclick">Runtime.refresh(this, '<xsl:value-of select="$idPrefix" />');</xsl:attribute>
					</xsl:if>
				</input>
			</xsl:when>
			<xsl:otherwise>
				<!-- No value and no domain, dont show -->
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="field[@domain='true' and @readonly='true']" mode="radio">
		<xsl:value-of select="domain/domainValue[@selected='true']" />
	</xsl:template>

	<xsl:template match="field" mode="radio">
		<xsl:choose>
			<xsl:when test="@basetype='currency'">
				<span class="aq-field-domain-before"><xsl:value-of select="'&amp;euro;'" disable-output-escaping="yes" /></span>
			</xsl:when>
			<xsl:when test="@basetype='percentage'">
				<span class="aq-field-domain-after">%</span>
			</xsl:when>
		</xsl:choose>
		<ul class="aq-field-domain">
			<xsl:for-each select="domain/domainValue[@valid='true']">
				<li>
					<input type="radio">
						<xsl:attribute name="id"><xsl:value-of select="$idPrefix" /><xsl:value-of select="../../@id" />-<xsl:value-of
							select="position()" /></xsl:attribute>
						<xsl:attribute name="name"><xsl:value-of select="../../@id" /></xsl:attribute>
						<xsl:attribute name="value"><xsl:value-of select="@value" /></xsl:attribute>
						<xsl:if test="../../@refresh='true'">
							<xsl:attribute name="onclick">Runtime.refresh(this, '<xsl:value-of select="$idPrefix" />');</xsl:attribute>
						</xsl:if>
						<xsl:if test="../../@readonly or @valid='false'">
							<xsl:attribute name="disabled">disabled</xsl:attribute>
						</xsl:if>
						<xsl:if test="@selected='true'">
							<xsl:attribute name="checked">checked</xsl:attribute>
						</xsl:if>
					</input>
					<label>
						<xsl:attribute name="for"><xsl:value-of select="$idPrefix" /><xsl:value-of select="../../@id" />-<xsl:value-of
							select="position()" /></xsl:attribute>
						<xsl:value-of select="." />
					</label>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>

	<xsl:template match="field[@domain='true' and @readonly='true']" mode="dropdown">
		<xsl:value-of select="domain/domainValue[@selected='true']" />
	</xsl:template>

	<xsl:template match="field" mode="dropdown">
		<select id="{$idPrefix}{@id}" name="{$idPrefix}{@id}">
			<xsl:if test="@readonly">
				<xsl:attribute name="disabled">disabled</xsl:attribute>
			</xsl:if>
			<xsl:if test="@refresh='true'">
				<xsl:attribute name="onchange">Runtime.refresh(this, '<xsl:value-of select="$idPrefix" />');</xsl:attribute>
			</xsl:if>
			<option value=""></option>
			<xsl:for-each select="domain/domainValue[@valid='true']">
				<option value="{@value}">
					<xsl:if test="@selected='true'">
						<xsl:attribute name="selected">selected</xsl:attribute>
					</xsl:if>
					<xsl:value-of select="." />
				</option>
			</xsl:for-each>
		</select>
	</xsl:template>
</xsl:stylesheet>
