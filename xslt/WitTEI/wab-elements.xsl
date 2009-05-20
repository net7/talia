<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE TEI [
<!ENTITY nbsp "&#160;">
<!ENTITY emdash "&#2014;">
<!ENTITY dash  "&#x2014;">
]>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:tei="http://www.tei-c.org/ns/1.0" version="1.0">


	<!-- The basic page-elements are handled by the following templates -->
	
	<xsl:template match="tei:facsimile"/>
	
	<xsl:template match="tei:div">
		<xsl:apply-templates/>
	</xsl:template>
	
	<xsl:template match="tei:pb">
		<xsl:variable name="pagename">
			<xsl:value-of select="substring-before(attribute::n, ' ')"/>
		</xsl:variable>
		<xsl:variable name="pageref">
			<xsl:value-of select="substring-after(attribute::n, ' ')"/>
		</xsl:variable>
		<xsl:variable name="facsimile">
			<xsl:value-of select="attribute::facs"/>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="ancestor::tei:ab">
				<xsl:element name="TABLE">
					<xsl:attribute name="width">100%</xsl:attribute>
					<xsl:attribute name="style">border-bottom-style: solid; border-width: 1px; color: #FF0000;</xsl:attribute>
					<xsl:element name="TR">
						<xsl:element name="TD"></xsl:element>
					</xsl:element>
				</xsl:element>
				<xsl:element name="TABLE">
					<xsl:attribute name="width">100%</xsl:attribute>
					<xsl:attribute name="style">border-top-style: solid; border-width: 1px; color: #FF0000;</xsl:attribute>
					<xsl:element name="TR">
						<xsl:element name="TD"></xsl:element>
					</xsl:element>
				</xsl:element>
			</xsl:when>
			<xsl:otherwise>
				<xsl:element name="TABLE">
					<xsl:attribute name="border">0</xsl:attribute>
					<xsl:element name="TR">
						<xsl:element name="TD">
							<xsl:attribute name="width">100px</xsl:attribute>
						</xsl:element>
						<xsl:element name="TD">
							<xsl:attribute name="width">700px</xsl:attribute>
							<xsl:element name="TABLE">
								<xsl:attribute name="width">100%</xsl:attribute>
								<xsl:attribute name="style">border-bottom-style: solid; border-width: 1px; color: #FF0000;</xsl:attribute>
								<xsl:element name="TR">
									<xsl:element name="TD"></xsl:element>
								</xsl:element>
							</xsl:element>
							<xsl:element name="TABLE">
								<xsl:attribute name="width">100%</xsl:attribute>
								<xsl:attribute name="style">border-top-style: solid; border-width: 1px; color: #FF0000;</xsl:attribute>
								<xsl:element name="TR">
									<xsl:element name="TD"></xsl:element>
								</xsl:element>
							</xsl:element>
						</xsl:element>
					</xsl:element>
				</xsl:element>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:choose>
			<xsl:when test="$prosjekt='discovery'"></xsl:when>
			<xsl:otherwise>
				<xsl:element name="DIV">
					<xsl:attribute name="style">float: right; padding: 1px; border: 1px solid #000000; background-color: #DDDDDD;</xsl:attribute>
					<xsl:element name="A">
						<xsl:attribute name="style">text-decoration: none; color: #FF0000;</xsl:attribute>
						<xsl:attribute name="href">
							<xsl:value-of select="preceding::tei:facsimile/descendant::tei:surface[attribute::xml:id=$facsimile]/child::tei:graphic/attribute::url"/>
						</xsl:attribute>
						<xsl:attribute name="target">_blank</xsl:attribute>
						<xsl:text>&#x00A4;</xsl:text>
					</xsl:element>
					<xsl:text> </xsl:text>
					<xsl:element name="SPAN">
						<xsl:attribute name="style">font-size: 10pt; color: #FF0000;</xsl:attribute>
						<xsl:value-of select="substring-after($pagename, '_')"/>
					</xsl:element>
				</xsl:element>
				<xsl:element name="BR"></xsl:element>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:element name="BR"></xsl:element>
	</xsl:template>
	
	<xsl:template match="tei:lb">
		<xsl:choose>
			<xsl:when test="contains($lb, 'excl')">
				<xsl:choose>
					<xsl:when test="attribute::rend='shyphen'"></xsl:when>
					<xsl:when test="attribute::rend='shyphen-pb'">
						<xsl:text>&#x002D;</xsl:text>
					</xsl:when>
					<xsl:when test="attribute::rend='shyphen0'"></xsl:when>
					<xsl:when test="attribute::rend='hl'">
						<xsl:element name="BR"/>
					</xsl:when>
					<xsl:otherwise><xsl:text>&#x0020;</xsl:text></xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<xsl:choose>
					<xsl:when test="contains($visning, 'dipl')">
						<xsl:choose>
							<xsl:when test="child::tei:blabla"></xsl:when>
							<xsl:otherwise>
								<xsl:choose>
									<xsl:when test="attribute::rend='shyphen'">
										<xsl:text>&#x002D;</xsl:text>
										<xsl:element name="BR"/>
									</xsl:when>
									<xsl:when test="attribute::rend='shyphen-pb'">
										<xsl:text>&#x002D;</xsl:text>
										<xsl:element name="BR"/>
									</xsl:when>
									<xsl:when test="attribute::rend='shyphen0'">
										<xsl:element name="BR"/>
									</xsl:when>
									<xsl:when test="attribute::rend='hl'">
										<xsl:element name="BR"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:element name="BR"/>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:when test="contains($visning, 'study')">
						<xsl:choose>
							<xsl:when test="attribute::rend='shyphen'">
								<xsl:text>&#x002D;</xsl:text>
								<xsl:element name="BR"/>
							</xsl:when>
							<xsl:when test="attribute::rend='shyphen-pb'">
								<xsl:text>&#x002D;</xsl:text>
								<xsl:element name="BR"/>
							</xsl:when>
							<xsl:when test="attribute::rend='shyphen0'">
								<xsl:element name="BR"/>
							</xsl:when>
							<xsl:when test="attribute::rend='hl'">
								<xsl:element name="BR"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:element name="BR"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:when test="contains($visning, 'norm')">
						<xsl:choose>
							<xsl:when test="attribute::rend='shyphen'">
								<xsl:choose>
									<xsl:when test="$lb = 'incl'">
										<xsl:text>&#x002D;</xsl:text>
										<xsl:element name="BR"/>
									</xsl:when>
									<xsl:otherwise></xsl:otherwise>
								</xsl:choose>
							</xsl:when>
							<xsl:when test="attribute::rend='shyphen-pb'">
								<xsl:choose>
									<xsl:when test="$lb = 'incl'">
										<xsl:text>&#x002D;</xsl:text>
										<xsl:element name="BR"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:text>&#x002D;</xsl:text>
										<xsl:element name="BR"/>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:when>
							<xsl:when test="attribute::rend='shyphen0'">
								<xsl:choose>
									<xsl:when test="$lb = 'incl'">
										<xsl:element name="BR"/>
									</xsl:when>
									<xsl:otherwise></xsl:otherwise>
								</xsl:choose>
							</xsl:when>
							<xsl:when test="attribute::rend='hl'">
								<xsl:element name="BR"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:choose>
									<xsl:when test="$lb = 'incl'">
										<xsl:element name="BR"></xsl:element>
									</xsl:when>
									<xsl:otherwise>
										<xsl:text>&#x0020;</xsl:text>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:otherwise/>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="tei:fw">
		<xsl:choose>
			<xsl:when test="contains($visning, 'dipl')">
				<xsl:choose>
					<xsl:when test="contains(attribute::place, 'right')">
						<xsl:element name="DIV">
							<xsl:attribute name="style">text-align: right; margin-right: 250px;</xsl:attribute>
							<xsl:apply-templates/>
						</xsl:element>
					</xsl:when>
					<xsl:when test="contains(attribute::place, 'left')">
						<xsl:element name="DIV">
							<xsl:attribute name="style">text-align: left; margin-left: 0px;</xsl:attribute>
							<xsl:apply-templates/>
						</xsl:element>
					</xsl:when>
					<xsl:otherwise>
						<xsl:element name="DIV">
							<xsl:attribute name="style">text-align: center</xsl:attribute>
							<xsl:apply-templates/>
						</xsl:element>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="contains($visning, 'study')">
				<xsl:choose>
					<xsl:when test="contains(attribute::place, 'right')">
						<xsl:element name="DIV">
							<xsl:attribute name="style">text-align: right; margin-right: 250px;</xsl:attribute>
							<xsl:apply-templates/>
						</xsl:element>
					</xsl:when>
					<xsl:when test="contains(attribute::place, 'left')">
						<xsl:element name="DIV">
							<xsl:attribute name="style">text-align: left</xsl:attribute>
							<xsl:apply-templates/>
						</xsl:element>
					</xsl:when>
					<xsl:otherwise>
						<xsl:element name="DIV">
							<xsl:attribute name="style">text-align: center</xsl:attribute>
							<xsl:apply-templates/>
						</xsl:element>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="contains($visning, 'norm')">
				<xsl:choose>
					<xsl:when test="attribute::type='fragpagen'"/>
					<xsl:otherwise>
						<xsl:choose>
							<xsl:when test="contains(attribute::place, 'right')">
								<xsl:element name="DIV">
									<xsl:attribute name="style">text-align: right; margin-right: 250px;</xsl:attribute>
									<xsl:apply-templates/>
								</xsl:element>
							</xsl:when>
							<xsl:when test="contains(attribute::place, 'left')">
								<xsl:element name="DIV">
									<xsl:attribute name="style">text-align: left</xsl:attribute>
									<xsl:apply-templates/>
								</xsl:element>
							</xsl:when>
							<xsl:otherwise>
								<xsl:element name="DIV">
									<xsl:attribute name="style">text-align: center</xsl:attribute>
									<xsl:apply-templates/>
								</xsl:element>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise/>
		</xsl:choose>
	</xsl:template>
	
	<!-- Basic structures in the text -->
	
	<xsl:template match="tei:ab">
        <xsl:variable name="sm-check">
            <xsl:value-of select="."/>
        </xsl:variable>
        <xsl:variable name="paragraphid">
            <xsl:value-of select="attribute::xml:id"/>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="ancestor::tei:teiHeader">
                <xsl:apply-templates/>
            </xsl:when>
            <!--<xsl:when test="contains(attribute::emph, '_h') and $handwriting='off'"></xsl:when>-->
            <!--<xsl:when test="contains(attribute::div, '_h') and $handwriting='off'"></xsl:when>-->
            <!--<xsl:when test="contains(attribute::add, '_h') and $handwriting='off'"></xsl:when>-->
            <!--<xsl:when test="contains(attribute::del, '_h') and $handwriting='off'"></xsl:when>-->
            <!--<xsl:when test="contains(attribute::corr, '_h') and $handwriting='off'"></xsl:when>-->
            <xsl:otherwise>
                <xsl:choose>
                   <xsl:when test="descendant::tei:seg[contains(self::tei:seg, '&#x2216;')] and not($sm-back='show')">
                   </xsl:when>
                    <xsl:when test="descendant::tei:seg[contains(self::tei:seg, '&#x2223;')] and not($sm-bar='show')">
                    </xsl:when>
                    <xsl:when test="descendant::tei:seg[contains(self::tei:seg, '&#x03F5;')] and not($sm-epsi='show')">
                    </xsl:when>
                    <xsl:when test="descendant::tei:seg[contains(self::tei:seg, '&#x00A5;')] and not($sm-im='show')">
                    </xsl:when>
                    <xsl:when test="descendant::tei:seg[contains(self::tei:seg, '&#x203D;')] and not($sm-qm='show')">
                    </xsl:when>
                    <xsl:when test="descendant::tei:seg[contains(self::tei:seg, '&#x2215;')] and not($sm-slash='show')">
                    </xsl:when>
                    <xsl:when test="descendant::tei:seg[contains(self::tei:seg, '&#x2023;')] and not($sm-tick='show')">
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:choose>
                            <xsl:when test="ancestor::tei:ab and ancestor::tei:reloc">
                                <xsl:choose>
                                    <xsl:when test="$visning='norm'">
                                        <xsl:element name="DIV">
                                            <xsl:attribute name="style">margin-bottom: 10px; width: 700px;</xsl:attribute>
                                            <xsl:if test="not(contains(attribute::rend, 'conline'))">
                                                <xsl:element name="BR"/>
                                            </xsl:if>
                                            <xsl:choose>
                                                <xsl:when test="attribute::xml:id">
                                                    <xsl:element name="SPAN">
                                                        <!--<xsl:attribute name="onMouseover">
                                                            <xsl:text>ddrivetip('</xsl:text>
                                                            <xsl:if test="document('../cost-a32_komm/cost-vw139a_komm.xml')/descendant-or-self::tei:list[attribute::xml:id=$paragraphid]">
                                                                <xsl:if test="document('../cost-a32_komm/cost-vw139a_komm.xml')/descendant-or-self::tei:list[attribute::xml:id=$paragraphid]/child::tei:item[attribute::type='A1']">
                                                                    <xsl:text> A1: </xsl:text>
                                                                    <xsl:value-of select="document('../cost-a32_komm/cost-vw139a_komm.xml')/descendant-or-self::tei:list[attribute::xml:id=$paragraphid]/child::tei:item[attribute::type='A1']"/>
                                                                    <xsl:text>&lt;BR&gt;</xsl:text>
                                                                </xsl:if>
                                                            </xsl:if>
                                                            <xsl:text>\n</xsl:text>
                                                            <xsl:text>','gray')</xsl:text>
                                                        </xsl:attribute>-->
                                                        <!--<xsl:attribute name="onMouseout">hideddrivetip()</xsl:attribute>-->
                                                        <xsl:apply-templates/>
                                                        <xsl:if test="contains(attribute::rend, 'sepline')">
                                                            <xsl:element name="HR">
                                                                <xsl:attribute name="width">150px</xsl:attribute>
                                                                <xsl:attribute name="align">left</xsl:attribute>
                                                            </xsl:element>
                                                        </xsl:if>
                                                    </xsl:element>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <xsl:apply-templates/>
                                                    <xsl:if test="contains(attribute::rend, 'sepline')">
                                                        <xsl:element name="HR">
                                                            <xsl:attribute name="width">150px</xsl:attribute>
                                                            <xsl:attribute name="align">left</xsl:attribute>
                                                        </xsl:element>
                                                    </xsl:if>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                            <xsl:element name="BR"/>
                                        </xsl:element>
                                    </xsl:when>
                                    <xsl:when test="$visning='study'">
                                        <xsl:element name="DIV">
                                            <xsl:attribute name="style">margin-bottom: 10px; width: 700px;</xsl:attribute>
                                            <xsl:element name="BR"/>
                                            <xsl:choose>
                                                <xsl:when test="attribute::xml:id">
                                                    <xsl:element name="SPAN">
                                                        <!--<xsl:attribute name="onMouseover">
                                                            <xsl:text>ddrivetip('</xsl:text>
                                                            <xsl:if test="document('../cost-a32_komm/cost-vw139a_komm.xml')/descendant-or-self::tei:list[attribute::xml:id=$paragraphid]">
                                                                <xsl:if test="document('../cost-a32_komm/cost-vw139a_komm.xml')/descendant-or-self::tei:list[attribute::xml:id=$paragraphid]/child::tei:item[attribute::type='A2']">
                                                                    <xsl:text> A2: </xsl:text>
                                                                    <xsl:value-of select="document('../cost-a32_komm/cost-vw139a_komm.xml')/descendant-or-self::tei:list[attribute::xml:id=$paragraphid]/child::tei:item[attribute::type='A2']"/>
                                                                    <xsl:text>&lt;BR&gt;</xsl:text>
                                                                </xsl:if>
                                                            </xsl:if>
                                                            <xsl:text>\n</xsl:text>
                                                            <xsl:text>','gray')</xsl:text>
                                                        </xsl:attribute>-->
                                                        <!--<xsl:attribute name="onMouseout">hideddrivetip()</xsl:attribute>-->
                                                        <xsl:apply-templates/>
                                                        <xsl:if test="contains(attribute::rend, 'sepline')">
                                                            <xsl:element name="HR">
                                                                <xsl:attribute name="width">150px</xsl:attribute>
                                                                <xsl:attribute name="align">left</xsl:attribute>
                                                            </xsl:element>
                                                        </xsl:if>
                                                    </xsl:element>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <xsl:apply-templates/>
                                                    <xsl:if test="contains(attribute::rend, 'sepline')">
                                                        <xsl:element name="HR">
                                                            <xsl:attribute name="width">150px</xsl:attribute>
                                                            <xsl:attribute name="align">left</xsl:attribute>
                                                        </xsl:element>
                                                    </xsl:if>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:element>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:if test="contains(attribute::rend, 'blbef') and contains(attribute::rend, 'blaft')">
                                            <xsl:variable name="first">
                                                <xsl:value-of select="substring-before(attribute::rend, ' ')"/>
                                            </xsl:variable>
                                            <xsl:call-template name="blanks">
                                                <xsl:with-param name="i" select="1"/>
                                                <xsl:with-param name="max" select="substring-after($first, '_')"/>
                                            </xsl:call-template>
                                        </xsl:if>
                                        <xsl:if test="contains(attribute::rend, 'blbef') and not(contains(attribute::rend, 'blaft'))">
                                            <xsl:call-template name="blanks">
                                                <xsl:with-param name="i" select="1"/>
                                                <xsl:with-param name="max" select="substring-after(attribute::rend, '_')"/>
                                            </xsl:call-template>
                                        </xsl:if>
                                        <xsl:apply-templates/>
                                        <xsl:if test="contains(attribute::rend, 'blaft') and contains(attribute::rend, 'blbef')">
                                            <xsl:variable name="last">
                                                <xsl:value-of select="substring-after(attribute::rend, ' ')"/>
                                            </xsl:variable>
                                            <xsl:call-template name="blanks">
                                                <xsl:with-param name="i" select="1"/>
                                                <xsl:with-param name="max"
                                                    select="substring-after($last, '_')"/>
                                            </xsl:call-template>
                                        </xsl:if>
                                        <xsl:if test="contains(attribute::rend, 'blaft') and not(contains(attribute::rend, 'blbef'))">
                                            <xsl:call-template name="blanks">
                                                <xsl:with-param name="i" select="1"/>
                                                <xsl:with-param name="max" select="substring-after(attribute::rend, '_')"/>
                                            </xsl:call-template>
                                        </xsl:if>
                                        <xsl:if test="contains(attribute::rend, 'sepline')">
                                            <xsl:element name="HR">
                                                <xsl:attribute name="width">200px</xsl:attribute>
                                                <xsl:attribute name="align">left</xsl:attribute>
                                            </xsl:element>
                                        </xsl:if>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:if test="child::tei:seg[contains(attribute::type, 'nm')] or child::tei:seg[contains(attribute::type, 'nl')] or child::tei:seg[contains(attribute::type, 'nr')]">
                                    <xsl:choose>
                                        <xsl:when test="$handwriting='off' and contains(attribute::add, '_h')"></xsl:when>
                                        <xsl:when test="$handwriting='off' and contains(attribute::add, '_H5')"></xsl:when>
                                        <xsl:when test="$handwriting='off' and contains(attribute::add, 'H')"></xsl:when>
                                        <xsl:otherwise>
                                            <xsl:choose>
                                                <xsl:when test="$visning='dipl' or $visning='study'">
                                                    <xsl:element name="TABLE">
                                                        <xsl:attribute name="border">0</xsl:attribute>
                                                        <xsl:attribute name="cellpadding">0</xsl:attribute>
                                                        <xsl:attribute name="cellspacing">0</xsl:attribute>
                                                        <xsl:attribute name="width">800px</xsl:attribute>
                                                        <xsl:element name="TR">
                                                            <xsl:element name="TD">
                                                                <xsl:attribute name="width">85px</xsl:attribute>
                                                                <xsl:text>&nbsp;</xsl:text>
                                                            </xsl:element>
                                                            <xsl:element name="TD">
                                                                <xsl:attribute name="width">205px</xsl:attribute>
                                                                <xsl:choose>
                                                                    <xsl:when test="child::tei:seg[contains(attribute::type, 'nl')]">
                                                                        <xsl:apply-templates select="child::tei:seg[contains(attribute::type, 'nl')]" mode="margins"/>
                                                                    </xsl:when>
                                                                    <xsl:otherwise>
                                                                        <xsl:text>&nbsp;</xsl:text>
                                                                    </xsl:otherwise>
                                                                </xsl:choose>
                                                            </xsl:element>
                                                            <xsl:element name="TD">
                                                                <xsl:attribute name="width">205px</xsl:attribute>
                                                                <xsl:choose>
                                                                    <xsl:when test="child::tei:seg[contains(attribute::type, 'nm')]">
                                                                        <xsl:apply-templates select="child::tei:seg[contains(attribute::type, 'nm')]" mode="margins"/>
                                                                    </xsl:when>
                                                                    <xsl:otherwise>
                                                                        <xsl:text>&nbsp;</xsl:text>
                                                                    </xsl:otherwise>
                                                                </xsl:choose>
                                                            </xsl:element>
                                                            <xsl:element name="TD">
                                                                <xsl:attribute name="width">205px</xsl:attribute>
                                                                <xsl:choose>
                                                                    <xsl:when test="child::tei:seg[contains(attribute::type, 'nr')]">
                                                                        <xsl:apply-templates select="child::tei:seg[contains(attribute::type, 'nr')]" mode="margins"/>
                                                                    </xsl:when>
                                                                    <xsl:otherwise>
                                                                        <xsl:text>&nbsp;</xsl:text>
                                                                    </xsl:otherwise>
                                                                </xsl:choose>
                                                            </xsl:element>
                                                        </xsl:element>
                                                    </xsl:element>
                                                </xsl:when>
                                                <xsl:otherwise></xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:if>
                                <xsl:if test="descendant::tei:seg[contains(attribute::type, 'secm')]">
                                    <xsl:choose>
                                        <xsl:when test="$handwriting='off' and contains(attribute::add, '_h')"></xsl:when>
                                        <xsl:when test="$handwriting='off' and contains(attribute::add, '_H5')"></xsl:when>
                                        <xsl:when test="$handwriting='off' and contains(attribute::add, 'H')"></xsl:when>
                                        <xsl:otherwise>
                                            <xsl:choose>
                                                <xsl:when test="$visning='dipl'">
                                                    <xsl:element name="TABLE">
                                                        <xsl:attribute name="border">0</xsl:attribute>
                                                        <xsl:attribute name="cellpadding">0</xsl:attribute>
                                                        <xsl:attribute name="cellspacing">0</xsl:attribute>
                                                        <xsl:attribute name="width">800px</xsl:attribute>
                                                        <xsl:element name="TR">
                                                            <xsl:element name="TD">
                                                                <xsl:attribute name="width">85px</xsl:attribute>
                                                                <xsl:text>&nbsp;</xsl:text>
                                                            </xsl:element>
                                                            <xsl:element name="TD">
                                                                <xsl:attribute name="width">205px</xsl:attribute>
                                                                <xsl:attribute name="style">text-align: left;</xsl:attribute>
                                                                <xsl:choose>
                                                                    <xsl:when test="descendant::tei:seg[contains(attribute::type, 'secml')]">
                                                                        <xsl:for-each select="descendant::tei:seg[contains(attribute::type, 'secml')]">
                                                                            <xsl:choose>
                                                                                <xsl:when test="contains(attribute::type, '_h')">
                                                                                    <xsl:choose>
                                                                                        <xsl:when test="$handwriting = 'off'"></xsl:when>
                                                                                        <xsl:otherwise>
                                                                                            <xsl:element name="SPAN">
                                                                                                <xsl:attribute name="style">color: #0000FF; font-size: 60%; font-family: Arial Unicode MS;</xsl:attribute>
                                                                                                <xsl:apply-templates/>
                                                                                            </xsl:element>
                                                                                        </xsl:otherwise>
                                                                                    </xsl:choose>
                                                                                </xsl:when>
                                                                                <xsl:otherwise>
                                                                                    <xsl:element name="SPAN">
                                                                                        <xsl:attribute name="style">font-family: Arial Unicode MS;</xsl:attribute>
                                                                                        <xsl:apply-templates/>
                                                                                    </xsl:element>
                                                                                </xsl:otherwise>
                                                                            </xsl:choose>
                                                                        </xsl:for-each>
                                                                    </xsl:when>
                                                                    <xsl:otherwise>
                                                                        <xsl:text>&nbsp;</xsl:text>
                                                                    </xsl:otherwise>
                                                                </xsl:choose>
                                                            </xsl:element>
                                                            <xsl:element name="TD">
                                                                <xsl:text>&nbsp;</xsl:text>
                                                            </xsl:element>
                                                            <xsl:element name="TD">
                                                                <xsl:attribute name="width">205px</xsl:attribute>
                                                                <xsl:attribute name="style">text-align: right;</xsl:attribute>
                                                                <xsl:choose>
                                                                    <xsl:when test="descendant::tei:seg[contains(attribute::type, 'secmr')]">
                                                                        <xsl:for-each select="descendant::tei:seg[contains(attribute::type, 'secmr')]">
                                                                            <xsl:choose>
                                                                                <xsl:when test="contains(attribute::type, '_h')">
                                                                                    <xsl:choose>
                                                                                        <xsl:when test="$handwriting = 'off'"></xsl:when>
                                                                                        <xsl:otherwise>
                                                                                            <xsl:element name="SPAN">
                                                                                                <xsl:attribute name="style">color: #0000FF; font-size: 60%; font-family: Arial Unicode MS;</xsl:attribute>
                                                                                                <xsl:apply-templates/>
                                                                                            </xsl:element>
                                                                                        </xsl:otherwise>
                                                                                    </xsl:choose>
                                                                                </xsl:when>
                                                                                <xsl:otherwise>
                                                                                    <xsl:element name="SPAN">
                                                                                        <xsl:attribute name="style">font-family: Arial Unicode MS;</xsl:attribute>
                                                                                        <xsl:apply-templates/>
                                                                                    </xsl:element>
                                                                                </xsl:otherwise>
                                                                            </xsl:choose>
                                                                        </xsl:for-each>
                                                                    </xsl:when>
                                                                    <xsl:otherwise>
                                                                        <xsl:text>&nbsp;</xsl:text>
                                                                    </xsl:otherwise>
                                                                </xsl:choose>
                                                            </xsl:element>
                                                        </xsl:element>
                                                    </xsl:element>
                                                </xsl:when>
                                                <xsl:otherwise></xsl:otherwise>
                                            </xsl:choose> 
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:if>
                                <xsl:element name="table">
                                    <xsl:attribute name="border">0</xsl:attribute>
                                    <xsl:attribute name="cellpadding">0</xsl:attribute>
                                    <xsl:attribute name="cellspacing">0</xsl:attribute>
                                    <xsl:choose>
                                        <xsl:when test="$prosjekt = 'discovery'">
                                            <xsl:attribute name="width">700px</xsl:attribute>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:attribute name="width">800px</xsl:attribute>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                    <xsl:element name="tr">
                                        <xsl:element name="td">
                                            <xsl:choose>
                                                <xsl:when test="$prosjekt = 'discovery'">
                                                    <xsl:attribute name="width">25px</xsl:attribute>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <xsl:attribute name="width">75px</xsl:attribute>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                            <xsl:attribute name="valign">top</xsl:attribute>
                                            <xsl:text>&nbsp;</xsl:text>
                                        </xsl:element>
                                        <xsl:element name="td">
                                            <xsl:attribute name="width">20px</xsl:attribute>
                                            <xsl:attribute name="valign">top</xsl:attribute>
                                            <xsl:attribute name="text-align">right</xsl:attribute>
                                            <xsl:if test="contains(attribute::rend, 'conline')">
                                                <xsl:choose>
                                                    <xsl:when test="contains(attribute::rend, 'conline_h')">
                                                        <xsl:choose>
                                                            <xsl:when test="$handwriting = 'off'"></xsl:when>
                                                            <xsl:otherwise>
                                                                <xsl:choose>
                                                                    <xsl:when test="contains($visning, 'dipl')">
                                                                        <xsl:element name="SPAN">
                                                                            <xsl:attribute name="style">color: #0000FF;</xsl:attribute>
                                                                            <xsl:text>(</xsl:text>
                                                                        </xsl:element>
                                                                    </xsl:when>
                                                                    <xsl:when test="contains($visning, 'study')">
                                                                        <xsl:element name="SPAN">
                                                                            <xsl:attribute name="style">color: #0000FF;</xsl:attribute>
                                                                            <xsl:text>(</xsl:text>
                                                                        </xsl:element>
                                                                    </xsl:when>
                                                                    <xsl:otherwise></xsl:otherwise>
                                                                </xsl:choose>
                                                            </xsl:otherwise>
                                                        </xsl:choose>
                                                    </xsl:when>
                                                    <xsl:otherwise>
                                                        <xsl:choose>
                                                            <xsl:when test="contains($visning, 'dipl')">
                                                                <xsl:text>(</xsl:text>
                                                            </xsl:when>
                                                            <xsl:when test="contains($visning, 'study')">
                                                                <xsl:text>(</xsl:text>
                                                            </xsl:when>
                                                            <xsl:otherwise></xsl:otherwise>
                                                        </xsl:choose>
                                                    </xsl:otherwise>
                                                </xsl:choose>
                                            </xsl:if>
                                            <xsl:text>&nbsp;</xsl:text>
                                        </xsl:element>
                                        <xsl:element name="td">
                                            <xsl:attribute name="width">5px</xsl:attribute>
                                            <xsl:text>&nbsp;</xsl:text>
                                        </xsl:element>
                                        <xsl:element name="td">
                                            <xsl:attribute name="style">
                                                <xsl:text> text-align: left;</xsl:text>
                                                <!-- Background-color on main cell -->
                                                <xsl:choose>
                                                    <xsl:when test="contains(attribute::emph, 'arrback') and not(contains(attribute::emph, 'arrback_'))">background-color: #CC77FF;</xsl:when>
                                                    <xsl:when test="contains(attribute::emph, 'arrback_h') and not($handwriting='off')">background-color: #CC77FF;</xsl:when>
                                                    <xsl:when test="contains(attribute::emph, 'arrforward') and not(contains(attribute::emph, 'arrforward_'))">background-color: #CC77FF;</xsl:when>
                                                    <xsl:when test="contains(attribute::emph, 'arrforward_h') and not($handwriting='off')">background-color: #CC77FF;</xsl:when>
                                                    <xsl:when test="contains(attribute::emph, 'clilm') and not(contains(attribute::emph, 'clilm_'))">background-color: #BEBEBE;</xsl:when>
                                                    <xsl:when test="contains(attribute::emph, 'clilm_h' and not($handwriting='off'))">background-color: #BEBEBE;</xsl:when>
                                                    <xsl:when test="contains(attribute::emph, 'clirm') and not(contains(attribute::emph, 'clirm_'))">background-color: #BEBEBE;</xsl:when>
                                                    <xsl:when test="contains(attribute::emph, 'clirm_h' and not($handwriting='off'))">background-color: #BEBEBE;</xsl:when>
                                                    <xsl:when test="contains(attribute::emph, 'crossed') and not(contains(attribute::emph, 'crossed_'))">background-color: #BEBEBE;</xsl:when>
                                                    <xsl:when test="contains(attribute::emph, 'crossed_h') and not($handwriting='off')">background-color: #BEBEBE;</xsl:when>
                                                    <xsl:when test="contains(attribute::emph, 'slilm') and not(contains(attribute::emph, 'slilm_'))">background-color: #BEBEBE;</xsl:when>
                                                    <xsl:when test="contains(attribute::emph, 'slilm_h' and not($handwriting='off'))">background-color: #BEBEBE;</xsl:when>
                                                    <xsl:when test="contains(attribute::emph, 'slirm') and not(contains(attribute::emph, 'slirm_'))">background-color: #BEBEBE;</xsl:when>
                                                    <xsl:when test="contains(attribute::emph, 'slirm_h') and not($handwriting='off')">background-color: #BEBEBE;</xsl:when>
                                                    <xsl:when test="contains(attribute::emph, 'vdline') and not(contains(attribute::emph, 'vdline_'))">background-color: #BEBEBE;</xsl:when>
                                                    <xsl:when test="contains(attribute::emph, 'vdline_h') and not($handwriting='off')">background-color: #BEBEBE;</xsl:when>
                                                    <xsl:when test="contains(attribute::emph, 'vdline_h_ch') and not($handwriting='off') and not($visning='norm')">background-color: #BEBEBE;</xsl:when>
                                                    <xsl:when test="contains(attribute::emph, 'wlilm') and not(contains(attribute::emph, 'wlilm_'))">background-color: #BEBEBE;</xsl:when>
                                                    <xsl:when test="contains(attribute::emph, 'wlilm_c')">background-color: #BEBEBE;</xsl:when>
                                                    <xsl:when test="contains(attribute::emph, 'wlilm_h' and not($handwriting='off'))">background-color: #BEBEBE;</xsl:when>
                                                    <xsl:when test="contains(attribute::emph, 'wlirm') and not(contains(attribute::emph, 'wlirm_'))">background-color: #BEBEBE;</xsl:when>
                                                    <xsl:when test="contains(attribute::emph, 'wlirm_c')">background-color: #BEBEBE;</xsl:when>
                                                    <xsl:when test="contains(attribute::emph, 'wlirm_h' and not($handwriting='off'))">background-color: #BEBEBE;</xsl:when>
                                                    <xsl:when test="contains(attribute::emph, 'zigzagrm') and not(contains(attribute::emph, 'zigzagrm_'))">background-color: #BEBEBE;</xsl:when>
                                                    <xsl:when test="contains(attribute::emph, 'zigzagrm_h') and not($handwriting='off')">background-color: #BEBEBE;</xsl:when>
                                                    <xsl:when test="contains(attribute::seg, 'preface') and not($handwriting='off') and $seg-pre='mark'">text-color: #00FFFF;</xsl:when>
                                                    <xsl:otherwise></xsl:otherwise>
                                                </xsl:choose>
                                                <!-- Text color on main cell -->
                                                <xsl:choose>
                                                    <xsl:when test="contains(attribute::add, 'H') and not($handwriting='off') and not($visning='norm')">text-color: #33FFFF;</xsl:when>
                                                    <xsl:when test="contains(attribute::add, 'ip_h') and not($handwriting='off') and not($visning='norm')">text-color: #33FFFF;</xsl:when>
                                                    <xsl:when test="contains(attribute::add, 'ipp_h') and not($handwriting='off') and not($visning='norm')">text-color: #33FFFF;</xsl:when>
                                                    <xsl:otherwise></xsl:otherwise>
                                                </xsl:choose>
                                                <!-- Border around main cell -->
                                                <xsl:choose>
                                                    <xsl:when test="contains(attribute::emph, 'ringed') and not(contains(attribute::emph, 'ringed_'))">border: 2px solid purple;</xsl:when>
                                                    <xsl:when test="contains(attribute::emph, 'ringed_h') and not($handwriting='off')">border: 2px solid purple;</xsl:when>
                                                    <xsl:otherwise></xsl:otherwise>
                                                </xsl:choose>
                                                <!-- Block display on/off -->
                                                <xsl:choose>
                                                    <xsl:when test="contains(attribute::emph, 'ringed') and not(contains(attribute::emph, 'ringed_'))">display: inline-block;</xsl:when>
                                                    <xsl:when test="contains(attribute::emph, 'ringed_h') and not($handwriting='off')">display: inline-block;</xsl:when>
                                                    <xsl:when test="contains(attribute::emph, 'zigzagrm_h')">display: block;</xsl:when>
                                                    <xsl:otherwise></xsl:otherwise>
                                                </xsl:choose>
                                            </xsl:attribute>
                                            <xsl:attribute name="valign">top</xsl:attribute>
                                            <xsl:choose>
                                                <xsl:when test="$prosjekt = 'discovery'">
                                                    <xsl:attribute name="width">650px</xsl:attribute>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <xsl:attribute name="width">700px</xsl:attribute>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                            <xsl:choose>
                                                <xsl:when test="$visning='norm'">
                                                    <xsl:element name="DIV">
                                                        <xsl:attribute name="style">
                                                            <xsl:text>margin-bottom: 10px;</xsl:text>
                                                            <xsl:choose>
                                                                <xsl:when test="$prosjekt = 'discovery'">
                                                                    <xsl:text>width: 650px;</xsl:text>
                                                                </xsl:when>
                                                                <xsl:otherwise>
                                                                    <xsl:text>width: 700px;</xsl:text>
                                                                </xsl:otherwise>
                                                            </xsl:choose>
                                                            <!-- Text color -->
                                                            <xsl:choose>
                                                                <xsl:when test="contains(attribute::add, 'el_h') and not($handwriting='off') and $el='dipl'">
                                                                    <xsl:text>color: #0000FF;</xsl:text>
                                                                </xsl:when>
                                                                <xsl:when test="contains(attribute::add, 'ip_h') and not($handwriting='off') and $im='dipl'">
                                                                    <xsl:text>color: #33FFFF;</xsl:text>
                                                                </xsl:when>
                                                                <xsl:when test="contains(attribute::add, 'ipp_h') and not($handwriting='off') and $im='dipl'">
                                                                    <xsl:text>color: #33FFFF; </xsl:text>
                                                                </xsl:when>
                                                                <xsl:when test="contains(attribute::add, 'ipp_H5') and not($handwriting='off') and $im='dipl'">
                                                                    <xsl:text>color: #33FFFF; </xsl:text>
                                                                </xsl:when>
                                                                <xsl:otherwise></xsl:otherwise>
                                                            </xsl:choose>
                                                            <!-- Text decoration -->
                                                            <xsl:choose>
                                                                <xsl:when test="moo"></xsl:when>
                                                                <xsl:otherwise></xsl:otherwise>
                                                            </xsl:choose>
                                                            <!-- Font size -->
                                                            <xsl:choose>
                                                                <xsl:when test="moo"></xsl:when>
                                                                <xsl:otherwise></xsl:otherwise>
                                                            </xsl:choose>
                                                            <!-- Border -->
                                                            <xsl:choose>
                                                                <xsl:when test="moo"></xsl:when>
                                                                <xsl:otherwise></xsl:otherwise>
                                                            </xsl:choose>
                                                            <!-- Width -->
                                                            <xsl:choose>
                                                                <xsl:when test="contains(attribute::emph, 'ringed') and not(contains(attribute::emph, 'ringed_'))">width: 100%; </xsl:when>
                                                                <xsl:when test="contains(attribute::emph, 'ringed_h') and not($handwriting='off')">width: 100%; </xsl:when>
                                                                <xsl:otherwise></xsl:otherwise>
                                                            </xsl:choose>
                                                            <!-- Text Alignment -->
                                                            <xsl:choose>
                                                                <xsl:when test="contains(attribute::emph, 'centered')">
                                                                    <xsl:text>text-align: center; </xsl:text>
                                                                </xsl:when>
                                                                <xsl:otherwise></xsl:otherwise>
                                                            </xsl:choose>
                                                        </xsl:attribute>
                                                        <xsl:if test="not(contains(attribute::rend, 'conline'))">
                                                            <xsl:element name="BR"/>
                                                        </xsl:if>
                                                        <!-- Markings in front of text block -->
                                                        <xsl:choose>
                                                            <xsl:when test="contains(attribute::add, 'el_h') and not($handwriting='off') and $el='dipl'">
                                                                <xsl:element name="SPAN">
                                                                    <xsl:attribute name="style">color: #008000;</xsl:attribute>
                                                                    <xsl:text>&lt;</xsl:text>
                                                                </xsl:element>
                                                            </xsl:when>
                                                            <xsl:when test="contains(attribute::emph, 'arrback') and not(contains(attribute::emph, 'arrback_h'))">
                                                                <xsl:element name="SPAN">
                                                                    <xsl:attribute name="style">font-family: Arial Unicode MS;</xsl:attribute>
                                                                    <xsl:text>&#x21BA;</xsl:text>
                                                                </xsl:element>
                                                            </xsl:when>
                                                            <xsl:when test="contains(attribute::emph, 'arrback_h') and not($handwriting='off')">
                                                                <xsl:element name="SPAN">
                                                                    <xsl:attribute name="style">font-family: Arial Unicode MS;</xsl:attribute>
                                                                    <xsl:text>&#x21BA;</xsl:text>
                                                                </xsl:element>
                                                            </xsl:when>
                                                            <xsl:when test="contains(attribute::emph, 'arrforward') and not(contains(attribute::emph, 'arrforward_h'))">
                                                                <xsl:element name="SPAN">
                                                                    <xsl:attribute name="style">font-family: Arial Unicode MS;</xsl:attribute>
                                                                    <xsl:text>&#x21BB;</xsl:text>
                                                                </xsl:element>
                                                            </xsl:when><xsl:when test="contains(attribute::emph, 'arrforward_h') and not($handwriting='off')">
                                                                <xsl:element name="SPAN">
                                                                    <xsl:attribute name="style">font-family: Arial Unicode MS;</xsl:attribute>
                                                                    <xsl:text>&#x21BB;</xsl:text>
                                                                </xsl:element>
                                                            </xsl:when>
                                                            <xsl:otherwise></xsl:otherwise>
                                                        </xsl:choose>
                                                        <!-- Overriding text color for deletions -->
                                                        <xsl:element name="SPAN">
                                                            <xsl:attribute name="style">
                                                                <xsl:choose>
                                                                    <xsl:when test="contains(attribute::del, type_d_h) and contains($d, 'dipl')"><xsl:text>color: #000000;</xsl:text></xsl:when>
                                                                    <xsl:when test="contains(attribute::del, type_dnpc_h) and contains($dnpc, 'dipl')"><xsl:text>color: #000000;</xsl:text></xsl:when>
                                                                    <xsl:otherwise></xsl:otherwise>
                                                                </xsl:choose>
                                                            </xsl:attribute>
                                                            <xsl:choose>
                                                                <xsl:when test="ancestor::tei:reloc and not(ancestor::tei:ab) and attribute::xml:id">
                                                                    <xsl:variable name="p-num">
                                                                        <xsl:number count="tei:ab" from="tei:reloc"/>
                                                                    </xsl:variable>
                                                                    !!<xsl:value-of select="$p-num"/>!!
                                                                </xsl:when>
                                                                <xsl:otherwise></xsl:otherwise>
                                                            </xsl:choose>
                                                            <xsl:choose>
                                                                <xsl:when test="contains(attribute::add, '_h') and $handwriting='off'"></xsl:when>
                                                                <xsl:when test="contains(attribute::add, 'H') and $handwriting='off'"></xsl:when>
                                                                <xsl:otherwise>
                                                                    <xsl:choose>
                                                                        <xsl:when test="descendant::tei:seg[contains(attribute::type, 'series-number')]">
                                                                            <xsl:element name="DIV">
                                                                                <xsl:attribute name="class">series-number-indent</xsl:attribute>
                                                                                <xsl:attribute name="style">margin-left: 25px;</xsl:attribute>
                                                                                <xsl:apply-templates/>
                                                                            </xsl:element>
                                                                        </xsl:when>
                                                                        <xsl:otherwise>
                                                                            <xsl:apply-templates/>
                                                                        </xsl:otherwise>
                                                                    </xsl:choose>
                                                                </xsl:otherwise>
                                                            </xsl:choose>
                                                            <!--<xsl:choose>
                                                                <xsl:when test="contains(attribute::add, 'H') and $handwriting='off'"><xsl:text>!!###!!</xsl:text></xsl:when>
                                                                <xsl:when test="contains(attribute::add, '_h') and $handwriting='off'"><xsl:text>!!###!!</xsl:text></xsl:when>
                                                                <xsl:when test="contains(attribute::del, type_d_h)">
                                                                    <xsl:choose>
                                                                        <xsl:when test="contains($d, 'dipl')">
                                                                            <xsl:element name="SPAN">
                                                                                <xsl:attribute name="style">color: #000000;</xsl:attribute>
                                                                                <xsl:apply-templates/>
                                                                            </xsl:element>
                                                                        </xsl:when>
                                                                        <xsl:when test="contains($d, 'study')">
                                                                            <xsl:apply-templates/>
                                                                        </xsl:when>
                                                                        <xsl:otherwise>
                                                                            
                                                                        </xsl:otherwise>
                                                                    </xsl:choose>
                                                                </xsl:when>
                                                                <xsl:when test="contains(attribute::del, type_dnpc_h)">
                                                                    <xsl:choose>
                                                                        <xsl:when test="contains($dnpc, 'dipl')">
                                                                            <xsl:element name="SPAN">
                                                                                <xsl:attribute name="style">color: #000000;</xsl:attribute>
                                                                                <xsl:apply-templates/>
                                                                            </xsl:element>
                                                                        </xsl:when>
                                                                        <xsl:when test="contains($dnpc, 'study')"></xsl:when>
                                                                        <xsl:otherwise></xsl:otherwise>
                                                                    </xsl:choose>
                                                                </xsl:when>
                                                                <xsl:otherwise>
                                                                    <xsl:apply-templates/>
                                                                </xsl:otherwise>
                                                            </xsl:choose>-->
                                                        </xsl:element>
                                                        <!-- Markings at the back of text block -->
                                                        <xsl:choose>
                                                            <xsl:when test="contains(attribute::emph, 'wlilm_c') and not($handwriting='off')">
                                                                <xsl:element name="SPAN">
                                                                    <xsl:attribute name="style">color: #FF0000;</xsl:attribute>
                                                                    <xsl:element name="SUP">
                                                                        <xsl:text>[c]</xsl:text>
                                                                    </xsl:element>
                                                                </xsl:element>
                                                            </xsl:when>
                                                            <xsl:when test="contains(attribute::emph, 'wlirm_c') and not($handwriting='off')">
                                                                <xsl:element name="SPAN">
                                                                    <xsl:attribute name="style">color: #FF0000;</xsl:attribute>
                                                                    <xsl:element name="SUP">
                                                                        <xsl:text>[c]</xsl:text>
                                                                    </xsl:element>
                                                                </xsl:element>
                                                            </xsl:when>
                                                            <xsl:otherwise></xsl:otherwise>
                                                        </xsl:choose>
                                                        <xsl:if test="contains(attribute::rend, 'sepline')">
                                                            <xsl:element name="HR">
                                                                <xsl:attribute name="width">150px</xsl:attribute>
                                                                <xsl:attribute name="align">left</xsl:attribute>
                                                            </xsl:element>
                                                        </xsl:if>
                                                        <xsl:element name="BR"/>
                                                    </xsl:element>
                                                </xsl:when>
                                                <xsl:when test="$visning='study'">
                                                    <xsl:element name="DIV">
                                                        <xsl:attribute name="style">
                                                            <xsl:text>margin-bottom: 10px;</xsl:text>
                                                            <xsl:choose>
                                                                <xsl:when test="$prosjekt = 'discovery'">
                                                                    <xsl:text>width: 650px;</xsl:text>
                                                                </xsl:when>
                                                                <xsl:otherwise>
                                                                    <xsl:text>width: 700px;</xsl:text>
                                                                </xsl:otherwise>
                                                            </xsl:choose>
                                                            <xsl:choose>
                                                                <xsl:when test="contains(attribute::del, 'del_d_h')">
                                                                    <xsl:choose>
                                                                        <xsl:when test="contains($d, 'dipl')">
                                                                            <xsl:text>text-decoration: line-through; color: #0000FF;</xsl:text>
                                                                        </xsl:when>
                                                                        <xsl:when test="contains($d, 'norm')"></xsl:when>
                                                                        <xsl:otherwise>
                                                                            <xsl:attribute name="style">text-decoration: line-through; color: #0000FF;</xsl:attribute>
                                                                        </xsl:otherwise>
                                                                    </xsl:choose>
                                                                </xsl:when>
                                                                <xsl:when test="contains(attribute::del, 'del_dnpc_h')">
                                                                    <xsl:choose>
                                                                        <xsl:when test="contains($dnpc, 'dipl')">
                                                                            <xsl:attribute name="style">color: #0000FF; text-decoration: line-through;</xsl:attribute>
                                                                        </xsl:when>
                                                                        <xsl:when test="contains($dnpc, 'norm')"></xsl:when>
                                                                        <xsl:otherwise></xsl:otherwise>
                                                                    </xsl:choose>
                                                                </xsl:when>
                                                                <xsl:otherwise></xsl:otherwise>
                                                            </xsl:choose>
                                                        </xsl:attribute>
                                                        <xsl:element name="BR"/>
                                                        <xsl:choose>
                                                            <xsl:when test="attribute::xml:id">
                                                                <xsl:element name="SPAN">
                                                                    <!--<xsl:attribute name="onMouseover">
                                                                        <xsl:text>ddrivetip('</xsl:text>
                                                                        <xsl:if test="document('../cost-a32_komm/cost-vw139a_komm.xml')/descendant-or-self::tei:list[attribute::xml:id=$paragraphid]">
                                                                            <xsl:if test="document('../cost-a32_komm/cost-vw139a_komm.xml')/descendant-or-self::tei:list[attribute::xml:id=$paragraphid]/child::tei:item[attribute::type='A2']">
                                                                                <xsl:text> A2: </xsl:text>
                                                                                <xsl:value-of select="document('../cost-a32_komm/cost-vw139a_komm.xml')/descendant-or-self::tei:list[attribute::xml:id=$paragraphid]/child::tei:item[attribute::type='A2']"/>
                                                                                <xsl:text>&lt;BR&gt;</xsl:text>
                                                                            </xsl:if>
                                                                        </xsl:if>
                                                                        <xsl:text>\n</xsl:text>
                                                                        <xsl:text>','gray')</xsl:text>
                                                                    </xsl:attribute>-->
                                                                    <!--<xsl:attribute name="onMouseout">hideddrivetip()</xsl:attribute>-->
                                                                    <xsl:choose>
                                                                        <xsl:when test="contains(attribute::del, type_d_h)">
                                                                            <xsl:choose>
                                                                                <xsl:when test="contains($d, 'dipl')"><xsl:attribute name="style">color: #000000;</xsl:attribute></xsl:when>
                                                                                <xsl:when test="contains($d, 'norm')"></xsl:when>
                                                                                <xsl:otherwise></xsl:otherwise>
                                                                            </xsl:choose>
                                                                        </xsl:when>
                                                                        <xsl:when test="contains(attribute::del, type_dnpc_h)">
                                                                            <xsl:choose>
                                                                                <xsl:when test="contains($dnpc, 'dipl')"><xsl:attribute name="style">color: #000000;</xsl:attribute></xsl:when>
                                                                                <xsl:when test="contains($dnpc, 'norm')"></xsl:when>
                                                                                <xsl:otherwise></xsl:otherwise>
                                                                            </xsl:choose>
                                                                        </xsl:when>
                                                                        <xsl:otherwise></xsl:otherwise>
                                                                    </xsl:choose>
                                                                    <xsl:choose>
                                                                        <xsl:when test="descendant::tei:seg[contains(attribute::type, 'series-number')]">
                                                                            <xsl:element name="DIV">
                                                                                <xsl:attribute name="class">series-number-indent</xsl:attribute>
                                                                                <xsl:attribute name="style">margin-left: 25px;</xsl:attribute>
                                                                                <xsl:apply-templates/>
                                                                            </xsl:element>
                                                                        </xsl:when>
                                                                        <xsl:otherwise>
                                                                            <xsl:apply-templates/>
                                                                        </xsl:otherwise>
                                                                    </xsl:choose>
                                                                    <xsl:if test="contains(attribute::rend, 'sepline')">
                                                                        <xsl:element name="HR">
                                                                            <xsl:attribute name="width">150px</xsl:attribute>
                                                                            <xsl:attribute name="align">left</xsl:attribute>
                                                                        </xsl:element>
                                                                    </xsl:if>
                                                                </xsl:element>
                                                            </xsl:when>
                                                            <xsl:otherwise>
                                                                <xsl:choose>
                                                                    <xsl:when test="ancestor::tei:reloc and not(ancestor::tei:ab)">
                                                                        <xsl:variable name="p-num">
                                                                            <xsl:number count="tei:ab" from="tei:reloc"/>
                                                                        </xsl:variable>
                                                                        <xsl:choose>
                                                                            <xsl:when test="$visning='norm' or $visning='study'">
                                                                                <xsl:variable name="reloc1">
                                                                                    <xsl:value-of select="ancestor::tei:reloc/attribute::n"/>
                                                                                </xsl:variable>
                                                                                <xsl:element name="SPAN">
                                                                                    <xsl:attribute name="style">bacground-color: #CC77FF;</xsl:attribute>
                                                                                    <xsl:choose>
                                                                                        <xsl:when test="contains(attribute::del, type_d_h)">
                                                                                            <xsl:choose>
                                                                                                <xsl:when test="contains($d, 'dipl')"><xsl:attribute name="style">color: #000000;</xsl:attribute></xsl:when>
                                                                                                <xsl:when test="contains($d, 'norm')"></xsl:when>
                                                                                                <xsl:otherwise></xsl:otherwise>
                                                                                            </xsl:choose>
                                                                                        </xsl:when>
                                                                                        <xsl:when test="contains(attribute::del, type_dnpc_h)">
                                                                                            <xsl:choose>
                                                                                                <xsl:when test="contains($dnpc, 'dipl')"><xsl:attribute name="style">color: #000000;</xsl:attribute></xsl:when>
                                                                                                <xsl:when test="contains($dnpc, 'norm')"></xsl:when>
                                                                                                <xsl:otherwise>
                                                                                                    
                                                                                                </xsl:otherwise>
                                                                                            </xsl:choose>
                                                                                        </xsl:when>
                                                                                        <xsl:otherwise></xsl:otherwise>
                                                                                    </xsl:choose>
                                                                                    <xsl:choose>
                                                                                        <xsl:when test="descendant::tei:seg[contains(attribute::type, 'series-number')]">
                                                                                            <xsl:element name="DIV">
                                                                                                <xsl:attribute name="class">series-number-indent</xsl:attribute>
                                                                                                <xsl:attribute name="style">margin-left: 25px;</xsl:attribute>
                                                                                                <xsl:apply-templates/>
                                                                                            </xsl:element>
                                                                                        </xsl:when>
                                                                                        <xsl:otherwise>
                                                                                            <xsl:apply-templates/>
                                                                                        </xsl:otherwise>
                                                                                    </xsl:choose>
                                                                                </xsl:element>
                                                                            </xsl:when>
                                                                            <xsl:otherwise>
                                                                                
                                                                            </xsl:otherwise>
                                                                        </xsl:choose>
                                                                    </xsl:when>
                                                                    <xsl:otherwise></xsl:otherwise>
                                                                </xsl:choose>
                                                                <xsl:choose>
                                                                    <xsl:when test="attribute::n">
                                                                        <xsl:element name="SPAN">
                                                                            <!--<xsl:attribute name="onMouseover"><xsl:text>ddrivetip('</xsl:text>
                                                                                <xsl:value-of select="attribute::n"/>
                                                                                <xsl:text>','gray')</xsl:text></xsl:attribute>-->
                                                                                <!--<xsl:attribute name="onMouseout">hideddrivetip()</xsl:attribute>-->
                                                                            <xsl:choose>
                                                                                <xsl:when test="contains(attribute::del, type_d_h)">
                                                                                    <xsl:choose>
                                                                                        <xsl:when test="contains($d, 'dipl')"><xsl:attribute name="style">color: #000000;</xsl:attribute></xsl:when>
                                                                                        <xsl:when test="contains($d, 'norm')"></xsl:when>
                                                                                        <xsl:otherwise></xsl:otherwise>
                                                                                    </xsl:choose>
                                                                                </xsl:when>
                                                                                <xsl:when test="contains(attribute::del, type_dnpc_h)">
                                                                                    <xsl:choose>
                                                                                        <xsl:when test="contains($dnpc, 'dipl')"><xsl:attribute name="style">color: #000000;</xsl:attribute></xsl:when>
                                                                                        <xsl:when test="contains($dnpc, 'norm')"></xsl:when>
                                                                                        <xsl:otherwise></xsl:otherwise>
                                                                                    </xsl:choose>
                                                                                </xsl:when>
                                                                                <xsl:otherwise></xsl:otherwise>
                                                                            </xsl:choose>
                                                                            <xsl:choose>
                                                                                <xsl:when test="descendant::tei:seg[contains(attribute::type, 'series-number')]">
                                                                                    <xsl:element name="DIV">
                                                                                        <xsl:attribute name="class">series-number-indent</xsl:attribute>
                                                                                        <xsl:attribute name="style">margin-left: 25px;</xsl:attribute>
                                                                                        <xsl:apply-templates/>
                                                                                    </xsl:element>
                                                                                </xsl:when>
                                                                                <xsl:otherwise>
                                                                                    <xsl:apply-templates/>
                                                                                </xsl:otherwise>
                                                                            </xsl:choose>
                                                                        </xsl:element>
                                                                    </xsl:when>
                                                                    <xsl:otherwise>
                                                                        <xsl:choose>
                                                                            <xsl:when test="contains(attribute::del, type_d_h)">
                                                                                <xsl:choose>
                                                                                    <xsl:when test="contains($d, 'dipl')">
                                                                                        <xsl:element name="SPAN">
                                                                                            <xsl:attribute name="style">color: #000000;</xsl:attribute>
                                                                                            <xsl:choose>
                                                                                                <xsl:when test="descendant::tei:seg[contains(attribute::type, 'series-number')]">
                                                                                                    <xsl:element name="DIV">
                                                                                                        <xsl:attribute name="class">series-number-indent</xsl:attribute>
                                                                                                        <xsl:attribute name="style">margin-left: 25px;</xsl:attribute>
                                                                                                        <xsl:apply-templates/>
                                                                                                    </xsl:element>
                                                                                                </xsl:when>
                                                                                                <xsl:otherwise>
                                                                                                    <xsl:apply-templates/>
                                                                                                </xsl:otherwise>
                                                                                            </xsl:choose>
                                                                                        </xsl:element>
                                                                                    </xsl:when>
                                                                                    <xsl:when test="contains($d, 'norm')">
                                                                                        <xsl:choose>
                                                                                            <xsl:when test="descendant::tei:seg[contains(attribute::type, 'series-number')]">
                                                                                                <xsl:element name="DIV">
                                                                                                    <xsl:attribute name="class">series-number-indent</xsl:attribute>
                                                                                                    <xsl:attribute name="style">margin-left: 25px;</xsl:attribute>
                                                                                                    <xsl:apply-templates/>
                                                                                                </xsl:element>
                                                                                            </xsl:when>
                                                                                            <xsl:otherwise>
                                                                                                <xsl:apply-templates/>
                                                                                            </xsl:otherwise>
                                                                                        </xsl:choose>
                                                                                    </xsl:when>
                                                                                    <xsl:otherwise>
                                                                                        <xsl:choose>
                                                                                            <xsl:when test="descendant::tei:seg[contains(attribute::type, 'series-number')]">
                                                                                                <xsl:element name="DIV">
                                                                                                    <xsl:attribute name="class">series-number-indent</xsl:attribute>
                                                                                                    <xsl:attribute name="style">margin-left: 25px;</xsl:attribute>
                                                                                                    <xsl:apply-templates/>
                                                                                                </xsl:element>
                                                                                            </xsl:when>
                                                                                            <xsl:otherwise>
                                                                                                <xsl:apply-templates/>
                                                                                            </xsl:otherwise>
                                                                                        </xsl:choose>
                                                                                    </xsl:otherwise>
                                                                                </xsl:choose>
                                                                            </xsl:when>
                                                                            <xsl:when test="contains(attribute::del, type_dnpc_h)">
                                                                                <xsl:choose>
                                                                                    <xsl:when test="contains($dnpc, 'dipl')">
                                                                                        <xsl:element name="SPAN">
                                                                                            <xsl:attribute name="style">color: #000000;</xsl:attribute>
                                                                                            <xsl:choose>
                                                                                                <xsl:when test="descendant::tei:seg[contains(attribute::type, 'series-number')]">
                                                                                                    <xsl:element name="DIV">
                                                                                                        <xsl:attribute name="class">series-number-indent</xsl:attribute>
                                                                                                        <xsl:attribute name="style">margin-left: 25px;</xsl:attribute>
                                                                                                        <xsl:apply-templates/>
                                                                                                    </xsl:element>
                                                                                                </xsl:when>
                                                                                                <xsl:otherwise>
                                                                                                    <xsl:apply-templates/>
                                                                                                </xsl:otherwise>
                                                                                            </xsl:choose>
                                                                                        </xsl:element>
                                                                                    </xsl:when>
                                                                                    <xsl:when test="contains($dnpc, 'norm')">
                                                                                        
                                                                                    </xsl:when>
                                                                                    <xsl:otherwise>

                                                                                    </xsl:otherwise>
                                                                                </xsl:choose>
                                                                            </xsl:when>
                                                                            <xsl:otherwise>
                                                                                <xsl:choose>
                                                                                    <xsl:when test="descendant::tei:seg[contains(attribute::type, 'series-number')]">
                                                                                        <xsl:element name="DIV">
                                                                                            <xsl:attribute name="class">series-number-indent</xsl:attribute>
                                                                                            <xsl:attribute name="style">margin-left: 25px;</xsl:attribute>
                                                                                            <xsl:apply-templates/>
                                                                                        </xsl:element>
                                                                                    </xsl:when>
                                                                                    <xsl:otherwise>
                                                                                        <xsl:apply-templates/>
                                                                                    </xsl:otherwise>
                                                                                </xsl:choose>
                                                                            </xsl:otherwise>
                                                                        </xsl:choose>
                                                                    </xsl:otherwise>
                                                                </xsl:choose>
                                                                <xsl:if test="contains(attribute::rend, 'sepline')">
                                                                    <xsl:element name="HR">
                                                                        <xsl:attribute name="width">150px</xsl:attribute>
                                                                        <xsl:attribute name="align">left</xsl:attribute>
                                                                    </xsl:element>
                                                                </xsl:if>
                                                            </xsl:otherwise>
                                                        </xsl:choose>
                                                    </xsl:element>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <xsl:element name="DIV">
                                                        <xsl:attribute name="class">ab-style</xsl:attribute>
                                                        <xsl:attribute name="style">
                                                            <!-- Text color -->
                                                            <xsl:choose>
                                                                <xsl:when test="contains(attribute::add, 'el_h') and not($handwriting='off') and not($el='norm') and not($el='study')">
                                                                    <xsl:text>color: #0000FF;</xsl:text>
                                                                </xsl:when>
                                                                <xsl:when test="contains(attribute::add, 'H') and not($handwriting='off')">
                                                                    <xsl:text>color: #33FFFF;</xsl:text>
                                                                </xsl:when>
                                                                <xsl:when test="contains(attribute::add, 'ip_h') and not($handwriting='off')">
                                                                    <xsl:text>color: #33FFFF;</xsl:text>
                                                                </xsl:when>
                                                                <xsl:when test="contains(attribute::add, 'ipp_h') and not($handwriting='off')">
                                                                    <xsl:text>color: #33FFFF;</xsl:text>
                                                                </xsl:when>
                                                                <xsl:when test="contains(attribute::add, 'ipp_H5') and not($handwriting='off')">
                                                                    <xsl:text>color: #33FFFF;</xsl:text>
                                                                </xsl:when>
                                                                <xsl:when test="contains(attribute::del, 'del_d_h')">
                                                                    <xsl:choose>
                                                                        <xsl:when test="contains($d, 'study')">
                                                                            <xsl:text>color: #0000FF;</xsl:text>
                                                                        </xsl:when>
                                                                        <xsl:when test="contains($d, 'norm')"></xsl:when>
                                                                        <xsl:otherwise>
                                                                            <xsl:text>color: #0000FF;</xsl:text>
                                                                        </xsl:otherwise>
                                                                    </xsl:choose>
                                                                </xsl:when>
                                                                <xsl:when test="contains(attribute::del, 'del_dnpc_h')">
                                                                    <xsl:choose>
                                                                        <xsl:when test="contains($dnpc, 'study')"></xsl:when>
                                                                        <xsl:when test="contains($dnpc, 'norm')"></xsl:when>
                                                                        <xsl:otherwise>
                                                                            <xsl:text>color: #0000FF;</xsl:text>
                                                                        </xsl:otherwise>
                                                                    </xsl:choose>
                                                                </xsl:when>
                                                                <xsl:otherwise></xsl:otherwise>
                                                            </xsl:choose>
                                                            <!-- Text decoration -->
                                                            <xsl:choose>
                                                                <xsl:when test="contains(attribute::del, 'del_dnpc_h')">
                                                                    <xsl:choose>
                                                                        <xsl:when test="contains($dnpc, 'study')"></xsl:when>
                                                                        <xsl:when test="contains($dnpc, 'norm')"></xsl:when>
                                                                        <xsl:otherwise>
                                                                            <xsl:text>text-decoration: line-through;</xsl:text>
                                                                        </xsl:otherwise>
                                                                    </xsl:choose>
                                                                </xsl:when>
                                                                <xsl:when test="contains(attribute::del, 'del_d_h')">
                                                                    <xsl:choose>
                                                                        <xsl:when test="contains($d, 'study')">
                                                                            <xsl:text>text-decoration: line-through;</xsl:text>
                                                                        </xsl:when>
                                                                        <xsl:when test="contains($d, 'norm')"></xsl:when>
                                                                        <xsl:otherwise>
                                                                            <xsl:text>text-decoration: line-through;</xsl:text>
                                                                        </xsl:otherwise>
                                                                    </xsl:choose>
                                                                </xsl:when>
                                                                <xsl:when test="contains(attribute::del, 'del_d')">
                                                                    <xsl:choose>
                                                                        <xsl:when test="contains($d, 'study')">
                                                                            <xsl:text>text-decoration: line-through;</xsl:text>
                                                                        </xsl:when>
                                                                        <xsl:when test="contains($d, 'norm')"></xsl:when>
                                                                        <xsl:otherwise>
                                                                            <xsl:text>text-decoration: line-through;</xsl:text>
                                                                        </xsl:otherwise>
                                                                    </xsl:choose>
                                                                </xsl:when>
                                                                <xsl:otherwise></xsl:otherwise>
                                                            </xsl:choose>
                                                            <!-- Font size -->
                                                            <xsl:choose>
                                                                <xsl:when test="contains(attribute::add, 'ipp_H5') and not($handwriting='off')">
                                                                    <xsl:text>font-size: 12pt; </xsl:text>
                                                                </xsl:when>
                                                                <xsl:otherwise></xsl:otherwise>
                                                            </xsl:choose>
                                                            <!-- Border -->
                                                            <xsl:choose>
                                                                <xsl:when test="contains(attribute::emph, 'ringed')">
                                                                    <xsl:text>border: 2px solid purple; </xsl:text>
                                                                </xsl:when>
                                                                <xsl:when test="contains(attribute::emph, 'ringed_h') and not($handwriting='off')">
                                                                    <xsl:text>border: 2px solid purple; </xsl:text>
                                                                </xsl:when>
                                                                <xsl:otherwise></xsl:otherwise>
                                                            </xsl:choose>
                                                            <!-- Width -->
                                                            <xsl:choose>
                                                                <xsl:when test="contains(attribute::emph, 'ringed') and not(contains(attribute::emph, 'ringed_'))">width: 100%; </xsl:when>
                                                                <xsl:when test="contains(attribute::emph, 'ringed_h') and not($handwriting='off')">width: 100%; </xsl:when>
                                                                <xsl:otherwise></xsl:otherwise>
                                                            </xsl:choose>
                                                            <!-- Text Alignment -->
                                                            <xsl:choose>
                                                                <xsl:when test="contains(attribute::emph, 'centered')">
                                                                    <xsl:text>text-align: center; </xsl:text>
                                                                </xsl:when>
                                                                <xsl:otherwise></xsl:otherwise>
                                                            </xsl:choose>
                                                        </xsl:attribute>
                                                        <xsl:if test="contains(attribute::rend, 'blbef') and contains(attribute::rend, 'blaft')">
                                                            <xsl:variable name="first">
                                                                <xsl:value-of select="substring-before(attribute::rend, ' ')"/>
                                                            </xsl:variable>
                                                            <xsl:call-template name="blanks">
                                                                <xsl:with-param name="i" select="1"/>
                                                                <xsl:with-param name="max" select="substring-after($first, '_')"/>
                                                            </xsl:call-template>
                                                        </xsl:if>
                                                        <xsl:if test="contains(attribute::rend, 'blbef') and not(contains(attribute::rend, 'blaft'))">
                                                            <xsl:call-template name="blanks">
                                                                <xsl:with-param name="i" select="1"/>
                                                                <xsl:with-param name="max" select="substring-after(attribute::rend, '_')"/>
                                                            </xsl:call-template>
                                                        </xsl:if>
                                                        <!-- Markings in front of text block -->
                                                        <xsl:choose>
                                                            <xsl:when test="contains(attribute::add, 'el_h') and not($handwriting='off') and not($el='norm') and not($el='study')">
                                                                <xsl:element name="SPAN">
                                                                    <xsl:attribute name="style">color: #008000;</xsl:attribute>
                                                                    <xsl:text>&lt;</xsl:text>
                                                                </xsl:element>
                                                            </xsl:when>
                                                            <xsl:when test="contains(attribute::add, 'ilm') and not($handwriting='off')">
                                                                <xsl:element name="SPAN">
                                                                    <xsl:attribute name="style">color: #FF00FF;</xsl:attribute>
                                                                    <xsl:text>&lt;</xsl:text>
                                                                </xsl:element>
                                                            </xsl:when>
                                                            <xsl:when test="contains(attribute::add, 'ilom') and not($handwriting='off')">
                                                                <xsl:element name="SPAN">
                                                                    <xsl:attribute name="style">color: #FF00FF;</xsl:attribute>
                                                                    <xsl:text>&lt;</xsl:text>
                                                                </xsl:element>
                                                            </xsl:when>
                                                            <xsl:when test="contains(attribute::add, 'iupm_h') and not($handwriting='off')">
                                                                <xsl:element name="SPAN">
                                                                    <xsl:attribute name="style">color: #FF00FF;</xsl:attribute>
                                                                    <xsl:text>&lt;</xsl:text>
                                                                </xsl:element>
                                                            </xsl:when>
                                                            <xsl:when test="contains(attribute::corr, 'npc') and not($handwriting='off')">
                                                                <xsl:choose>
                                                                    <xsl:when test="contains($npc, 'study')">
                                                                        <xsl:element name="SPAN">
                                                                            <xsl:attribute name="style">color: #FF0000;</xsl:attribute>
                                                                            <xsl:text>&#x2026;</xsl:text>
                                                                        </xsl:element>
                                                                    </xsl:when>
                                                                    <xsl:when test="contains($npc, 'norm')">
                                                                        <xsl:element name="SPAN">
                                                                            <xsl:attribute name="style">color: #FF0000;</xsl:attribute>
                                                                            <xsl:text>&#x2026;</xsl:text>
                                                                        </xsl:element>
                                                                    </xsl:when>
                                                                    <xsl:otherwise>
                                                                        <xsl:apply-templates/>
                                                                    </xsl:otherwise>
                                                                </xsl:choose>
                                                            </xsl:when>
                                                            <xsl:when test="contains(attribute::emph, 'arrback') and not(contains(attribute::emph, 'arrback_h'))">
                                                                <xsl:element name="SPAN">
                                                                    <xsl:attribute name="style">font-family: Arial Unicode MS;</xsl:attribute>
                                                                    <xsl:text>&#x21BA;</xsl:text>
                                                                </xsl:element>
                                                            </xsl:when>
                                                            <xsl:when test="contains(attribute::emph, 'arrback_h') and not($handwriting='off')">
                                                                <xsl:element name="SPAN">
                                                                    <xsl:attribute name="style">font-family: Arial Unicode MS;</xsl:attribute>
                                                                    <xsl:text>&#x21BA;</xsl:text>
                                                                </xsl:element>
                                                            </xsl:when>
                                                            <xsl:when test="contains(attribute::emph, 'arrforward') and not(contains(attribute::emph, 'arrforward_h'))">
                                                                <xsl:element name="SPAN">
                                                                    <xsl:attribute name="style">font-family: Arial Unicode MS;</xsl:attribute>
                                                                    <xsl:text>&#x21BB;</xsl:text>
                                                                </xsl:element>
                                                            </xsl:when>
                                                            <xsl:when test="contains(attribute::emph, 'arrforward_h') and not($handwriting='off')">
                                                                <xsl:element name="SPAN">
                                                                    <xsl:attribute name="style">font-family: Arial Unicode MS;</xsl:attribute>
                                                                    <xsl:text>&#x21BB;</xsl:text>
                                                                </xsl:element>
                                                            </xsl:when>
                                                            <xsl:otherwise></xsl:otherwise>
                                                        </xsl:choose>
                                                        <!-- Overriding text color for deletions -->
                                                        <xsl:choose>
                                                            <xsl:when test="attribute::n">
                                                                <xsl:element name="SPAN">
                                                                    <xsl:attribute name="class">text-override</xsl:attribute>
                                                                    <!--<xsl:attribute name="onMouseover"><xsl:text>ddrivetip('</xsl:text>
                                                                        <xsl:value-of select="attribute::n"/>
                                                                        <xsl:text>','gray')</xsl:text></xsl:attribute>-->
                                                                    <!--<xsl:attribute name="onMouseout">hideddrivetip()</xsl:attribute>-->
                                                                    <xsl:choose>
                                                                        <xsl:when test="contains(attribute::del, 'type_d_h')">
                                                                            <xsl:choose>
                                                                                <xsl:when test="contains($d, 'study')">
                                                                                    <xsl:attribute name="style">color: #000000;</xsl:attribute>
                                                                                </xsl:when>
                                                                                <xsl:when test="contains($d, 'norm')"></xsl:when>
                                                                                <xsl:otherwise>
                                                                                    <xsl:attribute name="style">color: #000000;</xsl:attribute>
                                                                                </xsl:otherwise>
                                                                            </xsl:choose>
                                                                        </xsl:when>
                                                                        <xsl:when test="contains(attribute::del, 'type_dnpc_h')">
                                                                            <xsl:choose>
                                                                                <xsl:when test="contains($dnpc, 'study')"></xsl:when>
                                                                                <xsl:when test="contains($dnpc, 'norm')"></xsl:when>
                                                                                <xsl:otherwise>
                                                                                    <xsl:attribute name="style">color: #000000;</xsl:attribute>
                                                                                </xsl:otherwise>
                                                                            </xsl:choose>
                                                                        </xsl:when>
                                                                        <xsl:when test="contains(attribute::add, 'ip_h') and not($handwriting='off') and not($visning='norm') and not($visning='study')">
                                                                            <xsl:attribute name="style">color: #33FFFF</xsl:attribute>
                                                                        </xsl:when>
                                                                        <xsl:when test="contains(attribute::add, 'ipp_h') and not($handwriting='off') and not($visning='norm') and not($visning='study')">
                                                                            <xsl:attribute name="style">color: #33FFFF</xsl:attribute>
                                                                        </xsl:when>
                                                                        <xsl:when test="contains(attribute::add, 'H') and not($handwriting='off') and not($visning='norm') and not($visning='study')">
                                                                            <xsl:attribute name="style">color: #33FFFF</xsl:attribute>
                                                                        </xsl:when>
                                                                        <xsl:when test="contains(attribute::add, 'ipp_H5') and not($handwriting='off') and not($visning='norm') and not($visning='study')">
                                                                            <xsl:attribute name="style">color: #33FFFF</xsl:attribute>
                                                                        </xsl:when>
                                                                        <xsl:otherwise></xsl:otherwise>
                                                                    </xsl:choose>
                                                                    <xsl:choose>
                                                                        <xsl:when test="descendant::tei:seg[attribute::type='series-number-indent']">
                                                                            <xsl:element name="DIV">
                                                                                <xsl:attribute name="class">series-number-indent</xsl:attribute>
                                                                                <xsl:attribute name="style">margin-left: 25px; border-left: 1px solid black;</xsl:attribute>
                                                                                <xsl:apply-templates/>
                                                                            </xsl:element>
                                                                        </xsl:when>
                                                                        <xsl:otherwise>
                                                                            <xsl:apply-templates/>
                                                                        </xsl:otherwise>
                                                                    </xsl:choose>
                                                                </xsl:element>
                                                            </xsl:when>
                                                            <xsl:otherwise>
                                                                <xsl:choose>
                                                                    <xsl:when test="contains(attribute::del, type_d_h)">
                                                                        <xsl:choose>
                                                                            <xsl:when test="contains($d, 'study')"></xsl:when>
                                                                            <xsl:when test="contains($d, 'norm')"></xsl:when>
                                                                            <xsl:otherwise>
                                                                                <xsl:element name="SPAN">
                                                                                    <xsl:attribute name="style">color: #000000;</xsl:attribute>
                                                                                    <xsl:choose>
                                                                                        <xsl:when test="descendant::tei:seg[attribute::type='series-number-indent']">
                                                                                            <xsl:element name="DIV">
                                                                                                <xsl:attribute name="class">series-number-indent</xsl:attribute>
                                                                                                <xsl:attribute name="style">margin-left: 25px; border-left: 1px solid black;</xsl:attribute>
                                                                                                <xsl:apply-templates/>
                                                                                            </xsl:element>
                                                                                        </xsl:when>
                                                                                        <xsl:otherwise>
                                                                                            <xsl:apply-templates/>
                                                                                        </xsl:otherwise>
                                                                                    </xsl:choose>
                                                                                </xsl:element>
                                                                            </xsl:otherwise>
                                                                        </xsl:choose>
                                                                    </xsl:when>
                                                                    <xsl:when test="contains(attribute::del, type_dnpc_h)">
                                                                        <xsl:choose>
                                                                            <xsl:when test="contains($dnpc, 'study')"></xsl:when>
                                                                            <xsl:when test="contains($dnpc, 'norm')"></xsl:when>
                                                                            <xsl:otherwise>
                                                                                <xsl:element name="SPAN">
                                                                                    <xsl:attribute name="style">color: #000000;</xsl:attribute>
                                                                                    <xsl:choose>
                                                                                        <xsl:when test="descendant::tei:seg[attribute::type='series-number-indent']">
                                                                                            <xsl:element name="DIV">
                                                                                                <xsl:attribute name="class">series-number-indent</xsl:attribute>
                                                                                                <xsl:attribute name="style">margin-left: 25px; border-left: 1px solid black;</xsl:attribute>
                                                                                                <xsl:apply-templates/>
                                                                                            </xsl:element>
                                                                                        </xsl:when>
                                                                                        <xsl:otherwise>
                                                                                            <xsl:apply-templates/>
                                                                                        </xsl:otherwise>
                                                                                    </xsl:choose>
                                                                                </xsl:element>
                                                                            </xsl:otherwise>
                                                                        </xsl:choose>
                                                                    </xsl:when>
                                                                    <xsl:otherwise>
                                                                        <xsl:choose>
                                                                            <xsl:when test="descendant::tei:seg[attribute::type='series-number-indent']">
                                                                                <xsl:element name="DIV">
                                                                                    <xsl:attribute name="class">series-number-indent</xsl:attribute>
                                                                                    <xsl:attribute name="style">margin-left: 25px; border-left: 1px solid black;</xsl:attribute>
                                                                                    <xsl:apply-templates/>
                                                                                </xsl:element>
                                                                            </xsl:when>
                                                                            <xsl:otherwise>
                                                                                <xsl:apply-templates/>
                                                                            </xsl:otherwise>
                                                                        </xsl:choose>
                                                                    </xsl:otherwise>
                                                                </xsl:choose>
                                                            </xsl:otherwise>
                                                        </xsl:choose>
                                                        <!-- Markings at the back of text block -->
                                                        <xsl:choose>
                                                            <xsl:when test="contains(attribute::add, 'el_h') and not($handwriting='off') and not($el='norm') and not($el='study')">
                                                                <xsl:element name="SPAN">
                                                                    <xsl:attribute name="style">color: #008000;</xsl:attribute>
                                                                    <xsl:text>&gt;</xsl:text>
                                                                </xsl:element>
                                                            </xsl:when>
                                                            <xsl:when test="contains(attribute::add, 'ilm') and not($handwriting='off')">
                                                                <xsl:element name="SPAN">
                                                                    <xsl:attribute name="style">color: #FF00FF;</xsl:attribute>
                                                                    <xsl:text>&gt;</xsl:text>
                                                                </xsl:element>
                                                            </xsl:when>
                                                            <xsl:when test="contains(attribute::add, 'ilom') and not($handwriting='off')">
                                                                <xsl:element name="SPAN">
                                                                    <xsl:attribute name="style">color: #FF00FF;</xsl:attribute>
                                                                    <xsl:text>&gt;</xsl:text>
                                                                </xsl:element>
                                                            </xsl:when>
                                                            <xsl:when test="contains(attribute::add, 'iupm_h') and not($handwriting='off') and not($visning='norm')">
                                                                <xsl:element name="SPAN">
                                                                    <xsl:attribute name="style">color: #FF00FF;</xsl:attribute>
                                                                    <xsl:text>&gt;4</xsl:text>
                                                                </xsl:element>
                                                            </xsl:when>
                                                            <xsl:when test="contains(attribute::emph, 'vdline_h_ch') and not($handwriting='off') and not($visning='norm')">
                                                                <xsl:element name="SUP">
                                                                    <xsl:attribute name="style">color: #FF0000;</xsl:attribute>
                                                                    <xsl:text>ch</xsl:text>
                                                                </xsl:element>
                                                            </xsl:when>
                                                            <xsl:when test="contains(attribute::emph, 'wlilm_c') and not($handwriting='off')">
                                                                <xsl:element name="SPAN">
                                                                    <xsl:attribute name="style">color: #FF0000;</xsl:attribute>
                                                                    <xsl:element name="SUP">
                                                                        <xsl:text>[c]</xsl:text>
                                                                    </xsl:element>
                                                                </xsl:element>
                                                            </xsl:when>
                                                            <xsl:when test="contains(attribute::emph, 'wlirm_c') and not($handwriting='off')">
                                                                <xsl:element name="SPAN">
                                                                    <xsl:attribute name="style">color: #FF0000;</xsl:attribute>
                                                                    <xsl:element name="SUP">
                                                                        <xsl:text>[c]</xsl:text>
                                                                    </xsl:element>
                                                                </xsl:element>
                                                            </xsl:when>
                                                            <xsl:otherwise></xsl:otherwise>
                                                        </xsl:choose>
                                                        <xsl:if test="contains(attribute::rend, 'blaft') and contains(attribute::rend, 'blbef')">
                                                            <xsl:variable name="last">
                                                                <xsl:value-of select="substring-after(attribute::rend, ' ')"/>
                                                            </xsl:variable>
                                                            <xsl:call-template name="blanks">
                                                                <xsl:with-param name="i" select="1"/>
                                                                <xsl:with-param name="max" select="substring-after($last, '_')"/>
                                                            </xsl:call-template>
                                                        </xsl:if>
                                                        <xsl:if test="contains(attribute::rend, 'blaft') and not(contains(attribute::rend, 'blbef'))">
                                                            <xsl:call-template name="blanks">
                                                                <xsl:with-param name="i" select="1"/>
                                                                <xsl:with-param name="max" select="substring-after(attribute::rend, '_')"/>
                                                            </xsl:call-template>
                                                        </xsl:if>
                                                        <xsl:if test="contains(attribute::rend, 'sepline')">
                                                            <xsl:element name="HR">
                                                                <xsl:attribute name="width">150px</xsl:attribute>
                                                                <xsl:attribute name="align">left</xsl:attribute>
                                                            </xsl:element>
                                                        </xsl:if>
                                                    </xsl:element>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:element>
                                    </xsl:element>
                                </xsl:element>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
	
	<xsl:template match="tei:s">
		<xsl:choose>
			<xsl:when test="attribute::type='legend'">
				<xsl:element name="TABLE">
					<xsl:attribute name="border">0</xsl:attribute>
					<xsl:attribute name="width">750px</xsl:attribute>
					<xsl:element name="TR">
						<xsl:apply-templates/>
					</xsl:element>
				</xsl:element>
			</xsl:when>
			<xsl:when test="attribute::type='legend-visning'">
				<xsl:element name="TD">
					<xsl:attribute name="valign">top</xsl:attribute>
					<xsl:attribute name="width">150px</xsl:attribute>
					<xsl:apply-templates/>
				</xsl:element>
			</xsl:when>
			<xsl:when test="attribute::type='legend-description'">
				<xsl:element name="TD">
					<xsl:attribute name="valign">top</xsl:attribute>
					<xsl:attribute name="width">300px</xsl:attribute>
					<xsl:apply-templates/>
				</xsl:element>
			</xsl:when>
			<xsl:when test="attribute::type='legend-codes'">
				<xsl:element name="TD">
					<xsl:attribute name="valign">top</xsl:attribute>
					<xsl:attribute name="width">300px</xsl:attribute>
					<xsl:apply-templates/>
				</xsl:element>
			</xsl:when>
			<xsl:otherwise>
				<xsl:if test="contains(attribute::rend, 'indl')">         
					<!-- Brukes kun til testing
						<xsl:element name="SPAN">
						<xsl:attribute name="style">color: #008000;</xsl:attribute>
						<xsl:value-of select="attribute::rend"/>
						</xsl:element> -->
					<xsl:choose>
						<xsl:when test="$visning='dipl'">
							<xsl:choose>
								<xsl:when test="parent::tei:ab">
									<xsl:choose>
										<!--<xsl:when test="preceding-sibling::tei:lb[1][preceding-sibling::*[1][self::tei:s]]"></xsl:when>-->
										<xsl:when test="preceding-sibling::*[1][self::tei:lb]"></xsl:when>
										<xsl:when test="preceding-sibling::*[1][self::node()[contains(attribute::type, 'wabmarks')]]"></xsl:when>
										<xsl:when test="preceding-sibling::*[1][self::node()[contains(attribute::rend, 'bl')]]"></xsl:when>
										<xsl:when test="ancestor::tei:ab[preceding-sibling::*[1][self::tei:ab]] and not(preceding-sibling::tei:s)"></xsl:when>
										<xsl:when test="ancestor::tei:ab[preceding-sibling::*[1][self::tei:lb]] and not(preceding-sibling::tei:s)"></xsl:when>
										<xsl:otherwise>
											<xsl:element name="BR"></xsl:element>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:when>
								<xsl:when test="not(parent::tei:ab)">
									<xsl:choose>
										<xsl:when test="preceding-sibling::*[1][self::tei:lb]"></xsl:when>
										<xsl:when test="ancestor::tei:ab[preceding-sibling::*[1][self::tei:ab]] and not(preceding-sibling::tei:s)"></xsl:when>
										<xsl:when test="ancestor::tei:ab[preceding-sibling::*[1][self::tei:lb]] and not(preceding-sibling::tei:s)"></xsl:when>
										<xsl:when test="parent::node()[preceding-sibling::*[1][self::lb]]"></xsl:when>
										<xsl:when test="parent::node()[preceding-sibling::*[1][self::node()[contains(attribute::rend, 'bl')]]]"></xsl:when>
										<xsl:otherwise>
											<xsl:element name="BR"></xsl:element>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:when>
								<xsl:otherwise>
									<xsl:element name="BR"></xsl:element>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<xsl:otherwise>
							<xsl:element name="BR"></xsl:element>
						</xsl:otherwise>
					</xsl:choose>
					<xsl:call-template name="spaces">
						<xsl:with-param name="i" select="1"/>
						<xsl:with-param name="max" select="substring-after(attribute::rend, '_')"/>
					</xsl:call-template>
				</xsl:if>
				<xsl:apply-templates/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="tei:seg">
        <xsl:choose>
            <xsl:when test="contains(attribute::type, 'wabmarks')">
                <xsl:choose>
                    <xsl:when test="$visning = 'dipl' or $visning = 'study'">
                        <xsl:choose>
                            <!-- Start -->
                            <xsl:when test="contains(attribute::type, 'nm') or contains(attribute::type, 'nr') or contains(attribute::type, 'nl') or contains(attribute::type, 'mr') or contains(attribute::type, 'ml')">
                                <xsl:choose>
                                    <xsl:when test="parent::tei:ab"></xsl:when>
                                    <xsl:otherwise>
                                        <xsl:element name="TABLE">
                                            <xsl:attribute name="border">0</xsl:attribute>
                                            <xsl:attribute name="cellpadding">0</xsl:attribute>
                                            <xsl:attribute name="cellspacing">0</xsl:attribute>
                                            <xsl:attribute name="width">615px</xsl:attribute>
                                            <xsl:element name="TR">
                                                <xsl:element name="TD">
                                                    <xsl:attribute name="width">205px</xsl:attribute>
                                                    <xsl:choose>
                                                        <xsl:when test="contains(attribute::type, 'nl')">
                                                            <xsl:apply-templates select="self::tei:seg[contains(attribute::type, 'nl')]" mode="margins"/>
                                                        </xsl:when>
                                                        <xsl:when test="contains(attribute::type, 'ml')">
                                                            <xsl:apply-templates select="self::tei:seg[contains(attribute::type, 'ml')]" mode="margins"/>
                                                        </xsl:when>
                                                        <xsl:otherwise>
                                                            <xsl:text>&nbsp;</xsl:text>
                                                        </xsl:otherwise>
                                                    </xsl:choose>
                                                </xsl:element>
                                                <xsl:element name="TD">
                                                    <xsl:attribute name="width">205px</xsl:attribute>
                                                    <xsl:choose>
                                                        <xsl:when test="contains(attribute::type, 'nm')">
                                                            <xsl:apply-templates select="self::tei:seg[contains(attribute::type, 'nm')]" mode="margins"/>
                                                        </xsl:when>
                                                        <xsl:otherwise>
                                                            <xsl:text>&nbsp;</xsl:text>
                                                        </xsl:otherwise>
                                                    </xsl:choose>
                                                </xsl:element>
                                                <xsl:element name="TD">
                                                    <xsl:attribute name="width">205px</xsl:attribute>
                                                    <xsl:choose>
                                                        <xsl:when test="contains(attribute::type, 'nr')">
                                                            <xsl:apply-templates select="self::tei:seg[contains(attribute::type, 'nr')]" mode="margins"/>
                                                        </xsl:when>
                                                        <xsl:when test="contains(attribute::type, 'mr')">
                                                            <xsl:choose>
                                                                <xsl:when test="$handwriting='off'"></xsl:when>
                                                                <xsl:otherwise>
                                                                    <xsl:apply-templates select="self::tei:seg[contains(attribute::type, 'mr')]" mode="margins"/>        
                                                                </xsl:otherwise>
                                                            </xsl:choose>
                                                        </xsl:when>
                                                        <xsl:otherwise>
                                                            <xsl:text>&nbsp;</xsl:text>
                                                        </xsl:otherwise>
                                                    </xsl:choose>
                                                </xsl:element>
                                            </xsl:element>
                                        </xsl:element>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:when>
                            <xsl:when test="contains(attribute::type, 'secm')"></xsl:when>
                            <!-- Slutt -->
                            <xsl:otherwise>
                                <xsl:choose>
                                    <xsl:when test="contains(attribute::type, '_h') or contains(attribute::type, 'S1')">
                                        <xsl:choose>
                                            <xsl:when test="$handwriting = 'off'"></xsl:when>
                                            <xsl:otherwise>
                                                <!--<xsl:element name="SPAN">
                                                    <xsl:attribute name="style">color: #0000FF; font-size: 60%;</xsl:attribute>
                                                    <xsl:apply-templates/>                                           
                                                </xsl:element>-->
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:element name="SPAN">
                                            <xsl:attribute name="style">font-size: 60%;</xsl:attribute>
                                            <xsl:apply-templates/>                                           
                                        </xsl:element>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:choose>
                            <xsl:when test="contains(attribute::type, '_h')  or contains(attribute::type, 'S1')">
                                <xsl:choose>
                                    <xsl:when test="$handwriting='on'">
                                        <xsl:apply-templates/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:when>
                            <xsl:otherwise>

                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:otherwise>
                </xsl:choose>                    
            </xsl:when>
            <!-- Disse skal ikke undertykkes med mindre det er definert i den interaktive. Vær obs på disse. -->
            <xsl:when test="contains(attribute::type, 'secmr_h')"/>
            <xsl:when test="contains(attribute::type, 'secml_h')"/>
            <xsl:when test="contains(attribute::type, 'secmr_H1')"/>
            <xsl:when test="contains(attribute::type, 'secml_H1')"/>
            <xsl:when test="attribute::type='code'">
                <xsl:choose>
                    <xsl:when test="$seg-cod='mark'">
                        <xsl:element name="SPAN">
                            <xsl:attribute name="style">background-color: #00FFFF;</xsl:attribute>
                            <xsl:apply-templates/>
                        </xsl:element>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:apply-templates/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="attribute::type='dedication'">
                <xsl:choose>
                    <xsl:when test="$seg-ded='mark'">
                        <xsl:element name="SPAN">
                            <xsl:attribute name="style">background-color: #00FFFF;</xsl:attribute>
                            <xsl:apply-templates/>
                        </xsl:element>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:apply-templates/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="attribute::type='definition'">
                <xsl:choose>
                    <xsl:when test="$seg-def='mark'">
                        <xsl:element name="SPAN">
                            <xsl:attribute name="style">background-color: #00FFFF;</xsl:attribute>
                            <xsl:apply-templates/>
                        </xsl:element>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:apply-templates/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="attribute::type='direct_speech'">
                <xsl:choose>
                    <xsl:when test="$seg-dir='mark'">
                        <xsl:element name="SPAN">
                            <xsl:attribute name="style">background-color: #00FFFF;</xsl:attribute>
                            <xsl:apply-templates/>
                        </xsl:element>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:apply-templates/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="attribute::type='edinst'">
                <!-- Changes need to be reflected on ab as well -->
                <xsl:choose>
                    <xsl:when test="$visning='dipl'">
                        <xsl:apply-templates/>
                    </xsl:when>
                    <xsl:otherwise></xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="attribute::type='example'">
                <xsl:choose>
                    <xsl:when test="$seg-ex='mark'">
                        <xsl:element name="SPAN">
                            <xsl:attribute name="style">background-color: #00FFFF;</xsl:attribute>
                            <xsl:apply-templates/>
                        </xsl:element>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:apply-templates/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="attribute::type='head'">
                <xsl:choose>
                    <!-- added by ap: begin-->
                    <xsl:when test="contains($visning, 'dipl')">
                        <xsl:element name="SPAN">
                            <xsl:apply-templates/>
                        </xsl:element>
                    </xsl:when>
                    <xsl:when test="contains($visning, 'study')">
                        <xsl:element name="SPAN">
                            <xsl:attribute name="style">font-size: 300%</xsl:attribute>
                            <xsl:apply-templates/>
                        </xsl:element>
                    </xsl:when>
                    <!-- added by ap: end-->
                    <xsl:when test="contains($visning, 'norm')">
                        <xsl:element name="SPAN">
                            <xsl:attribute name="style">font-size: 300%</xsl:attribute>
                            <xsl:apply-templates/>
                        </xsl:element>
                    </xsl:when>
                    <xsl:otherwise/>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="attribute::type='illspace'">
                <xsl:call-template name="spaces">
                    <xsl:with-param name="i" select="1"/>
                    <xsl:with-param name="max" select="substring-after(attribute::type, '_')"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="attribute::type='ill-space'">
                <xsl:call-template name="spaces">
                    <xsl:with-param name="i" select="1"/>
                    <xsl:with-param name="max" select="substring-after(attribute::type, '_')"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="attribute::type='int-ref'">
                <xsl:variable name="int">
                    <xsl:value-of select="substring-before(attribute::n, '_')"/>
                </xsl:variable>
                <xsl:variable name="mark">
                    <xsl:value-of select="substring-after(attribute::n, '_')"/>
                </xsl:variable>
                <!--<xsl:text>[int-ref: </xsl:text>-->
                <xsl:apply-templates/>
                <xsl:element name="A">
                    <xsl:attribute name="name"><xsl:text>int_</xsl:text><xsl:value-of select="$int"/></xsl:attribute>
                </xsl:element>
                <xsl:element name="A">
                    <xsl:attribute name="href"><xsl:text>#mark_</xsl:text><xsl:value-of select="$mark"/></xsl:attribute>
                    <xsl:attribute name="style">color: #0000FF; text-decoration: none;</xsl:attribute>
                    <xsl:text>&#x21D2;</xsl:text>
                </xsl:element>
                <!--<xsl:text>]</xsl:text>-->
            </xsl:when>
            <xsl:when test="attribute::type='mark-ref'">
                <xsl:variable name="int">
                    <xsl:value-of select="substring-before(attribute::n, '_')"/>
                </xsl:variable>
                <xsl:variable name="mark">
                    <xsl:value-of select="substring-after(attribute::n, '_')"/>
                </xsl:variable>
                <!--<xsl:text>[mark-ref: </xsl:text>-->
                <xsl:apply-templates/>
                <xsl:element name="A">
                    <xsl:attribute name="name"><xsl:text>mark_</xsl:text><xsl:value-of select="$mark"/></xsl:attribute>
                </xsl:element>
                <xsl:element name="A">
                    <xsl:attribute name="href"><xsl:text>#int_</xsl:text><xsl:value-of select="$int"/></xsl:attribute>
                    <xsl:attribute name="style">color: #0000FF; text-decoration: none;</xsl:attribute>
                    <xsl:text>&#x21D0;</xsl:text>
                </xsl:element>
                <!--<xsl:text>]</xsl:text>-->
            </xsl:when>
            <xsl:when test="attribute::type='introduction'">
                <xsl:choose>
                    <xsl:when test="$seg-intr='mark'">
                        <xsl:element name="SPAN">
                            <xsl:attribute name="style">background-color: #00FFFF;</xsl:attribute>
                            <xsl:apply-templates/>
                        </xsl:element>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:apply-templates/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="attribute::type='mathlog'">
                <xsl:apply-templates/>
            </xsl:when>
            <xsl:when test="attribute::type='motto'">
                <xsl:choose>
                    <xsl:when test="$seg-mot='mark'">
                        <xsl:element name="SPAN">
                            <xsl:attribute name="style">background-color: #00FFFF;</xsl:attribute>
                            <xsl:apply-templates/>
                        </xsl:element>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:apply-templates/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="attribute::type='notation' and not(attribute::corresp)">
                <xsl:choose>
                    <xsl:when test="contains($seg-not, 'mark')">
                        <xsl:element name="SPAN">
                            <xsl:attribute name="style">background-color: #00FFFF; border: 1px solid;</xsl:attribute>
                            <xsl:apply-templates/>
                        </xsl:element>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:apply-templates/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="attribute::type='notation' and attribute::corresp">
                <xsl:choose>
                    <xsl:when test="contains($seg-not, 'mark')">
                        <xsl:choose>
                            <xsl:when test="contains(attribute::rend, 'illspace')">
                                <xsl:element name="DIV">
                                    <xsl:attribute name="style">border: 1px solid black; width: 50px;</xsl:attribute>
                                    <xsl:text>&nbsp;</xsl:text>
                                    <xsl:element name="BR"/>
                                    <xsl:text>&nbsp;</xsl:text>
                                </xsl:element>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">background-color: #00FFFF;</xsl:attribute>
                                    <xsl:element name="SPAN">
                                        <xsl:attribute name="onMouseover">ddrivetip('Click for image','gray')</xsl:attribute>
                                        <xsl:attribute name="onMouseout">hideddrivetip()</xsl:attribute>
                                        <xsl:element name="A">
                                            <xsl:attribute name="href"><xsl:text>javascript:openBilde('</xsl:text><xsl:value-of select="attribute::corresp"/><xsl:text>')</xsl:text></xsl:attribute>
                                            <xsl:attribute name="style">border: 1px</xsl:attribute>
                                            <xsl:element name="IMG">
                                                <xsl:attribute name="src">
                                                    <xsl:value-of select="attribute::corresp"/>
                                                </xsl:attribute>
                                                <xsl:attribute name="style">border: solid</xsl:attribute>
                                                <xsl:attribute name="width">50px</xsl:attribute>
                                            </xsl:element>
                                        </xsl:element>
                                    </xsl:element>
                                </xsl:element>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:choose>
                            <xsl:when test="contains(attribute::rend, 'illspace')">
                                <xsl:element name="DIV">
                                    <xsl:attribute name="style">border: 1px solid black; width: 50px</xsl:attribute>
                                    <xsl:text>&nbsp;</xsl:text>
                                    <xsl:element name="BR"/>
                                    <xsl:text>&nbsp;</xsl:text>
                                </xsl:element>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="onMouseover">ddrivetip('Click for image','gray')</xsl:attribute>
                                    <xsl:attribute name="onMouseout">hideddrivetip()</xsl:attribute>
                                    <xsl:element name="A">
                                        <xsl:attribute name="href"><xsl:text>javascript:openBilde('</xsl:text><xsl:value-of select="attribute::corresp"/><xsl:text>')</xsl:text></xsl:attribute>
                                        <xsl:attribute name="style">border: 1px</xsl:attribute>
                                        <xsl:element name="IMG">
                                            <xsl:attribute name="src">
                                                <xsl:value-of select="attribute::corresp"/>
                                            </xsl:attribute>
                                            <xsl:attribute name="style">border: solid</xsl:attribute>
                                            <xsl:attribute name="width">50px</xsl:attribute>
                                        </xsl:element>
                                    </xsl:element>
                                </xsl:element>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="attribute::type='pictorial_expression'">
                <xsl:choose>
                    <xsl:when test="$seg-pic='mark'">
                        <xsl:element name="SPAN">
                            <xsl:attribute name="style">background-color: #00FFFF;</xsl:attribute>
                            <xsl:apply-templates/>
                        </xsl:element>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:apply-templates/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="attribute::type='preface'">
                <!-- Changes need to be reflected on ab as well -->
                <xsl:choose>
                    <xsl:when test="$seg-pre='mark'">
                        <xsl:element name="SPAN">
                            <xsl:attribute name="style">background-color: #00FFFF;</xsl:attribute>
                            <xsl:apply-templates/>
                        </xsl:element>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:apply-templates/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="attribute::type='pt'">
                <xsl:apply-templates/>
            </xsl:when>
            <xsl:when test="attribute::type='q'">
                <xsl:apply-templates/>
            </xsl:when>
            <xsl:when test="attribute::type='rhetorical_question'">
                <xsl:choose>
                    <xsl:when test="$seg-rhe='mark'">
                        <xsl:element name="SPAN">
                            <xsl:attribute name="style">background-color: #00FFFF;</xsl:attribute>
                            <xsl:apply-templates/>
                        </xsl:element>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:apply-templates/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="attribute::type='salutation'">
                <xsl:choose>
                    <xsl:when test="$seg-sal='mark'">
                        <xsl:element name="SPAN">
                            <xsl:attribute name="style">background-color: #00FFFF;</xsl:attribute>
                            <xsl:apply-templates/>
                        </xsl:element>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:apply-templates/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="attribute::type='subhead'">
                <xsl:choose>
                    <!-- added by ap: begin-->
                    <xsl:when test="contains($visning, 'dipl')">
                        <xsl:element name="SPAN">
                            <xsl:apply-templates/>
                        </xsl:element>
                    </xsl:when>
                    <xsl:when test="contains($visning, 'study')">
                        <xsl:element name="SPAN">
                            <xsl:attribute name="style">font-size: 200%</xsl:attribute>
                            <xsl:apply-templates/>
                        </xsl:element>
                    </xsl:when>
                    <!-- added by ap: end-->
                    <xsl:when test="contains($visning, 'norm')">
                        <xsl:element name="SPAN">
                            <xsl:attribute name="style">font-size: 200%</xsl:attribute>
                            <xsl:apply-templates/>
                        </xsl:element>
                    </xsl:when>
                    <xsl:otherwise/>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="attribute::type='ts'">
                <!-- Changes need to be reflected on ab as well -->
                <xsl:apply-templates/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates/>
            </xsl:otherwise>
        </xsl:choose>
	</xsl:template>
	
	<xsl:template match="tei:seg" mode="margins">
		<xsl:choose>
			<xsl:when test="contains(attribute::type, 'nm')">
				<xsl:choose>
					<xsl:when test="$handwriting = 'off' and contains(attribute::type, '_h')"></xsl:when>
					<xsl:otherwise>
						<xsl:element name="DIV">
							<xsl:attribute name="style">text-align: center; <xsl:if test="contains(attribute::type, '_h')">color: #0000FF; font-size: 60%;</xsl:if></xsl:attribute>
							<xsl:apply-templates/>
						</xsl:element>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="contains(attribute::type, 'nr')">
				<xsl:choose>
					<xsl:when test="$handwriting = 'off' and contains(attribute::type, '_h')"></xsl:when>
					<xsl:otherwise>
						<xsl:element name="DIV">
							<xsl:attribute name="style">text-align: right;<xsl:if test="contains(attribute::type, '_h')">color: #0000FF; font-size: 60%;</xsl:if></xsl:attribute>
							<xsl:apply-templates/>
						</xsl:element>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="contains(attribute::type, 'ml')">
				<xsl:choose>
					<xsl:when test="$handwriting = 'off' and contains(attribute::type, '_h')"></xsl:when>
					<xsl:otherwise>
						<xsl:element name="DIV">
							<xsl:attribute name="style">text-align: right;<xsl:if test="contains(attribute::type, '_h')">color: #0000FF; font-size: 60%;</xsl:if></xsl:attribute>
							<xsl:apply-templates/>
						</xsl:element>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="contains(attribute::type, 'mr')">
				<xsl:choose>
					<xsl:when test="$handwriting = 'off' and contains(attribute::type, '_h')"></xsl:when>
					<xsl:otherwise>
						<xsl:element name="DIV">
							<xsl:attribute name="style">text-align: right;<xsl:if test="contains(attribute::type, '_h')">color: #0000FF; font-size: 60%;</xsl:if></xsl:attribute>
							<xsl:apply-templates/>
						</xsl:element>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="contains(attribute::type, 'nl')">
				<xsl:choose>
					<xsl:when test="$handwriting = 'off' and contains(attribute::type, '_h')"></xsl:when>
					<xsl:otherwise>
						<xsl:element name="DIV">
							<xsl:attribute name="style">text-align: left;<xsl:if test="contains(attribute::type, '_h')">color: #0000FF; font-size: 60%;</xsl:if></xsl:attribute>
							<xsl:apply-templates/>
						</xsl:element>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="tei:date">
		<xsl:choose>
			<xsl:when test="contains($visning, 'dipl') or contains($visning, 'study')">
				<xsl:element name="DIV">
					<xsl:if test="attribute::rend='right'">
						<xsl:attribute name="align">right</xsl:attribute>
						<xsl:attribute name="style">margin-right: 250px;</xsl:attribute>
					</xsl:if>
					<xsl:apply-templates/>
				</xsl:element>
			</xsl:when>
			<xsl:otherwise>
				<xsl:element name="DIV">
					<xsl:if test="attribute::rend='right'">
						<xsl:attribute name="align">right</xsl:attribute>
						<xsl:attribute name="style">margin-right: 250px;</xsl:attribute>
					</xsl:if>
					<xsl:apply-templates/>
				</xsl:element>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="tei:dateline">
		<xsl:choose>
			<xsl:when test="contains($visning, 'dipl') or contains($visning, 'study')">
				<xsl:element name="DIV">
					<xsl:if test="attribute::pos='right'">
						<xsl:attribute name="align">right</xsl:attribute>
						<xsl:attribute name="style">margin-right: 250px;</xsl:attribute>
					</xsl:if>
					<xsl:apply-templates/>
				</xsl:element>
			</xsl:when>
			<xsl:otherwise> </xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template name="spaces">
		<xsl:param name="i"/>
		<xsl:param name="max"/>
		<xsl:if test="$i &lt;= $max">
			<xsl:text>&nbsp;</xsl:text>
		</xsl:if>
		<xsl:if test="$i &lt;= $max">
			<xsl:call-template name="spaces">
				<xsl:with-param name="i">
					<xsl:value-of select="$i+1"/>
				</xsl:with-param>
				<xsl:with-param name="max">
					<xsl:value-of select="$max"/>
				</xsl:with-param>
			</xsl:call-template>
		</xsl:if>
		<!-- Denne named templaten setter inn mellomrom -->
	</xsl:template>
	
	<xsl:template name="lines">
		<xsl:param name="i"/>
		<xsl:param name="max"/>
		<xsl:if test="$i &lt;= $max">
			<xsl:element name="BR"></xsl:element>
		</xsl:if>
		<xsl:if test="$i &lt;= $max">
			<xsl:call-template name="lines">
				<xsl:with-param name="i">
					<xsl:value-of select="$i+1"/>
				</xsl:with-param>
				<xsl:with-param name="max">
					<xsl:value-of select="$max"/>
				</xsl:with-param>
			</xsl:call-template>
		</xsl:if>
		<!-- Denne named templaten setter inn linjer -->
	</xsl:template>
	
	<xsl:template name="blanks">
		<xsl:param name="i"/>
		<xsl:param name="max"/>
		<xsl:if test="$i &lt;= $max">
			<xsl:element name="BR"/>
		</xsl:if>
		<xsl:if test="$i &lt;= $max">
			<xsl:call-template name="blanks">
				<xsl:with-param name="i">
					<xsl:value-of select="$i+1"/>
				</xsl:with-param>
				<xsl:with-param name="max">
					<xsl:value-of select="$max"/>
				</xsl:with-param>
			</xsl:call-template>
		</xsl:if>
		<!-- Denne named templaten setter inn blanke linjer -->
	</xsl:template>
	
	<!-- Encoding of tables -->
	
	<xsl:template match="tei:table">
		<xsl:element name="TABLE">
			<xsl:attribute name="border">1</xsl:attribute>
			<xsl:attribute name="style">display: inline-table</xsl:attribute>
			<xsl:element name="TR">
				<xsl:apply-templates/>
			</xsl:element>
		</xsl:element>
	</xsl:template>
	
	<xsl:template match="tei:cell">
		<xsl:element name="TD">
			<xsl:apply-templates/>
		</xsl:element>
	</xsl:template>
	
	<!-- Encoding of lists -->
	
	<xsl:template match="tei:list" mode="tooltip">
		<xsl:apply-templates mode="tooltip"/>
	</xsl:template>
	
	<!-- Encoding of apparatus -->
	
	<xsl:template match="tei:choice">
        <xsl:choose>
            <xsl:when test="attribute::type='co'">
                <xsl:choose>
                    <xsl:when test="contains($visning, 'dipl')">
                        <xsl:element name="SPAN">
                            <xsl:attribute name="style">background-color: #FFFF00;</xsl:attribute>
                            <xsl:apply-templates select="child::tei:orig[attribute::type='alt1']"/>
                            <xsl:element name="SPAN">
                                <xsl:attribute name="style">font-size: 75%;</xsl:attribute>
                                <xsl:text>&#x21C4;</xsl:text>
                            </xsl:element>
                            <xsl:apply-templates select="child::tei:orig[attribute::type='alt2']"/>
                        </xsl:element>
                    </xsl:when>
                    <xsl:when test="contains($visning, 'study')">
                        <xsl:element name="SPAN">
                            <xsl:attribute name="style">background-color: #FFFF00;</xsl:attribute>
                            <xsl:apply-templates select="child::tei:orig[attribute::type='alt1']"/>
                            <xsl:element name="SPAN">
                                <xsl:attribute name="style">font-size: 75%;</xsl:attribute>
                                <xsl:text>&#x21C4;</xsl:text>
                            </xsl:element>
                            <xsl:apply-templates select="child::tei:orig[attribute::type='alt2']"/>
                        </xsl:element>
                    </xsl:when>
                    <xsl:when test="contains($visning, 'norm')">
                        <xsl:apply-templates select="child::tei:orig[attribute::type='alt2']"/>
                    </xsl:when>
                    <xsl:otherwise/>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="attribute::type='co_h'">
                <xsl:choose>
                    <xsl:when test="contains($visning, 'dipl')">
                        <xsl:element name="SPAN">
                            <xsl:attribute name="style">background-color: #FFFF00;</xsl:attribute>
                            <xsl:element name="SPAN">
                                <xsl:apply-templates select="child::tei:orig[attribute::type='alt1']"/>
                            </xsl:element>
                            <xsl:choose>
                                <xsl:when test="$handwriting = 'off'"></xsl:when>
                                <xsl:otherwise>
                                    <xsl:element name="SPAN">
                                        <xsl:attribute name="style">color: #0000FF; font-size: 75%;</xsl:attribute>
                                        <xsl:text>&#x21C4;</xsl:text>
                                    </xsl:element>
                                </xsl:otherwise>
                            </xsl:choose>
                            <xsl:choose>
                                <xsl:when test="$handwriting='off'"></xsl:when>
                                <xsl:otherwise>
                                    <xsl:element name="SPAN">
                                        <xsl:apply-templates select="child::tei:orig[attribute::type='alt2']"/>
                                    </xsl:element>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:element>
                    </xsl:when>
                    <xsl:when test="contains($visning, 'study')">
                        <xsl:element name="SPAN">
                            <xsl:attribute name="style">background-color: #FFFF00;</xsl:attribute>
                            <xsl:element name="SPAN">
                                <xsl:apply-templates select="child::tei:orig[attribute::type='alt1']"/>
                            </xsl:element>
                            <xsl:choose>
                                <xsl:when test="$handwriting = 'off'"></xsl:when>
                                <xsl:otherwise>
                                    <xsl:element name="SPAN">
                                        <xsl:attribute name="style">color: #0000FF; font-size: 75%;</xsl:attribute>
                                        <xsl:text>&#x21C4;</xsl:text>
                                    </xsl:element>
                                </xsl:otherwise>
                            </xsl:choose>
                            <xsl:choose>
                                <xsl:when test="$handwriting='off'"></xsl:when>
                                <xsl:otherwise>
                                    <xsl:element name="SPAN">
                                        <xsl:apply-templates select="child::tei:orig[attribute::type='alt2']"/>
                                    </xsl:element>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:element>
                    </xsl:when>
                    <xsl:when test="contains($visning, 'norm')">
                        <xsl:choose>
                            <xsl:when test="$handwriting = 'off'">
                                <xsl:apply-templates select="child::tei:orig[attribute::type='alt1']"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:apply-templates select="child::tei:orig[attribute::type='alt2']"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:otherwise/>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="attribute::type='co_H1'">
                <xsl:choose>
                    <xsl:when test="contains($visning, 'dipl')">
                        <xsl:element name="SPAN">
                            <xsl:attribute name="style">background-color: #FFFF00;</xsl:attribute>
                            <xsl:element name="SPAN">
                                <xsl:attribute name="style">color: #0000FF;</xsl:attribute>
                                <xsl:apply-templates select="child::tei:orig[attribute::type='alt1']"/>
                            </xsl:element>
                            <xsl:choose>
                                <xsl:when test="$handwriting = 'off'"></xsl:when>
                                <xsl:otherwise>
                                    <xsl:element name="SPAN">
                                        <xsl:attribute name="style">color: #0000FF; font-size: 75%;</xsl:attribute>
                                        <xsl:text>&#x2194;</xsl:text>
                                    </xsl:element>
                                </xsl:otherwise>
                            </xsl:choose>
                            <xsl:element name="SPAN">
                                <xsl:attribute name="style">color: #0000FF;</xsl:attribute>
                                <xsl:apply-templates select="child::tei:orig[attribute::type='alt2']"/>
                            </xsl:element>
                        </xsl:element>
                    </xsl:when>
                    <xsl:when test="contains($visning, 'study')">
                        <xsl:element name="SPAN">
                            <xsl:attribute name="style">background-color: #FFFF00;</xsl:attribute>
                            <xsl:element name="SPAN">
                                <xsl:attribute name="style">color: #0000FF;</xsl:attribute>
                                <xsl:apply-templates select="child::tei:orig[attribute::type='alt1']"/>
                            </xsl:element>
                            <xsl:choose>
                                <xsl:when test="$handwriting = 'off'"></xsl:when>
                                <xsl:otherwise>
                                    <xsl:element name="SPAN">
                                        <xsl:attribute name="style">color: #0000FF; font-size: 75%;</xsl:attribute>
                                        <xsl:text>&#x2194;</xsl:text>
                                    </xsl:element>
                                </xsl:otherwise>
                            </xsl:choose>
                            <xsl:element name="SPAN">
                                <xsl:attribute name="style">color: #0000FF;</xsl:attribute>
                                <xsl:apply-templates select="child::tei:orig[attribute::type='alt2']"/>
                            </xsl:element>
                        </xsl:element>
                    </xsl:when>
                    <xsl:when test="contains($visning, 'norm')">
                        <xsl:choose>
                            <xsl:when test="$handwriting = 'off'">
                                <xsl:apply-templates select="child::tei:orig[attribute::type='alt1']"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:apply-templates select="child::tei:orig[attribute::type='alt2']"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:otherwise/>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="attribute::type='corr-co'">
                <xsl:choose>
                    <xsl:when test="contains($visning, 'dipl')">
                        <xsl:apply-templates select="child::tei:orig[attribute::type='alt1']"/>
                    </xsl:when>
                    <xsl:when test="contains($visning, 'study')">
                        <xsl:element name="SPAN">
                            <xsl:attribute name="style">color: #009900;</xsl:attribute>
                            <xsl:text>{</xsl:text>
                        </xsl:element>
                        <xsl:apply-templates select="child::tei:orig[attribute::type='alt2']"/>
                        <xsl:element name="SPAN">
                            <xsl:attribute name="style">color: #009900;</xsl:attribute>
                            <xsl:text>}</xsl:text>
                        </xsl:element>
                    </xsl:when>
                    <xsl:when test="contains($visning, 'norm')">
                        <xsl:apply-templates select="child::tei:orig[attribute::type='alt2']"/>
                    </xsl:when>
                    <xsl:otherwise/>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="attribute::type='dsf'">
                <xsl:choose>
                    <xsl:when test="contains($visning, 'dipl')">
                        <!--<xsl:for-each select="child::tei:orig">-->
                            <xsl:apply-templates/>
                        <!--</xsl:for-each>-->
                    </xsl:when>
                    <xsl:when test="contains($visning, 'study')">
                        <xsl:element name="SPAN">
                            <xsl:attribute name="style">background-color: #FFFF00;</xsl:attribute>
                            <xsl:apply-templates select="child::tei:orig[attribute::type='alt1']"/>
                            <xsl:element name="SPAN">
                                <xsl:attribute name="style">color: #0000FF;</xsl:attribute>
                                <xsl:text>|</xsl:text>
                            </xsl:element>
                            <xsl:apply-templates select="child::tei:orig[attribute::type='alt2']"/>
                        </xsl:element>
                    </xsl:when>
                    <xsl:when test="contains($visning, 'norm')">
                        <xsl:apply-templates select="child::tei:orig[attribute::type='alt1']"/>
                    </xsl:when>
                    <xsl:otherwise/>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="attribute::type='dsf_h'">
                <xsl:choose>
                    <xsl:when test="$handwriting = 'off'">
                        <xsl:apply-templates/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:choose>
                            <xsl:when test="contains($visning, 'dipl')">
                                <!--<xsl:for-each select="child::tei:orig">-->
                                    <xsl:apply-templates/>
                                <!--</xsl:for-each>-->
                            </xsl:when>
                            <xsl:when test="contains($visning, 'study')">
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">background-color: #FFFF00;</xsl:attribute>
                                    <xsl:apply-templates select="child::tei:orig[attribute::type='alt1']"/>
                                    <xsl:element name="SPAN">
                                        <xsl:attribute name="style">color: #0000FF;</xsl:attribute>
                                        <xsl:text>|</xsl:text>
                                    </xsl:element>
                                    <xsl:apply-templates select="child::tei:orig[attribute::type='alt2']"/>
                                    <xsl:element name="SUP">
                                        <xsl:attribute name="style">color: #0000FF;</xsl:attribute>
                                        <xsl:text>h</xsl:text>
                                    </xsl:element>
                                </xsl:element>
                            </xsl:when>
                            <xsl:when test="contains($visning, 'norm')">
                                <xsl:apply-templates select="child::tei:orig[attribute::type='alt1']"/>
                            </xsl:when>
                            <xsl:otherwise/>
                        </xsl:choose>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="attribute::type='dsl'">
                <xsl:choose>
                    <xsl:when test="contains($visning, 'dipl')">
                        <!--<xsl:for-each select="child::tei:orig">
                            <xsl:apply-templates/>
                            </xsl:for-each>-->
                        <xsl:apply-templates/>
                    </xsl:when>
                    <xsl:when test="contains($visning, 'study')">
                        <xsl:element name="SPAN">
                            <xsl:attribute name="style">background-color: #FFFF00;</xsl:attribute>
                            <xsl:apply-templates select="child::tei:orig[attribute::type='alt1']"/>
                            <xsl:element name="SPAN">
                                <xsl:attribute name="style">color: #0000FF;</xsl:attribute>
                                <xsl:text>|</xsl:text>
                            </xsl:element>
                            <xsl:apply-templates select="child::tei:orig[attribute::type='alt2']"/>
                        </xsl:element>
                    </xsl:when>
                    <xsl:when test="contains($visning, 'norm')">
                        <xsl:apply-templates select="child::tei:orig[attribute::type='alt2']"/>
                    </xsl:when>
                    <xsl:otherwise/>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="attribute::type='dsl_h'">
                <xsl:choose>
                    <xsl:when test="$handwriting = 'off'">
                        <xsl:apply-templates/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:choose>
                            <xsl:when test="contains($visning, 'dipl')">
                                <!--<xsl:for-each select="child::tei:orig">-->
                                    <xsl:apply-templates/>
                                <!--</xsl:for-each>-->
                            </xsl:when>
                            <xsl:when test="contains($visning, 'study')">
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">background-color: #FFFF00;</xsl:attribute>
                                    <xsl:apply-templates select="child::tei:orig[attribute::type='alt1']"/>
                                    <xsl:element name="SPAN">
                                        <xsl:attribute name="style">color: #0000FF;</xsl:attribute>
                                        <xsl:text>|</xsl:text>
                                    </xsl:element>
                                    <xsl:apply-templates select="child::tei:orig[attribute::type='alt2']"/>
                                    <xsl:element name="SUP">
                                        <xsl:attribute name="style">color: #0000FF;</xsl:attribute>
                                        <xsl:text>h</xsl:text>
                                    </xsl:element>
                                </xsl:element>
                            </xsl:when>
                            <xsl:when test="contains($visning, 'norm')">
                                <xsl:apply-templates select="child::tei:orig[attribute::type='alt2']"/>
                            </xsl:when>
                            <xsl:otherwise/>
                        </xsl:choose>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="attribute::type='dsl_H1'">
                <xsl:choose>
                    <xsl:when test="$handwriting = 'off'"></xsl:when>
                    <xsl:otherwise>
                        <xsl:choose>
                            <xsl:when test="contains($visning, 'dipl')">
                                <!--<xsl:for-each select="child::tei:orig">-->
                                    <xsl:apply-templates/>
                                <!--</xsl:for-each>-->
                            </xsl:when>
                            <xsl:when test="contains($visning, 'study')">
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">background-color: #FFFF00;</xsl:attribute>
                                    <xsl:apply-templates select="child::tei:orig[attribute::type='alt1']"/>
                                    <xsl:element name="SPAN">
                                        <xsl:attribute name="style">color: #0000FF;</xsl:attribute>
                                        <xsl:text>|</xsl:text>
                                    </xsl:element>
                                    <xsl:apply-templates select="child::tei:orig[attribute::type='alt2']"/>
                                    <xsl:element name="SUP">
                                        <xsl:attribute name="style">color: #0000FF;</xsl:attribute>
                                        <xsl:text>h</xsl:text>
                                    </xsl:element>
                                </xsl:element>
                            </xsl:when>
                            <xsl:when test="contains($visning, 'norm')">
                                <xsl:apply-templates select="child::tei:orig[attribute::type='alt2']"/>
                            </xsl:when>
                            <xsl:otherwise/>
                        </xsl:choose>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="attribute::type='dsl-em'">
                <xsl:choose>
                    <xsl:when test="contains($visning, 'dipl')">
                        <xsl:apply-templates select="child::tei:orig[attribute::type='em1']"/>
                    </xsl:when>
                    <xsl:when test="contains($visning, 'study')">
                        <xsl:apply-templates select="child::tei:orig[attribute::type='em2']"/>
                    </xsl:when>
                    <xsl:when test="contains($visning, 'norm')">
                        <xsl:apply-templates select="child::tei:orig[attribute::type='em2']"/>
                    </xsl:when>
                    <xsl:otherwise/>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="attribute::type='em'">
                <xsl:choose>
                    <xsl:when test="contains($visning, 'dipl')">
                        <xsl:apply-templates select="child::tei:orig[attribute::type='em1']"/>
                    </xsl:when>
                    <xsl:when test="contains($visning, 'study')">
                        <xsl:element name="SPAN">
                            <xsl:attribute name="style">color: #009900;</xsl:attribute>
                            <xsl:text>{</xsl:text>
                        </xsl:element>
                        <xsl:apply-templates select="child::tei:orig[attribute::type='em2']"/>
                        <xsl:element name="SPAN">
                            <xsl:attribute name="style">color: #009900;</xsl:attribute>
                            <xsl:text>}</xsl:text>
                        </xsl:element>
                    </xsl:when>
                    <xsl:when test="contains($visning, 'norm')">
                        <xsl:apply-templates select="child::tei:orig[attribute::type='em2']"/>
                    </xsl:when>
                    <xsl:otherwise/>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="attribute::type='o'">
                <xsl:choose>
                    <xsl:when test="contains($visning, 'dipl')">
                        <xsl:element name="SPAN">
                            <xsl:attribute name="style">color: brown;</xsl:attribute>
                            <xsl:text>[</xsl:text>
                        </xsl:element>
                            <xsl:apply-templates select="child::tei:orig[attribute::type='o1']"/>
                        <xsl:element name="SPAN">
                            <xsl:attribute name="style">color: brown;</xsl:attribute>
                            <xsl:text>|</xsl:text>
                        </xsl:element>
                        <xsl:apply-templates select="child::tei:orig[attribute::type='o2']"/>
                        <xsl:element name="SPAN">
                            <xsl:attribute name="style">color: brown;</xsl:attribute>
                            <xsl:text>]</xsl:text>
                        </xsl:element>
                    </xsl:when>
                    <xsl:when test="contains($visning, 'study')">
                        <xsl:apply-templates select="child::tei:orig[attribute::type='o2']"/>
                    </xsl:when>
                    <xsl:when test="contains($visning, 'norm')">
                        <xsl:apply-templates select="child::tei:orig[attribute::type='o2']"/>
                    </xsl:when>
                    <xsl:otherwise/>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="attribute::type='o_c'">
                <xsl:choose>
                    <xsl:when test="contains($visning, 'dipl')">
                        <xsl:element name="SPAN">
                            <xsl:attribute name="style">color: brown;</xsl:attribute>
                            <xsl:text>[</xsl:text>
                        </xsl:element>
                        <xsl:apply-templates select="child::tei:orig[attribute::type='o_c1']"/>
                        <xsl:element name="SPAN">
                            <xsl:attribute name="style">color: brown;</xsl:attribute>
                            <xsl:text>|</xsl:text>
                        </xsl:element>
                        <xsl:apply-templates select="child::tei:orig[attribute::type='o_c2']"/>
                        <xsl:element name="SPAN">
                            <xsl:attribute name="style">color: brown;</xsl:attribute>
                            <xsl:text>]</xsl:text>
                        </xsl:element>
                        <xsl:element name="SPAN">
                            <xsl:attribute name="style">color: #FF0000;</xsl:attribute>
                            <xsl:element name="SUP">
                                <xsl:text>[c]</xsl:text>
                            </xsl:element>
                        </xsl:element>
                    </xsl:when>
                    <xsl:when test="contains($visning, 'study')">
                        <xsl:apply-templates select="child::tei:orig[attribute::type='o_c2']"/>
                    </xsl:when>
                    <xsl:when test="contains($visning, 'norm')">
                        <xsl:apply-templates select="child::tei:orig[attribute::type='o_c2']"/>
                    </xsl:when>
                    <xsl:otherwise/>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="attribute::type='o_h'">
                <xsl:choose>
                    <xsl:when test="$handwriting = 'off'">
                        <xsl:apply-templates select="child::tei:orig[attribute::type='o1']"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:choose>
                            <xsl:when test="contains($visning, 'dipl')">
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">color: brown;</xsl:attribute>
                                    <xsl:text>[</xsl:text>
                                </xsl:element>
                                <xsl:element name="SPAN">
                                    <xsl:apply-templates select="child::tei:orig[attribute::type='o1']"/>
                                </xsl:element>
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">color: brown;</xsl:attribute>
                                    <xsl:text>|</xsl:text>
                                </xsl:element>
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">color: #0000FF;</xsl:attribute>
                                    <xsl:apply-templates select="child::tei:orig[attribute::type='o2']"/>
                                </xsl:element>
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">color: brown;</xsl:attribute>
                                    <xsl:text>]</xsl:text>
                                </xsl:element>
                            </xsl:when>
                            <xsl:when test="contains($visning, 'study')">
                                <xsl:apply-templates select="child::tei:orig[attribute::type='o2']"/>
                            </xsl:when>
                            <xsl:when test="contains($visning, 'norm')">
                                <xsl:apply-templates select="child::tei:orig[attribute::type='o2']"/>
                            </xsl:when>
                            <xsl:otherwise/>
                        </xsl:choose>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="attribute::type='o_H1'"><!-- Sjekk visning -->
                <xsl:choose>
                    <xsl:when test="$handwriting = 'off'"></xsl:when>
                    <xsl:otherwise>
                        <xsl:choose>
                            <xsl:when test="contains($visning, 'dipl')">
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">color: brown;</xsl:attribute>
                                    <xsl:text>[</xsl:text>
                                </xsl:element>
                                <xsl:element name="SPAN">
                                    <xsl:apply-templates select="child::tei:orig[attribute::type='o_H11']"/>
                                </xsl:element>
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">color: brown;</xsl:attribute>
                                    <xsl:text>|</xsl:text>
                                </xsl:element>
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">color: #0000FF;</xsl:attribute>
                                    <xsl:apply-templates select="child::tei:orig[attribute::type='o_H12']"/>
                                </xsl:element>
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">color: brown;</xsl:attribute>
                                    <xsl:text>]</xsl:text>
                                </xsl:element>
                            </xsl:when>
                            <xsl:when test="contains($visning, 'study')">
                                <xsl:apply-templates select="child::tei:orig[attribute::type='o_H12']"/>
                            </xsl:when>
                            <xsl:when test="contains($visning, 'norm')">
                                <xsl:apply-templates select="child::tei:orig[attribute::type='o_H12']"/>
                            </xsl:when>
                            <xsl:otherwise/>
                        </xsl:choose>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="attribute::type='on'">
                <xsl:choose>
                    <xsl:when test="contains($visning, 'dipl')">
                        <xsl:element name="SPAN">
                            <xsl:attribute name="style">color: brown;</xsl:attribute>
                            <xsl:text>[</xsl:text>
                        </xsl:element>
                        <xsl:apply-templates select="child::tei:orig[attribute::type='on1']"/>
                        <xsl:element name="SPAN">
                            <xsl:attribute name="style">color: brown;</xsl:attribute>
                            <xsl:text>|</xsl:text>
                        </xsl:element>
                        <xsl:apply-templates select="child::tei:orig[attribute::type='on2']"/>
                        <xsl:element name="SPAN">
                            <xsl:attribute name="style">color: brown;</xsl:attribute>
                            <xsl:text>]</xsl:text>
                        </xsl:element>
                    </xsl:when>
                    <xsl:when test="contains($visning, 'study')">
                        <xsl:apply-templates select="child::tei:orig[attribute::type='on2']"/>
                    </xsl:when>
                    <xsl:when test="contains($visning, 'norm')">
                        <xsl:apply-templates select="child::tei:orig[attribute::type='on2']"/>
                    </xsl:when>
                    <xsl:otherwise/>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="attribute::type='on_h'">
                <xsl:choose>
                    <xsl:when test="$handwriting = 'off'"></xsl:when>
                    <xsl:otherwise>
                        <xsl:choose>
                            <xsl:when test="contains($visning, 'dipl')">
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">color: brown;</xsl:attribute>
                                    <xsl:text>[</xsl:text>
                                </xsl:element>
                                <xsl:apply-templates
                                    select="child::tei:orig[attribute::type='on1_h']"/>
                                <!-- Alois vurder om det ikke skal hete on1_h og on2_h -->
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">color: brown;</xsl:attribute>
                                    <xsl:text>|</xsl:text>
                                </xsl:element>
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">color: #0000FF;</xsl:attribute>
                                    <xsl:apply-templates
                                        select="child::tei:orig[attribute::type='on2_h']"/>
                                    <!-- Alois vurder om det ikke skal hete on1_h og on2_h -->
                                </xsl:element>
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">color: brown;</xsl:attribute>
                                    <xsl:text>]</xsl:text>
                                </xsl:element>
                                <xsl:element name="SUP">
                                    <xsl:attribute name="style">color: #0000FF;</xsl:attribute>
                                    <xsl:text>h</xsl:text>
                                </xsl:element>
                            </xsl:when>
                            <xsl:when test="contains($visning, 'study')">
                                <xsl:apply-templates
                                    select="child::tei:orig[attribute::type='on2']"/>
                            </xsl:when>
                            <xsl:when test="contains($visning, 'norm')">
                                <xsl:apply-templates select="child::tei:orig[attribute::type='on2']"/>
                            </xsl:when>
                            <xsl:otherwise/>
                        </xsl:choose>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="attribute::type='on_S1'">
                <xsl:choose>
                    <xsl:when test="$handwriting = 'off'"></xsl:when>
                    <xsl:otherwise>
                        <xsl:choose>
                            <xsl:when test="contains($visning, 'dipl')">
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">color: brown;</xsl:attribute>
                                    <xsl:text>[</xsl:text>
                                </xsl:element>
                                <xsl:apply-templates select="child::tei:orig[attribute::type='on_S11']"/>
                                <!-- Alois vurder om det ikke skal hete on1_h og on2_h -->
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">color: brown;</xsl:attribute>
                                    <xsl:text>|</xsl:text>
                                </xsl:element>
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">color: #0000FF;</xsl:attribute>
                                    <xsl:apply-templates select="child::tei:orig[attribute::type='on_S12']"/>
                                    <!-- Alois vurder om det ikke skal hete on1_h og on2_h -->
                                </xsl:element>
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">color: brown;</xsl:attribute>
                                    <xsl:text>]</xsl:text>
                                </xsl:element>
                                <xsl:element name="SUP">
                                    <xsl:attribute name="style">color: #0000FF;</xsl:attribute>
                                    <xsl:text>S1</xsl:text>
                                </xsl:element>
                            </xsl:when>
                            <xsl:when test="contains($visning, 'study')">
                                <xsl:apply-templates
                                    select="child::tei:orig[attribute::type='on_S12']"/>
                            </xsl:when>
                            <xsl:when test="contains($visning, 'norm')">
                                <xsl:apply-templates select="child::tei:orig[attribute::type='on_S12']"/>
                            </xsl:when>
                            <xsl:otherwise/>
                        </xsl:choose>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="attribute::type='oncr_h'">
                <xsl:choose>
                    <xsl:when test="$handwriting = 'off'"></xsl:when>
                    <xsl:otherwise>
                        <xsl:choose>
                            <xsl:when test="contains($visning, 'dipl')">
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">color: brown;</xsl:attribute>
                                    <xsl:text>[</xsl:text>
                                </xsl:element>
                                <xsl:apply-templates
                                    select="child::tei:orig[attribute::type='oncr1_h']"/>
                                <!-- Alois vurder om det ikke skal hete on1_h og on2_h -->
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">color: brown;</xsl:attribute>
                                    <xsl:text>|</xsl:text>
                                </xsl:element>
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">color: #0000FF;</xsl:attribute>
                                    <xsl:apply-templates
                                        select="child::tei:orig[attribute::type='oncr2_h']"/>
                                    <!-- Alois vurder om det ikke skal hete on1_h og on2_h -->
                                </xsl:element>
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">color: brown;</xsl:attribute>
                                    <xsl:text>]</xsl:text>
                                </xsl:element>
                                <xsl:element name="SUP">
                                    <xsl:attribute name="style">color: #0000FF;</xsl:attribute>
                                    <xsl:text>h</xsl:text>
                                </xsl:element>
                            </xsl:when>
                            <xsl:when test="contains($visning, 'study')">
                                <xsl:apply-templates
                                    select="child::tei:orig[attribute::type='oncr2']"/>
                            </xsl:when>
                            <xsl:when test="contains($visning, 'norm')">
                                <xsl:apply-templates select="child::tei:orig[attribute::type='oncr2']"/>
                            </xsl:when>
                            <xsl:otherwise/>
                        </xsl:choose>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="attribute::type='os'"><!-- Sjekk visning -->
                <xsl:choose>
                    <xsl:when test="contains($visning, 'dipl')">
                        <xsl:element name="SPAN">
                            <xsl:attribute name="style">color: brown;</xsl:attribute>
                            <xsl:text>[</xsl:text>
                        </xsl:element>
                        <xsl:apply-templates select="child::tei:orig[attribute::type='os1']"/>
                        <xsl:element name="SPAN">
                            <xsl:attribute name="style">color: brown;</xsl:attribute>
                            <xsl:text>|</xsl:text>
                        </xsl:element>
                        <xsl:apply-templates select="child::tei:orig[attribute::type='os2']"/>
                        <xsl:element name="SPAN">
                            <xsl:attribute name="style">color: brown;</xsl:attribute>
                            <xsl:text>]</xsl:text>
                        </xsl:element>
                    </xsl:when>
                    <xsl:when test="contains($visning, 'study')">
                        <xsl:apply-templates select="child::tei:orig[attribute::type='os2']"/>
                    </xsl:when>
                    <xsl:when test="contains($visning, 'norm')">
                        <xsl:apply-templates select="child::tei:orig[attribute::type='os2']"/>
                    </xsl:when>
                    <xsl:otherwise/>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="attribute::type='os_h'">
                <xsl:choose>
                    <xsl:when test="$handwriting = 'off'">
                        <xsl:apply-templates select="child::tei:orig[attribute::type='os1']"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:choose>
                            <xsl:when test="contains($visning, 'dipl')">
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">color: brown;</xsl:attribute>
                                    <xsl:text>[</xsl:text>
                                </xsl:element>
                                <xsl:element name="SPAN">
                                    <xsl:apply-templates select="child::tei:orig[attribute::type='os1']"/>
                                </xsl:element>
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">color: brown;</xsl:attribute>
                                    <xsl:text>|</xsl:text>
                                </xsl:element>
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">color: #0000FF;</xsl:attribute>
                                    <xsl:apply-templates select="child::tei:orig[attribute::type='os2']"/>
                                </xsl:element>
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">color: brown;</xsl:attribute>
                                    <xsl:text>]</xsl:text>
                                </xsl:element>
                            </xsl:when>
                            <xsl:when test="contains($visning, 'study')">
                                <xsl:apply-templates select="child::tei:orig[attribute::type='os2']"/>
                            </xsl:when>
                            <xsl:when test="contains($visning, 'norm')">
                                <xsl:apply-templates select="child::tei:orig[attribute::type='os2']"/>
                            </xsl:when>
                            <xsl:otherwise/>
                        </xsl:choose>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>   
            <xsl:when test="attribute::type='ospace'">
                <xsl:choose>
                    <xsl:when test="contains($visning, 'dipl')">
                        <xsl:element name="SPAN">
                            <xsl:attribute name="style">color: brown;</xsl:attribute>
                            <xsl:text>[</xsl:text>
                        </xsl:element>
                        <xsl:apply-templates select="child::tei:orig[attribute::type='ospace1']"/>
                        <xsl:element name="SPAN">
                            <xsl:attribute name="style">color: brown;</xsl:attribute>
                            <xsl:text>|</xsl:text>
                        </xsl:element>
                        <xsl:apply-templates select="child::tei:orig[attribute::type='ospace2']"/>
                        <xsl:element name="SPAN">
                            <xsl:attribute name="style">color: brown;</xsl:attribute>
                            <xsl:text>]</xsl:text>
                        </xsl:element>
                    </xsl:when>
                    <xsl:when test="contains($visning, 'study')">
                        <xsl:apply-templates select="child::tei:orig[attribute::type='ospace2']"/>
                    </xsl:when>
                    <xsl:when test="contains($visning, 'norm')">
                        <xsl:apply-templates select="child::tei:orig[attribute::type='ospace2']"/>
                    </xsl:when>
                    <xsl:otherwise/>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="attribute::type='s'">
                <xsl:choose>
                    <xsl:when test="contains($visning, 'dipl')">
                        <!--<xsl:for-each select="child::tei:orig">-->
                            <xsl:apply-templates/>
                        <!--</xsl:for-each>-->
                    </xsl:when>
                    <xsl:when test="contains($visning, 'study')">
                        <xsl:element name="SPAN">
                            <xsl:attribute name="style">background-color: #FFFF00;</xsl:attribute>
                            <xsl:for-each select="child::tei:orig">
                                <xsl:apply-templates/>
                                <xsl:if test="following-sibling::tei:orig">
                                    <xsl:element name="SPAN">
                                        <xsl:text>|</xsl:text>
                                    </xsl:element>
                                </xsl:if>
                            </xsl:for-each>
                        </xsl:element>
                    </xsl:when>
                    <xsl:when test="contains($visning, 'norm')">
                        <xsl:element name="SPAN">
                            <xsl:attribute name="style">background-color: #FFFF00;</xsl:attribute>
                            <xsl:for-each select="child::tei:orig">
                                <xsl:apply-templates/>
                                <xsl:if test="following-sibling::tei:orig">
                                    <xsl:element name="SPAN">
                                        <xsl:text>|</xsl:text>
                                    </xsl:element>
                                </xsl:if>
                            </xsl:for-each>
                        </xsl:element>
                    </xsl:when>
                    <xsl:otherwise/>
                </xsl:choose>
            </xsl:when>
        	<xsl:when test="attribute::type='s_h'">
        		<xsl:choose>
        			<xsl:when test="contains($visning, 'dipl')">
        				<!--<xsl:for-each select="child::tei:orig">-->
        					<xsl:apply-templates/>
        				<!--</xsl:for-each>-->
        			</xsl:when>
        			<xsl:when test="contains($visning, 'study')">
        				<xsl:element name="SPAN">
        					<xsl:attribute name="style">background-color: #FFFF00;</xsl:attribute>
        					<xsl:for-each select="child::tei:orig">
        						<xsl:apply-templates/>
        						<xsl:if test="following-sibling::tei:orig">
        							<xsl:element name="SPAN">
        								<xsl:attribute name="style">color: #0000FF;</xsl:attribute>
        								<xsl:text>|</xsl:text>
        							</xsl:element>
        						</xsl:if>
        					</xsl:for-each>
        				</xsl:element>
        			</xsl:when>
        			<xsl:when test="contains($visning, 'norm')">
        				<xsl:element name="SPAN">
        					<xsl:attribute name="style">background-color: #FFFF00;</xsl:attribute>
        					<xsl:for-each select="child::tei:orig">
        						<xsl:apply-templates/>
        						<xsl:if test="following-sibling::tei:orig">
        							<xsl:element name="SPAN">
        								<xsl:attribute name="style">color: #0000FF;</xsl:attribute>
        								<xsl:text>|</xsl:text>
        							</xsl:element>
        						</xsl:if>
        					</xsl:for-each>
        				</xsl:element>
        			</xsl:when>
        			<xsl:otherwise/>
        		</xsl:choose>
        	</xsl:when>
            <xsl:when test="attribute::type='s_S1'">
                <xsl:choose>
                    <xsl:when test="contains($visning, 'dipl')">
                        <!--<xsl:for-each select="child::tei:orig">-->
                            <xsl:apply-templates/>
                        <!--</xsl:for-each>-->
                    </xsl:when>
                    <xsl:when test="contains($visning, 'study')">
                        <xsl:element name="SPAN">
                            <xsl:attribute name="style">background-color: #FFFF00;</xsl:attribute>
                            <xsl:for-each select="child::tei:orig">
                                <xsl:apply-templates/>
                                <xsl:if test="following-sibling::tei:orig">
                                    <xsl:element name="SPAN">
                                        <xsl:attribute name="style">color: #0000FF;</xsl:attribute>
                                        <xsl:text>|</xsl:text>
                                    </xsl:element>
                                </xsl:if>
                            </xsl:for-each>
                        </xsl:element>
                    </xsl:when>
                    <xsl:when test="contains($visning, 'norm')">
                        <xsl:element name="SPAN">
                            <xsl:attribute name="style">background-color: #FFFF00;</xsl:attribute>
                            <xsl:for-each select="child::tei:orig">
                                <xsl:apply-templates/>
                                <xsl:if test="following-sibling::tei:orig">
                                    <xsl:element name="SPAN">
                                        <xsl:attribute name="style">color: #0000FF;</xsl:attribute>
                                        <xsl:text>|</xsl:text>
                                    </xsl:element>
                                </xsl:if>
                            </xsl:for-each>
                        </xsl:element>
                    </xsl:when>
                    <xsl:otherwise/>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates/>
            </xsl:otherwise>
        </xsl:choose>
	</xsl:template>
	
	<xsl:template match="tei:orig">
		<xsl:choose>
			<xsl:when test="attribute::type='o1'">
				<xsl:element name="SPAN">
					<xsl:attribute name="style">text-decoration: line-through;</xsl:attribute>
					<xsl:apply-templates/>
				</xsl:element>
			</xsl:when>
		    <xsl:when test="attribute::type='o2'">
		        <xsl:element name="SPAN">
		            <xsl:choose>
		                <xsl:when test="$visning='norm'"></xsl:when>
		                <xsl:otherwise>
		                    <xsl:attribute name="style">font-weight: bold;</xsl:attribute>
		                </xsl:otherwise>
		            </xsl:choose>
		            <xsl:apply-templates/>
		        </xsl:element>
		    </xsl:when>
			<xsl:when test="attribute::type='on1'">
				<xsl:element name="SPAN">
					<xsl:attribute name="style">text-decoration: line-through;</xsl:attribute>
					<xsl:apply-templates/>
				</xsl:element>
			</xsl:when>
			<xsl:when test="attribute::type='on1_h'">
				<xsl:choose>
					<xsl:when test="$handwriting = 'off'"></xsl:when>
					<xsl:otherwise>
						<xsl:element name="SPAN">
							<xsl:apply-templates/>
						</xsl:element>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="attribute::type='on2_h'">
				<xsl:choose>
					<xsl:when test="$handwriting = 'off'"></xsl:when>
					<xsl:otherwise>
						<xsl:element name="SPAN">
							<xsl:apply-templates/>
						</xsl:element>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="attribute::type='on_S11'">
				<xsl:choose>
					<xsl:when test="$handwriting = 'off'"></xsl:when>
					<xsl:otherwise>
						<xsl:element name="SPAN">
							<xsl:apply-templates/>
						</xsl:element>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="attribute::type='on_S12'">
				<xsl:choose>
					<xsl:when test="$handwriting = 'off'"></xsl:when>
					<xsl:otherwise>
						<xsl:element name="SPAN">
							<xsl:apply-templates/>
						</xsl:element>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="attribute::type='oncr1_h'">
				<xsl:element name="SPAN">
					<xsl:attribute name="style">text-decoration: line-through;</xsl:attribute>
					<xsl:apply-templates/>
				</xsl:element>
			</xsl:when>
			<xsl:when test="attribute::type='oncr2_h'">
				<xsl:element name="SPAN">
					<xsl:attribute name="style">text-decoration: line-through;</xsl:attribute>
					<xsl:apply-templates/>
				</xsl:element>
			</xsl:when>
			<xsl:when test="attribute::type='os1'">
				<xsl:element name="SPAN">
					<xsl:attribute name="style">text-decoration: line-through;</xsl:attribute>
					<xsl:apply-templates/>
				</xsl:element>
			</xsl:when>
			<xsl:when test="attribute::type='os2'">
				<xsl:element name="SPAN">
					<xsl:choose>
						<xsl:when test="$visning='norm'"></xsl:when>
						<xsl:otherwise>
							<xsl:attribute name="style">font-weight: bold;</xsl:attribute>
						</xsl:otherwise>
					</xsl:choose>
					<xsl:apply-templates/>
				</xsl:element>
			</xsl:when>
			<xsl:when test="attribute::type='alt1' and parent::tei:choice[attribute::type='dsl']">
				<xsl:element name="SPAN">
					<xsl:attribute name="style">text-decoration: line-through;</xsl:attribute>
					<xsl:apply-templates/>
				</xsl:element>
			</xsl:when>
			<xsl:when test="attribute::type='alt1' and parent::tei:choice[attribute::type='co']">
    			<xsl:apply-templates/>
			</xsl:when>
			<xsl:when test="attribute::type='alt2' and parent::tei:choice[attribute::type='dsf']">
				<xsl:element name="SPAN">
					<xsl:attribute name="style">text-decoration: line-through;</xsl:attribute>
					<xsl:apply-templates/>
				</xsl:element>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	
	<!-- Corrections, deletions, additions and insertions -->
	
    <xsl:template match="tei:corr">
        <xsl:choose>
            <xsl:when test="attribute::type='npc'">
                <xsl:choose>
                    <xsl:when test="contains($visning, 'dipl')">
                        <xsl:choose>
                            <xsl:when test="contains($npc, 'study')">
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">color: #FF0000;</xsl:attribute>
                                    <xsl:text>&#x2026;</xsl:text>
                                </xsl:element>
                            </xsl:when>
                            <xsl:when test="contains($npc, 'norm')">
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">color: #FF0000;</xsl:attribute>
                                    <xsl:text>&#x2026;</xsl:text>
                                </xsl:element>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:apply-templates/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:when test="contains($visning, 'study')">
                        <xsl:choose>
                            <xsl:when test="contains($npc, 'dipl')">
                                <xsl:apply-templates/>
                            </xsl:when>
                            <xsl:when test="contains($npc, 'norm')">
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">color: #FF0000;</xsl:attribute>
                                    <xsl:text>&#x2026;</xsl:text>
                                </xsl:element>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">color: #FF0000;</xsl:attribute>
                                    <xsl:text>&#x2026;</xsl:text>
                                </xsl:element>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:when test="contains($visning, 'norm')">
                        <xsl:choose>
                            <xsl:when test="contains($npc, 'dipl')">
                                <xsl:apply-templates/>
                            </xsl:when>
                            <xsl:when test="contains($npc, 'study')">
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">color: #FF0000;</xsl:attribute>
                                    <xsl:text>&#x2026;</xsl:text>
                                </xsl:element>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">color: #FF0000;</xsl:attribute>
                                    <xsl:text>&#x2026;</xsl:text>
                                </xsl:element>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:otherwise/>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="attribute::type='npcn'">
                <xsl:choose>
                    <xsl:when test="contains($visning, 'dipl')">
                        <xsl:choose>
                            <xsl:when test="contains($npcn, 'study')">
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">color: #FF0000;</xsl:attribute>
                                    <xsl:text>&#x2026;</xsl:text>
                                </xsl:element>
                            </xsl:when>
                            <xsl:when test="contains($npcn, 'norm')">
                                <xsl:element name="SPAN">
                                </xsl:element>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:apply-templates/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:when test="contains($visning, 'study')">
                        <xsl:choose>
                            <xsl:when test="contains($npcn, 'dipl')">
                                <xsl:apply-templates/>
                            </xsl:when>
                            <xsl:when test="contains($npcn, 'norm')">
                                <xsl:element name="SPAN">
                                </xsl:element>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">color: #FF0000;</xsl:attribute>
                                    <xsl:text>&#x2026;</xsl:text>
                                </xsl:element>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:when test="contains($visning, 'norm')">
                        <xsl:choose>
                            <xsl:when test="contains($npcn, 'dipl')">
                                <xsl:apply-templates/>
                            </xsl:when>
                            <xsl:when test="contains($npcn, 'study')">
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">color: #FF0000;</xsl:attribute>
                                    <xsl:text>&#x2026;</xsl:text>
                                </xsl:element>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:element name="SPAN">
                                </xsl:element>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:otherwise/>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="attribute::type='tra'">
                <xsl:choose>
                    <xsl:when test="contains($visning, 'dipl')">
                        <xsl:choose>
                            <xsl:when test="contains($tra, 'study')">
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">color: #FF0000;</xsl:attribute>
                                    <xsl:apply-templates/>
                                </xsl:element>
                            </xsl:when>
                            <xsl:when test="contains($tra, 'norm')">
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">color: #FF0000;</xsl:attribute>
                                    <xsl:apply-templates/>
                                </xsl:element>
                            </xsl:when>
                            <xsl:otherwise/>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:when test="contains($visning, 'study')">
                        <xsl:choose>
                            <xsl:when test="contains($tra, 'dipl')"/>
                            <xsl:when test="contains($tra, 'norm')">
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">color: #FF0000;</xsl:attribute>
                                    <xsl:apply-templates/>
                                </xsl:element>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">color: #FF0000;</xsl:attribute>
                                    <xsl:apply-templates/>
                                </xsl:element>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:when test="contains($visning, 'norm')">
                        <xsl:choose>
                            <xsl:when test="contains($tra, 'dipl')"/>
                            <xsl:when test="contains($tra, 'study')">
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">color: #FF0000;</xsl:attribute>
                                    <xsl:apply-templates/>
                                </xsl:element>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">color: #FF0000;</xsl:attribute>
                                    <xsl:apply-templates/>
                                </xsl:element>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:otherwise/>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="attribute::type='tran'">
                <xsl:choose>
                    <xsl:when test="contains($visning, 'dipl')">
                        <xsl:choose>
                            <xsl:when test="contains($tran, 'study')">
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">color: #FF0000;</xsl:attribute>
                                    <xsl:apply-templates/>
                                </xsl:element>
                            </xsl:when>
                            <xsl:when test="contains($tran, 'norm')">
                                <xsl:element name="SPAN">
                                    <xsl:apply-templates/>
                                </xsl:element>
                            </xsl:when>
                            <xsl:otherwise/>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:when test="contains($visning, 'study')">
                        <xsl:choose>
                            <xsl:when test="contains($tran, 'dipl')"/>
                            <xsl:when test="contains($tran, 'norm')">
                                <xsl:element name="SPAN">
                                    <xsl:apply-templates/>
                                </xsl:element>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">color: #FF0000;</xsl:attribute>
                                    <xsl:apply-templates/>
                                </xsl:element>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:when test="contains($visning, 'norm')">
                        <xsl:choose>
                            <xsl:when test="contains($tran, 'dipl')"/>
                            <xsl:when test="contains($tran, 'study')">
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">color: #FF0000;</xsl:attribute>
                                    <xsl:apply-templates/>
                                </xsl:element>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:element name="SPAN">
                                    <xsl:apply-templates/>
                                </xsl:element>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:otherwise/>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="attribute::type='trco'">
                <xsl:choose>
                    <xsl:when test="contains($visning, 'dipl')">
                        <xsl:apply-templates select="child::tei:orig[attribute::type='trco1']"/>
                    </xsl:when>
                    <xsl:when test="contains($visning, 'study')">
                        <xsl:element name="SPAN">
                            <xsl:attribute name="style">color: #FF0000;</xsl:attribute>
                            <xsl:apply-templates select="child::tei:reg[attribute::type='trco2']"/>
                        </xsl:element>
                    </xsl:when>
                    <xsl:when test="contains($visning, 'norm')">
                        <xsl:element name="SPAN">
                            <xsl:attribute name="style">color: #FF0000;</xsl:attribute>
                            <xsl:apply-templates select="child::tei:reg[attribute::type='trco2']"/>
                        </xsl:element>
                    </xsl:when>
                    <xsl:otherwise/>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="attribute::type='trcon'">
                <xsl:choose>
                    <xsl:when test="contains($visning, 'dipl')">
                        <xsl:apply-templates select="child::tei:orig[attribute::type='trcon1']"/>
                    </xsl:when>
                    <xsl:when test="contains($visning, 'study')">
                        <xsl:element name="SPAN">
                            <xsl:attribute name="style">color: #FF0000;</xsl:attribute>
                            <xsl:apply-templates select="child::tei:reg[attribute::type='trcon2']"/>
                        </xsl:element>
                    </xsl:when>
                    <xsl:when test="contains($visning, 'norm')">
                        <xsl:element name="SPAN">
                            <xsl:attribute name="style">color: #FF0000;</xsl:attribute>
                            <xsl:apply-templates select="child::tei:reg[attribute::type='trcon2']"/>
                        </xsl:element>
                    </xsl:when>
                    <xsl:otherwise/>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="attribute::type='trs'">
                <xsl:choose>
                    <xsl:when test="contains($visning, 'dipl')">
                        <xsl:apply-templates select="child::tei:orig[attribute::type='trs1']"/>
                    </xsl:when>
                    <xsl:when test="contains($visning, 'study')">
                        <xsl:element name="SPAN">
                            <xsl:attribute name="style">color: #FF0000;</xsl:attribute>
                            <xsl:apply-templates select="child::tei:reg[attribute::type='trs2']"/>
                        </xsl:element>
                    </xsl:when>
                    <xsl:when test="contains($visning, 'norm')">
                        <xsl:element name="SPAN">
                            <xsl:attribute name="style">color: #FF0000;</xsl:attribute>
                            <xsl:apply-templates select="child::tei:reg[attribute::type='trs2']"/>
                        </xsl:element>
                    </xsl:when>
                    <xsl:otherwise/>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="attribute::type='trsn'">
                <xsl:choose>
                    <xsl:when test="contains($visning, 'dipl')">
                        <xsl:apply-templates select="child::tei:orig[attribute::type='trsn1']"/>
                    </xsl:when>
                    <xsl:when test="contains($visning, 'study')">
                        <xsl:element name="SPAN">
                            <xsl:attribute name="style">color: #FF0000;</xsl:attribute>
                            <xsl:apply-templates select="child::tei:reg[attribute::type='trsn2']"/>
                        </xsl:element>
                    </xsl:when>
                    <xsl:when test="contains($visning, 'norm')">
                        <xsl:element name="SPAN">
                            <xsl:apply-templates select="child::tei:reg[attribute::type='trsn2']"/>
                        </xsl:element>
                    </xsl:when>
                    <xsl:otherwise/>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
	
    <xsl:template match="tei:del">
        <xsl:choose>
            <xsl:when test="attribute::type='d'">
                <!-- Changes need to be reflected on ab as well -->
                <xsl:choose>
                    <xsl:when test="contains($visning, 'dipl')">
                        <xsl:choose>
                            <xsl:when test="contains($d, 'study')">
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">color: #000000; text-decoration: line-through;</xsl:attribute>
                                    <xsl:apply-templates/>
                                </xsl:element>
                            </xsl:when>
                            <xsl:when test="contains($d, 'norm')"></xsl:when>
                            <xsl:otherwise>
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">color: #000000; text-decoration: line-through;</xsl:attribute>
                                    <xsl:apply-templates/>
                                </xsl:element>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:when test="contains($visning, 'study')">
                        <xsl:choose>
                            <xsl:when test="contains($d, 'dipl')">
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">color: #000000; text-decoration: line-through;</xsl:attribute>
                                    <xsl:apply-templates/>
                                </xsl:element>
                            </xsl:when>
                            <xsl:when test="contains($d, 'norm')"></xsl:when>
                            <xsl:otherwise>
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">color: #000000; text-decoration: line-through;</xsl:attribute>
                                    <xsl:apply-templates/>
                                </xsl:element>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:when test="contains($visning, 'norm')">
                        <xsl:choose>
                            <xsl:when test="contains($d, 'dipl')">
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">color: #000000; text-decoration: line-through;</xsl:attribute>
                                    <xsl:apply-templates/>
                                </xsl:element>
                            </xsl:when>
                            <xsl:when test="contains($d, 'study')">
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">color: #000000; text-decoration: line-through;</xsl:attribute>
                                    <xsl:apply-templates/>
                                </xsl:element>
                            </xsl:when>
                            <xsl:otherwise/>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:otherwise/>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="attribute::type='d_c'">
                <xsl:choose>
                    <xsl:when test="contains($visning, 'dipl')">
                        <xsl:choose>
                            <xsl:when test="contains($d_c, 'study')">
                                <xsl:apply-templates/>
                            </xsl:when>
                            <xsl:when test="contains($d_c, 'norm')"/>
                            <xsl:otherwise>
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">color: #000000; text-decoration: line-through;</xsl:attribute>
                                    <xsl:apply-templates/>
                                </xsl:element>
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">vertical-align: super; color: #FF0000;</xsl:attribute>
                                    <xsl:text>c</xsl:text>
                                </xsl:element>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:when test="contains($visning, 'study')">
                        <xsl:choose>
                            <xsl:when test="contains($d_c, 'dipl')">
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">color: #000000; border-bottom-width: thin; border-bottom-color: #000000; border-bottom-style: dotted; text-decoration: line-through;</xsl:attribute>
                                    <xsl:apply-templates/>
                                </xsl:element>
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">vertical-align: super; color: #FF0000;</xsl:attribute>
                                    <xsl:text>c</xsl:text>
                                </xsl:element>
                            </xsl:when>
                            <xsl:when test="contains($d_c, 'norm')"/>
                            <xsl:otherwise>
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">color: #000000; border-bottom-width: thin; border-bottom-color: #000000; border-bottom-style: dotted; text-decoration: line-through;</xsl:attribute>
                                    <xsl:apply-templates/>
                                </xsl:element>
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">vertical-align: super; color: #FF0000;</xsl:attribute>
                                    <xsl:text>c</xsl:text>
                                </xsl:element>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:when test="contains($visning, 'norm')">
                        <xsl:choose>
                            <xsl:when test="contains($d_c, 'dipl')">
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">color: #000000; border-bottom-width: thin; border-bottom-color: #000000; border-bottom-style: dotted; text-decoration: line-through;</xsl:attribute>
                                    <xsl:apply-templates/>
                                </xsl:element>
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">vertical-align: super; color: #FF0000;</xsl:attribute>
                                    <xsl:text>c</xsl:text>
                                </xsl:element>
                            </xsl:when>
                            <xsl:when test="contains($d_c, 'study')">
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">color: #000000; border-bottom-width: thin; border-bottom-color: #000000; border-bottom-style: dotted; text-decoration: line-through;</xsl:attribute>
                                    <xsl:apply-templates/>
                                </xsl:element>
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">vertical-align: super; color: #FF0000;</xsl:attribute>
                                    <xsl:text>c</xsl:text>
                                </xsl:element>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:apply-templates/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:otherwise/>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="attribute::type='d_ch'">
                <xsl:choose>
                    <xsl:when test="contains($handwriting, 'off')"></xsl:when>
                    <xsl:otherwise>
                        <xsl:choose>
                            <xsl:when test="contains($visning, 'dipl')">
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">text-decoration: line-through; color: #000000;</xsl:attribute>
                                    <xsl:element name="SPAN">
                                        <xsl:attribute name="style">color: #000000;</xsl:attribute>
                                        <xsl:apply-templates/>
                                    </xsl:element>
                                </xsl:element>
                                <xsl:element name="SUP">
                                    <xsl:attribute name="style">color: #FF0000;</xsl:attribute>
                                    <xsl:text>ch</xsl:text>
                                </xsl:element>
                            </xsl:when>
                            <xsl:when test="contains($visning, 'study')">
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">text-decoration: line-through; color: #000000;</xsl:attribute>
                                    <xsl:element name="SPAN">
                                        <xsl:attribute name="style">color: #000000;</xsl:attribute>
                                        <xsl:apply-templates/>
                                    </xsl:element>
                                </xsl:element>
                                <xsl:element name="SUP">
                                    <xsl:attribute name="style">color: #FF0000;</xsl:attribute>
                                    <xsl:text>ch</xsl:text>
                                </xsl:element>
                            </xsl:when>
                            <xsl:when test="contains($visning, 'norm')">
                                <xsl:apply-templates/>
                            </xsl:when>
                            <xsl:otherwise/>
                        </xsl:choose>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="attribute::type='d_h'">
                <!-- Changes need to be reflected on ab as well -->
                <xsl:choose>
                    <xsl:when test="$handwriting = 'off'">
                        <xsl:apply-templates/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:choose>
                            <xsl:when test="contains($visning, 'dipl')">
                                <xsl:choose>
                                    <xsl:when test="contains($d, 'study')">
                                        <xsl:element name="SPAN">
                                            <xsl:attribute name="style">color: #0000FF; text-decoration: line-through;</xsl:attribute>
                                            <xsl:apply-templates/>
                                        </xsl:element>
                                    </xsl:when>
                                    <xsl:when test="contains($d, 'norm')"></xsl:when>
                                    <xsl:otherwise>
                                        <xsl:element name="SPAN">
                                            <xsl:attribute name="style">text-decoration: line-through; color: #0000FF;</xsl:attribute>
                                            <xsl:element name="SPAN">
                                                <!--<xsl:attribute name="style"><xsl:choose><xsl:when test="ancestor::node()[contains(attribute::rend, '_h')]"> color: #0000FF;</xsl:when><xsl:when test="ancestor::node()[attribute::rend='H' or attribute::rend='h']"> color: #0000FF;</xsl:when><xsl:otherwise>color: #000000;</xsl:otherwise></xsl:choose></xsl:attribute>-->
                                                <xsl:attribute name="style">
                                                    <xsl:choose>
                                                        <xsl:when test="ancestor::node()[contains(attribute::rend, '_h')]"> color: #0000FF;</xsl:when>
                                                        <xsl:when test="ancestor::node()[contains(attribute::add, '_h')]"> color: #0000FF;</xsl:when>
                                                        <xsl:when test="ancestor::node()[contains(attribute::rend, '_H')]"> color: #0000FF;</xsl:when>
                                                        <xsl:when test="ancestor::node()[contains(attribute::add, '_H')]"> color: #0000FF;</xsl:when>
                                                        <xsl:when test="ancestor::node()[contains(attribute::rend, 'H')]"> color: #0000FF;</xsl:when>
                                                        <xsl:when test="ancestor::node()[contains(attribute::add, 'H')]"> color: #0000FF;</xsl:when>
                                                        <xsl:otherwise>color: #000000;</xsl:otherwise>
                                                    </xsl:choose>
                                                </xsl:attribute>
                                                <xsl:apply-templates/>
                                            </xsl:element>
                                        </xsl:element>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:when>
                            <xsl:when test="contains($visning, 'study')">
                                <xsl:choose>
                                    <xsl:when test="contains($d, 'dipl')">
                                        <xsl:element name="SPAN">
                                            <xsl:attribute name="style">text-decoration: line-through; color: #0000FF;</xsl:attribute>
                                            <xsl:element name="SPAN">
                                                <xsl:attribute name="style">color: #000000;</xsl:attribute>
                                                <xsl:apply-templates/>
                                            </xsl:element>
                                        </xsl:element>
                                    </xsl:when>
                                    <xsl:when test="contains($d, 'norm')"></xsl:when>
                                    <xsl:otherwise>
                                        <xsl:element name="SPAN">
                                            <xsl:attribute name="style">color: #0000FF; text-decoration: line-through;</xsl:attribute>
                                            <xsl:apply-templates/>
                                        </xsl:element>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:when>
                            <xsl:when test="contains($visning, 'norm')">
                                <xsl:choose>
                                    <xsl:when test="contains($d, 'dipl')">
                                        <xsl:element name="SPAN">
                                            <xsl:attribute name="style">text-decoration: line-through; color: #0000FF;</xsl:attribute>
                                            <xsl:element name="SPAN">
                                                <xsl:attribute name="style">color: #000000;</xsl:attribute>
                                                <xsl:apply-templates/>
                                            </xsl:element>
                                        </xsl:element>
                                    </xsl:when>
                                    <xsl:when test="contains($d, 'study')">
                                        <xsl:element name="SPAN">
                                            <xsl:attribute name="style">color: #0000FF; text-decoration: line-through;</xsl:attribute>
                                            <xsl:apply-templates/>
                                        </xsl:element>
                                    </xsl:when>
                                    <xsl:otherwise/>
                                </xsl:choose>
                            </xsl:when>
                            <xsl:otherwise/>
                        </xsl:choose>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="attribute::type='d_H1'">
                <xsl:choose>
                    <xsl:when test="$handwriting = 'off'"></xsl:when>
                    <xsl:otherwise>
                        <xsl:choose>
                            <xsl:when test="contains($visning, 'dipl')">
                                <xsl:choose>
                                    <xsl:when test="contains($d, 'study')">
                                        <xsl:element name="SPAN">
                                            <xsl:attribute name="style">color: #0000FF; text-decoration: line-through;</xsl:attribute>
                                            <xsl:apply-templates/>
                                        </xsl:element>
                                    </xsl:when>
                                    <xsl:when test="contains($d, 'norm')"></xsl:when>
                                    <xsl:otherwise>
                                        <xsl:element name="SPAN">
                                            <xsl:attribute name="style">text-decoration: line-through; color: #0000FF;</xsl:attribute>
                                            <xsl:element name="SPAN">
                                                <xsl:attribute name="style"><xsl:choose><xsl:when test="ancestor::node()[contains(attribute::rend, '_h')]"> color: #0000FF;</xsl:when><xsl:when test="ancestor::node()[attribute::rend='H' or attribute::rend='h']"> color: #0000FF;</xsl:when><xsl:otherwise>color: #000000;</xsl:otherwise></xsl:choose></xsl:attribute>
                                                <xsl:apply-templates/>
                                            </xsl:element>
                                        </xsl:element>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:when>
                            <xsl:when test="contains($visning, 'study')">
                                <xsl:choose>
                                    <xsl:when test="contains($d, 'dipl')">
                                        <xsl:element name="SPAN">
                                            <xsl:attribute name="style">text-decoration: line-through; color: #0000FF;</xsl:attribute>
                                            <xsl:element name="SPAN">
                                                <xsl:attribute name="style">color: #000000;</xsl:attribute>
                                                <xsl:apply-templates/>
                                            </xsl:element>
                                        </xsl:element>
                                    </xsl:when>
                                    <xsl:when test="contains($d, 'norm')"></xsl:when>
                                    <xsl:otherwise>
                                        <xsl:element name="SPAN">
                                            <xsl:attribute name="style">color: #0000FF; text-decoration: line-through;</xsl:attribute>
                                            <xsl:apply-templates/>
                                        </xsl:element>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:when>
                            <xsl:when test="contains($visning, 'norm')">
                                <xsl:choose>
                                    <xsl:when test="contains($d, 'dipl')">
                                        <xsl:element name="SPAN">
                                            <xsl:attribute name="style">text-decoration: line-through; color: #0000FF;</xsl:attribute>
                                            <xsl:element name="SPAN">
                                                <xsl:attribute name="style">color: #000000;</xsl:attribute>
                                                <xsl:apply-templates/>
                                            </xsl:element>
                                        </xsl:element>
                                    </xsl:when>
                                    <xsl:when test="contains($d, 'study')">
                                        <xsl:element name="SPAN">
                                            <xsl:attribute name="style">color: #0000FF; text-decoration: line-through;</xsl:attribute>
                                            <xsl:apply-templates/>
                                        </xsl:element>
                                    </xsl:when>
                                    <xsl:otherwise/>
                                </xsl:choose>
                            </xsl:when>
                            <xsl:otherwise/>
                        </xsl:choose>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="attribute::type='d_h_c'">
                <xsl:choose>
                    <xsl:when test="$handwriting = 'off'"></xsl:when>
                    <xsl:otherwise>
                        <xsl:choose>
                            <xsl:when test="contains($visning, 'dipl')">
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">text-decoration: line-through;</xsl:attribute>
                                    <xsl:element name="SPAN">
                                        <xsl:attribute name="style">color: #000000;</xsl:attribute>
                                        <xsl:apply-templates/>
                                    </xsl:element>
                                </xsl:element>
                                <xsl:element name="SUP">
                                    <xsl:attribute name="style">color: #FF0000;</xsl:attribute>
                                    <xsl:text>c</xsl:text>
                                </xsl:element>
                            </xsl:when>
                            <xsl:when test="contains($visning, 'study')">
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">text-decoration: line-through;</xsl:attribute>
                                    <xsl:element name="SPAN">
                                        <xsl:attribute name="style">color: #000000;</xsl:attribute>
                                        <xsl:apply-templates/>
                                    </xsl:element>
                                </xsl:element>
                                <xsl:element name="SUP">
                                    <xsl:attribute name="style">color: #FF0000;</xsl:attribute>
                                    <xsl:text>c</xsl:text>
                                </xsl:element>
                            </xsl:when>
                            <xsl:when test="contains($visning, 'norm')">
                                <xsl:apply-templates/>
                            </xsl:when>
                            <xsl:otherwise/>
                        </xsl:choose>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="attribute::type='d_h_ch'">
                <xsl:choose>
                    <xsl:when test="$handwriting = 'off'">
                        <xsl:apply-templates/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:choose>
                            <xsl:when test="contains($visning, 'dipl')">
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">text-decoration: line-through; color: #0000FF;</xsl:attribute>
                                    <xsl:element name="SPAN">
                                        <xsl:attribute name="style">color: #000000;</xsl:attribute>
                                        <xsl:apply-templates/>
                                    </xsl:element>
                                </xsl:element>
                                <xsl:element name="SUP">
                                    <xsl:attribute name="style">color: #FF0000;</xsl:attribute>
                                    <xsl:text>ch</xsl:text>
                                </xsl:element>
                            </xsl:when>
                            <xsl:when test="contains($visning, 'study')">
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">text-decoration: line-through; color: #0000FF;</xsl:attribute>
                                    <xsl:element name="SPAN">
                                        <xsl:attribute name="style">color: #000000;</xsl:attribute>
                                        <xsl:apply-templates/>
                                    </xsl:element>
                                </xsl:element>
                                <xsl:element name="SUP">
                                    <xsl:attribute name="style">color: #FF0000;</xsl:attribute>
                                    <xsl:text>ch</xsl:text>
                                </xsl:element>
                            </xsl:when>
                            <xsl:when test="contains($visning, 'norm')">
                                <xsl:apply-templates/>
                            </xsl:when>
                            <xsl:otherwise/>
                        </xsl:choose>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="attribute::type='d_S1'">
                <xsl:choose>
                    <xsl:when test="$handwriting = 'off'"></xsl:when>
                    <xsl:otherwise>
                        <xsl:choose>
                            <xsl:when test="contains($visning, 'dipl')">
                                <xsl:choose>
                                    <xsl:when test="contains($d, 'study')">
                                        <xsl:element name="SPAN">
                                            <xsl:attribute name="style">color: #0000FF; text-decoration: line-through;</xsl:attribute>
                                            <xsl:apply-templates/>
                                        </xsl:element>
                                    </xsl:when>
                                    <xsl:when test="contains($d, 'norm')"></xsl:when>
                                    <xsl:otherwise>
                                        <xsl:element name="SPAN">
                                            <xsl:attribute name="style">text-decoration: line-through; color: #0000FF;</xsl:attribute>
                                            <xsl:element name="SPAN">
                                                <xsl:attribute name="style"><xsl:choose><xsl:when test="ancestor::node()[contains(attribute::rend, '_h')]"> color: #0000FF;</xsl:when><xsl:when test="ancestor::node()[attribute::rend='H' or attribute::rend='h']"> color: #0000FF;</xsl:when><xsl:otherwise>color: #000000;</xsl:otherwise></xsl:choose></xsl:attribute>
                                                <xsl:apply-templates/>
                                            </xsl:element>
                                        </xsl:element>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:when>
                            <xsl:when test="contains($visning, 'study')">
                                <xsl:choose>
                                    <xsl:when test="contains($d, 'dipl')">
                                        <xsl:element name="SPAN">
                                            <xsl:attribute name="style">text-decoration: line-through; color: #0000FF;</xsl:attribute>
                                            <xsl:element name="SPAN">
                                                <xsl:attribute name="style">color: #000000;</xsl:attribute>
                                                <xsl:apply-templates/>
                                            </xsl:element>
                                        </xsl:element>
                                    </xsl:when>
                                    <xsl:when test="contains($d, 'norm')"></xsl:when>
                                    <xsl:otherwise>
                                        <xsl:element name="SPAN">
                                            <xsl:attribute name="style">color: #0000FF; text-decoration: line-through;</xsl:attribute>
                                            <xsl:apply-templates/>
                                        </xsl:element>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:when>
                            <xsl:when test="contains($visning, 'norm')">
                                <xsl:choose>
                                    <xsl:when test="contains($d, 'dipl')">
                                        <xsl:element name="SPAN">
                                            <xsl:attribute name="style">text-decoration: line-through; color: #0000FF;</xsl:attribute>
                                            <xsl:element name="SPAN">
                                                <xsl:attribute name="style">color: #000000;</xsl:attribute>
                                                <xsl:apply-templates/>
                                            </xsl:element>
                                        </xsl:element>
                                    </xsl:when>
                                    <xsl:when test="contains($d, 'study')">
                                        <xsl:element name="SPAN">
                                            <xsl:attribute name="style">color: #0000FF; text-decoration: line-through;</xsl:attribute>
                                            <xsl:apply-templates/>
                                        </xsl:element>
                                    </xsl:when>
                                    <xsl:otherwise/>
                                </xsl:choose>
                            </xsl:when>
                            <xsl:otherwise/>
                        </xsl:choose>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="attribute::type='dn'">
                <xsl:choose>
                    <xsl:when test="contains($visning, 'dipl')">
                        <xsl:choose>
                            <xsl:when test="contains($dn, 'study')"/>
                            <xsl:when test="contains($dn, 'norm')"/>
                            <xsl:otherwise>
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">color: #000000; text-decoration: line-through;</xsl:attribute>
                                    <xsl:apply-templates/>
                                </xsl:element>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:when test="contains($visning, 'study')">
                        <xsl:choose>
                            <xsl:when test="contains($dn, 'dipl')">
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">color: #000000; text-decoration: line-through;</xsl:attribute>
                                    <xsl:apply-templates/>
                                </xsl:element>
                            </xsl:when>
                            <xsl:when test="contains($dn, 'norm')"/>
                            <xsl:otherwise/>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:when test="contains($visning, 'norm')">
                        <xsl:choose>
                            <xsl:when test="contains($dn, 'dipl')">
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">color: #000000; text-decoration: line-through;</xsl:attribute>
                                    <xsl:apply-templates/>
                                </xsl:element>
                            </xsl:when>
                            <xsl:when test="contains($dn, 'study')"/>
                            <xsl:otherwise/>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:otherwise/>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="attribute::type='dn_c'">
                <xsl:choose>
                    <xsl:when test="contains($visning, 'dipl')">
                        <xsl:choose>
                            <xsl:when test="contains($dn, 'study')"/>
                            <xsl:when test="contains($dn, 'norm')"/>
                            <xsl:otherwise>
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">color: #000000; text-decoration: line-through;</xsl:attribute>
                                    <xsl:apply-templates/>
                                </xsl:element>
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">vertical-align: super; color: #FF0000;</xsl:attribute>
                                    <xsl:text>c</xsl:text>
                                </xsl:element>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:when test="contains($visning, 'study')">
                        <xsl:choose>
                            <xsl:when test="contains($dn, 'dipl')">
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">color: #000000; border-bottom-width: thin; border-bottom-color: #000000; border-bottom-style: dotted; text-decoration: line-through;</xsl:attribute>
                                    <xsl:apply-templates/>
                                </xsl:element>
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">vertical-align: super; color: #FF0000;</xsl:attribute>
                                    <xsl:text>c</xsl:text>
                                </xsl:element>
                            </xsl:when>
                            <xsl:when test="contains($dn, 'norm')"/>
                            <xsl:otherwise/>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:when test="contains($visning, 'norm')">
                        <xsl:choose>
                            <xsl:when test="contains($dn, 'dipl')">
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">color: #000000; border-bottom-width: thin; border-bottom-color: #000000; border-bottom-style: dotted; text-decoration: line-through;</xsl:attribute>
                                    <xsl:apply-templates/>
                                </xsl:element>
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">vertical-align: super; color: #FF0000;</xsl:attribute>
                                    <xsl:text>c</xsl:text>
                                </xsl:element>
                            </xsl:when>
                            <xsl:when test="contains($dn, 'study')"/>
                            <xsl:otherwise/>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:otherwise/>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="attribute::type='dn_ch'">
                <xsl:choose>
                    <xsl:when test="contains($visning, 'dipl')">
                        <xsl:choose>
                            <xsl:when test="contains($dn, 'study')"/>
                            <xsl:when test="contains($dn, 'norm')"/>
                            <xsl:otherwise>
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">color: #000000; text-decoration: line-through;</xsl:attribute>
                                    <xsl:apply-templates/>
                                </xsl:element>
                                <xsl:element name="SUP">
                                    <xsl:attribute name="style">color: #FF0000;</xsl:attribute>
                                    <xsl:text>ch</xsl:text>
                                </xsl:element>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:when test="contains($visning, 'study')">
                        <xsl:choose>
                            <xsl:when test="contains($dn, 'dipl')">
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">color: #000000; text-decoration: line-through;</xsl:attribute>
                                    <xsl:apply-templates/>
                                </xsl:element>
                                <xsl:element name="SUP">
                                    <xsl:attribute name="style">color: #FF0000;</xsl:attribute>
                                    <xsl:text>ch</xsl:text>
                                </xsl:element>
                            </xsl:when>
                            <xsl:when test="contains($dn, 'norm')"/>
                            <xsl:otherwise/>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:when test="contains($visning, 'norm')">
                        <xsl:choose>
                            <xsl:when test="contains($dn, 'dipl')">
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">color: #000000; text-decoration: line-through;</xsl:attribute>
                                    <xsl:apply-templates/>
                                </xsl:element>
                                <xsl:element name="SUP">
                                    <xsl:attribute name="style">color: #FF0000;</xsl:attribute>
                                    <xsl:text>ch</xsl:text>
                                </xsl:element>
                            </xsl:when>
                            <xsl:when test="contains($dn, 'study')"/>
                            <xsl:otherwise/>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:otherwise/>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="attribute::type='dn_h'">
                <xsl:choose>
                    <xsl:when test="$handwriting = 'off'"></xsl:when>
                    <xsl:otherwise>
                        <xsl:choose>
                            <xsl:when test="contains($visning, 'dipl')">
                                <xsl:choose>
                                    <xsl:when test="contains($dn, 'study')"/>
                                    <xsl:when test="contains($dn, 'norm')"/>
                                    <xsl:otherwise>
                                        <xsl:element name="SPAN">
                                            <xsl:attribute name="style">text-decoration: line-through; color: #0000FF;</xsl:attribute>
                                            <xsl:element name="SPAN">
                                                <xsl:attribute name="style">color: #000000;</xsl:attribute>
                                                <xsl:apply-templates/>
                                            </xsl:element>
                                        </xsl:element>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:when>
                            <xsl:when test="contains($visning, 'study')">
                                <xsl:choose>
                                    <xsl:when test="contains($dn, 'diplo')">
                                        <xsl:element name="SPAN">
                                            <xsl:attribute name="style">text-decoration: line-through; color: #0000FF;</xsl:attribute>
                                            <xsl:element name="SPAN">
                                                <xsl:attribute name="style">color: #000000;</xsl:attribute>
                                                <xsl:apply-templates/>
                                            </xsl:element>
                                        </xsl:element>
                                    </xsl:when>
                                    <xsl:when test="contains($dn, 'norm')"/>
                                    <xsl:otherwise/>
                                </xsl:choose>
                            </xsl:when>
                            <xsl:when test="contains($visning, 'norm')">
                                <xsl:choose>
                                    <xsl:when test="contains($dn, 'diplo')">
                                        <xsl:element name="SPAN">
                                            <xsl:attribute name="style">text-decoration: line-through; color: #0000FF;</xsl:attribute>
                                            <xsl:element name="SPAN">
                                                <xsl:attribute name="style">color: #000000;</xsl:attribute>
                                                <xsl:apply-templates/>
                                            </xsl:element>
                                        </xsl:element>
                                    </xsl:when>
                                    <xsl:when test="contains($dn, 'study')"/>
                                    <xsl:otherwise/>
                                </xsl:choose>
                            </xsl:when>
                            <xsl:otherwise/>
                        </xsl:choose>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="attribute::type='dn_h_ch'">
                <xsl:choose>
                    <xsl:when test="$handwriting = 'off'"></xsl:when>
                    <xsl:otherwise>
                        <xsl:choose>
                            <xsl:when test="contains($visning, 'dipl')">
                                <xsl:choose>
                                    <xsl:when test="contains($dn, 'study')"/>
                                    <xsl:when test="contains($dn, 'norm')"/>
                                    <xsl:otherwise>
                                        <xsl:element name="SPAN">
                                            <xsl:attribute name="style">text-decoration: line-through; color: #0000FF;</xsl:attribute>
                                            <xsl:element name="SPAN">
                                                <xsl:attribute name="style">color: #000000;</xsl:attribute>
                                                <xsl:apply-templates/>
                                            </xsl:element>
                                        </xsl:element>
                                        <xsl:element name="SUP">
                                            <xsl:attribute name="style">color: #FF0000;</xsl:attribute>
                                            <xsl:text>ch</xsl:text>
                                        </xsl:element>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:when>
                            <xsl:when test="contains($visning, 'study')">
                                <xsl:choose>
                                    <xsl:when test="contains($dn, 'diplo')">
                                        <xsl:element name="SPAN">
                                            <xsl:attribute name="style">text-decoration: line-through; color: #0000FF;</xsl:attribute>
                                            <xsl:element name="SPAN">
                                                <xsl:attribute name="style">color: #000000;</xsl:attribute>
                                                <xsl:apply-templates/>
                                            </xsl:element>
                                        </xsl:element>
                                        <xsl:element name="SUP">
                                            <xsl:attribute name="style">color: #FF0000;</xsl:attribute>
                                            <xsl:text>ch</xsl:text>
                                        </xsl:element>
                                    </xsl:when>
                                    <xsl:when test="contains($dn, 'norm')"/>
                                    <xsl:otherwise/>
                                </xsl:choose>
                            </xsl:when>
                            <xsl:when test="contains($visning, 'norm')">
                                <xsl:choose>
                                    <xsl:when test="contains($dn, 'diplo')">
                                        <xsl:element name="SPAN">
                                            <xsl:attribute name="style">text-decoration: line-through; color: #0000FF;</xsl:attribute>
                                            <xsl:element name="SPAN">
                                                <xsl:attribute name="style">color: #000000;</xsl:attribute>
                                                <xsl:apply-templates/>
                                            </xsl:element>
                                        </xsl:element>
                                        <xsl:element name="SUP">
                                            <xsl:attribute name="style">color: #FF0000;</xsl:attribute>
                                            <xsl:text>ch</xsl:text>
                                        </xsl:element>
                                    </xsl:when>
                                    <xsl:when test="contains($dn, 'study')"/>
                                    <xsl:otherwise/>
                                </xsl:choose>
                            </xsl:when>
                            <xsl:otherwise/>
                        </xsl:choose>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="attribute::type='dn_H1'">
                <xsl:choose>
                    <xsl:when test="$handwriting = 'off'"></xsl:when>
                    <xsl:otherwise>
                        <xsl:choose>
                            <xsl:when test="contains($visning, 'dipl')">
                                <xsl:choose>
                                    <xsl:when test="contains($dn, 'study')"/>
                                    <xsl:when test="contains($dn, 'norm')"/>
                                    <xsl:otherwise>
                                        <xsl:element name="SPAN">
                                            <xsl:attribute name="style">text-decoration: line-through; color: #0000FF;</xsl:attribute>
                                            <xsl:element name="SPAN">
                                                <xsl:attribute name="style">color: #000000;</xsl:attribute>
                                                <xsl:apply-templates/>
                                            </xsl:element>
                                        </xsl:element>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:when>
                            <xsl:when test="contains($visning, 'study')">
                                <xsl:choose>
                                    <xsl:when test="contains($dn, 'diplo')">
                                        <xsl:element name="SPAN">
                                            <xsl:attribute name="style">text-decoration: line-through; color: #0000FF;</xsl:attribute>
                                            <xsl:element name="SPAN">
                                                <xsl:attribute name="style">color: #000000;</xsl:attribute>
                                                <xsl:apply-templates/>
                                            </xsl:element>
                                        </xsl:element>
                                    </xsl:when>
                                    <xsl:when test="contains($dn, 'norm')"/>
                                    <xsl:otherwise/>
                                </xsl:choose>
                            </xsl:when>
                            <xsl:when test="contains($visning, 'norm')">
                                <xsl:choose>
                                    <xsl:when test="contains($dn, 'diplo')">
                                        <xsl:element name="SPAN">
                                            <xsl:attribute name="style">text-decoration: line-through; color: #0000FF;</xsl:attribute>
                                            <xsl:element name="SPAN">
                                                <xsl:attribute name="style">color: #000000;</xsl:attribute>
                                                <xsl:apply-templates/>
                                            </xsl:element>
                                        </xsl:element>
                                    </xsl:when>
                                    <xsl:when test="contains($dn, 'study')"/>
                                    <xsl:otherwise/>
                                </xsl:choose>
                            </xsl:when>
                            <xsl:otherwise/>
                        </xsl:choose>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="attribute::type='dn_S1'">
                <xsl:choose>
                    <xsl:when test="$handwriting = 'off'"></xsl:when>
                    <xsl:otherwise>
                        <xsl:choose>
                            <xsl:when test="contains($visning, 'dipl')">
                                <xsl:choose>
                                    <xsl:when test="contains($dn, 'study')"/>
                                    <xsl:when test="contains($dn, 'norm')"/>
                                    <xsl:otherwise>
                                        <xsl:element name="SPAN">
                                            <xsl:attribute name="style">text-decoration: line-through; color: #0000FF;</xsl:attribute>
                                            <xsl:element name="SPAN">
                                                <xsl:attribute name="style">color: #000000;</xsl:attribute>
                                                <xsl:apply-templates/>
                                            </xsl:element>
                                        </xsl:element>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:when>
                            <xsl:when test="contains($visning, 'study')">
                                <xsl:choose>
                                    <xsl:when test="contains($dn, 'diplo')">
                                        <xsl:element name="SPAN">
                                            <xsl:attribute name="style">text-decoration: line-through; color: #0000FF;</xsl:attribute>
                                            <xsl:element name="SPAN">
                                                <xsl:attribute name="style">color: #000000;</xsl:attribute>
                                                <xsl:apply-templates/>
                                            </xsl:element>
                                        </xsl:element>
                                    </xsl:when>
                                    <xsl:when test="contains($dn, 'norm')"/>
                                    <xsl:otherwise/>
                                </xsl:choose>
                            </xsl:when>
                            <xsl:when test="contains($visning, 'norm')">
                                <xsl:choose>
                                    <xsl:when test="contains($dn, 'diplo')">
                                        <xsl:element name="SPAN">
                                            <xsl:attribute name="style">text-decoration: line-through; color: #0000FF;</xsl:attribute>
                                            <xsl:element name="SPAN">
                                                <xsl:attribute name="style">color: #000000;</xsl:attribute>
                                                <xsl:apply-templates/>
                                            </xsl:element>
                                        </xsl:element>
                                    </xsl:when>
                                    <xsl:when test="contains($dn, 'study')"/>
                                    <xsl:otherwise/>
                                </xsl:choose>
                            </xsl:when>
                            <xsl:otherwise/>
                        </xsl:choose>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="attribute::type='dncr'"><!-- Sjekk visning -->
                <xsl:choose>
                    <xsl:when test="contains($visning, 'dipl')">
                        <xsl:choose>
                            <xsl:when test="contains($dnpc, 'study')"/>
                            <xsl:when test="contains($dnpc, 'norm')"/>
                            <xsl:otherwise>
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">color: #000000; text-decoration: line-through;</xsl:attribute>
                                    <xsl:apply-templates/>
                                </xsl:element>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:when test="contains($visning, 'study')">
                        <xsl:choose>
                            <xsl:when test="contains($dncr, 'dipl')">
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">color: #000000; text-decoration: line-through;</xsl:attribute>
                                    <xsl:apply-templates/>
                                </xsl:element>
                            </xsl:when>
                            <xsl:when test="contains($dncr, 'norm')"/>
                            <xsl:otherwise/>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:when test="contains($visning, 'norm')">
                        <xsl:choose>
                            <xsl:when test="contains($dncr, 'dipl')">
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">color: #000000; text-decoration: line-through;</xsl:attribute>
                                    <xsl:apply-templates/>
                                </xsl:element>
                            </xsl:when>
                            <xsl:when test="contains($dncr, 'study')"/>
                            <xsl:otherwise/>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:otherwise/>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="attribute::type='dncr_h'">
                <xsl:choose>
                    <xsl:when test="$handwriting = 'off'"></xsl:when>
                    <xsl:otherwise>
                        <xsl:choose>
                            <xsl:when test="contains($visning, 'dipl')">
                                <xsl:choose>
                                    <xsl:when test="contains($dncr, 'study')"/>
                                    <xsl:when test="contains($dncr, 'norm')"/>
                                    <xsl:otherwise>
                                        <xsl:element name="SPAN">
                                            <xsl:attribute name="style">text-decoration: line-through; color: #0000FF;</xsl:attribute>
                                            <xsl:element name="SPAN">
                                                <xsl:attribute name="style">color: #000000;</xsl:attribute>
                                                <xsl:apply-templates/>
                                            </xsl:element>
                                        </xsl:element>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:when>
                            <xsl:when test="contains($visning, 'study')">
                                <xsl:choose>
                                    <xsl:when test="contains($dncr, 'dipl')">
                                        <xsl:element name="SPAN">
                                            <xsl:attribute name="style">text-decoration: line-through; color: #0000FF;</xsl:attribute>
                                            <xsl:element name="SPAN">
                                                <xsl:attribute name="style">color: #000000;</xsl:attribute>
                                                <xsl:apply-templates/>
                                            </xsl:element>
                                        </xsl:element>
                                    </xsl:when>
                                    <xsl:when test="contains($dncr, 'norm')"/>
                                    <xsl:otherwise/>
                                </xsl:choose>
                            </xsl:when>
                            <xsl:when test="contains($visning, 'norm')">
                                <xsl:choose>
                                    <xsl:when test="contains($dncr, 'dipl')">
                                        <xsl:element name="SPAN">
                                            <xsl:attribute name="style">text-decoration: line-through; color: #0000FF;</xsl:attribute>
                                            <xsl:element name="SPAN">
                                                <xsl:attribute name="style">color: #000000;</xsl:attribute>
                                                <xsl:apply-templates/>
                                            </xsl:element>
                                        </xsl:element>
                                    </xsl:when>
                                    <xsl:when test="contains($dncr, 'study')"/>
                                    <xsl:otherwise/>
                                </xsl:choose>
                            </xsl:when>
                            <xsl:otherwise/>
                        </xsl:choose>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="attribute::type='dnpc'">
                <xsl:choose>
                    <xsl:when test="contains($visning, 'dipl')">
                        <xsl:choose>
                            <xsl:when test="contains($dnpc, 'study')"/>
                            <xsl:when test="contains($dnpc, 'norm')"/>
                            <xsl:otherwise>
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">color: #000000; text-decoration: line-through;</xsl:attribute>
                                    <xsl:apply-templates/>
                                </xsl:element>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:when test="contains($visning, 'study')">
                        <xsl:choose>
                            <xsl:when test="contains($dnpc, 'dipl')">
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">color: #000000; text-decoration: line-through;</xsl:attribute>
                                    <xsl:apply-templates/>
                                </xsl:element>
                            </xsl:when>
                            <xsl:when test="contains($dnpc, 'norm')"/>
                            <xsl:otherwise/>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:when test="contains($visning, 'norm')">
                        <xsl:choose>
                            <xsl:when test="contains($dnpc, 'dipl')">
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">color: #000000; text-decoration: line-through;</xsl:attribute>
                                    <xsl:apply-templates/>
                                </xsl:element>
                            </xsl:when>
                            <xsl:when test="contains($dnpc, 'study')"/>
                            <xsl:otherwise/>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:otherwise/>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="attribute::type='dnpc_ch'">
                <xsl:choose>
                    <xsl:when test="contains($visning, 'dipl')">
                        <xsl:choose>
                            <xsl:when test="contains($dnpc, 'study')"/>
                            <xsl:when test="contains($dnpc, 'norm')"/>
                            <xsl:otherwise>
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">color: #000000; text-decoration: line-through;</xsl:attribute>
                                    <xsl:apply-templates/>
                                </xsl:element>
                                <xsl:element name="SUP">
                                    <xsl:attribute name="style">color: #FF0000;</xsl:attribute>
                                    <xsl:text>ch</xsl:text>
                                </xsl:element>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:when test="contains($visning, 'study')">
                        <xsl:choose>
                            <xsl:when test="contains($dnpc, 'dipl')">
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">color: #000000; text-decoration: line-through;</xsl:attribute>
                                    <xsl:apply-templates/>
                                </xsl:element>
                                <xsl:element name="SUP">
                                    <xsl:attribute name="style">color: #FF0000;</xsl:attribute>
                                    <xsl:text>ch</xsl:text>
                                </xsl:element>
                            </xsl:when>
                            <xsl:when test="contains($dnpc, 'norm')"/>
                            <xsl:otherwise/>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:when test="contains($visning, 'norm')">
                        <xsl:choose>
                            <xsl:when test="contains($dnpc, 'dipl')">
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">color: #000000; text-decoration: line-through;</xsl:attribute>
                                    <xsl:apply-templates/>
                                </xsl:element>
                                <xsl:element name="SUP">
                                    <xsl:attribute name="style">color: #FF0000;</xsl:attribute>
                                    <xsl:text>ch</xsl:text>
                                </xsl:element>
                            </xsl:when>
                            <xsl:when test="contains($dnpc, 'study')"/>
                            <xsl:otherwise/>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:otherwise/>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="attribute::type='dnpc_c'">
                <xsl:choose>
                    <xsl:when test="contains($visning, 'dipl')">
                        <xsl:choose>
                            <xsl:when test="contains($dnpc, 'study')">
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">color: #000000; text-decoration: line-through;</xsl:attribute>
                                    <xsl:apply-templates/>
                                </xsl:element>
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">vertical-align: super; color: #FF0000;</xsl:attribute>
                                    <xsl:text>c</xsl:text>
                                </xsl:element>
                            </xsl:when>
                            <xsl:when test="contains($dnpc, 'norm')"/>
                            <xsl:otherwise>
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">color: #000000; text-decoration: line-through;</xsl:attribute>
                                    <xsl:apply-templates/>
                                </xsl:element>
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">vertical-align: super; color: #FF0000;</xsl:attribute>
                                    <xsl:text>c</xsl:text>
                                </xsl:element>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:when test="contains($visning, 'study')">
                        <xsl:choose>
                            <xsl:when test="contains($dnpc, 'dipl')">
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">color: #000000; border-bottom-width: thin; border-bottom-color: #000000; border-bottom-style: dotted; text-decoration: line-through;</xsl:attribute>
                                    <xsl:apply-templates/>
                                </xsl:element>
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">vertical-align: super; color: #FF0000;</xsl:attribute>
                                    <xsl:text>c</xsl:text>
                                </xsl:element>
                            </xsl:when>
                            <xsl:when test="contains($dnpc, 'norm')"/>
                            <xsl:otherwise>	
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">color: #000000; text-decoration: line-through;</xsl:attribute>
                                    <xsl:apply-templates/>
                                </xsl:element>
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">vertical-align: super; color: #FF0000;</xsl:attribute>
                                    <xsl:text>c</xsl:text>
                                </xsl:element></xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:when test="contains($visning, 'norm')">
                        <xsl:choose>
                            <xsl:when test="contains($dnpc, 'dipl')">
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">color: #000000; border-bottom-width: thin; border-bottom-color: #000000; border-bottom-style: dotted; text-decoration: line-through;</xsl:attribute>
                                    <xsl:apply-templates/>
                                </xsl:element>
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">vertical-align: super; color: #FF0000;</xsl:attribute>
                                    <xsl:text>c</xsl:text>
                                </xsl:element>
                            </xsl:when>
                            <xsl:when test="contains($dnpc, 'study')">
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">color: #000000; text-decoration: line-through;</xsl:attribute>
                                    <xsl:apply-templates/>
                                </xsl:element>
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">vertical-align: super; color: #FF0000;</xsl:attribute>
                                    <xsl:text>c</xsl:text>
                                </xsl:element>
                            </xsl:when>
                            <xsl:otherwise/>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:otherwise/>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="attribute::type='dnpc_h'">
                <!-- Changes need to be reflected on ab as well -->
                <xsl:choose>
                    <xsl:when test="$handwriting = 'off'"></xsl:when>
                    <xsl:otherwise>
                        <xsl:choose>
                            <xsl:when test="contains($visning, 'dipl')">
                                <xsl:choose>
                                    <xsl:when test="contains($dnpc, 'study')"/>
                                    <xsl:when test="contains($dnpc, 'norm')"/>
                                    <xsl:otherwise>
                                        <xsl:element name="SPAN">
                                            <xsl:attribute name="style">text-decoration: line-through; color: #0000FF;</xsl:attribute>
                                            <xsl:element name="SPAN">
                                                <xsl:attribute name="style">color: #000000;</xsl:attribute>
                                                <xsl:apply-templates/>
                                            </xsl:element>
                                        </xsl:element>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:when>
                            <xsl:when test="contains($visning, 'study')">
                                <xsl:choose>
                                    <xsl:when test="contains($dnpc, 'dipl')">
                                        <xsl:element name="SPAN">
                                            <xsl:attribute name="style">text-decoration: line-through; color: #0000FF;</xsl:attribute>
                                            <xsl:element name="SPAN">
                                                <xsl:attribute name="style">color: #000000;</xsl:attribute>
                                                <xsl:apply-templates/>
                                            </xsl:element>
                                        </xsl:element>
                                    </xsl:when>
                                    <xsl:when test="contains($dnpc, 'norm')"/>
                                    <xsl:otherwise/>
                                </xsl:choose>
                            </xsl:when>
                            <xsl:when test="contains($visning, 'norm')">
                                <xsl:choose>
                                    <xsl:when test="contains($dnpc, 'dipl')">
                                        <xsl:element name="SPAN">
                                            <xsl:attribute name="style">text-decoration: line-through; color: #0000FF;</xsl:attribute>
                                            <xsl:element name="SPAN">
                                                <xsl:attribute name="style">color: #000000;</xsl:attribute>
                                                <xsl:apply-templates/>
                                            </xsl:element>
                                        </xsl:element>
                                    </xsl:when>
                                    <xsl:when test="contains($dnpc, 'study')"/>
                                    <xsl:otherwise/>
                                </xsl:choose>
                            </xsl:when>
                            <xsl:otherwise/>
                        </xsl:choose>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="attribute::type='dnpc_h_ch'">
                <xsl:choose>
                    <xsl:when test="$handwriting = 'off'"></xsl:when>
                    <xsl:otherwise>
                        <xsl:choose>
                            <xsl:when test="contains($visning, 'dipl')">
                                <xsl:choose>
                                    <xsl:when test="contains($dnpc, 'study')"/>
                                    <xsl:when test="contains($dnpc, 'norm')"/>
                                    <xsl:otherwise>
                                        <xsl:element name="SPAN">
                                            <xsl:attribute name="style">text-decoration: line-through; color: #0000FF;</xsl:attribute>
                                            <xsl:element name="SPAN">
                                                <xsl:attribute name="style">color: #000000;</xsl:attribute>
                                                <xsl:apply-templates/>
                                            </xsl:element>
                                        </xsl:element>
                                        <xsl:element name="SUP">
                                            <xsl:attribute name="style">color: #FF0000;</xsl:attribute>
                                            <xsl:text>ch</xsl:text>
                                        </xsl:element>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:when>
                            <xsl:when test="contains($visning, 'study')">
                                <xsl:choose>
                                    <xsl:when test="contains($dnpc, 'dipl')">
                                        <xsl:element name="SPAN">
                                            <xsl:attribute name="style">text-decoration: line-through; color: #0000FF;</xsl:attribute>
                                            <xsl:element name="SPAN">
                                                <xsl:attribute name="style">color: #000000;</xsl:attribute>
                                                <xsl:apply-templates/>
                                            </xsl:element>
                                        </xsl:element>
                                        <xsl:element name="SUP">
                                            <xsl:attribute name="style">color: #FF0000;</xsl:attribute>
                                            <xsl:text>ch</xsl:text>
                                        </xsl:element>
                                    </xsl:when>
                                    <xsl:when test="contains($dnpc, 'norm')"/>
                                    <xsl:otherwise/>
                                </xsl:choose>
                            </xsl:when>
                            <xsl:when test="contains($visning, 'norm')">
                                <xsl:choose>
                                    <xsl:when test="contains($dnpc, 'dipl')">
                                        <xsl:element name="SPAN">
                                            <xsl:attribute name="style">text-decoration: line-through; color: #0000FF;</xsl:attribute>
                                            <xsl:element name="SPAN">
                                                <xsl:attribute name="style">color: #000000;</xsl:attribute>
                                                <xsl:apply-templates/>
                                            </xsl:element>
                                        </xsl:element>
                                        <xsl:element name="SUP">
                                            <xsl:attribute name="style">color: #FF0000;</xsl:attribute>
                                            <xsl:text>ch</xsl:text>
                                        </xsl:element>
                                    </xsl:when>
                                    <xsl:when test="contains($dnpc, 'study')"/>
                                    <xsl:otherwise/>
                                </xsl:choose>
                            </xsl:when>
                            <xsl:otherwise/>
                        </xsl:choose>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="attribute::type='dnpc_H1'">
                <xsl:choose>
                    <xsl:when test="$handwriting = 'off'"></xsl:when>
                    <xsl:otherwise>
                        <xsl:choose>
                            <xsl:when test="contains($visning, 'dipl')">
                                <xsl:choose>
                                    <xsl:when test="contains($dnpc, 'study')"/>
                                    <xsl:when test="contains($dnpc, 'norm')"/>
                                    <xsl:otherwise>
                                        <xsl:element name="SPAN">
                                            <xsl:attribute name="style">text-decoration: line-through; color: #0000FF;</xsl:attribute>
                                            <xsl:element name="SPAN">
                                                <xsl:attribute name="style">color: #000000;</xsl:attribute>
                                                <xsl:apply-templates/>
                                            </xsl:element>
                                        </xsl:element>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:when>
                            <xsl:when test="contains($visning, 'study')">
                                <xsl:choose>
                                    <xsl:when test="contains($dnpc, 'dipl')">
                                        <xsl:element name="SPAN">
                                            <xsl:attribute name="style">text-decoration: line-through; color: #0000FF;</xsl:attribute>
                                            <xsl:element name="SPAN">
                                                <xsl:attribute name="style">color: #000000;</xsl:attribute>
                                                <xsl:apply-templates/>
                                            </xsl:element>
                                        </xsl:element>
                                    </xsl:when>
                                    <xsl:when test="contains($dnpc, 'norm')"/>
                                    <xsl:otherwise/>
                                </xsl:choose>
                            </xsl:when>
                            <xsl:when test="contains($visning, 'norm')">
                                <xsl:choose>
                                    <xsl:when test="contains($dnpc, 'dipl')">
                                        <xsl:element name="SPAN">
                                            <xsl:attribute name="style">text-decoration: line-through; color: #0000FF;</xsl:attribute>
                                            <xsl:element name="SPAN">
                                                <xsl:attribute name="style">color: #000000;</xsl:attribute>
                                                <xsl:apply-templates/>
                                            </xsl:element>
                                        </xsl:element>
                                    </xsl:when>
                                    <xsl:when test="contains($dnpc, 'study')"/>
                                    <xsl:otherwise/>
                                </xsl:choose>
                            </xsl:when>
                            <xsl:otherwise/>
                        </xsl:choose>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="attribute::type='dnpc_S1'">
                <xsl:choose>
                    <xsl:when test="$handwriting = 'off'"></xsl:when>
                    <xsl:otherwise>
                        <xsl:choose>
                            <xsl:when test="contains($visning, 'dipl')">
                                <xsl:choose>
                                    <xsl:when test="contains($dnpc, 'study')"/>
                                    <xsl:when test="contains($dnpc, 'norm')"/>
                                    <xsl:otherwise>
                                        <xsl:element name="SPAN">
                                            <xsl:attribute name="style">text-decoration: line-through; color: #0000FF;</xsl:attribute>
                                            <xsl:element name="SPAN">
                                                <xsl:attribute name="style">color: #000000;</xsl:attribute>
                                                <xsl:apply-templates/>
                                            </xsl:element>
                                        </xsl:element>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:when>
                            <xsl:when test="contains($visning, 'study')">
                                <xsl:choose>
                                    <xsl:when test="contains($dnpc, 'dipl')">
                                        <xsl:element name="SPAN">
                                            <xsl:attribute name="style">text-decoration: line-through; color: #0000FF;</xsl:attribute>
                                            <xsl:element name="SPAN">
                                                <xsl:attribute name="style">color: #000000;</xsl:attribute>
                                                <xsl:apply-templates/>
                                            </xsl:element>
                                        </xsl:element>
                                    </xsl:when>
                                    <xsl:when test="contains($dnpc, 'norm')"/>
                                    <xsl:otherwise/>
                                </xsl:choose>
                            </xsl:when>
                            <xsl:when test="contains($visning, 'norm')">
                                <xsl:choose>
                                    <xsl:when test="contains($dnpc, 'dipl')">
                                        <xsl:element name="SPAN">
                                            <xsl:attribute name="style">text-decoration: line-through; color: #0000FF;</xsl:attribute>
                                            <xsl:element name="SPAN">
                                                <xsl:attribute name="style">color: #000000;</xsl:attribute>
                                                <xsl:apply-templates/>
                                            </xsl:element>
                                        </xsl:element>
                                    </xsl:when>
                                    <xsl:when test="contains($dnpc, 'study')"/>
                                    <xsl:otherwise/>
                                </xsl:choose>
                            </xsl:when>
                            <xsl:otherwise/>
                        </xsl:choose>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="attribute::type='oo'">
                <xsl:choose>
                    <xsl:when test="contains($visning, 'dipl')">
                        <xsl:choose>
                            <xsl:when test="contains($d, 'study')">
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">color: #000000; text-decoration: line-through;</xsl:attribute>
                                    <xsl:apply-templates/>
                                </xsl:element>
                                <xsl:element name="SPAN"><!-- overwriting -->
                                    <xsl:attribute name="style">color: #FF0000;</xsl:attribute>
                                    <xsl:element name="SUP">
                                        <xsl:text>[o]</xsl:text>
                                    </xsl:element>
                                </xsl:element>
                            </xsl:when>
                            <xsl:when test="contains($d, 'norm')"></xsl:when>
                            <xsl:otherwise>
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">color: #000000; text-decoration: line-through;</xsl:attribute>
                                    <xsl:apply-templates/>
                                </xsl:element>
                                <xsl:element name="SPAN"><!-- overwriting -->
                                    <xsl:attribute name="style">color: #FF0000;</xsl:attribute>
                                    <xsl:element name="SUP">
                                        <xsl:text>[o]</xsl:text>
                                    </xsl:element>
                                </xsl:element>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:when test="contains($visning, 'study')">
                        <xsl:choose>
                            <xsl:when test="contains($d, 'dipl')">
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">color: #000000; text-decoration: line-through;</xsl:attribute>
                                    <xsl:apply-templates/>
                                </xsl:element>
                                <xsl:element name="SPAN"><!-- overwriting -->
                                    <xsl:attribute name="style">color: #FF0000;</xsl:attribute>
                                    <xsl:element name="SUP">
                                        <xsl:text>[o]</xsl:text>
                                    </xsl:element>
                                </xsl:element>
                            </xsl:when>
                            <xsl:when test="contains($d, 'norm')"></xsl:when>
                            <xsl:otherwise>
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">color: #000000; text-decoration: line-through;</xsl:attribute>
                                    <xsl:apply-templates/>
                                </xsl:element>
                                <xsl:element name="SPAN"><!-- overwriting -->
                                    <xsl:attribute name="style">color: #FF0000;</xsl:attribute>
                                    <xsl:element name="SUP">
                                        <xsl:text>[o]</xsl:text>
                                    </xsl:element>
                                </xsl:element>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:when test="contains($visning, 'norm')">
                        <xsl:choose>
                            <xsl:when test="contains($d, 'dipl')">
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">color: #000000; text-decoration: line-through;</xsl:attribute>
                                    <xsl:apply-templates/>
                                </xsl:element>
                                <xsl:element name="SPAN"><!-- overwriting -->
                                    <xsl:attribute name="style">color: #FF0000;</xsl:attribute>
                                    <xsl:element name="SUP">
                                        <xsl:text>[o]</xsl:text>
                                    </xsl:element>
                                </xsl:element>
                            </xsl:when>
                            <xsl:when test="contains($d, 'study')">
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">color: #000000; text-decoration: line-through;</xsl:attribute>
                                    <xsl:apply-templates/>
                                </xsl:element>
                                <xsl:element name="SPAN"><!-- overwriting -->
                                    <xsl:attribute name="style">color: #FF0000;</xsl:attribute>
                                    <xsl:element name="SUP">
                                        <xsl:text>[o]</xsl:text>
                                    </xsl:element>
                                </xsl:element>
                            </xsl:when>
                            <xsl:otherwise/>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:otherwise/>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise/>
        </xsl:choose>
    </xsl:template>	
	
	<xsl:template match="tei:add">
        <xsl:choose>
            <xsl:when test="attribute::rend='el'">
                <!-- Changes need to be reflected on ab as well -->
                <xsl:choose>
                    <xsl:when test="contains($visning, 'dipl')">
                        <xsl:choose>
                            <xsl:when test="contains($el, 'study')">
                                <xsl:apply-templates/>
                            </xsl:when>
                            <xsl:when test="contains($el, 'norm')">
                                <xsl:apply-templates/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">color: #008000;</xsl:attribute>
                                    <xsl:text>&lt;</xsl:text>
                                </xsl:element>
                                <xsl:apply-templates/>
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">color: #008000;</xsl:attribute>
                                    <xsl:text>&gt;</xsl:text>
                                </xsl:element>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:when test="contains($visning, 'study')">
                        <xsl:choose>
                            <xsl:when test="contains($el, 'dipl')">
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">color: #008000;</xsl:attribute>
                                    <xsl:text>&lt;</xsl:text>
                                </xsl:element>
                                <xsl:apply-templates/>
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">color: #008000;</xsl:attribute>
                                    <xsl:text>&gt;</xsl:text>
                                </xsl:element>
                            </xsl:when>
                            <xsl:when test="contains($el, 'norm')">
                                <xsl:apply-templates/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:apply-templates/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:when test="contains($visning, 'norm')">
                        <xsl:choose>
                            <xsl:when test="contains($el, 'dipl')">
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">color: #008000;</xsl:attribute>
                                    <xsl:text>&lt;</xsl:text>
                                </xsl:element>
                                <xsl:apply-templates/>
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">color: #008000;</xsl:attribute>
                                    <xsl:text>&gt;</xsl:text>
                                </xsl:element>
                            </xsl:when>
                            <xsl:when test="contains($el, 'study')">
                                <xsl:apply-templates/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:apply-templates/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:apply-templates/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="attribute::rend='el_h'">
                <!-- Changes need to be reflected on ab as well -->
                <xsl:choose>
                    <xsl:when test="$handwriting = 'off'"></xsl:when>
                    <xsl:otherwise>
                        <xsl:choose>
                            <xsl:when test="contains($visning, 'dipl')">
                                <xsl:choose>
                                    <xsl:when test="contains($el, 'study')">
                                        <xsl:apply-templates/>
                                    </xsl:when>
                                    <xsl:when test="contains($el, 'norm')">
                                        <xsl:apply-templates/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:element name="SPAN">
                                            <xsl:attribute name="style">color: #008000;</xsl:attribute>
                                            <xsl:text>&lt;</xsl:text>
                                        </xsl:element>
                                        <xsl:element name="SPAN">
                                            <xsl:attribute name="style">color: #0000FF;</xsl:attribute>
                                            <xsl:apply-templates/>
                                        </xsl:element>
                                        <xsl:element name="SPAN">
                                            <xsl:attribute name="style">color: #008000;</xsl:attribute>
                                            <xsl:text>&gt;</xsl:text>
                                        </xsl:element>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:when>
                            <xsl:when test="contains($visning, 'study')">
                                <xsl:choose>
                                    <xsl:when test="contains($el, 'dipl')">
                                        <xsl:element name="SPAN">
                                            <xsl:attribute name="style">color: #008000;</xsl:attribute>
                                            <xsl:text>&lt;</xsl:text>
                                        </xsl:element>
                                        <xsl:element name="SPAN">
                                            <xsl:attribute name="style">color: #0000FF;</xsl:attribute>
                                            <xsl:apply-templates/>
                                        </xsl:element>
                                        <xsl:element name="SPAN">
                                            <xsl:attribute name="style">color: #008000;</xsl:attribute>
                                            <xsl:text>&gt;</xsl:text>
                                        </xsl:element>
                                    </xsl:when>
                                    <xsl:when test="contains($el, 'norm')">
                                        <xsl:apply-templates/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:apply-templates/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:when>
                            <xsl:when test="contains($visning, 'norm')">
                                <xsl:choose>
                                    <xsl:when test="contains($el, 'dipl')">
                                        <xsl:element name="SPAN">
                                            <xsl:attribute name="style">color: #008000;</xsl:attribute>
                                            <xsl:text>&lt;</xsl:text>
                                        </xsl:element>
                                        <xsl:element name="SPAN">
                                            <xsl:attribute name="style">color: #0000FF;</xsl:attribute>
                                            <xsl:apply-templates/>
                                        </xsl:element>
                                        <xsl:element name="SPAN">
                                            <xsl:attribute name="style">color: #008000;</xsl:attribute>
                                            <xsl:text>&gt;</xsl:text>
                                        </xsl:element>
                                    </xsl:when>
                                    <xsl:when test="contains($el, 'study')">
                                        <xsl:apply-templates/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:apply-templates/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:apply-templates/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="attribute::rend='el_H1'">
                <xsl:choose>
                    <xsl:when test="$handwriting = 'off'"></xsl:when>
                    <xsl:otherwise>
                        <xsl:choose>
                            <xsl:when test="contains($visning, 'dipl')">
                                <xsl:choose>
                                    <xsl:when test="contains($el, 'study')">
                                        <xsl:apply-templates/>
                                    </xsl:when>
                                    <xsl:when test="contains($el, 'norm')">
                                        <xsl:apply-templates/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:element name="SPAN">
                                            <xsl:attribute name="style">color: #008000;</xsl:attribute>
                                            <xsl:text>&lt;</xsl:text>
                                        </xsl:element>
                                        <xsl:element name="SPAN">
                                            <xsl:attribute name="style">color: #0000FF;</xsl:attribute>
                                            <xsl:apply-templates/>
                                        </xsl:element>
                                        <xsl:element name="SPAN">
                                            <xsl:attribute name="style">color: #008000;</xsl:attribute>
                                            <xsl:text>&gt;</xsl:text>
                                        </xsl:element>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:when>
                            <xsl:when test="contains($visning, 'study')">
                                <xsl:choose>
                                    <xsl:when test="contains($el, 'dipl')">
                                        <xsl:element name="SPAN">
                                            <xsl:attribute name="style">color: #008000;</xsl:attribute>
                                            <xsl:text>&lt;</xsl:text>
                                        </xsl:element>
                                        <xsl:element name="SPAN">
                                            <xsl:attribute name="style">color: #0000FF;</xsl:attribute>
                                            <xsl:apply-templates/>
                                        </xsl:element>
                                        <xsl:element name="SPAN">
                                            <xsl:attribute name="style">color: #008000;</xsl:attribute>
                                            <xsl:text>&gt;</xsl:text>
                                        </xsl:element>
                                    </xsl:when>
                                    <xsl:when test="contains($el, 'norm')">
                                        <xsl:apply-templates/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:apply-templates/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:when>
                            <xsl:when test="contains($visning, 'norm')">
                                <xsl:choose>
                                    <xsl:when test="contains($el, 'dipl')">
                                        <xsl:element name="SPAN">
                                            <xsl:attribute name="style">color: #008000;</xsl:attribute>
                                            <xsl:text>&lt;</xsl:text>
                                        </xsl:element>
                                        <xsl:element name="SPAN">
                                            <xsl:attribute name="style">color: #0000FF;</xsl:attribute>
                                            <xsl:apply-templates/>
                                        </xsl:element>
                                        <xsl:element name="SPAN">
                                            <xsl:attribute name="style">color: #008000;</xsl:attribute>
                                            <xsl:text>&gt;</xsl:text>
                                        </xsl:element>
                                    </xsl:when>
                                    <xsl:when test="contains($el, 'study')">
                                        <xsl:apply-templates/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:apply-templates/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:apply-templates/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="attribute::rend='el_s'">
                <xsl:choose>
                    <xsl:when test="$handwriting = 'off'"></xsl:when>
                    <xsl:otherwise>
                        <xsl:choose>
                            <xsl:when test="contains($visning, 'dipl')">
                                <xsl:choose>
                                    <xsl:when test="contains($el, 'study')">
                                        <xsl:apply-templates/>
                                    </xsl:when>
                                    <xsl:when test="contains($el, 'norm')">
                                        <xsl:apply-templates/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:element name="SPAN">
                                            <xsl:attribute name="style">color: #008000;</xsl:attribute>
                                            <xsl:text>&lt;</xsl:text>
                                        </xsl:element>
                                        <xsl:element name="SPAN">
                                            <xsl:attribute name="style">color: #0000FF;</xsl:attribute>
                                            <xsl:apply-templates/>
                                        </xsl:element>
                                        <xsl:element name="SPAN">
                                            <xsl:attribute name="style">color: #008000;</xsl:attribute>
                                            <xsl:text>&gt;</xsl:text>
                                        </xsl:element>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:when>
                            <xsl:when test="contains($visning, 'study')">
                                <xsl:choose>
                                    <xsl:when test="contains($el, 'dipl')">
                                        <xsl:element name="SPAN">
                                            <xsl:attribute name="style">color: #008000;</xsl:attribute>
                                            <xsl:text>&lt;</xsl:text>
                                        </xsl:element>
                                        <xsl:element name="SPAN">
                                            <xsl:attribute name="style">color: #0000FF;</xsl:attribute>
                                            <xsl:apply-templates/>
                                        </xsl:element>
                                        <xsl:element name="SPAN">
                                            <xsl:attribute name="style">color: #008000;</xsl:attribute>
                                            <xsl:text>&gt;</xsl:text>
                                        </xsl:element>
                                    </xsl:when>
                                    <xsl:when test="contains($el, 'norm')">
                                        <xsl:apply-templates/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:apply-templates/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:when>
                            <xsl:when test="contains($visning, 'norm')">
                                <xsl:choose>
                                    <xsl:when test="contains($el, 'dipl')">
                                        <xsl:element name="SPAN">
                                            <xsl:attribute name="style">color: #008000;</xsl:attribute>
                                            <xsl:text>&lt;</xsl:text>
                                        </xsl:element>
                                        <xsl:element name="SPAN">
                                            <xsl:attribute name="style">color: #0000FF;</xsl:attribute>
                                            <xsl:apply-templates/>
                                        </xsl:element>
                                        <xsl:element name="SPAN">
                                            <xsl:attribute name="style">color: #008000;</xsl:attribute>
                                            <xsl:text>&gt;</xsl:text>
                                        </xsl:element>
                                    </xsl:when>
                                    <xsl:when test="contains($el, 'study')">
                                        <xsl:apply-templates/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:apply-templates/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:apply-templates/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="attribute::rend='el_S1'">
                <xsl:choose>
                    <xsl:when test="$handwriting = 'off'"></xsl:when>
                    <xsl:otherwise>
                        <xsl:choose>
                            <xsl:when test="contains($visning, 'dipl')">
                                <xsl:choose>
                                    <xsl:when test="contains($el, 'study')">
                                        <xsl:apply-templates/>
                                    </xsl:when>
                                    <xsl:when test="contains($el, 'norm')">
                                        <xsl:apply-templates/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:element name="SPAN">
                                            <xsl:attribute name="style">color: #008000;</xsl:attribute>
                                            <xsl:text>&lt;</xsl:text>
                                        </xsl:element>
                                        <xsl:element name="SPAN">
                                            <xsl:attribute name="style">color: #0000FF;</xsl:attribute>
                                            <xsl:apply-templates/>
                                        </xsl:element>
                                        <xsl:element name="SPAN">
                                            <xsl:attribute name="style">color: #008000;</xsl:attribute>
                                            <xsl:text>&gt;</xsl:text>
                                        </xsl:element>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:when>
                            <xsl:when test="contains($visning, 'study')">
                                <xsl:choose>
                                    <xsl:when test="contains($el, 'dipl')">
                                        <xsl:element name="SPAN">
                                            <xsl:attribute name="style">color: #008000;</xsl:attribute>
                                            <xsl:text>&lt;</xsl:text>
                                        </xsl:element>
                                        <xsl:element name="SPAN">
                                            <xsl:attribute name="style">color: #0000FF;</xsl:attribute>
                                            <xsl:apply-templates/>
                                        </xsl:element>
                                        <xsl:element name="SPAN">
                                            <xsl:attribute name="style">color: #008000;</xsl:attribute>
                                            <xsl:text>&gt;</xsl:text>
                                        </xsl:element>
                                    </xsl:when>
                                    <xsl:when test="contains($el, 'norm')">
                                        <xsl:apply-templates/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:apply-templates/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:when>
                            <xsl:when test="contains($visning, 'norm')">
                                <xsl:choose>
                                    <xsl:when test="contains($el, 'dipl')">
                                        <xsl:element name="SPAN">
                                            <xsl:attribute name="style">color: #008000;</xsl:attribute>
                                            <xsl:text>&lt;</xsl:text>
                                        </xsl:element>
                                        <xsl:element name="SPAN">
                                            <xsl:attribute name="style">color: #0000FF;</xsl:attribute>
                                            <xsl:apply-templates/>
                                        </xsl:element>
                                        <xsl:element name="SPAN">
                                            <xsl:attribute name="style">color: #008000;</xsl:attribute>
                                            <xsl:text>&gt;</xsl:text>
                                        </xsl:element>
                                    </xsl:when>
                                    <xsl:when test="contains($el, 'study')">
                                        <xsl:apply-templates/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:apply-templates/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:apply-templates/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="attribute::rend='el_X'">
                <xsl:choose>
                    <xsl:when test="$handwriting = 'off'"></xsl:when>
                    <xsl:otherwise>
                        <xsl:choose>
                            <xsl:when test="contains($visning, 'dipl')">
                                <xsl:choose>
                                    <xsl:when test="contains($el, 'study')">
                                        <xsl:apply-templates/>
                                    </xsl:when>
                                    <xsl:when test="contains($el, 'norm')">
                                        <xsl:apply-templates/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:element name="SPAN">
                                            <xsl:attribute name="style">color: #888BBD;</xsl:attribute>
                                            <xsl:text>&lt;</xsl:text>
                                            <xsl:apply-templates/>
                                            <xsl:text>&gt;</xsl:text>
                                        </xsl:element>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:when>
                            <xsl:when test="contains($visning, 'study')">
                                <xsl:choose>
                                    <xsl:when test="contains($el, 'dipl')">
                                        <xsl:element name="SPAN">
                                            <xsl:attribute name="style">color: #888BBD;</xsl:attribute>
                                            <xsl:text>&lt;</xsl:text>
                                            <xsl:apply-templates/>
                                            <xsl:text>&gt;</xsl:text>
                                        </xsl:element>
                                    </xsl:when>
                                    <xsl:when test="contains($el, 'norm')">
                                        <xsl:apply-templates/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:apply-templates/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:when>
                            <xsl:when test="contains($visning, 'norm')">
                                <xsl:choose>
                                    <xsl:when test="contains($el, 'dipl')">
                                        <xsl:element name="SPAN">
                                            <xsl:attribute name="style">color: #888BBD;</xsl:attribute>
                                            <xsl:text>&lt;</xsl:text>
                                            <xsl:apply-templates/>
                                            <xsl:text>&gt;</xsl:text>
                                        </xsl:element>
                                    </xsl:when>
                                    <xsl:when test="contains($el, 'study')">
                                        <xsl:apply-templates/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:apply-templates/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:apply-templates/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="attribute::rend='fremd'">
                <xsl:choose>
                    <xsl:when test="contains($visning, 'dipl')">
                        <xsl:element name="SPAN">
                            <xsl:attribute name="style">color: #FF7F00;</xsl:attribute>
                            <xsl:apply-templates/>
                        </xsl:element>
                    </xsl:when>
                    <xsl:when test="contains($visning, 'study')"></xsl:when>
                    <xsl:when test="contains($visning, 'norm')"></xsl:when>
                    <xsl:otherwise>
                        <xsl:apply-templates/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="attribute::rend='H'">
                <!-- Changes need to be reflected on ab as well -->
                <xsl:choose>
                    <xsl:when test="contains($handwriting, 'off')"/>
                    <xsl:otherwise>
                        <xsl:choose>
                            <xsl:when test="contains($visning, 'dipl')">
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">color: #33FFFF;</xsl:attribute>
                                    <xsl:apply-templates/>
                                </xsl:element>
                            </xsl:when>
                            <xsl:when test="contains($visning, 'study')">
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">color: #33FFFF;</xsl:attribute>
                                    <xsl:apply-templates/>
                                </xsl:element>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">color: #33FFFF;</xsl:attribute>
                                    <xsl:apply-templates/>
                                </xsl:element>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="attribute::rend='i'">
                <xsl:choose>
                    <xsl:when test="contains($visning, 'dipl')">
                        <xsl:choose>
                            <xsl:when test="contains($i, 'study')">
                                <xsl:apply-templates/>
                            </xsl:when>
                            <xsl:when test="contains($i, 'norm')">
                                <xsl:apply-templates/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">vertical-align: super; font-size: 10pt;</xsl:attribute>
                                    <xsl:apply-templates/>
                                </xsl:element>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:when test="contains($visning, 'study')">
                        <xsl:choose>
                            <xsl:when test="contains($i, 'dipl')">
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">vertical-align: super; font-size: 10pt;</xsl:attribute>
                                    <xsl:apply-templates/>
                                </xsl:element>
                            </xsl:when>
                            <xsl:when test="contains($i, 'norm')">
                                <xsl:apply-templates/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:apply-templates/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:when test="contains($visning, 'norm')">
                        <xsl:choose>
                            <xsl:when test="contains($i, 'dipl')">
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">vertical-align: super; font-size: 10pt;</xsl:attribute>
                                    <xsl:apply-templates/>
                                </xsl:element>
                            </xsl:when>
                            <xsl:when test="contains($i, 'study')">
                                <xsl:apply-templates/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:apply-templates/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:apply-templates/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="attribute::rend='i_h'">
                <xsl:choose>
                    <xsl:when test="$handwriting = 'off'"></xsl:when>
                    <xsl:otherwise>
                        <xsl:choose>
                            <xsl:when test="contains($visning, 'dipl')">
                                <xsl:choose>
                                    <xsl:when test="contains($i, 'study')">
                                        <xsl:apply-templates/>
                                    </xsl:when>
                                    <xsl:when test="contains($i, 'norm')">
                                        <xsl:apply-templates/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:element name="SPAN">
                                            <xsl:attribute name="style">color: #0000FF; vertical-align: super; font-size: 10pt;</xsl:attribute>
                                            <xsl:apply-templates/>
                                        </xsl:element>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:when>
                            <xsl:when test="contains($visning, 'study')">
                                <xsl:choose>
                                    <xsl:when test="contains($i, 'dipl')">
                                        <xsl:element name="SPAN">
                                            <xsl:attribute name="style">color: #0000FF; vertical-align: super; font-size: 10pt;</xsl:attribute>
                                            <xsl:apply-templates/>
                                        </xsl:element>
                                    </xsl:when>
                                    <xsl:when test="contains($i, 'norm')">
                                        <xsl:apply-templates/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:apply-templates/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:apply-templates/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="attribute::rend='i_H1'">
                <xsl:choose>
                    <xsl:when test="$handwriting = 'off'"></xsl:when>
                    <xsl:otherwise>
                        <xsl:choose>
                            <xsl:when test="contains($visning, 'dipl')">
                                <xsl:choose>
                                    <xsl:when test="contains($i, 'study')">
                                        <xsl:apply-templates/>
                                    </xsl:when>
                                    <xsl:when test="contains($i, 'norm')">
                                        <xsl:apply-templates/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:element name="SPAN">
                                            <xsl:attribute name="style">color: #0000FF; vertical-align: super; font-size: 10pt;</xsl:attribute>
                                            <xsl:apply-templates/>
                                        </xsl:element>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:when>
                            <xsl:when test="contains($visning, 'study')">
                                <xsl:choose>
                                    <xsl:when test="contains($i, 'dipl')">
                                        <xsl:element name="SPAN">
                                            <xsl:attribute name="style">color: #0000FF; vertical-align: super; font-size: 10pt;</xsl:attribute>
                                            <xsl:apply-templates/>
                                        </xsl:element>
                                    </xsl:when>
                                    <xsl:when test="contains($i, 'norm')">
                                        <xsl:apply-templates/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:apply-templates/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:apply-templates/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="attribute::rend='i_s'">
                <xsl:choose>
                    <xsl:when test="$handwriting = 'off'"></xsl:when>
                    <xsl:otherwise>
                        <xsl:choose>
                            <xsl:when test="contains($visning, 'dipl')">
                                <xsl:choose>
                                    <xsl:when test="contains($i, 'study')">
                                        <xsl:apply-templates/>
                                    </xsl:when>
                                    <xsl:when test="contains($i, 'norm')">
                                        <xsl:apply-templates/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:element name="SPAN">
                                            <xsl:attribute name="style">color: #0000FF; vertical-align: super; font-size: 10pt;</xsl:attribute>
                                            <xsl:apply-templates/>
                                        </xsl:element>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:when>
                            <xsl:when test="contains($visning, 'study')">
                                <xsl:choose>
                                    <xsl:when test="contains($i, 'dipl')">
                                        <xsl:element name="SPAN">
                                            <xsl:attribute name="style">color: #0000FF; vertical-align: super; font-size: 10pt;</xsl:attribute>
                                            <xsl:apply-templates/>
                                        </xsl:element>
                                    </xsl:when>
                                    <xsl:when test="contains($i, 'norm')">
                                        <xsl:apply-templates/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:apply-templates/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:apply-templates/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="attribute::rend='i_S1'">
                <xsl:choose>
                    <xsl:when test="$handwriting = 'off'"></xsl:when>
                    <xsl:otherwise>
                        <xsl:choose>
                            <xsl:when test="contains($visning, 'dipl')">
                                <xsl:choose>
                                    <xsl:when test="contains($i, 'study')">
                                        <xsl:apply-templates/>
                                    </xsl:when>
                                    <xsl:when test="contains($i, 'norm')">
                                        <xsl:apply-templates/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:element name="SPAN">
                                            <xsl:attribute name="style">color: #0000FF; vertical-align: super; font-size: 10pt;</xsl:attribute>
                                            <xsl:apply-templates/>
                                        </xsl:element>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:when>
                            <xsl:when test="contains($visning, 'study')">
                                <xsl:choose>
                                    <xsl:when test="contains($i, 'dipl')">
                                        <xsl:element name="SPAN">
                                            <xsl:attribute name="style">color: #0000FF; vertical-align: super; font-size: 10pt;</xsl:attribute>
                                            <xsl:apply-templates/>
                                        </xsl:element>
                                    </xsl:when>
                                    <xsl:when test="contains($i, 'norm')">
                                        <xsl:apply-templates/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:apply-templates/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:apply-templates/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="attribute::rend='ib'">
                <xsl:choose>
                    <xsl:when test="contains($visning, 'dipl')">
                        <xsl:element name="SPAN">
                            <xsl:attribute name="style">vertical-align: sub; font-size: 10pt;</xsl:attribute>
                            <xsl:apply-templates/>
                        </xsl:element>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:apply-templates/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="attribute::rend='ib_h'">
                <xsl:choose>
                    <xsl:when test="$handwriting = 'off'"></xsl:when>
                    <xsl:otherwise>
                        <xsl:choose>
                            <xsl:when test="contains($visning, 'dipl')">
                                <xsl:choose>
                                    <xsl:when test="contains($i, 'study')">
                                        <xsl:apply-templates/>
                                    </xsl:when>
                                    <xsl:when test="contains($i, 'norm')">
                                        <xsl:apply-templates/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:element name="SPAN">
                                            <xsl:attribute name="style">color: #0000FF; vertical-align: sub; font-size: 10pt;</xsl:attribute>
                                            <xsl:apply-templates/>
                                        </xsl:element>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:when>
                            <xsl:when test="contains($visning, 'study')">
                                <xsl:choose>
                                    <xsl:when test="contains($i, 'dipl')">
                                        <xsl:element name="SPAN">
                                            <xsl:attribute name="style">color: #0000FF; vertical-align: sub; font-size: 10pt;</xsl:attribute>
                                            <xsl:apply-templates/>
                                        </xsl:element>
                                    </xsl:when>
                                    <xsl:when test="contains($i, 'norm')">
                                        <xsl:apply-templates/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:apply-templates/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:apply-templates/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="attribute::rend='ilm'">
                <!-- Changes need to be reflected on ab as well -->
                <xsl:choose>
                    <xsl:when test="contains($visning, 'dipl')">
                        <xsl:element name="SPAN">
                            <xsl:attribute name="style">color: #FF00FF;</xsl:attribute>
                            <xsl:text>&lt;</xsl:text>
                        </xsl:element>
                        <xsl:apply-templates/>
                        <xsl:element name="SPAN">
                            <xsl:attribute name="style">color: #FF00FF;</xsl:attribute>
                            <xsl:text>&gt;</xsl:text>
                        </xsl:element>
                    </xsl:when>
                    <xsl:when test="contains($visning, 'study')">
                        <xsl:element name="SPAN">
                            <xsl:attribute name="style">color: #FF00FF;</xsl:attribute>
                            <xsl:text>&lt;</xsl:text>
                        </xsl:element>
                        <xsl:apply-templates/>
                        <xsl:element name="SPAN">
                            <xsl:attribute name="style">color: #FF00FF;</xsl:attribute>
                            <xsl:text>&gt;</xsl:text>
                        </xsl:element>
                    </xsl:when>
                    <xsl:when test="contains($visning, 'norm')">
                        <xsl:apply-templates/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:apply-templates/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="attribute::rend='ilm_h'">
                <xsl:choose>
                    <xsl:when test="$handwriting = 'off'"></xsl:when>
                    <xsl:otherwise>
                        <xsl:choose>
                            <xsl:when test="contains($visning, 'dipl')">
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">color: #FF00FF;</xsl:attribute>
                                    <xsl:text>&lt;</xsl:text>
                                </xsl:element>
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">color: #0000FF;</xsl:attribute>
                                    <xsl:apply-templates/>
                                </xsl:element>
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">color: #FF00FF;</xsl:attribute>
                                    <xsl:text>&gt;</xsl:text>
                                </xsl:element>
                            </xsl:when>
                            <xsl:when test="contains($visning, 'study')">
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">color: #FF00FF;</xsl:attribute>
                                    <xsl:text>&lt;</xsl:text>
                                </xsl:element>
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">color: #0000FF;</xsl:attribute>
                                    <xsl:apply-templates/>
                                </xsl:element>
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">color: #FF00FF;</xsl:attribute>
                                    <xsl:text>&gt;</xsl:text>
                                </xsl:element>
                            </xsl:when>
                            <xsl:when test="contains($visning, 'norm')">
                                <xsl:apply-templates/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:apply-templates/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="attribute::rend='ilmm'">
                <xsl:choose>
                    <xsl:when test="contains($visning, 'dipl')">
                        <xsl:element name="SPAN">
                            <xsl:attribute name="style">color: #FF00FF;</xsl:attribute>
                            <xsl:text>&lt;</xsl:text>
                        </xsl:element>
                        <xsl:apply-templates/>
                        <xsl:element name="SPAN">
                            <xsl:attribute name="style">color: #FF00FF;</xsl:attribute>
                            <xsl:text>&gt;</xsl:text>
                        </xsl:element>
                    </xsl:when>
                    <xsl:when test="contains($visning, 'study')">
                        <xsl:element name="SPAN">
                            <xsl:attribute name="style">color: #FF00FF;</xsl:attribute>
                            <xsl:text>&lt;</xsl:text>
                        </xsl:element>
                        <xsl:apply-templates/>
                        <xsl:element name="SPAN">
                            <xsl:attribute name="style">color: #FF00FF;</xsl:attribute>
                            <xsl:text>&gt;</xsl:text>
                        </xsl:element>
                    </xsl:when>
                    <xsl:when test="contains($visning, 'norm')">
                        <xsl:apply-templates/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:apply-templates/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="attribute::rend='ilom'">
                <!-- Changes need to be reflected on ab as well -->
                <xsl:choose>
                    <xsl:when test="contains($visning, 'dipl')">
                        <xsl:element name="SPAN">
                            <xsl:attribute name="style">color: #FF00FF;</xsl:attribute>
                            <xsl:text>&lt;</xsl:text>
                        </xsl:element>
                        <xsl:apply-templates/>
                        <xsl:element name="SPAN">
                            <xsl:attribute name="style">color: #FF00FF;</xsl:attribute>
                            <xsl:text>&gt;</xsl:text>
                        </xsl:element>
                    </xsl:when>
                    <xsl:when test="contains($visning, 'study')">
                        <xsl:element name="SPAN">
                            <xsl:attribute name="style">color: #FF00FF;</xsl:attribute>
                            <xsl:text>&lt;</xsl:text>
                        </xsl:element>
                        <xsl:apply-templates/>
                        <xsl:element name="SPAN">
                            <xsl:attribute name="style">color: #FF00FF;</xsl:attribute>
                            <xsl:text>&gt;</xsl:text>
                        </xsl:element>
                    </xsl:when>
                    <xsl:when test="contains($visning, 'norm')">
                        <xsl:apply-templates/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:apply-templates/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="attribute::rend='ilom_h'">
                <xsl:choose>
                    <xsl:when test="$handwriting = 'off'"></xsl:when>
                    <xsl:otherwise>
                        <xsl:choose>
                            <xsl:when test="contains($visning, 'dipl')">
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">color: #FF00FF;</xsl:attribute>
                                    <xsl:text>&lt;</xsl:text>
                                </xsl:element>
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">color: #0000FF;</xsl:attribute>
                                    <xsl:apply-templates/>
                                </xsl:element>
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">color: #FF00FF;</xsl:attribute>
                                    <xsl:text>&gt;</xsl:text>
                                </xsl:element>
                            </xsl:when>
                            <xsl:when test="contains($visning, 'study')">
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">color: #FF00FF;</xsl:attribute>
                                    <xsl:text>&lt;</xsl:text>
                                </xsl:element>
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">color: #0000FF;</xsl:attribute>
                                    <xsl:apply-templates/>
                                </xsl:element>
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">color: #FF00FF;</xsl:attribute>
                                    <xsl:text>&gt;</xsl:text>
                                </xsl:element>
                            </xsl:when>
                            <xsl:when test="contains($visning, 'norm')">
                                <xsl:apply-templates/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:apply-templates/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="attribute::rend='ilomm'">
                <xsl:choose>
                    <xsl:when test="contains($visning, 'dipl')">
                        <xsl:element name="SPAN">
                            <xsl:attribute name="style">color: #FF00FF;</xsl:attribute>
                            <xsl:text>&lt;</xsl:text>
                        </xsl:element>
                        <xsl:text>&#x02C7;</xsl:text>
                        <xsl:apply-templates/>
                        <xsl:element name="SPAN">
                            <xsl:attribute name="style">color: #FF00FF;</xsl:attribute>
                            <xsl:text>&gt;</xsl:text>
                        </xsl:element>
                    </xsl:when>
                    <xsl:when test="contains($visning, 'study')">
                        <xsl:element name="SPAN">
                            <xsl:attribute name="style">color: #FF00FF;</xsl:attribute>
                            <xsl:text>&lt;</xsl:text>
                        </xsl:element>
                        <xsl:text>&#x02C7;</xsl:text>
                        <xsl:apply-templates/>
                        <xsl:element name="SPAN">
                            <xsl:attribute name="style">color: #FF00FF;</xsl:attribute>
                            <xsl:text>&gt;</xsl:text>
                        </xsl:element>
                    </xsl:when>
                    <xsl:when test="contains($visning, 'norm')">
                        <xsl:apply-templates/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:apply-templates/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
        	<xsl:when test="attribute::rend='ilomm_h'">
        		<xsl:choose>
        			<xsl:when test="$handwriting = 'off'"></xsl:when>
        			<xsl:otherwise>
        				<xsl:choose>
        					<xsl:when test="contains($visning, 'dipl')">
        						<xsl:element name="SPAN">
        							<xsl:attribute name="style">color: #FF00FF;</xsl:attribute>
        							<xsl:text>&lt;</xsl:text>
        						</xsl:element>
        						<xsl:element name="SPAN">
        							<xsl:attribute name="style">color: #0000FF;</xsl:attribute>
        							<xsl:text>&#x02C7;</xsl:text>
        							<xsl:apply-templates/>
        						</xsl:element>
        						<xsl:element name="SPAN">
        							<xsl:attribute name="style">color: #FF00FF;</xsl:attribute>
        							<xsl:text>&gt;</xsl:text>
        						</xsl:element>
        					</xsl:when>
        					<xsl:when test="contains($visning, 'study')">
        						<xsl:element name="SPAN">
        							<xsl:attribute name="style">color: #FF00FF;</xsl:attribute>
        							<xsl:text>&lt;</xsl:text>
        						</xsl:element>
        						<xsl:element name="SPAN">
        							<xsl:attribute name="style">color: #0000FF;</xsl:attribute>
        							<xsl:text>&#x02C7;</xsl:text>
        							<xsl:apply-templates/>
        						</xsl:element>
        						<xsl:element name="SPAN">
        							<xsl:attribute name="style">color: #FF00FF;</xsl:attribute>
        							<xsl:text>&gt;</xsl:text>
        						</xsl:element>
        					</xsl:when>
        					<xsl:when test="contains($visning, 'norm')">
        						<xsl:apply-templates/>
        					</xsl:when>
        					<xsl:otherwise>
        						<xsl:apply-templates/>
        					</xsl:otherwise>
        				</xsl:choose>
        			</xsl:otherwise>
        		</xsl:choose>
        	</xsl:when>
            <xsl:when test="attribute::rend='im'">
                <xsl:choose>
                    <xsl:when test="contains($visning, 'dipl')">
                        <xsl:choose>
                            <xsl:when test="contains($im, 'study')">
                                <xsl:apply-templates/>
                            </xsl:when>
                            <xsl:when test="contains($im, 'norm')">
                                <xsl:apply-templates/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">vertical-align: super; font-size: 10pt;</xsl:attribute>
                                    <xsl:text>&#x02C7;</xsl:text>
                                    <xsl:apply-templates/>
                                </xsl:element>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:when test="contains($visning, 'study')">
                        <xsl:choose>
                            <xsl:when test="contains($im, 'dipl')">
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">vertical-align: super; font-size: 10pt;</xsl:attribute>
                                    <xsl:text>&#x02C7;</xsl:text>
                                    <xsl:apply-templates/>
                                </xsl:element>
                            </xsl:when>
                            <xsl:when test="contains($im, 'norm')">
                                <xsl:apply-templates/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:apply-templates/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:when test="contains($visning, 'norm')">
                        <xsl:choose>
                            <xsl:when test="contains($im, 'dipl')">
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">vertical-align: super; font-size: 10pt;</xsl:attribute>
                                    <xsl:text>&#x02C7;</xsl:text>
                                    <xsl:apply-templates/>
                                </xsl:element>
                            </xsl:when>
                            <xsl:when test="contains($im, 'study')">
                                <xsl:apply-templates/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:apply-templates/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:apply-templates/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="attribute::rend='im_h'">
                <xsl:choose>
                    <xsl:when test="$handwriting = 'off'"></xsl:when>
                    <xsl:otherwise>
                        <xsl:choose>
                            <xsl:when test="contains($visning, 'dipl')">
                                <xsl:choose>
                                    <xsl:when test="contains($im, 'study')">
                                        <xsl:apply-templates/>
                                    </xsl:when>
                                    <xsl:when test="contains($im, 'norm')">
                                        <xsl:apply-templates/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:element name="SPAN">
                                            <xsl:attribute name="style">vertical-align: super; font-size: 10pt; color: #0000FF;</xsl:attribute>
                                            <xsl:text>&#x02C7;</xsl:text>
                                            <xsl:apply-templates/>
                                        </xsl:element>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:when>
                            <xsl:when test="contains($visning, 'study')">
                                <xsl:choose>
                                    <xsl:when test="contains($im, 'dipl')">
                                        <xsl:element name="SPAN">
                                            <xsl:attribute name="style">vertical-align: super; font-size: 10pt; color: #0000FF;</xsl:attribute>
                                            <xsl:text>&#x02C7;</xsl:text>
                                            <xsl:apply-templates/>
                                        </xsl:element>
                                    </xsl:when>
                                    <xsl:when test="contains($im, 'norm')">
                                        <xsl:apply-templates/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:apply-templates/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:when>
                            <xsl:when test="contains($visning, 'norm')">
                                <xsl:choose>
                                    <xsl:when test="contains($im, 'dipl')">
                                        <xsl:element name="SPAN">
                                            <xsl:attribute name="style">vertical-align: super; font-size: 10pt; color: #0000FF;</xsl:attribute>
                                            <xsl:text>&#x02C7;</xsl:text>
                                            <xsl:apply-templates/>
                                        </xsl:element>
                                    </xsl:when>
                                    <xsl:when test="contains($im, 'study')">
                                        <xsl:apply-templates/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:apply-templates/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:apply-templates/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="attribute::rend='im_H1'">
                <xsl:choose>
                    <xsl:when test="$handwriting = 'off'"></xsl:when>
                    <xsl:otherwise>
                        <xsl:choose>
                            <xsl:when test="contains($visning, 'dipl')">
                                <xsl:choose>
                                    <xsl:when test="contains($im, 'study')">
                                        <xsl:apply-templates/>
                                    </xsl:when>
                                    <xsl:when test="contains($im, 'norm')">
                                        <xsl:apply-templates/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:element name="SPAN">
                                            <xsl:attribute name="style">vertical-align: super; font-size: 10pt; color: #0000FF;</xsl:attribute>
                                            <xsl:text>&#x02C7;</xsl:text>
                                            <xsl:apply-templates/>
                                        </xsl:element>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:when>
                            <xsl:when test="contains($visning, 'study')">
                                <xsl:choose>
                                    <xsl:when test="contains($im, 'dipl')">
                                        <xsl:element name="SPAN">
                                            <xsl:attribute name="style">vertical-align: super; font-size: 10pt; color: #0000FF;</xsl:attribute>
                                            <xsl:text>&#x02C7;</xsl:text>
                                            <xsl:apply-templates/>
                                        </xsl:element>
                                    </xsl:when>
                                    <xsl:when test="contains($im, 'norm')">
                                        <xsl:apply-templates/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:apply-templates/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:when>
                            <xsl:when test="contains($visning, 'norm')">
                                <xsl:choose>
                                    <xsl:when test="contains($im, 'dipl')">
                                        <xsl:element name="SPAN">
                                            <xsl:attribute name="style">vertical-align: super; font-size: 10pt; color: #0000FF;</xsl:attribute>
                                            <xsl:text>&#x02C7;</xsl:text>
                                            <xsl:apply-templates/>
                                        </xsl:element>
                                    </xsl:when>
                                    <xsl:when test="contains($im, 'study')">
                                        <xsl:apply-templates/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:apply-templates/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:apply-templates/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="attribute::rend='im_hm'"><!-- Insertion mark addded by hand -->
                <xsl:choose>
                    <xsl:when test="contains($visning, 'dipl')">
                        <xsl:choose>
                            <xsl:when test="contains($im, 'study')">
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">vertical-align: super; font-size: 10pt; color: #0000FF;</xsl:attribute>
                                    <xsl:choose>
                                        <xsl:when test="$handwriting = 'off'"></xsl:when>
                                        <xsl:otherwise>
                                            <xsl:text>&#x02C7;</xsl:text>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:element>
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">vertical-align: super;</xsl:attribute>
                                    <xsl:apply-templates/>
                                </xsl:element>
                            </xsl:when>
                            <xsl:when test="contains($im, 'norm')">
                                <xsl:apply-templates/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">vertical-align: super; font-size: 10pt; color: #0000FF;</xsl:attribute>
                                    <xsl:choose>
                                        <xsl:when test="$handwriting = 'off'"></xsl:when>
                                        <xsl:otherwise>
                                            <xsl:text>&#x02C7;</xsl:text>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:element>
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">vertical-align: super;</xsl:attribute>
                                    <xsl:apply-templates/>
                                </xsl:element>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:when test="contains($visning, 'study')">
                        <xsl:choose>
                            <xsl:when test="contains($im, 'dipl')">
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">vertical-align: super; font-size: 10pt; color: #0000FF;</xsl:attribute>
                                    <xsl:choose>
                                        <xsl:when test="$handwriting = 'off'"></xsl:when>
                                        <xsl:otherwise>
                                            <xsl:text>&#x02C7;</xsl:text>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:element>
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">vertical-align: super;</xsl:attribute>
                                    <xsl:apply-templates/>
                                </xsl:element>
                            </xsl:when>
                            <xsl:when test="contains($im, 'norm')">
                                <xsl:apply-templates/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">vertical-align: super; font-size: 10pt; color: #0000FF;</xsl:attribute>
                                    <xsl:choose>
                                        <xsl:when test="$handwriting = 'off'"></xsl:when>
                                        <xsl:otherwise>
                                            <xsl:text>&#x02C7;</xsl:text>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:element>
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">vertical-align: super;</xsl:attribute>
                                    <xsl:apply-templates/>
                                </xsl:element>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:when test="contains($visning, 'norm')">
                        <xsl:choose>
                            <xsl:when test="contains($im, 'dipl')">
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">vertical-align: super; font-size: 10pt; color: #0000FF;</xsl:attribute>
                                    <xsl:choose>
                                        <xsl:when test="$handwriting = 'off'"></xsl:when>
                                        <xsl:otherwise>
                                            <xsl:text>&#x02C7;</xsl:text>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:element>
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">vertical-align: super;</xsl:attribute>
                                    <xsl:apply-templates/>
                                </xsl:element>
                            </xsl:when>
                            <xsl:when test="contains($im, 'study')">
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">vertical-align: super; font-size: 10pt; color: #0000FF;</xsl:attribute>
                                    <xsl:choose>
                                        <xsl:when test="$handwriting = 'off'"></xsl:when>
                                        <xsl:otherwise>
                                            <xsl:text>&#x02C7;</xsl:text>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:element>
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">vertical-align: super;</xsl:attribute>
                                    <xsl:apply-templates/>
                                </xsl:element>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:apply-templates/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:apply-templates/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="attribute::rend='im_S1'">
                <xsl:choose>
                    <xsl:when test="$handwriting = 'off'"></xsl:when>
                    <xsl:otherwise>
                        <xsl:choose>
                            <xsl:when test="contains($visning, 'dipl')">
                                <xsl:choose>
                                    <xsl:when test="contains($im, 'study')">
                                        <xsl:apply-templates/>
                                    </xsl:when>
                                    <xsl:when test="contains($im, 'norm')">
                                        <xsl:apply-templates/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:element name="SPAN">
                                            <xsl:attribute name="style">vertical-align: super; font-size: 10pt; color: #0000FF;</xsl:attribute>
                                            <xsl:text>&#x02C7;</xsl:text>
                                            <xsl:apply-templates/>
                                        </xsl:element>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:when>
                            <xsl:when test="contains($visning, 'study')">
                                <xsl:choose>
                                    <xsl:when test="contains($im, 'dipl')">
                                        <xsl:element name="SPAN">
                                            <xsl:attribute name="style">vertical-align: super; font-size: 10pt; color: #0000FF;</xsl:attribute>
                                            <xsl:text>&#x02C7;</xsl:text>
                                            <xsl:apply-templates/>
                                        </xsl:element>
                                    </xsl:when>
                                    <xsl:when test="contains($im, 'norm')">
                                        <xsl:apply-templates/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:apply-templates/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:when>
                            <xsl:when test="contains($visning, 'norm')">
                                <xsl:choose>
                                    <xsl:when test="contains($im, 'dipl')">
                                        <xsl:element name="SPAN">
                                            <xsl:attribute name="style">vertical-align: super; font-size: 10pt; color: #0000FF;</xsl:attribute>
                                            <xsl:text>&#x02C7;</xsl:text>
                                            <xsl:apply-templates/>
                                        </xsl:element>
                                    </xsl:when>
                                    <xsl:when test="contains($im, 'study')">
                                        <xsl:apply-templates/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:apply-templates/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:apply-templates/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="attribute::rend='im_X'">
                <xsl:choose>
                    <xsl:when test="contains($handwriting, 'off')"/>
                    <xsl:otherwise>
                        <xsl:choose>
                            <xsl:when test="contains($visning, 'dipl')">
                                <xsl:choose>
                                    <xsl:when test="contains($im, 'study')">
                                        <xsl:apply-templates/>
                                    </xsl:when>
                                    <xsl:when test="contains($im, 'norm')">
                                        <xsl:apply-templates/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:element name="SPAN">
                                            <xsl:attribute name="style">vertical-align: super; font-size: 10pt; color: #888BBD;</xsl:attribute>
                                            <xsl:text>&#x02C7;</xsl:text>
                                            <xsl:apply-templates/>
                                        </xsl:element>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:when>
                            <xsl:when test="contains($visning, 'study')">
                                <xsl:choose>
                                    <xsl:when test="contains($im, 'dipl')">
                                        <xsl:element name="SPAN">
                                            <xsl:attribute name="style">vertical-align: super; font-size: 10pt; color: #888BBD;</xsl:attribute>
                                            <xsl:text>&#x02C7;</xsl:text>
                                            <xsl:apply-templates/>
                                        </xsl:element>
                                    </xsl:when>
                                    <xsl:when test="contains($im, 'norm')">
                                        <xsl:apply-templates/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:apply-templates/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:apply-templates/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="attribute::rend='imb'"><!-- Sjekk visning -->
                <xsl:choose>
                    <xsl:when test="contains($visning, 'dipl')">
                        <xsl:choose>
                            <xsl:when test="contains($im, 'study')">
                                <xsl:apply-templates/>
                            </xsl:when>
                            <xsl:when test="contains($im, 'norm')">
                                <xsl:apply-templates/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">vertical-align: sub; font-size: 10pt;</xsl:attribute>
                                    <xsl:text>&#x02C7;</xsl:text>
                                    <xsl:apply-templates/>
                                </xsl:element>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:when test="contains($visning, 'study')">
                        <xsl:choose>
                            <xsl:when test="contains($im, 'dipl')">
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">vertical-align: super; font-size: 10pt;</xsl:attribute>
                                    <xsl:text>&#x02C7;</xsl:text>
                                    <xsl:apply-templates/>
                                </xsl:element>
                            </xsl:when>
                            <xsl:when test="contains($im, 'norm')">
                                <xsl:apply-templates/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:apply-templates/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:when test="contains($visning, 'norm')">
                        <xsl:choose>
                            <xsl:when test="contains($im, 'dipl')">
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">vertical-align: super; font-size: 10pt;</xsl:attribute>
                                    <xsl:text>&#x02C7;</xsl:text>
                                    <xsl:apply-templates/>
                                </xsl:element>
                            </xsl:when>
                            <xsl:when test="contains($im, 'study')">
                                <xsl:apply-templates/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:apply-templates/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:apply-templates/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="attribute::rend='imb_h'"><!-- Sjekk visning -->
                <xsl:choose>
                    <xsl:when test="contains($visning, 'dipl')">
                        <xsl:choose>
                            <xsl:when test="$handwriting='off'"></xsl:when>
                            <xsl:otherwise>
                                <xsl:choose>
                                    <xsl:when test="contains($im, 'study')">
                                        <xsl:apply-templates/>
                                    </xsl:when>
                                    <xsl:when test="contains($im, 'norm')">
                                        <xsl:apply-templates/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:element name="SPAN">
                                            <xsl:attribute name="style">vertical-align: sub; font-size: 10pt; color: #0000FF;</xsl:attribute>
                                            <xsl:text>&#x02C7;</xsl:text>
                                            <xsl:apply-templates/>
                                        </xsl:element>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:when test="contains($visning, 'study')">
                        <xsl:choose>
                            <xsl:when test="$handwriting='off'"></xsl:when>
                            <xsl:otherwise>
                                <xsl:choose>
                                    <xsl:when test="contains($im, 'dipl')">
                                        <xsl:element name="SPAN">
                                            <xsl:attribute name="style">vertical-align: super; font-size: 10pt; color: #0000FF;</xsl:attribute>
                                            <xsl:text>&#x02C7;</xsl:text>
                                            <xsl:apply-templates/>
                                        </xsl:element>
                                    </xsl:when>
                                    <xsl:when test="contains($im, 'norm')">
                                        <xsl:apply-templates/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:apply-templates/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:when test="contains($visning, 'norm')">
                        <xsl:choose>
                            <xsl:when test="$handwriting='off'"></xsl:when>
                            <xsl:otherwise>
                                <xsl:choose>
                                    <xsl:when test="contains($im, 'dipl')">
                                        <xsl:element name="SPAN">
                                            <xsl:attribute name="style">vertical-align: super; font-size: 10pt; color: #0000FF;</xsl:attribute>
                                            <xsl:text>&#x02C7;</xsl:text>
                                            <xsl:apply-templates/>
                                        </xsl:element>
                                    </xsl:when>
                                    <xsl:when test="contains($im, 'study')">
                                        <xsl:apply-templates/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:apply-templates/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:choose>
                            <xsl:when test="$handwriting='off'"></xsl:when>
                            <xsl:otherwise>
                                <xsl:apply-templates/>                                
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="attribute::rend='imw'">
                <xsl:choose>
                    <xsl:when test="contains($visning, 'dipl')">
                        <xsl:choose>
                            <xsl:when test="contains($im, 'study')">
                                <xsl:apply-templates/>
                            </xsl:when>
                            <xsl:when test="contains($im, 'norm')">
                                <xsl:apply-templates/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">vertical-align: super; font-size: 10pt;</xsl:attribute>
                                    <xsl:text>&#x02C7;</xsl:text>
                                    <xsl:apply-templates/>
                                </xsl:element>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:when test="contains($visning, 'study')">
                        <xsl:choose>
                            <xsl:when test="contains($im, 'dipl')">
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">vertical-align: super; font-size: 10pt;</xsl:attribute>
                                    <xsl:text>&#x02C7;</xsl:text>
                                    <xsl:apply-templates/>
                                </xsl:element>
                            </xsl:when>
                            <xsl:when test="contains($im, 'norm')">
                                <xsl:apply-templates/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:apply-templates/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:when test="contains($visning, 'norm')">
                        <xsl:choose>
                            <xsl:when test="contains($im, 'dipl')">
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">vertical-align: super; font-size: 10pt;</xsl:attribute>
                                    <xsl:text>&#x02C7;</xsl:text>
                                    <xsl:apply-templates/>
                                </xsl:element>
                            </xsl:when>
                            <xsl:when test="contains($im, 'study')">
                                <xsl:apply-templates/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:apply-templates/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:apply-templates/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="attribute::rend='imw_c'">
                <xsl:choose>
                    <xsl:when test="contains($visning, 'dipl')">
                        <xsl:choose>
                            <xsl:when test="contains($im, 'study')">
                                <xsl:apply-templates/>
                            </xsl:when>
                            <xsl:when test="contains($im, 'norm')">
                                <xsl:apply-templates/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">vertical-align: super; font-size: 10pt;</xsl:attribute>
                                    <xsl:text>&#x02C7;</xsl:text>
                                    <xsl:apply-templates/>
                                    <xsl:element name="SPAN">
                                        <xsl:attribute name="style">color: #FF0000;</xsl:attribute>
                                        <xsl:element name="SUP">
                                            <xsl:text>[c]</xsl:text>
                                        </xsl:element>
                                    </xsl:element>
                                </xsl:element>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:when test="contains($visning, 'study')">
                        <xsl:choose>
                            <xsl:when test="contains($im, 'dipl')">
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">vertical-align: super; font-size: 10pt;</xsl:attribute>
                                    <xsl:text>&#x02C7;</xsl:text>
                                    <xsl:apply-templates/>
                                    <xsl:element name="SPAN">
                                        <xsl:attribute name="style">color: #FF0000;</xsl:attribute>
                                        <xsl:element name="SUP">
                                            <xsl:text>[c]</xsl:text>
                                        </xsl:element>
                                    </xsl:element>
                                </xsl:element>
                            </xsl:when>
                            <xsl:when test="contains($im, 'norm')">
                                <xsl:apply-templates/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:apply-templates/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:when test="contains($visning, 'norm')">
                        <xsl:choose>
                            <xsl:when test="contains($im, 'dipl')">
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">vertical-align: super; font-size: 10pt;</xsl:attribute>
                                    <xsl:text>&#x02C7;</xsl:text>
                                    <xsl:apply-templates/>
                                    <xsl:element name="SPAN">
                                        <xsl:attribute name="style">color: #FF0000;</xsl:attribute>
                                        <xsl:element name="SUP">
                                            <xsl:text>[c]</xsl:text>
                                        </xsl:element>
                                    </xsl:element>
                                </xsl:element>
                            </xsl:when>
                            <xsl:when test="contains($im, 'study')">
                                <xsl:apply-templates/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:apply-templates/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:apply-templates/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="attribute::rend='imw_h'">
                <xsl:choose>
                    <xsl:when test="$handwriting = 'off'">
                        <xsl:choose>
                            <xsl:when test="contains($visning, 'dipl')">
                                <xsl:choose>
                                    <xsl:when test="contains($im, 'study')">
                                        <xsl:apply-templates/>
                                    </xsl:when>
                                    <xsl:when test="contains($im, 'norm')">
                                        <xsl:apply-templates/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:element name="SPAN">
                                            <xsl:attribute name="style">vertical-align: super; font-size: 10pt;</xsl:attribute>
                                            <xsl:text>&#x02C7;</xsl:text>
                                            <xsl:apply-templates/>
                                        </xsl:element>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:when>
                            <xsl:when test="contains($visning, 'study')">
                                <xsl:choose>
                                    <xsl:when test="contains($im, 'dipl')">
                                        <xsl:element name="SPAN">
                                            <xsl:attribute name="style">vertical-align: super; font-size: 10pt;</xsl:attribute>
                                            <xsl:text>&#x02C7;</xsl:text>
                                            <xsl:apply-templates/>
                                        </xsl:element>
                                    </xsl:when>
                                    <xsl:when test="contains($im, 'norm')">
                                        <xsl:apply-templates/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:apply-templates/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:when>
                            <xsl:when test="contains($visning, 'norm')">
                                <xsl:choose>
                                    <xsl:when test="contains($im, 'dipl')">
                                        <xsl:element name="SPAN">
                                            <xsl:attribute name="style">vertical-align: super; font-size: 10pt;</xsl:attribute>
                                            <xsl:text>&#x02C7;</xsl:text>
                                            <xsl:apply-templates/>
                                        </xsl:element>
                                    </xsl:when>
                                    <xsl:when test="contains($im, 'study')">
                                        <xsl:apply-templates/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:apply-templates/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:apply-templates/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:choose>
                            <xsl:when test="contains($visning, 'dipl')">
                                <xsl:choose>
                                    <xsl:when test="contains($im, 'study')">
                                        <xsl:element name="SPAN">
                                            <xsl:attribute name="style">vertical-align: super; font-size: 10pt;</xsl:attribute>
                                            <xsl:text>&#x02C7;</xsl:text>
                                            <xsl:apply-templates/>
                                        </xsl:element>
                                    </xsl:when>
                                    <xsl:when test="contains($im, 'norm')">
                                        <xsl:apply-templates/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:element name="SPAN">
                                            <xsl:attribute name="style">vertical-align: super; font-size: 10pt;</xsl:attribute>
                                            <xsl:text>&#x02C7;</xsl:text>
                                            <xsl:apply-templates/>
                                        </xsl:element>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:when>
                            <xsl:when test="contains($visning, 'study')">
                                <xsl:choose>
                                    <xsl:when test="contains($im, 'dipl')">
                                        <xsl:element name="SPAN">
                                            <xsl:attribute name="style">vertical-align: super; font-size: 10pt;</xsl:attribute>
                                            <xsl:text>&#x02C7;</xsl:text>
                                            <xsl:apply-templates/>
                                        </xsl:element>
                                    </xsl:when>
                                    <xsl:when test="contains($im, 'norm')">
                                        <xsl:apply-templates/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:element name="SPAN">
                                            <xsl:attribute name="style">vertical-align: super; font-size: 10pt;</xsl:attribute>
                                            <xsl:text>&#x02C7;</xsl:text>
                                            <xsl:apply-templates/>
                                        </xsl:element>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:when>
                            <xsl:when test="contains($visning, 'norm')">
                                <xsl:choose>
                                    <xsl:when test="contains($im, 'dipl')">
                                        <xsl:element name="SPAN">
                                            <xsl:attribute name="style">vertical-align: super; font-size: 10pt;</xsl:attribute>
                                            <xsl:text>&#x02C7;</xsl:text>
                                            <xsl:element name="SPAN">
                                                <xsl:attribute name="style">color: #0000FF;</xsl:attribute>
                                                <xsl:apply-templates/>
                                            </xsl:element>
                                        </xsl:element>
                                    </xsl:when>
                                    <xsl:when test="contains($im, 'study')">
                                        <xsl:element name="SPAN">
                                            <xsl:attribute name="style">vertical-align: super; font-size: 10pt;</xsl:attribute>
                                            <xsl:text>&#x02C7;</xsl:text>
                                            <xsl:apply-templates/>
                                        </xsl:element>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:apply-templates/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:apply-templates/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:otherwise>
                </xsl:choose>                    
            </xsl:when>
            <xsl:when test="attribute::rend='ip_h'">
                <!-- Changes need to be reflected on ab as well -->
                <xsl:choose>
                    <xsl:when test="$handwriting = 'off'"></xsl:when>
                    <xsl:otherwise>
                        <xsl:choose>
                            <xsl:when test="contains($visning, 'dipl')">
                                <xsl:choose>
                                    <xsl:when test="contains($im, 'study')">
                                        <xsl:element name="SPAN">
                                            <xsl:attribute name="style">color: #33FFFF;</xsl:attribute>
                                            <xsl:apply-templates/>
                                        </xsl:element>
                                    </xsl:when>
                                    <xsl:when test="contains($im, 'norm')">
                                        <xsl:element name="SPAN">
                                            <xsl:attribute name="style">color: #33FFFF;</xsl:attribute>
                                            <xsl:apply-templates/>
                                        </xsl:element>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:element name="SPAN">
                                            <xsl:attribute name="style">font-size: 10pt; color: #33FFFF;</xsl:attribute>
                                            <xsl:apply-templates/>
                                        </xsl:element>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:when>
                            <xsl:when test="contains($visning, 'study')">
                                <xsl:choose>
                                    <xsl:when test="contains($im, 'dipl')">
                                        <xsl:element name="SPAN">
                                            <xsl:attribute name="style">color: #33FFFF;</xsl:attribute>
                                            <xsl:apply-templates/>
                                        </xsl:element>
                                    </xsl:when>
                                    <xsl:when test="contains($im, 'norm')">
                                        <xsl:element name="SPAN">
                                            <xsl:attribute name="style">color: #33FFFF;</xsl:attribute>
                                            <xsl:apply-templates/>
                                        </xsl:element>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:element name="SPAN">
                                            <xsl:attribute name="style">color: #33FFFF;</xsl:attribute>
                                            <xsl:apply-templates/>
                                        </xsl:element>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:when>
                            <xsl:when test="contains($visning, 'norm')">
                                <xsl:choose>
                                    <xsl:when test="contains($im, 'dipl')">
                                        <xsl:element name="SPAN">
                                            <xsl:attribute name="style">color: #33FFFF;</xsl:attribute>
                                            <xsl:apply-templates/>
                                        </xsl:element>
                                    </xsl:when>
                                    <xsl:when test="contains($im, 'study')">
                                        <xsl:element name="SPAN">
                                            <xsl:attribute name="style">color: #33FFFF;</xsl:attribute>
                                            <xsl:apply-templates/>
                                        </xsl:element>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:element name="SPAN">
                                            <xsl:attribute name="style">color: #33FFFF;</xsl:attribute>
                                            <xsl:apply-templates/>
                                        </xsl:element>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:apply-templates/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="attribute::rend='ipp_h'">
                <!-- Changes need to be reflected on ab as well -->
                <xsl:choose>
                    <xsl:when test="$handwriting = 'off'"></xsl:when>
                    <xsl:otherwise>
                        <xsl:choose>
                            <xsl:when test="contains($visning, 'dipl')">
                                <xsl:choose>
                                    <xsl:when test="contains($im, 'study')">
                                        <xsl:element name="SPAN">
                                            <xsl:attribute name="style">color: #33FFFF;</xsl:attribute>
                                            <xsl:apply-templates/>
                                        </xsl:element>
                                    </xsl:when>
                                    <xsl:when test="contains($im, 'norm')">
                                        <xsl:element name="SPAN">
                                            <xsl:attribute name="style">color: #33FFFF;</xsl:attribute>
                                            <xsl:apply-templates/>
                                        </xsl:element>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:element name="SPAN">
                                            <xsl:attribute name="style">color: #33FFFF;</xsl:attribute>
                                            <xsl:apply-templates/>
                                        </xsl:element>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:when>
                            <xsl:when test="contains($visning, 'study')">
                                <xsl:choose>
                                    <xsl:when test="contains($im, 'dipl')">
                                        <xsl:element name="SPAN">
                                            <xsl:attribute name="style">color: #33FFFF;</xsl:attribute>
                                            <xsl:apply-templates/>
                                        </xsl:element>
                                    </xsl:when>
                                    <xsl:when test="contains($im, 'norm')">
                                        <xsl:element name="SPAN">
                                            <xsl:attribute name="style">color: #33FFFF;</xsl:attribute>
                                            <xsl:apply-templates/>
                                        </xsl:element>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:element name="SPAN">
                                            <xsl:attribute name="style">color: #33FFFF;</xsl:attribute>
                                            <xsl:apply-templates/>
                                        </xsl:element>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:when>
                            <xsl:when test="contains($visning, 'norm')">
                                <xsl:choose>
                                    <xsl:when test="contains($im, 'dipl')">
                                        <xsl:element name="SPAN">
                                            <xsl:attribute name="style">color: #33FFFF;</xsl:attribute>
                                            <xsl:apply-templates/>
                                        </xsl:element>
                                    </xsl:when>
                                    <xsl:when test="contains($im, 'study')">
                                        <xsl:element name="SPAN">
                                            <xsl:attribute name="style">color: #33FFFF;</xsl:attribute>
                                            <xsl:apply-templates/>
                                        </xsl:element>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:element name="SPAN">
                                            <xsl:attribute name="style">color: #33FFFF;</xsl:attribute>
                                            <xsl:apply-templates/>
                                        </xsl:element>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:apply-templates/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="attribute::rend='ipp_H5'">
                <!-- Changes need to be reflected on ab as well -->
                <xsl:choose>
                    <xsl:when test="$handwriting = 'off'"></xsl:when>
                    <xsl:otherwise>
                        <xsl:choose>
                            <xsl:when test="contains($visning, 'dipl')">
                                <xsl:choose>
                                    <xsl:when test="contains($im, 'study')">
                                        <xsl:element name="SPAN">
                                            <xsl:attribute name="style">color: #33FFFF;</xsl:attribute>
                                            <xsl:apply-templates/>
                                        </xsl:element>
                                    </xsl:when>
                                    <xsl:when test="contains($im, 'norm')">
                                        <xsl:element name="SPAN">
                                            <xsl:attribute name="style">color: #33FFFF;</xsl:attribute>
                                            <xsl:apply-templates/>
                                        </xsl:element>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:element name="SPAN">
                                            <xsl:attribute name="style">color: #33FFFF;</xsl:attribute>
                                            <xsl:apply-templates/>
                                        </xsl:element>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:when>
                            <xsl:when test="contains($visning, 'study')">
                                <xsl:choose>
                                    <xsl:when test="contains($im, 'dipl')">
                                        <xsl:element name="SPAN">
                                            <xsl:attribute name="style">color: #33FFFF;</xsl:attribute>
                                            <xsl:apply-templates/>
                                        </xsl:element>
                                    </xsl:when>
                                    <xsl:when test="contains($im, 'norm')">
                                        <xsl:element name="SPAN">
                                            <xsl:attribute name="style">color: #33FFFF;</xsl:attribute>
                                            <xsl:apply-templates/>
                                        </xsl:element>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:apply-templates/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:when>
                            <xsl:when test="contains($visning, 'norm')">
                                <xsl:choose>
                                    <xsl:when test="contains($im, 'dipl')">
                                        <xsl:element name="SPAN">
                                            <xsl:attribute name="style">color: #33FFFF;</xsl:attribute>
                                            <xsl:apply-templates/>
                                        </xsl:element>
                                    </xsl:when>
                                    <xsl:when test="contains($im, 'study')">
                                        <xsl:apply-templates/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:element name="SPAN">
                                            <xsl:attribute name="style">color: #33FFFF;</xsl:attribute>
                                            <xsl:apply-templates/>
                                        </xsl:element>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:apply-templates/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="attribute::rend='irm'"><!-- Sjekk visning -->
                <xsl:choose>
                    <xsl:when test="contains($visning, 'dipl')">
                        <xsl:element name="SPAN">
                            <xsl:attribute name="style">color: #FF00FF;</xsl:attribute>
                            <xsl:text>&lt;</xsl:text>
                        </xsl:element>
                        <xsl:apply-templates/>
                        <xsl:element name="SPAN">
                            <xsl:attribute name="style">color: #FF00FF;</xsl:attribute>
                            <xsl:text>&gt;</xsl:text>
                        </xsl:element>
                    </xsl:when>
                    <xsl:when test="contains($visning, 'study')">
                        <xsl:element name="SPAN">
                            <xsl:attribute name="style">color: #FF00FF;</xsl:attribute>
                            <xsl:text>&lt;</xsl:text>
                        </xsl:element>
                        <xsl:apply-templates/>
                        <xsl:element name="SPAN">
                            <xsl:attribute name="style">color: #FF00FF;</xsl:attribute>
                            <xsl:text>&gt;</xsl:text>
                        </xsl:element>
                    </xsl:when>
                    <xsl:when test="contains($visning, 'norm')">
                        <xsl:apply-templates/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:apply-templates/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="attribute::rend='irm_h'"><!-- Sjekk visning -->
                <xsl:choose>
                    <xsl:when test="$handwriting = 'off'"></xsl:when>
                    <xsl:otherwise>
                        <xsl:choose>
                            <xsl:when test="contains($visning, 'dipl')">
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">color: #FF00FF;</xsl:attribute>
                                    <xsl:text>&lt;</xsl:text>
                                </xsl:element>
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">color: #0000FF;</xsl:attribute>
                                    <xsl:apply-templates/>
                                </xsl:element>
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">color: #FF00FF;</xsl:attribute>
                                    <xsl:text>&gt;</xsl:text>
                                </xsl:element>
                            </xsl:when>
                            <xsl:when test="contains($visning, 'study')">
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">color: #FF00FF;</xsl:attribute>
                                    <xsl:text>&lt;</xsl:text>
                                </xsl:element>
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">color: #0000FF;</xsl:attribute>
                                    <xsl:apply-templates/>
                                </xsl:element>
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">color: #FF00FF;</xsl:attribute>
                                    <xsl:text>&gt;</xsl:text>
                                </xsl:element>
                            </xsl:when>
                            <xsl:when test="contains($visning, 'norm')">
                                <xsl:apply-templates/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:apply-templates/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="attribute::rend='irm_S1'"><!-- Sjekk visning -->
                <xsl:choose>
                    <xsl:when test="$handwriting = 'off'"></xsl:when>
                    <xsl:otherwise>
                        <xsl:choose>
                            <xsl:when test="contains($visning, 'dipl')">
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">color: #FF00FF;</xsl:attribute>
                                    <xsl:text>&lt;</xsl:text>
                                </xsl:element>
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">color: #0000FF;</xsl:attribute>
                                    <xsl:apply-templates/>
                                </xsl:element>
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">color: #FF00FF;</xsl:attribute>
                                    <xsl:text>&gt;</xsl:text>
                                </xsl:element>
                            </xsl:when>
                            <xsl:when test="contains($visning, 'study')">
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">color: #FF00FF;</xsl:attribute>
                                    <xsl:text>&lt;</xsl:text>
                                </xsl:element>
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">color: #0000FF;</xsl:attribute>
                                    <xsl:apply-templates/>
                                </xsl:element>
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">color: #FF00FF;</xsl:attribute>
                                    <xsl:text>&gt;</xsl:text>
                                </xsl:element>
                            </xsl:when>
                            <xsl:when test="contains($visning, 'norm')">
                                <xsl:apply-templates/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:apply-templates/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="attribute::rend='iupm'">
                <xsl:choose>
                    <xsl:when test="contains($visning, 'dipl')">
                        <xsl:element name="SPAN">
                            <xsl:attribute name="style">color: #FF00FF;</xsl:attribute>
                            <xsl:text>&lt;</xsl:text>
                        </xsl:element>
                        <xsl:apply-templates/>
                        <xsl:element name="SPAN">
                            <xsl:attribute name="style">color: #FF00FF;</xsl:attribute>
                            <xsl:text>&gt;</xsl:text>
                        </xsl:element>
                    </xsl:when>
                    <xsl:when test="contains($visning, 'study')">
                        <xsl:element name="SPAN">
                            <xsl:attribute name="style">color: #FF00FF;</xsl:attribute>
                            <xsl:text>&lt;</xsl:text>
                        </xsl:element>
                        <xsl:apply-templates/>
                        <xsl:element name="SPAN">
                            <xsl:attribute name="style">color: #FF00FF;</xsl:attribute>
                            <xsl:text>&gt;</xsl:text>
                        </xsl:element>
                    </xsl:when>
                    <xsl:when test="contains($visning, 'norm')">
                        <xsl:apply-templates/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:apply-templates/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="attribute::rend='iupm_h'">
                <!-- Changes need to be reflected on ab as well -->
                <xsl:choose>
                    <xsl:when test="$handwriting = 'off'"></xsl:when>
                    <xsl:otherwise>
                        <xsl:choose>
                            <xsl:when test="contains($visning, 'dipl')">
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">color: #FF00FF;</xsl:attribute>
                                    <xsl:text>&lt;</xsl:text>
                                </xsl:element>
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">color: #0000FF;</xsl:attribute>
                                    <xsl:apply-templates/>
                                </xsl:element>
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">color: #FF00FF;</xsl:attribute>
                                    <xsl:text>&gt;</xsl:text>
                                </xsl:element>
                            </xsl:when>
                            <xsl:when test="contains($visning, 'study')">
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">color: #FF00FF;</xsl:attribute>
                                    <xsl:text>&lt;</xsl:text>
                                </xsl:element>
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">color: #0000FF;</xsl:attribute>
                                    <xsl:apply-templates/>
                                </xsl:element>
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">color: #FF00FF;</xsl:attribute>
                                    <xsl:text>&gt;</xsl:text>
                                </xsl:element>
                            </xsl:when>
                            <xsl:when test="contains($visning, 'norm')">
                                <xsl:apply-templates/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:apply-templates/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="attribute::rend='iupmm'"><!-- Sjekk visning -->
                <xsl:choose>
                    <xsl:when test="contains($visning, 'dipl')">
                        <xsl:element name="SPAN">
                            <xsl:attribute name="style">color: #FF00FF;</xsl:attribute>
                            <xsl:text>&lt;</xsl:text>
                        </xsl:element>
                        <xsl:text>&#x02C7;</xsl:text>
                        <xsl:apply-templates/>
                        <xsl:element name="SPAN">
                            <xsl:attribute name="style">color: #FF00FF;</xsl:attribute>
                            <xsl:text>&gt;</xsl:text>
                        </xsl:element>
                    </xsl:when>
                    <xsl:when test="contains($visning, 'study')">
                        <xsl:element name="SPAN">
                            <xsl:attribute name="style">color: #FF00FF;</xsl:attribute>
                            <xsl:text>&lt;</xsl:text>
                        </xsl:element>
                        <xsl:text>&#x02C7;</xsl:text>
                        <xsl:apply-templates/>
                        <xsl:element name="SPAN">
                            <xsl:attribute name="style">color: #FF00FF;</xsl:attribute>
                            <xsl:text>&gt;</xsl:text>
                        </xsl:element>
                    </xsl:when>
                    <xsl:when test="contains($visning, 'norm')">
                        <xsl:apply-templates/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:apply-templates/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="attribute::rend='iupmm_h'"><!-- Sjekk visning -->
                <xsl:choose>
                    <xsl:when test="$handwriting = 'off'">
                        <xsl:choose>
                            <xsl:when test="contains($visning, 'dipl')">
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">color: #FF00FF;</xsl:attribute>
                                    <xsl:text>&lt;</xsl:text>
                                </xsl:element>
                                <xsl:apply-templates/>
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">color: #FF00FF;</xsl:attribute>
                                    <xsl:text>&gt;</xsl:text>
                                </xsl:element>
                            </xsl:when>
                            <xsl:when test="contains($visning, 'study')">
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">color: #FF00FF;</xsl:attribute>
                                    <xsl:text>&lt;</xsl:text>
                                </xsl:element>
                                <xsl:apply-templates/>
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">color: #FF00FF;</xsl:attribute>
                                    <xsl:text>&gt;</xsl:text>
                                </xsl:element>
                            </xsl:when>
                            <xsl:when test="contains($visning, 'norm')">
                                <xsl:apply-templates/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:apply-templates/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:choose>
                            <xsl:when test="contains($visning, 'dipl')">
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">color: #FF00FF;</xsl:attribute>
                                    <xsl:text>&lt;</xsl:text>
                                </xsl:element>
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">color: #0000FF;</xsl:attribute>
                                    <xsl:text>&#x02C7;</xsl:text>
                                    <xsl:apply-templates/>
                                </xsl:element>
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">color: #FF00FF;</xsl:attribute>
                                    <xsl:text>&gt;</xsl:text>
                                </xsl:element>
                            </xsl:when>
                            <xsl:when test="contains($visning, 'study')">
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">color: #FF00FF;</xsl:attribute>
                                    <xsl:text>&lt;</xsl:text>
                                </xsl:element>
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">color: #0000FF;</xsl:attribute>
                                    <xsl:text>&#x02C7;</xsl:text>
                                    <xsl:apply-templates/>
                                </xsl:element>
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">color: #FF00FF;</xsl:attribute>
                                    <xsl:text>&gt;</xsl:text>
                                </xsl:element>
                            </xsl:when>
                            <xsl:when test="contains($visning, 'norm')">
                                <xsl:apply-templates/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:apply-templates/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="attribute::rend='o'">
                <xsl:choose>
                    <xsl:when test="contains($visning, 'dipl')">
                        <xsl:choose>
                            <xsl:when test="contains($our, 'study')">
                                <xsl:apply-templates/>
                            </xsl:when>
                            <xsl:when test="contains($our, 'norm')">
                                <xsl:apply-templates/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">font-weight: bold;</xsl:attribute>
                                    <xsl:apply-templates/>
                                </xsl:element>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:when test="contains($visning, 'study')">
                        <xsl:choose>
                            <xsl:when test="contains($our, 'dipl')">
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">font-weight: bold;</xsl:attribute>
                                    <xsl:apply-templates/>
                                </xsl:element>
                            </xsl:when>
                            <xsl:when test="contains($our, 'norm')">
                                <xsl:apply-templates/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:apply-templates/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:when test="contains($visning, 'norm')">
                        <xsl:choose>
                            <xsl:when test="contains($our, 'dipl')">
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">font-weight: bold;</xsl:attribute>
                                    <xsl:apply-templates/>
                                </xsl:element>
                            </xsl:when>
                            <xsl:when test="contains($our, 'study')">
                                <xsl:apply-templates/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:apply-templates/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>                    
                    <xsl:otherwise>
                        <xsl:apply-templates/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="attribute::rend='oo'">
                <xsl:choose>
                    <xsl:when test="contains($visning, 'dipl')">
                        <xsl:choose>
                            <xsl:when test="contains($our, 'study')">
                                <xsl:apply-templates/>
                            </xsl:when>
                            <xsl:when test="contains($our, 'norm')">
                                <xsl:apply-templates/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">font-weight: bold;</xsl:attribute>
                                    <xsl:apply-templates/>
                                </xsl:element>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:when test="contains($visning, 'study')">
                        <xsl:choose>
                            <xsl:when test="contains($our, 'dipl')">
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">font-weight: bold;</xsl:attribute>
                                    <xsl:apply-templates/>
                                </xsl:element>
                            </xsl:when>
                            <xsl:when test="contains($our, 'norm')">
                                <xsl:apply-templates/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:apply-templates/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:when test="contains($visning, 'norm')">
                        <xsl:choose>
                            <xsl:when test="contains($our, 'dipl')">
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">font-weight: bold;</xsl:attribute>
                                    <xsl:apply-templates/>
                                </xsl:element>
                            </xsl:when>
                            <xsl:when test="contains($our, 'study')">
                                <xsl:apply-templates/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:apply-templates/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>                    
                    <xsl:otherwise>
                        <xsl:apply-templates/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="attribute::rend='our'">
                <xsl:choose>
                    <xsl:when test="contains($visning, 'dipl')">
                        <xsl:choose>
                            <xsl:when test="contains($our, 'study')">
                                <xsl:apply-templates/>
                            </xsl:when>
                            <xsl:when test="contains($our, 'norm')">
                                <xsl:apply-templates/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">font-weight: bold;</xsl:attribute>
                                    <xsl:apply-templates/>
                                </xsl:element>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:when test="contains($visning, 'study')">
                        <xsl:choose>
                            <xsl:when test="contains($our, 'dipl')">
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">font-weight: bold;</xsl:attribute>
                                    <xsl:apply-templates/>
                                </xsl:element>
                            </xsl:when>
                            <xsl:when test="contains($our, 'norm')">
                                <xsl:apply-templates/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:apply-templates/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:when test="contains($visning, 'norm')">
                        <xsl:choose>
                            <xsl:when test="contains($our, 'dipl')">
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">font-weight: bold;</xsl:attribute>
                                    <xsl:apply-templates/>
                                </xsl:element>
                            </xsl:when>
                            <xsl:when test="contains($our, 'study')">
                                <xsl:apply-templates/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:apply-templates/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>                    
                    <xsl:otherwise>
                        <xsl:apply-templates/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="attribute::rend='our_h'">
                <xsl:choose>
                    <xsl:when test="$handwriting = 'off'">
                        <xsl:text>&lt;&#x2026;&gt;</xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:choose>
                            <xsl:when test="contains($visning, 'dipl')">
                                <xsl:choose>
                                    <xsl:when test="contains($our, 'study')">
                                        <xsl:apply-templates/>
                                    </xsl:when>
                                    <xsl:when test="contains($our, 'norm')">
                                        <xsl:apply-templates/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:element name="SPAN">
                                            <xsl:attribute name="style">font-weight: bold; color: #0000FF;</xsl:attribute>
                                            <xsl:apply-templates/>
                                        </xsl:element>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:when>
                            <xsl:when test="contains($visning, 'study')">
                                <xsl:choose>
                                    <xsl:when test="contains($our, 'dipl')">
                                        <xsl:element name="SPAN">
                                            <xsl:attribute name="style">font-weight: bold; color: #0000FF;</xsl:attribute>
                                            <xsl:apply-templates/>
                                        </xsl:element>
                                    </xsl:when>
                                    <xsl:when test="contains($our, 'norm')">
                                        <xsl:apply-templates/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:apply-templates/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:when>
                            <xsl:when test="contains($visning, 'norm')">
                                <xsl:choose>
                                    <xsl:when test="contains($our, 'dipl')">
                                        <xsl:element name="SPAN">
                                            <xsl:attribute name="style">font-weight: bold; color: #0000FF;</xsl:attribute>
                                            <xsl:apply-templates/>
                                        </xsl:element>
                                    </xsl:when>
                                    <xsl:when test="contains($our, 'study')">
                                        <xsl:apply-templates/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:apply-templates/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:apply-templates/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="attribute::rend='upm_h'">
                <xsl:choose>
                    <xsl:when test="$handwriting = 'off'"></xsl:when>
                    <xsl:otherwise>
                        <xsl:choose>
                            <xsl:when test="contains($visning, 'dipl')">
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">color: #0000FF;</xsl:attribute>
                                    <xsl:text>&lt;</xsl:text>
                                    <xsl:apply-templates/>
                                    <xsl:text>&gt;</xsl:text>
                                </xsl:element>
                            </xsl:when>
                            <xsl:when test="contains($visning, 'study')">
                                <xsl:apply-templates/>
                            </xsl:when>
                            <xsl:when test="contains($visning, 'norm')">
                                <xsl:apply-templates/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:apply-templates/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:otherwise>
                </xsl:choose>                
            </xsl:when>
            <xsl:otherwise>
                <xsl:element name="SPAN">
                    <xsl:attribute name="style">color: purple;</xsl:attribute>
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
	
	<xsl:template match="tei:supplied">
		<xsl:choose>
			<xsl:when test="contains($visning, 'dipl')"/>
			<xsl:when test="contains($visning, 'norm') or contains($visning, 'study')">
				<xsl:element name="DIV">
					<xsl:attribute name="align">right</xsl:attribute>
					<xsl:text>[</xsl:text>
					<xsl:element name="SPAN">
						<xsl:attribute name="style">color: #FF0000;</xsl:attribute>
						<xsl:apply-templates/>
					</xsl:element>
					<xsl:text>]</xsl:text>
				</xsl:element>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="tei:gap">
		<xsl:choose>
			<xsl:when test="attribute::extent">
				<xsl:choose>
					<xsl:when test="contains(attribute::extent, 'words')">
						<xsl:text>&lt;&#x2026;&gt;</xsl:text>
					</xsl:when>
					<xsl:when test="contains(attribute::extent, 'lines')">
					    <xsl:text>&lt;&#x2026;&gt;</xsl:text>
					</xsl:when>
					<xsl:when test="contains(attribute::extent, 'characters')">
					    <xsl:text>&lt;&#x2026;&gt;</xsl:text>
					</xsl:when>
					<xsl:otherwise>
						<xsl:apply-templates/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- Emphasized text -->
	
	<xsl:template match="tei:emph">
        <xsl:choose>
            <xsl:when test="attribute::rend='arrback'">
                <!-- Changes need to be reflected on ab as well -->
                <xsl:element name="SPAN">
                    <xsl:attribute name="style">background-color: #CC77FF; font-family: Arial Unicode MS;</xsl:attribute>
                    <xsl:text>&#x21BA;</xsl:text>
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:when>
            <xsl:when test="attribute::rend='arrback_h'">
                <xsl:choose>
                    <xsl:when test="$handwriting = 'off'">
                        <xsl:apply-templates/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:element name="SPAN">
                            <xsl:attribute name="style">background-color: #CC77FF; font-family: Arial Unicode MS;</xsl:attribute>
                            <xsl:text>&#x21BA;</xsl:text>
                            <xsl:apply-templates/>
                        </xsl:element>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
        	<xsl:when test="attribute::rend='arrback_h_ch'">
        		<xsl:choose>
        			<xsl:when test="$handwriting = 'off'">
        				<xsl:apply-templates/>
        			</xsl:when>
        			<xsl:otherwise>
        			    <xsl:choose>
        			        <xsl:when test="$visning='norm'">
        			            <xsl:apply-templates/>
        			        </xsl:when>
        			        <xsl:otherwise>
        			            <xsl:element name="SPAN">
        			                <xsl:attribute name="style"><xsl:if test="not($visning='norm')">background-color: #CC77FF; </xsl:if> font-family: Arial Unicode MS;</xsl:attribute>
        			                <xsl:text>&#x21BA;</xsl:text>
        			                <xsl:apply-templates/>
        			            </xsl:element>  
        			        </xsl:otherwise>
        			    </xsl:choose>
        			    <xsl:choose>
        			        <xsl:when test="$visning='norm'"></xsl:when>
        			        <xsl:otherwise>
        			            <xsl:element name="SUP">
        			                <xsl:attribute name="style">color: #FF0000;</xsl:attribute>
        			                <xsl:text>ch</xsl:text>
        			            </xsl:element>  
        			        </xsl:otherwise>
        			    </xsl:choose>
        			</xsl:otherwise>
        		</xsl:choose>
        	</xsl:when>
            <xsl:when test="attribute::rend='arrforward'">
                <!-- Changes need to be reflected on ab as well -->
                <xsl:element name="SPAN">
                    <xsl:attribute name="style">background-color: #CC77FF; font-family: Arial Unicode MS;</xsl:attribute>
                    <xsl:text>&#x21BB;</xsl:text>
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:when>
            <xsl:when test="attribute::rend='arrforward_h'">
                <xsl:choose>
                    <xsl:when test="$handwriting = 'off'">
                        <xsl:apply-templates/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:element name="SPAN">
                            <xsl:attribute name="style">background-color: #CC77FF; font-family: Arial Unicode MS;</xsl:attribute>
                            <xsl:text>&#x21BB;</xsl:text>
                            <xsl:apply-templates/>
                        </xsl:element>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
        	<xsl:when test="attribute::rend='arrforward_h_ch'">
        		<xsl:choose>
        			<xsl:when test="$handwriting = 'off'">
        				<xsl:apply-templates/>
        			</xsl:when>
        			<xsl:otherwise>
        			    <xsl:choose>
        			        <xsl:when test="$visning='norm'">
        			            <xsl:apply-templates/>
        			        </xsl:when>
        			        <xsl:otherwise>
        			            <xsl:element name="SPAN">
        			                <xsl:attribute name="style"><xsl:if test="not($visning='norm')">background-color: #CC77FF; </xsl:if> font-family: Arial Unicode MS;</xsl:attribute>
        			                <xsl:text>&#x21BB;</xsl:text>
        			                <xsl:apply-templates/>
        			            </xsl:element>  
        			        </xsl:otherwise>
        			    </xsl:choose>
        			    <xsl:choose>
        			        <xsl:when test="$visning='norm'"></xsl:when>
        			        <xsl:otherwise>
        			            <xsl:element name="SUP">
        			                <xsl:attribute name="style">color: #FF0000;</xsl:attribute>
        			                <xsl:text>ch</xsl:text>
        			            </xsl:element>  
        			        </xsl:otherwise>
        			    </xsl:choose>
        			</xsl:otherwise>
        		</xsl:choose>
        	</xsl:when>
            <xsl:when test="attribute::rend='bl' or contains(attribute::rend, 'bl_')">
                <xsl:choose>
                    <xsl:when test="contains(attribute::rend, '_')">
                        <xsl:call-template name="lines">
                            <xsl:with-param name="i" select="1"/>
                            <xsl:with-param name="max" select="substring-after(attribute::rend, '_')"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:call-template name="lines">
                            <xsl:with-param name="i" select="1"/>
                            <xsl:with-param name="max" select="."/>
                        </xsl:call-template>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="attribute::rend='blankspace' or contains(attribute::rend, 'blankspace_')">
                <xsl:choose>
                    <xsl:when test="contains(attribute::rend, '_')">
                        <xsl:call-template name="spaces">
                            <xsl:with-param name="i" select="1"/>
                            <xsl:with-param name="max" select="substring-after(attribute::rend, '_')"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:call-template name="spaces">
                            <xsl:with-param name="i" select="1"/>
                            <xsl:with-param name="max" select="."/>
                        </xsl:call-template>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="attribute::rend='cap'">
                <xsl:element name="SPAN">
                    <xsl:attribute name="style">font-variant: small-caps;</xsl:attribute>
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:when>
            <xsl:when test="attribute::rend='centered'">
                <!-- Changes need to be reflected on ab as well -->
                <xsl:element name="DIV">
                    <xsl:attribute name="align">center</xsl:attribute>
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:when>
            <xsl:when test="attribute::rend='cline'">
                <xsl:element name="SPAN">
                    <xsl:attribute name="style">background-color: #BEBEBE;</xsl:attribute>
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:when>
            <xsl:when test="attribute::rend='cline_h'">
                <xsl:choose>
                    <xsl:when test="$handwriting = 'off'">
                        <xsl:apply-templates/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:element name="SPAN">
                            <xsl:attribute name="style">background-color: #BEBEBE;</xsl:attribute>
                            <xsl:apply-templates/>
                        </xsl:element>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="attribute::rend='clilm'">
                <!-- Changes need to be reflected on ab as well -->
                <xsl:element name="SPAN">
                    <xsl:attribute name="style">background-color: #BEBEBE;</xsl:attribute>
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:when>
            <xsl:when test="attribute::rend='clilm_h'">
                <!-- Changes need to be reflected on ab as well -->
                <xsl:choose>
                    <xsl:when test="$handwriting = 'off'">
                        <xsl:apply-templates/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:element name="SPAN">
                            <xsl:attribute name="style">background-color: #BEBEBE;</xsl:attribute>
                            <xsl:apply-templates/>
                        </xsl:element>                 
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="attribute::rend='clilm_h_ch'">
                <xsl:choose>
                    <xsl:when test="$handwriting = 'off'">
                        <xsl:apply-templates/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:element name="SPAN">
                            <xsl:attribute name="style"><xsl:if test="not($visning='norm')">background-color: #BEBEBE; </xsl:if></xsl:attribute>
                            <xsl:apply-templates/>
                        </xsl:element> 
                        <xsl:choose>
                            <xsl:when test="$visning='norm'"></xsl:when>
                            <xsl:otherwise>
                                <xsl:element name="SUP">
                                    <xsl:attribute name="style">color: #FF0000;</xsl:attribute>
                                    <xsl:text>ch</xsl:text>
                                </xsl:element>  
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="attribute::rend='clirm'">
                <!-- Changes need to be reflected on ab as well -->
                <xsl:element name="SPAN">
                    <xsl:attribute name="style">background-color: #BEBEBE;</xsl:attribute>
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:when>
            <xsl:when test="attribute::rend='clirm_h'">
                <!-- Changes need to be reflected on ab as well -->
                <xsl:choose>
                    <xsl:when test="$handwriting = 'off'">
                        <xsl:apply-templates/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:element name="SPAN">
                            <xsl:attribute name="style">background-color: #BEBEBE;</xsl:attribute>
                            <xsl:apply-templates/>
                        </xsl:element>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="attribute::rend='clirm_h_ch'">
                <xsl:choose>
                    <xsl:when test="$handwriting = 'off'">
                        <xsl:apply-templates/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:element name="SPAN">
                            <xsl:attribute name="style"><xsl:if test="not($visning='norm')">background-color: #BEBEBE; </xsl:if></xsl:attribute>
                            <xsl:apply-templates/>
                        </xsl:element>
                        <xsl:choose>
                            <xsl:when test="$visning='norm'"></xsl:when>
                            <xsl:otherwise>
                                <xsl:element name="SUP">
                                    <xsl:attribute name="style">color: #FF0000;</xsl:attribute>
                                    <xsl:text>ch</xsl:text>
                                </xsl:element>  
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="contains(attribute::rend, 'conline')">
                <xsl:choose>
                    <xsl:when test="contains(attribute::rend, '_h')">
                        <xsl:choose>
                            <xsl:when test="$handwriting = 'off'"></xsl:when>
                            <xsl:otherwise>
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">color: #0000FF;</xsl:attribute>
                                    <xsl:text>&#x2194;</xsl:text>
                                </xsl:element>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:otherwise>
                    	<xsl:text>&#x2194;</xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="attribute::rend='crossed'">
                <!-- Changes need to be reflected on ab as well -->
                <xsl:element name="SPAN">
                    <xsl:attribute name="style">background-color: #BEBEBE;</xsl:attribute>
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:when>
            <xsl:when test="attribute::rend='crossed_h'">
                <!-- Changes need to be reflected on ab as well -->
                <xsl:choose>
                    <xsl:when test="$handwriting = 'off'">
                        <xsl:apply-templates/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:element name="SPAN">
                            <xsl:attribute name="style">background-color: #BEBEBE;</xsl:attribute>
                            <xsl:apply-templates/>
                        </xsl:element>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="attribute::rend='dlilm'"><!-- Sjekk visning -->
                <xsl:element name="SPAN">
                    <xsl:attribute name="style">background-color: #BEBEBE;</xsl:attribute>
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:when>
            <xsl:when test="attribute::rend='dlilm_h'"><!-- Sjekk visning -->
                <xsl:choose>
                    <xsl:when test="$handwriting = 'off'">
                        <xsl:apply-templates/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:element name="SPAN">
                            <xsl:attribute name="style">background-color: #BEBEBE;</xsl:attribute>
                            <xsl:apply-templates/>
                        </xsl:element>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="attribute::rend='dlirm'"><!-- Sjekk visning -->
                <xsl:element name="SPAN">
                    <xsl:attribute name="style">background-color: #BEBEBE;</xsl:attribute>
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:when>
            <xsl:when test="attribute::rend='dlirm_ch'">
                <xsl:choose>
                    <xsl:when test="$handwriting = 'off'">
                        <xsl:apply-templates/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:element name="SPAN">
                            <xsl:attribute name="style">background-color: #BEBEBE;</xsl:attribute>
                            <xsl:apply-templates/>
                        </xsl:element>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="attribute::rend='dlirm_h'"><!-- Sjekk visning -->
                <xsl:choose>
                    <xsl:when test="$handwriting = 'off'">
                        <xsl:apply-templates/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:element name="SPAN">
                            <xsl:attribute name="style">background-color: #BEBEBE;</xsl:attribute>
                            <xsl:apply-templates/>
                        </xsl:element>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="attribute::rend='emlm'">
                <xsl:element name="SPAN">
                    <xsl:attribute name="style">background-color: #BEBEBE;</xsl:attribute>
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:when>
            <xsl:when test="attribute::rend='emlm_h'">
                <xsl:choose>
                    <xsl:when test="$handwriting = 'off'">
                        <xsl:apply-templates/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:element name="SPAN">
                            <xsl:attribute name="style">background-color: #BEBEBE;</xsl:attribute>
                            <xsl:apply-templates/>
                        </xsl:element>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="attribute::rend='emrm'">
                <xsl:element name="SPAN">
                    <xsl:attribute name="style">background-color: #BEBEBE;</xsl:attribute>
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:when>
            <xsl:when test="attribute::rend='emrm_h'">
                <xsl:choose>
                    <xsl:when test="$handwriting = 'off'">
                        <xsl:apply-templates/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:element name="SPAN">
                            <xsl:attribute name="style">background-color: #BEBEBE;</xsl:attribute>
                            <xsl:apply-templates/>
                        </xsl:element>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>        
            <xsl:when test="attribute::rend='endarrback'">
                <xsl:element name="SPAN">
                    <xsl:attribute name="style">background-color: #CC77FF;</xsl:attribute>
                    <xsl:text>&#x2022;</xsl:text>
                </xsl:element>
            </xsl:when>
            <xsl:when test="attribute::rend='endarrback_h'">
                <xsl:choose>
                    <xsl:when test="$handwriting = 'off'">
                        <xsl:apply-templates/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:element name="SPAN">
                            <xsl:attribute name="style">background-color: #CC77FF;</xsl:attribute>
                            <xsl:text>&#x2022;</xsl:text>
                        </xsl:element>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
        	<xsl:when test="attribute::rend='endarrback_h_ch'">
        		<xsl:choose>
        			<xsl:when test="$handwriting = 'off'">
        				<xsl:apply-templates/>
        			</xsl:when>
        			<xsl:otherwise>
        			    <xsl:choose>
        			        <xsl:when test="$visning='norm'">
        			            <xsl:apply-templates/>
        			        </xsl:when>
        			        <xsl:otherwise>
        			            <xsl:element name="SPAN">
        			                <xsl:attribute name="style"><xsl:if test="not($visning='norm')">background-color: #CC77FF; </xsl:if> font-family: Arial Unicode MS;</xsl:attribute>
        			                <xsl:text>&#x2022;</xsl:text>
        			                <xsl:apply-templates/>
        			            </xsl:element>  
        			        </xsl:otherwise>
        			    </xsl:choose>
        			    <xsl:choose>
        			        <xsl:when test="$visning='norm'"></xsl:when>
        			        <xsl:otherwise>
        			            <xsl:element name="SUP">
        			                <xsl:attribute name="style">color: #FF0000;</xsl:attribute>
        			                <xsl:text>ch</xsl:text>
        			            </xsl:element>  
        			        </xsl:otherwise>
        			    </xsl:choose>
        			</xsl:otherwise>
        		</xsl:choose>
        	</xsl:when>
            <xsl:when test="attribute::rend='endarrforward'">
                <xsl:element name="SPAN">
                    <xsl:attribute name="style">background-color: #CC77FF;</xsl:attribute>
                    <xsl:text>&#x2022;</xsl:text>
                </xsl:element>
            </xsl:when>
            <xsl:when test="attribute::rend='endarrforward_h'">
                <xsl:choose>
                    <xsl:when test="$handwriting = 'off'">
                        <xsl:apply-templates/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:element name="SPAN">
                            <xsl:attribute name="style">background-color: #CC77FF;</xsl:attribute>
                            <xsl:text>&#x2022;</xsl:text>
                        </xsl:element>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
        	<xsl:when test="attribute::rend='endarrforward_h_ch'">
        		<xsl:choose>
        			<xsl:when test="$handwriting = 'off'">
        				<xsl:apply-templates/>
        			</xsl:when>
        			<xsl:otherwise>
        			    <xsl:choose>
        			        <xsl:when test="$visning='norm'">
        			            <xsl:apply-templates/>
        			        </xsl:when>
        			        <xsl:otherwise>
        			            <xsl:element name="SPAN">
        			                <xsl:attribute name="style"><xsl:if test="not($visning='norm')">background-color: #CC77FF; </xsl:if> font-family: Arial Unicode MS;</xsl:attribute>
        			                <xsl:text>&#x2022;</xsl:text>
        			                <xsl:apply-templates/>
        			            </xsl:element>  
        			        </xsl:otherwise>
        			    </xsl:choose>
        			    <xsl:choose>
        			        <xsl:when test="$visning='norm'"></xsl:when>
        			        <xsl:otherwise>
        			            <xsl:element name="SUP">
        			                <xsl:attribute name="style">color: #FF0000;</xsl:attribute>
        			                <xsl:text>ch</xsl:text>
        			            </xsl:element>  
        			        </xsl:otherwise>
        			    </xsl:choose>
        			</xsl:otherwise>
        		</xsl:choose>
        	</xsl:when>
            <xsl:when test="attribute::rend='H'"><!-- Sjekk koding -->
                <xsl:choose>
                    <xsl:when test="$handwriting = 'off'">
                        <xsl:apply-templates/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:element name="SPAN">
                            <xsl:attribute name="style">background-color: #BEBEBE;</xsl:attribute>
                            <xsl:apply-templates/>
                        </xsl:element>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="contains(attribute::rend, 'indl')">
                <xsl:choose>
                    <xsl:when test="preceding-sibling::*[1][self::tei:lb]"></xsl:when>
                    <xsl:when test="following-sibling::*[1][self::tei:s[contains(attribute::rend, 'indl')]]"></xsl:when>
                    <xsl:otherwise>
                        <xsl:choose>
                            <xsl:when test="ancestor::tei:ab[preceding-sibling::*[1][self::tei:ab]] and not(preceding-sibling::tei:s)"></xsl:when>
                            <xsl:when test="ancestor::tei:ab[preceding-sibling::*[1][self::tei:lb]]  and not(preceding-sibling::tei:s)"></xsl:when>
                            <xsl:otherwise>
                                <xsl:element name="BR"></xsl:element>
                            </xsl:otherwise>
                        </xsl:choose>
                        <xsl:call-template name="spaces">
                            <xsl:with-param name="i" select="1"/>
                            <xsl:with-param name="max" select="substring-after(attribute::rend, '_')"/>
                        </xsl:call-template>
                    </xsl:otherwise>
                </xsl:choose>
                <!-- Gi innrykk på neste s-element -->
            </xsl:when>
            <xsl:when test="attribute::rend='large'">
                <xsl:element name="SPAN">
                    <xsl:attribute name="style">font-size: 150%</xsl:attribute>
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:when>
            <xsl:when test="attribute::rend='lm'"><!-- Sjekk visning -->
                <xsl:element name="SPAN">
                    <xsl:attribute name="style">background-color: #BEBEBE;</xsl:attribute>
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:when>
            <xsl:when test="attribute::rend='lom'">
                <xsl:element name="SPAN">
                    <xsl:attribute name="style">background-color: #BEBEBE;</xsl:attribute>
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:when>
            <xsl:when test="attribute::rend='pabove'"><!-- Sjekk visning -->
                <xsl:element name="SPAN">
                    <xsl:attribute name="style">background-color: #BEBEBE;</xsl:attribute>
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:when>
            <xsl:when test="attribute::rend='power'">
                <xsl:element name="SUP">
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:when> 
            <xsl:when test="attribute::rend='qmlm'"><!-- Sjekk visning -->
                <xsl:element name="SPAN">
                    <xsl:attribute name="style">background-color: #BEBEBE;</xsl:attribute>
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:when>
            <xsl:when test="attribute::rend='qmlm_h'">
                <xsl:choose>
                    <xsl:when test="$handwriting = 'off'">
                        <xsl:apply-templates/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:element name="SPAN">
                            <xsl:attribute name="style">background-color: #BEBEBE;</xsl:attribute>
                            <xsl:apply-templates/>
                        </xsl:element>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="attribute::rend='qmlm_h_ch'">
                <xsl:choose>
                    <xsl:when test="$handwriting = 'off'">
                        <xsl:apply-templates/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:element name="SPAN">
                            <xsl:attribute name="style"><xsl:if test="not($visning='norm')">background-color: #BEBEBE; </xsl:if></xsl:attribute>
                            <xsl:apply-templates/>
                        </xsl:element>
                        <xsl:choose>
                            <xsl:when test="$visning='norm'"></xsl:when>
                            <xsl:otherwise>
                                <xsl:element name="SUP">
                                    <xsl:attribute name="style">color: #FF0000;</xsl:attribute>
                                    <xsl:text>ch</xsl:text>
                                </xsl:element>  
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="attribute::rend='qmlm_S1'">
                <xsl:choose>
                    <xsl:when test="$handwriting = 'off'">
                        <xsl:apply-templates/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:element name="SPAN">
                            <xsl:attribute name="style">background-color: #BEBEBE;</xsl:attribute>
                            <xsl:apply-templates/>
                        </xsl:element>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="attribute::rend='qmrm'"><!-- Sjekk visning -->
                <xsl:element name="SPAN">
                    <xsl:attribute name="style">background-color: #BEBEBE;</xsl:attribute>
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:when>
            <xsl:when test="attribute::rend='qmrm_h'">
                <xsl:choose>
                    <xsl:when test="$handwriting = 'off'">
                        <xsl:apply-templates/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:element name="SPAN">
                            <xsl:attribute name="style">background-color: #BEBEBE;</xsl:attribute>
                            <xsl:apply-templates/>
                        </xsl:element>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="attribute::rend='qmrm_h_ch'">
                <xsl:choose>
                    <xsl:when test="$handwriting = 'off'">
                        <xsl:apply-templates/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:element name="SPAN">
                            <xsl:attribute name="style"><xsl:if test="not($visning='norm')">background-color: #BEBEBE; </xsl:if></xsl:attribute>
                            <xsl:apply-templates/>
                        </xsl:element>
                        <xsl:choose>
                            <xsl:when test="$visning='norm'"></xsl:when>
                            <xsl:otherwise>
                                <xsl:element name="SUP">
                                    <xsl:attribute name="style">color: #FF0000;</xsl:attribute>
                                    <xsl:text>ch</xsl:text>
                                </xsl:element>  
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="attribute::rend='right'"><!-- Sjekk visning -->
                <xsl:element name="DIV">
                    <xsl:attribute name="style">float: right;</xsl:attribute>
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:when>
            <xsl:when test="attribute::rend='ringed'"><!-- Sjekk visning -->
                <!-- Changes need to be reflected on ab as well -->
                <xsl:element name="DIV">
                    <xsl:attribute name="style">border: 2px solid purple; display: inline-block;</xsl:attribute>
                    <xsl:attribute name="width">100%</xsl:attribute>
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:when>
            <xsl:when test="attribute::rend='ringed_h'"><!-- Sjekk visning -->
                <!-- Changes need to be reflected on ab as well -->
                <xsl:choose>
                    <xsl:when test="$handwriting = 'off'">
                        <xsl:apply-templates/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:element name="SPAN">
                            <xsl:attribute name="style">color: #0000FF; border: 2px solid purple;</xsl:attribute>
                            <xsl:apply-templates/>
                        </xsl:element>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="attribute::rend='rm'"><!-- Sjekk visning -->
                <xsl:element name="SPAN">
                    <xsl:attribute name="style">background-color: #BEBEBE;</xsl:attribute>
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:when>
            <xsl:when test="attribute::rend='sepline'">
                <xsl:element name="HR">
                    <xsl:attribute name="width">150px</xsl:attribute>
                    <xsl:attribute name="align">left</xsl:attribute>
                </xsl:element>
            </xsl:when>
            <xsl:when test="attribute::rend='slilm'">
                <!-- Changes need to be reflected on ab as well -->
                <xsl:element name="SPAN">
                    <xsl:attribute name="style">background-color: #BEBEBE;</xsl:attribute>
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:when>
            <xsl:when test="attribute::rend='slilm_h'">
                <!-- Changes need to be reflected on ab as well -->
                <xsl:choose>
                    <xsl:when test="$handwriting = 'off'">
                        <xsl:apply-templates/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:element name="SPAN">
                            <xsl:attribute name="style">background-color: #BEBEBE;</xsl:attribute>
                            <xsl:apply-templates/>
                        </xsl:element>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="attribute::rend='slilm_h_ch'">
                <xsl:choose>
                    <xsl:when test="$handwriting = 'off'">
                        <xsl:apply-templates/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:element name="SPAN">
                            <xsl:attribute name="style"><xsl:if test="not($visning='norm')">background-color: #BEBEBE; </xsl:if></xsl:attribute>
                            <xsl:apply-templates/>
                        </xsl:element>
                        <xsl:choose>
                            <xsl:when test="$visning='norm'"></xsl:when>
                            <xsl:otherwise>
                                <xsl:element name="SUP">
                                    <xsl:attribute name="style">color: #FF0000;</xsl:attribute>
                                    <xsl:text>ch</xsl:text>
                                </xsl:element>  
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="attribute::rend='slirm'">
                <!-- Changes need to be reflected on ab as well -->
                <xsl:element name="SPAN">
                    <xsl:attribute name="style">background-color: #BEBEBE;</xsl:attribute>
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:when>
            <xsl:when test="attribute::rend='slirm_h'">
                <!-- Changes need to be reflected on ab as well -->
                <xsl:choose>
                    <xsl:when test="$handwriting = 'off'">
                        <xsl:apply-templates/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:element name="SPAN">
                            <xsl:attribute name="style">background-color: #BEBEBE;</xsl:attribute>
                            <xsl:apply-templates/>
                        </xsl:element>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="attribute::rend='slirm_h_ch'">
                <xsl:choose>
                    <xsl:when test="$handwriting = 'off'">
                        <xsl:apply-templates/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:element name="SPAN">
                            <xsl:attribute name="style"><xsl:if test="not($visning='norm')">background-color: #BEBEBE; </xsl:if></xsl:attribute>
                            <xsl:apply-templates/>
                        </xsl:element>
                        <xsl:choose>
                            <xsl:when test="$visning='norm'"></xsl:when>
                            <xsl:otherwise>
                                <xsl:element name="SUP">
                                    <xsl:attribute name="style">color: #FF0000;</xsl:attribute>
                                    <xsl:text>ch</xsl:text>
                                </xsl:element>  
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="attribute::rend='space'">
                <xsl:text>&nbsp;&nbsp;&nbsp;</xsl:text>
                <xsl:element name="SPAN">
                    <xsl:attribute name="style">letter-spacing: 1em;</xsl:attribute>
                    <xsl:apply-templates/>
                </xsl:element>
                <xsl:text>&nbsp;&nbsp;</xsl:text>
            </xsl:when>
            <xsl:when test="attribute::rend='startarrback'">
                <xsl:element name="SPAN">
                    <xsl:attribute name="style">background-color: #CC77FF;</xsl:attribute>
                    <xsl:text>&#x2022;</xsl:text>
                </xsl:element>
            </xsl:when>
            <xsl:when test="attribute::rend='startarrback_h'">
                <xsl:choose>
                    <xsl:when test="$handwriting = 'off'">
                        <xsl:apply-templates/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:element name="SPAN">
                            <xsl:attribute name="style">background-color: #CC77FF;</xsl:attribute>
                            <xsl:text>&#x2022;</xsl:text>
                        </xsl:element>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
        	<xsl:when test="attribute::rend='startarrback_h_ch'">
        		<xsl:choose>
        			<xsl:when test="$handwriting = 'off'">
        				<xsl:apply-templates/>
        			</xsl:when>
        			<xsl:otherwise>
        			    <xsl:choose>
        			        <xsl:when test="$visning='norm'">
        			            <xsl:apply-templates/>
        			        </xsl:when>
        			        <xsl:otherwise>
        			            <xsl:element name="SPAN">
        			                <xsl:attribute name="style"><xsl:if test="not($visning='norm')">background-color: #CC77FF; </xsl:if> font-family: Arial Unicode MS;</xsl:attribute>
        			                <xsl:text>&#x2022;</xsl:text>
        			                <xsl:apply-templates/>
        			            </xsl:element>  
        			        </xsl:otherwise>
        			    </xsl:choose>
        			    <xsl:choose>
        			        <xsl:when test="$visning='norm'"></xsl:when>
        			        <xsl:otherwise>
        			            <xsl:element name="SUP">
        			                <xsl:attribute name="style">color: #FF0000;</xsl:attribute>
        			                <xsl:text>ch</xsl:text>
        			            </xsl:element>  
        			        </xsl:otherwise>
        			    </xsl:choose>
        			</xsl:otherwise>
        		</xsl:choose>
        	</xsl:when>
            <xsl:when test="attribute::rend='startarrforward'">
                <xsl:element name="SPAN">
                    <xsl:attribute name="style">background-color: #CC77FF;</xsl:attribute>
                    <xsl:text>&#x2022;</xsl:text>
                </xsl:element>
            </xsl:when>
            <xsl:when test="attribute::rend='startarrforward_h'">
                <xsl:choose>
                    <xsl:when test="$handwriting = 'off'">
                        <xsl:apply-templates/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:element name="SPAN">
                            <xsl:attribute name="style">background-color: #CC77FF;</xsl:attribute>
                            <xsl:text>&#x2022;</xsl:text>
                        </xsl:element>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
        	<xsl:when test="attribute::rend='startarrforward_h_ch'">
        		<xsl:choose>
        			<xsl:when test="$handwriting = 'off'">
        				<xsl:apply-templates/>
        			</xsl:when>
        			<xsl:otherwise>
        			    <xsl:choose>
        			        <xsl:when test="$visning='norm'">
        			            <xsl:apply-templates/>
        			        </xsl:when>
        			        <xsl:otherwise>
        			            <xsl:element name="SPAN">
        			                <xsl:attribute name="style"><xsl:if test="not($visning='norm')">background-color: #CC77FF; </xsl:if> font-family: Arial Unicode MS;</xsl:attribute>
        			                <xsl:text>&#x2022;</xsl:text>
        			                <xsl:apply-templates/>
        			            </xsl:element>  
        			        </xsl:otherwise>
        			    </xsl:choose>
        			    <xsl:choose>
        			        <xsl:when test="$visning='norm'"></xsl:when>
        			        <xsl:otherwise>
        			            <xsl:element name="SUP">
        			                <xsl:attribute name="style">color: #FF0000;</xsl:attribute>
        			                <xsl:text>ch</xsl:text>
        			            </xsl:element>  
        			        </xsl:otherwise>
        			    </xsl:choose>
        			</xsl:otherwise>
        		</xsl:choose>
        	</xsl:when>
            <xsl:when test="attribute::rend='sub'">
                <xsl:element name="SUB">
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:when> 
            <xsl:when test="attribute::rend='sup'">
                <xsl:element name="SUP">
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:when> 
            <xsl:when test="attribute::rend='us1'">
                <xsl:choose>
                    <xsl:when test="contains($visning, 'dipl')">
                        <xsl:element name="SPAN">
                            <xsl:attribute name="style">border-bottom-width: thin; border-bottom-color: #000000; border-bottom-style: solid;</xsl:attribute>
                            <xsl:apply-templates/>
                        </xsl:element>
                    </xsl:when>
                    <xsl:when test="contains($visning, 'study')">
                        <xsl:element name="SPAN">
                            <xsl:attribute name="style">border-bottom-width: thin; border-bottom-color: #000000; border-bottom-style: solid;</xsl:attribute>
                            <xsl:apply-templates/>
                        </xsl:element>
                    </xsl:when>
                    <xsl:when test="contains($visning, 'norm')">
                        <xsl:element name="SPAN">
                            <xsl:attribute name="style">border-bottom-width: thin; border-bottom-color: #000000; border-bottom-style: solid;</xsl:attribute>
                            <xsl:apply-templates/>
                        </xsl:element>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:apply-templates/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="attribute::rend='us1_c'">
                <xsl:choose>
                    <xsl:when test="contains($visning, 'dipl')">
                        <xsl:element name="SPAN">
                            <xsl:attribute name="style">border-bottom-width: thin; border-bottom-color: #000000; border-bottom-style: solid;</xsl:attribute>
                            <xsl:apply-templates/>
                        </xsl:element>
                        <xsl:element name="SUP">
                            <xsl:attribute name="style">color: #FF0000;</xsl:attribute>
                            <xsl:text>c</xsl:text>
                        </xsl:element>
                    </xsl:when>
                    <xsl:when test="contains($visning, 'study')">
                        <xsl:element name="SPAN">
                            <xsl:attribute name="style">border-bottom-width: thin; border-bottom-color: #000000; border-bottom-style: solid;</xsl:attribute>
                            <xsl:apply-templates/>
                        </xsl:element>
                        <xsl:element name="SUP">
                            <xsl:attribute name="style">color: #FF0000;</xsl:attribute>
                            <xsl:text>c</xsl:text>
                        </xsl:element>
                    </xsl:when>
                    <xsl:when test="contains($visning, 'norm')">
                        <xsl:element name="SPAN">
                            <xsl:apply-templates/>
                        </xsl:element>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:apply-templates/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="attribute::rend='us1_h'">
                <xsl:choose>
                    <xsl:when test="$handwriting = 'off'">
                        <xsl:apply-templates/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:choose>
                            <xsl:when test="contains($visning, 'dipl')">
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">border-bottom-width: thin; border-bottom-color: #0000FF; border-bottom-style: solid;</xsl:attribute>
                                    <xsl:apply-templates/>
                                </xsl:element>
                            </xsl:when>
                            <xsl:when test="contains($visning, 'study')">
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">border-bottom-width: thin; border-bottom-color: #0000FF; border-bottom-style: solid;</xsl:attribute>
                                    <xsl:apply-templates/>
                                </xsl:element>
                            </xsl:when>
                            <xsl:when test="contains($visning, 'norm')">
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">border-bottom-width: thin; border-bottom-color: #000000; border-bottom-style: solid;</xsl:attribute>
                                    <xsl:apply-templates/>
                                </xsl:element>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:apply-templates/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="attribute::rend='us1_h_ch'">
                <xsl:choose>
                    <xsl:when test="$handwriting = 'off'">
                        <xsl:apply-templates/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:choose>
                            <xsl:when test="contains($visning, 'dipl')">
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">border-bottom-width: thin; border-bottom-color: #0000FF; border-bottom-style: solid;</xsl:attribute>
                                    <xsl:apply-templates/>
                                </xsl:element>
                                <xsl:element name="SUP">
                                    <xsl:attribute name="style">color: #FF0000;</xsl:attribute>
                                    <xsl:text>ch</xsl:text>
                                </xsl:element>
                            </xsl:when>
                            <xsl:when test="contains($visning, 'study')">
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">border-bottom-width: thin; border-bottom-color: #0000FF; border-bottom-style: solid;</xsl:attribute>
                                    <xsl:apply-templates/>
                                </xsl:element>
                            	<xsl:element name="SUP">
                            		<xsl:attribute name="style">color: #FF0000;</xsl:attribute>
                            		<xsl:text>ch</xsl:text>
                            	</xsl:element>
                            </xsl:when>
                            <xsl:when test="contains($visning, 'norm')">
                                <xsl:apply-templates/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:apply-templates/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="attribute::rend='us1_ch'"><!-- 2009-02-01 Sjekk -->
                <xsl:choose>
                    <xsl:when test="contains($visning, 'dipl')">
                        <xsl:element name="SPAN">
                            <xsl:attribute name="style">border-bottom-width: thin; border-bottom-color: #000000; border-bottom-style: solid;</xsl:attribute>
                            <xsl:apply-templates/>
                        </xsl:element>
                        <xsl:element name="SUP">
                            <xsl:attribute name="style">color: #FF0000;</xsl:attribute>
                            <xsl:text>ch</xsl:text>
                        </xsl:element>
                    </xsl:when>
                    <xsl:when test="contains($visning, 'study')">
                        <xsl:element name="SPAN">
                            <xsl:attribute name="style">border-bottom-width: thin; border-bottom-color: #000000; border-bottom-style: solid;</xsl:attribute>
                            <xsl:apply-templates/>
                            <xsl:element name="SUP">
                                <xsl:attribute name="style">color: #FF0000;</xsl:attribute>
                                <xsl:text>ch</xsl:text>
                            </xsl:element>
                        </xsl:element>
                    </xsl:when>
                    <xsl:when test="contains($visning, 'norm')">
                        <xsl:element name="SPAN">
                            <xsl:apply-templates/>
                        </xsl:element>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:apply-templates/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="attribute::rend='us1_S1'">
                <xsl:choose>
                    <xsl:when test="$handwriting = 'off'">
                        <xsl:apply-templates/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:choose>
                            <xsl:when test="contains($visning, 'dipl')">
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">border-bottom-width: thin; border-bottom-color: #0000FF; border-bottom-style: solid;</xsl:attribute>
                                    <xsl:apply-templates/>
                                </xsl:element>
                            </xsl:when>
                            <xsl:when test="contains($visning, 'study')">
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">border-bottom-width: thin; border-bottom-color: #0000FF; border-bottom-style: solid;</xsl:attribute>
                                    <xsl:apply-templates/>
                                </xsl:element>
                            </xsl:when>
                            <xsl:when test="contains($visning, 'norm')">
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">border-bottom-width: thin; border-bottom-color: #0000FF; border-bottom-style: solid;</xsl:attribute>
                                    <xsl:apply-templates/>
                                </xsl:element>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:apply-templates/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="attribute::rend='us1_X'">
                <xsl:choose>
                    <xsl:when test="$handwriting = 'off'">
                        <xsl:apply-templates/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:choose>
                            <xsl:when test="contains($visning, 'dipl')">
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">border-bottom-width: thin; border-bottom-color: #0000FF; border-bottom-style: solid;</xsl:attribute>
                                    <xsl:apply-templates/>
                                </xsl:element>
                            </xsl:when>
                            <xsl:when test="contains($visning, 'study')">
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">border-bottom-width: thin; border-bottom-color: #0000FF; border-bottom-style: solid;</xsl:attribute>
                                    <xsl:apply-templates/>
                                </xsl:element>
                            </xsl:when>
                            <xsl:when test="contains($visning, 'norm')">
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">border-bottom-width: thin; border-bottom-color: #0000FF; border-bottom-style: solid;</xsl:attribute>
                                    <xsl:apply-templates/>
                                </xsl:element>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:apply-templates/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="attribute::rend='us2'">
                <xsl:choose>
                    <xsl:when test="contains($visning, 'dipl')">
                        <xsl:element name="SPAN">
                            <xsl:attribute name="style">border-bottom-width: medium; border-bottom-color: #000000; border-bottom-style: double;</xsl:attribute>
                            <xsl:apply-templates/>
                        </xsl:element>
                    </xsl:when>
                    <xsl:when test="contains($visning, 'study')">
                        <xsl:element name="SPAN">
                            <xsl:attribute name="style">border-bottom-width: medium; border-bottom-color: #000000; border-bottom-style: double;</xsl:attribute>
                            <xsl:apply-templates/>
                        </xsl:element>
                    </xsl:when>
                    <xsl:when test="contains($visning, 'norm')">
                        <xsl:element name="SPAN">
                            <xsl:attribute name="style">border-bottom-width: medium; border-bottom-color: #000000; border-bottom-style: double;</xsl:attribute>
                            <xsl:apply-templates/>
                        </xsl:element>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:apply-templates/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="attribute::rend='us2_h'">
                <xsl:choose>
                    <xsl:when test="$handwriting = 'off'">
                        <xsl:apply-templates/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:choose>
                            <xsl:when test="contains($visning, 'dipl')">
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">border-bottom-width: medium; border-bottom-color: #0000FF; border-bottom-style: double;</xsl:attribute>
                                    <xsl:apply-templates/>
                                </xsl:element>
                            </xsl:when>
                            <xsl:when test="contains($visning, 'study')">
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">border-bottom-width: medium; border-bottom-color: #0000FF; border-bottom-style: double;</xsl:attribute>
                                    <xsl:apply-templates/>
                                </xsl:element>
                            </xsl:when>
                            <xsl:when test="contains($visning, 'norm')">
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">border-bottom-width: medium; border-bottom-color: #000000; border-bottom-style: double;</xsl:attribute>
                                    <xsl:apply-templates/>
                                </xsl:element>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:apply-templates/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
        	<xsl:when test="attribute::rend='us2_h_ch'">
        		<xsl:choose>
        			<xsl:when test="$handwriting = 'off'">
        				<xsl:apply-templates/>
        			</xsl:when>
        			<xsl:otherwise>
        				<xsl:choose>
        					<xsl:when test="contains($visning, 'dipl')">
        						<xsl:element name="SPAN">
        							<xsl:attribute name="style">border-bottom-width: medium; border-bottom-color: #0000FF; border-bottom-style: double;</xsl:attribute>
        							<xsl:apply-templates/>
        						</xsl:element>
        						<xsl:element name="SUP">
        							<xsl:attribute name="style">color: #FF0000;</xsl:attribute>
        							<xsl:text>ch</xsl:text>
        						</xsl:element>
        					</xsl:when>
        					<xsl:when test="contains($visning, 'study')">
        						<xsl:element name="SPAN">
        						    <xsl:attribute name="style">border-bottom-width: medium; border-bottom-color: #0000FF; border-bottom-style: double;</xsl:attribute>
        							<xsl:apply-templates/>
        						</xsl:element>
        						<xsl:element name="SUP">
        							<xsl:attribute name="style">color: #FF0000;</xsl:attribute>
        							<xsl:text>ch</xsl:text>
        						</xsl:element>
        					</xsl:when>
        					<xsl:when test="contains($visning, 'norm')">
        					    <xsl:apply-templates/>
        					</xsl:when>
        					<xsl:otherwise>
        						<xsl:apply-templates/>
        					</xsl:otherwise>
        				</xsl:choose>
        			</xsl:otherwise>
        		</xsl:choose>
        	</xsl:when>
            <xsl:when test="attribute::rend='us3_h'">
                <xsl:choose>
                    <xsl:when test="$handwriting = 'off'">
                        <xsl:apply-templates/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:choose>
                            <xsl:when test="contains($visning, 'dipl')">
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">border-bottom-width: medium; border-bottom-color: #0000FF; border-bottom-style: double;</xsl:attribute>
                                    <xsl:apply-templates/>
                                </xsl:element>
                            </xsl:when>
                            <xsl:when test="contains($visning, 'study')">
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">border-bottom-width: medium; border-bottom-color: #0000FF; border-bottom-style: double;</xsl:attribute>
                                    <xsl:apply-templates/>
                                </xsl:element>
                            </xsl:when>
                            <xsl:when test="contains($visning, 'norm')">
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">border-bottom-width: medium; border-bottom-color: #000000; border-bottom-style: double;</xsl:attribute>
                                    <xsl:apply-templates/>
                                </xsl:element>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:apply-templates/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="attribute::rend='usb'">
                <xsl:choose>
                    <xsl:when test="contains($visning, 'dipl')">
                        <xsl:element name="SPAN">
                            <xsl:attribute name="style">border-bottom-width: thin; border-bottom-color: #000000; border-bottom-style: dashed;</xsl:attribute>
                            <xsl:apply-templates/>
                        </xsl:element>
                    </xsl:when>
                    <xsl:when test="contains($visning, 'study')">
                        <xsl:element name="SPAN">
                            <xsl:attribute name="style">border-bottom-width: thin; border-bottom-color: #000000; border-bottom-style: dashed;</xsl:attribute>
                            <xsl:apply-templates/>
                        </xsl:element>
                    </xsl:when>
                    <xsl:when test="contains($visning, 'norm')">
                        <xsl:element name="SPAN">
                            <xsl:attribute name="style">border-bottom-width: thin; border-bottom-color: #000000; border-bottom-style: dashed;</xsl:attribute>
                            <xsl:apply-templates/>
                        </xsl:element>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:apply-templates/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="attribute::rend='usb_c'">
                <xsl:choose>
                    <xsl:when test="contains($visning, 'dipl')">
                        <xsl:element name="SPAN">
                            <xsl:attribute name="style">border-bottom-width: thin; border-bottom-color: #000000; border-bottom-style: dashed;</xsl:attribute>
                            <xsl:apply-templates/>
                        </xsl:element>
                        <xsl:element name="SUP">
                            <xsl:attribute name="style">color: #FF0000;</xsl:attribute>
                            <xsl:text>c</xsl:text>
                        </xsl:element>
                    </xsl:when>
                    <xsl:when test="contains($visning, 'study')">
                        <xsl:element name="SPAN">
                            <xsl:attribute name="style">border-bottom-width: thin; border-bottom-color: #000000; border-bottom-style: dashed;</xsl:attribute>
                            <xsl:apply-templates/>
                        </xsl:element>
                        <xsl:element name="SUP">
                            <xsl:attribute name="style">color: #0000FF;</xsl:attribute>
                            <xsl:text>c</xsl:text>
                        </xsl:element>
                    </xsl:when>
                    <xsl:when test="contains($visning, 'norm')">
                        <xsl:element name="SPAN">
                            <xsl:apply-templates/>
                        </xsl:element>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:apply-templates/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="attribute::rend='usb_h'"><!-- Sjekk visning -->
                <xsl:choose>
                    <xsl:when test="$handwriting = 'off'">
                        <xsl:apply-templates/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:choose>
                            <xsl:when test="contains($visning, 'dipl')">
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">border-bottom-width: thin; border-bottom-color: #000000; border-bottom-style: dashed; color: #0000FF;</xsl:attribute>
                                    <xsl:apply-templates/>
                                </xsl:element>
                            </xsl:when>
                            <xsl:when test="contains($visning, 'study')">
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">border-bottom-width: thin; border-bottom-color: #000000; border-bottom-style: dashed; color: #0000FF;</xsl:attribute>
                                    <xsl:apply-templates/>
                                </xsl:element>
                            </xsl:when>
                            <xsl:when test="contains($visning, 'norm')">
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">border-bottom-width: thin; border-bottom-color: #000000; border-bottom-style: dashed; color: #0000FF;</xsl:attribute>
                                    <xsl:apply-templates/>
                                </xsl:element>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:apply-templates/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="attribute::rend='usb_ch'">
                <xsl:choose>
                    <xsl:when test="$handwriting = 'off'">
                        <xsl:apply-templates/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:choose>
                            <xsl:when test="contains($visning, 'dipl')">
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">border-bottom-width: thin; border-bottom-color: #000000; border-bottom-style: dashed;</xsl:attribute>
                                    <xsl:apply-templates/>
                                </xsl:element>
                                <xsl:element name="SUP">
                                    <xsl:attribute name="style">color: #FF0000;</xsl:attribute>
                                    <xsl:text>ch</xsl:text>
                                </xsl:element>
                            </xsl:when>
                            <xsl:when test="contains($visning, 'study')">
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">border-bottom-width: thin; border-bottom-color: #000000; border-bottom-style: dashed;</xsl:attribute>
                                    <xsl:apply-templates/>
                                </xsl:element>
                                <xsl:element name="SUP">
                                    <xsl:attribute name="style">color: #0000FF;</xsl:attribute>
                                    <xsl:text>ch</xsl:text>
                                </xsl:element>
                            </xsl:when>
                            <xsl:when test="contains($visning, 'norm')">
                                <xsl:element name="SPAN">
                                    <xsl:apply-templates/>
                                </xsl:element>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:apply-templates/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="attribute::rend='uw1'">
                <xsl:choose>
                    <xsl:when test="contains($visning, 'dipl')">
                        <xsl:element name="SPAN">
                            <xsl:attribute name="style">border-bottom-width: thin; border-bottom-color: #000000; border-bottom-style: dashed;</xsl:attribute>
                            <xsl:apply-templates/>
                        </xsl:element>
                    </xsl:when>
                    <xsl:when test="contains($visning, 'study')">
                        <xsl:element name="SPAN">
                            <xsl:attribute name="style">border-bottom-width: thin; border-bottom-color: #000000; border-bottom-style: dashed;</xsl:attribute>
                            <xsl:apply-templates/>
                        </xsl:element>
                    </xsl:when>
                    <xsl:when test="contains($visning, 'norm')">
                        <xsl:element name="SPAN">
                            <xsl:attribute name="style">border-bottom-width: thin; border-bottom-color: #000000; border-bottom-style: dashed;</xsl:attribute>
                            <xsl:apply-templates/>
                        </xsl:element>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:apply-templates/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="attribute::rend='uw1_c'"><!-- Sjekk visning -->
                <xsl:choose>
                    <xsl:when test="contains($visning, 'dipl')">
                        <xsl:element name="SPAN">
                            <xsl:attribute name="style">border-bottom-width: thin; border-bottom-color: #000000; border-bottom-style: dashed;</xsl:attribute>
                            <xsl:apply-templates/>
                        </xsl:element>
                        <xsl:element name="SUP">
                            <xsl:attribute name="style">color: #FF0000;</xsl:attribute>
                            <xsl:text>c</xsl:text>
                        </xsl:element>
                    </xsl:when>
                    <xsl:when test="contains($visning, 'study')">
                        <xsl:element name="SPAN">
                            <xsl:attribute name="style">border-bottom-width: thin; border-bottom-color: #000000; border-bottom-style: dashed;</xsl:attribute>
                            <xsl:apply-templates/>
                        </xsl:element>
                        <xsl:element name="SUP">
                            <xsl:attribute name="style">color: #FF0000;</xsl:attribute>
                            <xsl:text>c</xsl:text>
                        </xsl:element>
                    </xsl:when>
                    <xsl:when test="contains($visning, 'norm')">
                        <xsl:element name="SPAN">
                            <xsl:apply-templates/>
                        </xsl:element>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:apply-templates/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="attribute::rend='uw1_h'">
                <xsl:choose>
                    <xsl:when test="$handwriting = 'off'">
                        <xsl:apply-templates/>                        
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:choose>
                            <xsl:when test="contains($visning, 'dipl')">
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">border-bottom-width: thin; border-bottom-color: #0000FF; border-bottom-style: dashed;</xsl:attribute>
                                    <xsl:apply-templates/>
                                </xsl:element>
                            </xsl:when>
                            <xsl:when test="contains($visning, 'study')">
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">border-bottom-width: thin; border-bottom-color: #0000FF; border-bottom-style: dashed;</xsl:attribute>
                                    <xsl:apply-templates/>
                                </xsl:element>
                            </xsl:when>
                            <xsl:when test="contains($visning, 'norm')">
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">border-bottom-width: thin; border-bottom-color: #000000; border-bottom-style: dashed;</xsl:attribute>
                                    <xsl:apply-templates/>
                                </xsl:element>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:apply-templates/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
        	<xsl:when test="attribute::rend='uw1_h_ch'">
        		<xsl:choose>
        			<xsl:when test="$handwriting = 'off'">
        				<xsl:apply-templates/>                        
        			</xsl:when>
        			<xsl:otherwise>
        				<xsl:choose>
        					<xsl:when test="contains($visning, 'dipl')">
        						<xsl:element name="SPAN">
        							<xsl:attribute name="style">border-bottom-width: thin; border-bottom-color: #0000FF; border-bottom-style: dashed;</xsl:attribute>
        							<xsl:apply-templates/>
        						</xsl:element>
        						<xsl:element name="SUP">
        							<xsl:attribute name="style">color: #FF0000;</xsl:attribute>
        							<xsl:text>ch</xsl:text>
        						</xsl:element>
        					</xsl:when>
        					<xsl:when test="contains($visning, 'study')">
        						<xsl:element name="SPAN">
        							<xsl:attribute name="style">border-bottom-width: thin; border-bottom-color: #0000FF; border-bottom-style: dashed;</xsl:attribute>
        							<xsl:apply-templates/>
        						</xsl:element>
        						<xsl:element name="SUP">
        							<xsl:attribute name="style">color: #FF0000;</xsl:attribute>
        							<xsl:text>ch</xsl:text>
        						</xsl:element>
        					</xsl:when>
        					<xsl:when test="contains($visning, 'norm')">
        					    <xsl:apply-templates/>
        					</xsl:when>
        					<xsl:otherwise>
        						<xsl:apply-templates/>
        					</xsl:otherwise>
        				</xsl:choose>
        			</xsl:otherwise>
        		</xsl:choose>
        	</xsl:when>
            <xsl:when test="attribute::rend='uw1_H1'">
                <xsl:choose>
                    <xsl:when test="$handwriting = 'off'">
                        <xsl:apply-templates/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:choose>
                            <xsl:when test="contains($visning, 'dipl')">
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">border-bottom-width: thin; border-bottom-color: #0000FF; border-bottom-style: dashed;</xsl:attribute>
                                    <xsl:apply-templates/>
                                </xsl:element>
                            </xsl:when>
                            <xsl:when test="contains($visning, 'study')">
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">border-bottom-width: thin; border-bottom-color: #0000FF; border-bottom-style: dashed;</xsl:attribute>
                                    <xsl:apply-templates/>
                                </xsl:element>
                            </xsl:when>
                            <xsl:when test="contains($visning, 'norm')">
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">border-bottom-width: thin; border-bottom-color: #000000; border-bottom-style: dashed;</xsl:attribute>
                                    <xsl:apply-templates/>
                                </xsl:element>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:apply-templates/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="attribute::rend='uw1_S1'">
                <xsl:choose>
                    <xsl:when test="$handwriting = 'off'">
                        <xsl:apply-templates/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:choose>
                            <xsl:when test="contains($visning, 'dipl')">
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">border-bottom-width: thin; border-bottom-color: #0000FF; border-bottom-style: dashed;</xsl:attribute>
                                    <xsl:apply-templates/>
                                </xsl:element>
                            </xsl:when>
                            <xsl:when test="contains($visning, 'study')">
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">border-bottom-width: thin; border-bottom-color: #0000FF; border-bottom-style: dashed;</xsl:attribute>
                                    <xsl:apply-templates/>
                                </xsl:element>
                            </xsl:when>
                            <xsl:when test="contains($visning, 'norm')">
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">border-bottom-width: thin; border-bottom-color: #000000; border-bottom-style: dashed;</xsl:attribute>
                                    <xsl:apply-templates/>
                                </xsl:element>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:apply-templates/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="attribute::rend='uw2'">
                <xsl:choose>
                    <xsl:when test="contains($visning, 'dipl')">
                        <xsl:element name="SPAN">
                            <xsl:attribute name="style">border-bottom-width: thin; border-bottom-color: #000000; border-bottom-style: dashed;</xsl:attribute>
                            <xsl:apply-templates/>
                        </xsl:element>
                    </xsl:when>
                    <xsl:when test="contains($visning, 'study')">
                        <xsl:element name="SPAN">
                            <xsl:attribute name="style">border-bottom-width: thin; border-bottom-color: #000000; border-bottom-style: dashed;</xsl:attribute>
                            <xsl:apply-templates/>
                        </xsl:element>
                    </xsl:when>
                    <xsl:when test="contains($visning, 'norm')">
                        <xsl:element name="SPAN">
                            <xsl:attribute name="style">border-bottom-width: thin; border-bottom-color: #000000; border-bottom-style: dashed;</xsl:attribute>
                            <xsl:apply-templates/>
                        </xsl:element>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:apply-templates/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="attribute::rend='uw2_h'">
                <xsl:choose>
                    <xsl:when test="$handwriting = 'off'">
                        <xsl:apply-templates/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:choose>
                            <xsl:when test="contains($visning, 'dipl')">
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">border-bottom-width: thin; border-bottom-color: #0000FF; border-bottom-style: dashed;</xsl:attribute>
                                    <xsl:apply-templates/>
                                </xsl:element>
                            </xsl:when>
                            <xsl:when test="contains($visning, 'study')">
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">border-bottom-width: thin; border-bottom-color: #0000FF; border-bottom-style: dashed;</xsl:attribute>
                                    <xsl:apply-templates/>
                                </xsl:element>
                            </xsl:when>
                            <xsl:when test="contains($visning, 'norm')">
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">border-bottom-width: thin; border-bottom-color: #000000; border-bottom-style: dashed;</xsl:attribute>
                                    <xsl:apply-templates/>
                                </xsl:element>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:apply-templates/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
        	<xsl:when test="attribute::rend='uw2_h_ch'">
        		<xsl:choose>
        			<xsl:when test="$handwriting = 'off'">
        				<xsl:apply-templates/>
        			</xsl:when>
        			<xsl:otherwise>
        				<xsl:choose>
        					<xsl:when test="contains($visning, 'dipl')">
        						<xsl:element name="SPAN">
        							<xsl:attribute name="style">border-bottom-width: thin; border-bottom-color: #0000FF; border-bottom-style: dashed;</xsl:attribute>
        							<xsl:apply-templates/>
        						</xsl:element>
        						<xsl:element name="SUP">
        							<xsl:attribute name="style">color: #FF0000;</xsl:attribute>
        							<xsl:text>ch</xsl:text>
        						</xsl:element>
        					</xsl:when>
        					<xsl:when test="contains($visning, 'study')">
        						<xsl:element name="SPAN">
        							<xsl:attribute name="style">border-bottom-width: thin; border-bottom-color: #0000FF; border-bottom-style: dashed;</xsl:attribute>
        							<xsl:apply-templates/>
        						</xsl:element>
        						<xsl:element name="SUP">
        							<xsl:attribute name="style">color: #FF0000;</xsl:attribute>
        							<xsl:text>ch</xsl:text>
        						</xsl:element>
        					</xsl:when>
        					<xsl:when test="contains($visning, 'norm')">
        					    <xsl:apply-templates/>
        					</xsl:when>
        					<xsl:otherwise>
        						<xsl:apply-templates/>
        					</xsl:otherwise>
        				</xsl:choose>
        			</xsl:otherwise>
        		</xsl:choose>
        	</xsl:when>
            <xsl:when test="attribute::rend='vdline'">
                <!-- Changes need to be reflected on ab as well -->
                <xsl:element name="SPAN">
                    <xsl:attribute name="style">background-color: #BEBEBE;</xsl:attribute>
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:when>
            <xsl:when test="attribute::rend='vdline_c'">
                <xsl:element name="SPAN">
                    <xsl:attribute name="style">background-color: #BEBEBE;</xsl:attribute>
                    <xsl:apply-templates/>
                </xsl:element>
                <xsl:element name="SPAN">
                    <xsl:attribute name="style">color: #FF0000;</xsl:attribute>
                </xsl:element>
            </xsl:when>
            <xsl:when test="attribute::rend='vdline_h'">
                <!-- Changes need to be reflected on ab as well -->
                <xsl:choose>
                    <xsl:when test="$handwriting = 'off'">
                        <xsl:apply-templates/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:element name="SPAN">
                            <xsl:attribute name="style">background-color: #BEBEBE;</xsl:attribute>
                            <xsl:apply-templates/>
                        </xsl:element>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="attribute::rend='vdline_h_ch'"><!-- Sjekk visning -->
                <!-- Changes need to be reflected on ab as well -->
                <xsl:choose>
                    <xsl:when test="$handwriting = 'off'">
                        <xsl:apply-templates/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:element name="SPAN">
                            <xsl:attribute name="style"><xsl:if test="not($visning='norm')">background-color: #BEBEBE; </xsl:if></xsl:attribute>
                            <xsl:apply-templates/>
                        </xsl:element>
                        <xsl:choose>
                            <xsl:when test="$visning='norm'"></xsl:when>
                            <xsl:otherwise>
                                <xsl:element name="SUP">
                                    <xsl:attribute name="style">color: #FF0000;</xsl:attribute>
                                    <xsl:text>ch</xsl:text>
                                </xsl:element>  
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="attribute::rend='vdline_S1'">
                <xsl:choose>
                    <xsl:when test="$handwriting = 'off'">
                        <xsl:apply-templates/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:element name="SPAN">
                            <xsl:attribute name="style">background-color: #BEBEBE;</xsl:attribute>
                            <xsl:apply-templates/>
                        </xsl:element>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="attribute::rend='wlilm'">
                <!-- Changes need to be reflected on ab as well -->
                <xsl:element name="SPAN">
                    <xsl:attribute name="style">background-color: #BEBEBE;</xsl:attribute>
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:when>
            <xsl:when test="attribute::rend='wlilm_c'">
                <!-- Changes need to be reflected on ab as well -->
                <xsl:element name="SPAN">
                    <xsl:attribute name="style">background-color: #BEBEBE;</xsl:attribute>
                    <xsl:apply-templates/>
                </xsl:element>
                <xsl:element name="SPAN">
                    <xsl:attribute name="style">color: #FF0000;</xsl:attribute>
                    <xsl:element name="SUP">
                        <xsl:text>[c]</xsl:text>
                    </xsl:element>
                </xsl:element>
            </xsl:when>
            <xsl:when test="attribute::rend='wlilm_h'">
                <xsl:choose>
                    <xsl:when test="$handwriting = 'off'">
                        <xsl:apply-templates/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:element name="SPAN">
                            <xsl:attribute name="style">background-color: #BEBEBE;</xsl:attribute>
                            <xsl:apply-templates/>
                        </xsl:element>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="attribute::rend='wlilm_h_ch'">
                <xsl:choose>
                    <xsl:when test="$handwriting = 'off'">
                        <xsl:apply-templates/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:element name="SPAN">
                            <xsl:attribute name="style"><xsl:if test="not($visning='norm')">background-color: #BEBEBE; </xsl:if></xsl:attribute>
                            <xsl:apply-templates/>
                        </xsl:element>
                        <xsl:choose>
                            <xsl:when test="$visning='norm'"></xsl:when>
                            <xsl:otherwise>
                                <xsl:element name="SUP">
                                    <xsl:attribute name="style">color: #FF0000;</xsl:attribute>
                                    <xsl:text>ch</xsl:text>
                                </xsl:element>  
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="attribute::rend='wlilm_S1'">
                <xsl:choose>
                    <xsl:when test="$handwriting = 'off'">
                        <xsl:apply-templates/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:element name="SPAN">
                            <xsl:attribute name="style">background-color: #BEBEBE;</xsl:attribute>
                            <xsl:apply-templates/>
                        </xsl:element>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="attribute::rend='wlirm'">
                <!-- Changes need to be reflected on ab as well -->
                <xsl:element name="SPAN">
                    <xsl:attribute name="style">background-color: #BEBEBE;</xsl:attribute>
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:when>
            <xsl:when test="attribute::rend='wlirm_c'">
                <xsl:element name="SPAN">
                    <xsl:attribute name="style">background-color: #BEBEBE;</xsl:attribute>
                    <xsl:apply-templates/>
                </xsl:element>
                <xsl:element name="SPAN">
                    <xsl:attribute name="style">color: #FF0000;</xsl:attribute>
                    <xsl:element name="SUP">
                        <xsl:text>[c]</xsl:text>
                    </xsl:element>
                </xsl:element>
            </xsl:when>
            <xsl:when test="attribute::rend='wlirm_h'">
                <!-- Changes need to be reflected on ab as well -->
                <xsl:choose>
                    <xsl:when test="$handwriting = 'off'">
                        <xsl:apply-templates/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:element name="SPAN">
                            <xsl:attribute name="style">background-color: #BEBEBE;</xsl:attribute>
                            <xsl:apply-templates/>
                        </xsl:element>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="attribute::rend='wlirm_h_ch'">
                <xsl:choose>
                    <xsl:when test="$handwriting = 'off'">
                        <xsl:apply-templates/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:element name="SPAN">
                            <xsl:attribute name="style"><xsl:if test="not($visning='norm')">background-color: #BEBEBE; </xsl:if></xsl:attribute>
                            <xsl:apply-templates/>
                        </xsl:element>
                        <xsl:choose>
                            <xsl:when test="$visning='norm'"></xsl:when>
                            <xsl:otherwise>
                                <xsl:element name="SUP">
                                    <xsl:attribute name="style">color: #FF0000;</xsl:attribute>
                                    <xsl:text>ch</xsl:text>
                                </xsl:element>  
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="attribute::rend='X'"><!-- Sjekk koding -->
                <xsl:element name="SPAN">
                    <xsl:attribute name="style">background-color: #BEBEBE;</xsl:attribute>
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:when>
            <xsl:when test="attribute::rend='zigzaglm'"><!--  Sjekk koding -->
                <xsl:element name="SPAN">
                    <xsl:attribute name="style">background-color: #BEBEBE;</xsl:attribute>
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:when>
            <xsl:when test="attribute::rend='zigzaglm_h'"><!--  Sjekk koding -->
                <xsl:choose>
                    <xsl:when test="$handwriting = 'off'">
                        <xsl:apply-templates/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:element name="SPAN">
                            <xsl:attribute name="style">background-color: #BEBEBE;</xsl:attribute>
                            <xsl:apply-templates/>
                        </xsl:element>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="attribute::rend='zigzagrm'">
                <!-- Changes need to be reflected on ab as well -->
                <xsl:element name="SPAN">
                    <xsl:attribute name="style">background-color: #BEBEBE;</xsl:attribute>
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:when>
            <xsl:when test="attribute::rend='zigzagrm_h'">
                <!-- Changes need to be reflected on ab as well -->
                <xsl:choose>
                    <xsl:when test="$handwriting = 'off'">
                        <xsl:apply-templates/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:element name="SPAN">
                            <xsl:attribute name="style">background-color: #BEBEBE;</xsl:attribute>
                            <xsl:apply-templates/>
                        </xsl:element>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:element name="SPAN">
                    <xsl:attribute name="style">color: #FF0000;</xsl:attribute>
                    <xsl:text>!! </xsl:text><xsl:value-of select="attribute::rend"/><xsl:text> </xsl:text>
                </xsl:element>
                <xsl:apply-templates/>
                <xsl:element name="SPAN">
                    <xsl:attribute name="style">color: #FF0000;</xsl:attribute>
                    <xsl:text>!!</xsl:text>
                </xsl:element>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
	
	<xsl:template match="tei:hi">
		<xsl:choose>
			<xsl:when test="attribute::rend='literal_'"/>
			<xsl:when test="attribute::rend='literal_el'"/>
			<xsl:when test="attribute::rend='nr_h'"/>
			<xsl:when test="attribute::rend='nl_h'"/>
			<xsl:when test="attribute::rend='bl'"/>
			<xsl:when test="attribute::rend='table_'"/>
			<xsl:when test="attribute::rend='table_el'"/>
			<xsl:otherwise>
				<xsl:apply-templates/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="tei:unclear">
		<xsl:choose>
			<xsl:when test="contains($unclear, 'mark')">
				<xsl:choose>
					<xsl:when test="contains($visning, 'dipl')">
						<xsl:element name="SPAN">
							<xsl:attribute name="style">color: #FF0000;</xsl:attribute>
							<xsl:text>&#x00BF;</xsl:text>
						</xsl:element>
						<xsl:apply-templates/>
						<xsl:element name="SPAN">
							<xsl:attribute name="style">color: #FF0000;</xsl:attribute>
							<xsl:text>&#x00BF;</xsl:text>
						</xsl:element>
					</xsl:when>
					<xsl:when test="contains($visning, 'study')">
						<xsl:element name="SPAN">
							<xsl:attribute name="style">color: #FF0000;</xsl:attribute>
							<xsl:text>&#x00BF;</xsl:text>
						</xsl:element>
						<xsl:apply-templates/>
						<xsl:element name="SPAN">
							<xsl:attribute name="style">color: #FF0000;</xsl:attribute>
							<xsl:text>&#x00BF;</xsl:text>
						</xsl:element>
					</xsl:when>
					<xsl:when test="contains($visning, 'norm')">
						<xsl:element name="SPAN">
							<xsl:attribute name="style">color: #FF0000;</xsl:attribute>
							<xsl:text>&#x00BF;</xsl:text>
						</xsl:element>
						<xsl:apply-templates/>
						<xsl:element name="SPAN">
							<xsl:attribute name="style">color: #FF0000;</xsl:attribute>
							<xsl:text>&#x00BF;</xsl:text>
						</xsl:element>
					</xsl:when>
					<xsl:otherwise>
						<xsl:apply-templates/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- Notes -->
	
	<xsl:template match="tei:note">
		<xsl:choose>
			<xsl:when test="contains($visning, 'dipl')">
				<xsl:choose>
					<xsl:when test="attribute::type='header'">
						<xsl:element name="SPAN">
							<xsl:attribute name="style">color: #FF0000;</xsl:attribute>
							<xsl:apply-templates/>
						</xsl:element>
					</xsl:when>
					<xsl:when test="attribute::type='editor'">
						<xsl:element name="SPAN">
							<xsl:attribute name="title"><xsl:value-of select="."/></xsl:attribute>
							<xsl:attribute name="style">color: #FF0000;</xsl:attribute>
							<xsl:element name="A">
							    <xsl:attribute name="style">text-decoration: none; color: #FF0000;</xsl:attribute>
								<xsl:attribute name="href">#top</xsl:attribute>
								<xsl:attribute name="onclick"><xsl:text>openNote('</xsl:text><xsl:value-of select="."/><xsl:text>')</xsl:text></xsl:attribute>
								<xsl:text>*</xsl:text>
							</xsl:element>
						</xsl:element>
					</xsl:when>
					<xsl:otherwise>
						<xsl:element name="SPAN">
							<xsl:attribute name="title"><xsl:value-of select="."/></xsl:attribute>
							<xsl:attribute name="style">color: #FF0000;</xsl:attribute>
							<xsl:element name="A">
							    <xsl:attribute name="style">text-decoration: none; color: #FF0000;</xsl:attribute>
								<xsl:attribute name="href">#top</xsl:attribute>
								<xsl:attribute name="onclick"><xsl:text>openNote('</xsl:text><xsl:value-of select="."/><xsl:text>')</xsl:text></xsl:attribute>
								<xsl:text>*check*</xsl:text>
							</xsl:element>
						</xsl:element>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="contains($visning, 'study')">
				<xsl:choose>
					<xsl:when test="attribute::type='header'">
						<xsl:element name="SPAN">
							<xsl:attribute name="style">color: #FF0000;</xsl:attribute>
							<xsl:apply-templates/>
						</xsl:element>
					</xsl:when>
					<xsl:when test="attribute::type='editor'">
						<xsl:element name="SPAN">
							<xsl:attribute name="title"><xsl:value-of select="."/></xsl:attribute>
							<xsl:attribute name="style">color: #FF0000;</xsl:attribute>
							<xsl:element name="A">
							    <xsl:attribute name="style">text-decoration: none; color: #FF0000;</xsl:attribute>
								<xsl:attribute name="href">#top</xsl:attribute>
								<xsl:attribute name="onclick"><xsl:text>openNote('</xsl:text><xsl:value-of select="."/><xsl:text>')</xsl:text></xsl:attribute>
								<xsl:text>*</xsl:text>
							</xsl:element>
						</xsl:element>
					</xsl:when>
					<xsl:otherwise>
						<xsl:element name="SPAN">
							<xsl:attribute name="title"><xsl:value-of select="."/></xsl:attribute>
							<xsl:attribute name="style">color: #FF0000;</xsl:attribute>
							<xsl:element name="A">
							    <xsl:attribute name="style">text-decoration: none; color: #FF0000;</xsl:attribute>
								<xsl:attribute name="href">#top</xsl:attribute>
								<xsl:attribute name="onclick"><xsl:text>openNote('</xsl:text><xsl:value-of select="."/><xsl:text>')</xsl:text></xsl:attribute>
								<xsl:text>*check*</xsl:text>
							</xsl:element>
						</xsl:element>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="contains($visning, 'norm')">
				<xsl:choose>
					<xsl:when test="attribute::type='header'">
						<xsl:element name="SPAN">
							<xsl:attribute name="style">color: #FF0000;</xsl:attribute>
							<xsl:apply-templates/>
						</xsl:element>
					</xsl:when>
					<xsl:when test="attribute::type='editor'">
						<xsl:element name="SPAN">
							<xsl:attribute name="title"><xsl:value-of select="."/></xsl:attribute>
							<xsl:attribute name="style">color: #FF0000;</xsl:attribute>
							<xsl:element name="A">
							    <xsl:attribute name="style">text-decoration: none; color: #FF0000;</xsl:attribute>
								<xsl:attribute name="href">#top</xsl:attribute>
								<xsl:attribute name="onclick"><xsl:text>openNote('</xsl:text><xsl:value-of select="."/><xsl:text>')</xsl:text></xsl:attribute>
								<xsl:text>*</xsl:text>
							</xsl:element>
						</xsl:element>
					</xsl:when>
					<xsl:otherwise>
						<xsl:element name="SPAN">
							<xsl:attribute name="title"><xsl:value-of select="."/></xsl:attribute>
							<xsl:attribute name="style">color: #FF0000;</xsl:attribute>
							<xsl:element name="A">
							    <xsl:attribute name="style">text-decoration: none; color: #FF0000;</xsl:attribute>
								<xsl:attribute name="href">#top</xsl:attribute>
								<xsl:attribute name="onclick"><xsl:text>openNote('</xsl:text><xsl:value-of select="."/><xsl:text>')</xsl:text></xsl:attribute>
								<xsl:text>*check*</xsl:text>
							</xsl:element>
						</xsl:element>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="tei:check"/>
	
	<!-- Relocated text -->
	
	<xsl:template match="tei:reloc">
		<xsl:choose>
			<xsl:when test="contains($visning, 'dipl')">
				<xsl:choose>
					<xsl:when test="attribute::type='relocate-nec'">
						<xsl:element name="A">
							<xsl:attribute name="name">
								<xsl:value-of select="substring-before(attribute::n, '_')"/>
							</xsl:attribute>
						</xsl:element>
						<xsl:element name="SPAN">
							<xsl:attribute name="style">font-size: 10pt;</xsl:attribute>
							<xsl:element name="A">
								<xsl:attribute name="style">text-decoration: none; color: #CC77FF; font-family: Arial Unicode MS;</xsl:attribute>
								<xsl:attribute name="href">
									<xsl:text>#</xsl:text><xsl:value-of select="substring-after(attribute::n, '_')"/>
								</xsl:attribute>
								<xsl:text>&#x21BA;</xsl:text>
							</xsl:element>
						</xsl:element>
						<xsl:element name="SPAN">
							<xsl:attribute name="style">background-color: #CC77FF;</xsl:attribute>
							<xsl:apply-templates/>
						</xsl:element>
					</xsl:when>
					<xsl:when test="attribute::type='relocate-opt'">
						<xsl:element name="A">
							<xsl:attribute name="name">
								<xsl:value-of select="substring-before(attribute::n, '_')"/>
							</xsl:attribute>
						</xsl:element>
						<xsl:element name="SPAN">
							<xsl:attribute name="style">font-size: 10pt;</xsl:attribute>
							<xsl:element name="A">
								<xsl:attribute name="style">text-decoration: none; color: #CC77FF; font-family: Arial Unicode MS;</xsl:attribute>
								<xsl:attribute name="href">
									<xsl:text>#</xsl:text><xsl:value-of select="substring-after(attribute::n, '_')"/>
								</xsl:attribute>
								<xsl:text>&#x21BA;</xsl:text>
							</xsl:element>
						</xsl:element>
						<xsl:element name="SPAN">
							<xsl:attribute name="style">background-color: #CC77FF;</xsl:attribute>
							<xsl:apply-templates/>
						</xsl:element>
					</xsl:when>
					<xsl:when test="attribute::type='fetch-nec'">
						<xsl:element name="A">
							<xsl:attribute name="name">
								<xsl:value-of select="substring-after(attribute::n, '_')"/>
							</xsl:attribute>
						</xsl:element>
						<xsl:element name="SPAN">
							<xsl:attribute name="style">font-size: 10pt; color: #CC77FF;  font-family: Arial Unicode MS;</xsl:attribute>
							<xsl:element name="A">
								<xsl:attribute name="style">text-decoration: none;</xsl:attribute>
								<xsl:attribute name="href">
									<xsl:text>#</xsl:text><xsl:value-of select="substring-before(attribute::n, '_')"/>
								</xsl:attribute>
								<xsl:text>&#x21BB;</xsl:text>
							</xsl:element>
							<xsl:if test="descendant::node()">
								<xsl:apply-templates/>
							</xsl:if>
						</xsl:element>
					</xsl:when>
					<xsl:when test="attribute::type='fetch-opt'">
						<xsl:element name="A">
							<xsl:attribute name="name">
								<xsl:value-of select="substring-after(attribute::n, '_')"/>
							</xsl:attribute>
						</xsl:element>
						<xsl:element name="SPAN">
							<xsl:attribute name="style">font-size: 10pt; color: #CC77FF;  font-family: Arial Unicode MS;</xsl:attribute>
							<xsl:element name="A">
								<xsl:attribute name="style">text-decoration: none;</xsl:attribute>
								<xsl:attribute name="href">
									<xsl:text>#</xsl:text><xsl:value-of select="substring-before(attribute::n, '_')"/>
								</xsl:attribute>
								<xsl:text>&#x21BB;</xsl:text>
								<xsl:if test="descendant::node()">
									<xsl:apply-templates/>
								</xsl:if>
							</xsl:element>
						</xsl:element>
					</xsl:when>
					<xsl:otherwise>
						<xsl:element name="A">
							<xsl:attribute name="name">
								<xsl:value-of select="substring-after(attribute::n, '_')"/>
							</xsl:attribute>
						</xsl:element>
						<xsl:element name="SPAN">
							<xsl:attribute name="style">font-size: 10pt; color: #CC77FF; font-family: Arial Unicode MS;</xsl:attribute>
							<xsl:element name="A">
								<xsl:attribute name="style">text-decoration: none;</xsl:attribute>
								<xsl:attribute name="href">
									<xsl:text>#</xsl:text><xsl:value-of select="substring-before(attribute::n, '_')"/>
								</xsl:attribute>
								<xsl:text>&#x21BB;</xsl:text>
							</xsl:element>
						</xsl:element>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="contains($visning, 'study')">
				<xsl:choose>
					<xsl:when test="attribute::type='relocate-nec'">
						<xsl:element name="A">
							<xsl:attribute name="name">
								<xsl:value-of select="substring-before(attribute::n, '_')"/>
							</xsl:attribute>
						</xsl:element>
						<xsl:element name="SPAN">
							<xsl:attribute name="style">font-size: 10pt;</xsl:attribute>
							<xsl:element name="A">
								<xsl:attribute name="style">text-decoration: none; color: #CC77FF; font-family: Arial Unicode MS;</xsl:attribute>
								<xsl:attribute name="href">
									<xsl:text>#</xsl:text><xsl:value-of select="substring-after(attribute::n, '_')"/>
								</xsl:attribute>
								<xsl:text>&#x21BA;</xsl:text>
							</xsl:element>
						</xsl:element>
					</xsl:when>
					<xsl:when test="attribute::type='relocate-opt'">
						<xsl:element name="A">
							<xsl:attribute name="name">
								<xsl:value-of select="substring-before(attribute::n, '_')"/>
							</xsl:attribute>
						</xsl:element>
						<xsl:element name="SPAN">
							<xsl:attribute name="style">font-size: 10pt;</xsl:attribute>
							<xsl:element name="A">
								<xsl:attribute name="style">text-decoration: none; color: #CC77FF; font-family: Arial Unicode MS;</xsl:attribute>
								<xsl:attribute name="href">
									<xsl:text>#</xsl:text><xsl:value-of select="substring-after(attribute::n, '_')"/>
								</xsl:attribute>
								<xsl:text>&#x21BA;</xsl:text>
							</xsl:element>
						</xsl:element>
						<xsl:element name="SPAN">
							<xsl:attribute name="style">background-color: #CC77FF;</xsl:attribute>
							<xsl:apply-templates/>
						</xsl:element>
					</xsl:when>
					<xsl:when test="attribute::type='fetch-nec'">
						<xsl:variable name="fetch">
							<xsl:value-of select="attribute::n"/>
						</xsl:variable>
						<xsl:element name="A">
							<xsl:attribute name="name">
								<xsl:value-of select="substring-after(attribute::n, '_')"/>
							</xsl:attribute>
						</xsl:element>
						<xsl:element name="SPAN">
							<xsl:attribute name="style">font-size: 10pt; color: #CC77FF;  font-family: Arial Unicode MS;</xsl:attribute>
							<xsl:element name="A">
								<xsl:attribute name="style">text-decoration: none;</xsl:attribute>
								<xsl:attribute name="href">
									<xsl:text>#</xsl:text><xsl:value-of select="substring-before(attribute::n, '_')"/>
								</xsl:attribute>
								<xsl:text>&#x21BB;</xsl:text>
							</xsl:element>
							<xsl:apply-templates select="ancestor::tei:text/descendant::tei:reloc[attribute::type='relocate-nec' and attribute::n=$fetch]" mode="relocated"/>
						</xsl:element>
					</xsl:when>
					<xsl:when test="attribute::type='fetch-opt'">
						<xsl:element name="A">
							<xsl:attribute name="name">
								<xsl:value-of select="substring-after(attribute::n, '_')"/>
							</xsl:attribute>
						</xsl:element>
						<xsl:element name="SPAN">
							<xsl:attribute name="style">font-size: 10pt; color: #CC77FF;  font-family: Arial Unicode MS;</xsl:attribute>
							<xsl:element name="A">
								<xsl:attribute name="style">text-decoration: none;</xsl:attribute>
								<xsl:attribute name="href">
									<xsl:text>#</xsl:text><xsl:value-of select="substring-before(attribute::n, '_')"/>
								</xsl:attribute>
								<xsl:text>&#x21BB;</xsl:text>
							</xsl:element>
						</xsl:element>
					</xsl:when>
					<xsl:otherwise/>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="contains($visning, 'norm')">
				<xsl:choose>
					<xsl:when test="attribute::type='relocate-nec'">
						<xsl:element name="A">
							<xsl:attribute name="name">
								<xsl:value-of select="substring-before(attribute::n, '_')"/>
							</xsl:attribute>
						</xsl:element>
						<xsl:element name="SPAN">
							<xsl:attribute name="style">font-size: 10pt;</xsl:attribute>
							<xsl:element name="A">
								<xsl:attribute name="style">text-decoration: none; color: #CC77FF; font-family: Arial Unicode MS;</xsl:attribute>
								<xsl:attribute name="href">
									<xsl:text>#</xsl:text><xsl:value-of select="substring-after(attribute::n, '_')"/>
								</xsl:attribute>
								<xsl:text>&#x21BA;</xsl:text>
							</xsl:element>
						</xsl:element>
					</xsl:when>
					<xsl:when test="attribute::type='relocate-opt'">
						<xsl:element name="A">
							<xsl:attribute name="name">
								<xsl:value-of select="substring-before(attribute::n, '_')"/>
							</xsl:attribute>
						</xsl:element>
						<xsl:element name="SPAN">
							<xsl:attribute name="style">font-size: 10pt;</xsl:attribute>
							<xsl:element name="A">
								<xsl:attribute name="style">text-decoration: none; color: #CC77FF; font-family: Arial Unicode MS;</xsl:attribute>
								<xsl:attribute name="href">
									<xsl:text>#</xsl:text><xsl:value-of select="substring-after(attribute::n, '_')"/>
								</xsl:attribute>
								<xsl:text>&#x21BA;</xsl:text>
							</xsl:element>
						</xsl:element>
						<xsl:element name="SPAN">
							<xsl:attribute name="style">background-color: #CC77FF;</xsl:attribute>
							<xsl:apply-templates/>
						</xsl:element>
					</xsl:when>
					<xsl:when test="attribute::type='fetch-nec'">
						<xsl:variable name="fetch">
							<xsl:value-of select="attribute::n"/>
						</xsl:variable>
						<xsl:element name="A">
							<xsl:attribute name="name">
								<xsl:value-of select="substring-after(attribute::n, '_')"/>
							</xsl:attribute>
						</xsl:element>
						<xsl:element name="SPAN">
							<xsl:attribute name="style">font-size: 10pt; color: #CC77FF;  font-family: Arial Unicode MS;</xsl:attribute>
							<xsl:element name="A">
								<xsl:attribute name="style">text-decoration: none;</xsl:attribute>
								<xsl:attribute name="href">
									<xsl:text>#</xsl:text><xsl:value-of select="substring-before(attribute::n, '_')"/>
								</xsl:attribute>
								<xsl:text>&#x21BB;</xsl:text>
							</xsl:element>
							<xsl:apply-templates select="ancestor::tei:text/descendant::tei:reloc[attribute::type='relocate-nec' and attribute::n=$fetch]" mode="relocated"/>
						</xsl:element>
					</xsl:when>
					<xsl:when test="attribute::type='fetch-opt'">
						<xsl:element name="A">
							<xsl:attribute name="name">
								<xsl:value-of select="substring-after(attribute::n, '_')"/>
							</xsl:attribute>
						</xsl:element>
						<xsl:element name="SPAN">
							<xsl:attribute name="style">font-size: 10pt; color: #CC77FF;  font-family: Arial Unicode MS;</xsl:attribute>
							<xsl:element name="A">
								<xsl:attribute name="style">text-decoration: none;</xsl:attribute>
								<xsl:attribute name="href">
									<xsl:text>#</xsl:text><xsl:value-of select="substring-before(attribute::n, '_')"/>
								</xsl:attribute>
								<xsl:text>&#x21BB;</xsl:text>
							</xsl:element>
						</xsl:element>
					</xsl:when>
					<xsl:otherwise/>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="tei:reloc" mode="relocated">
		<xsl:apply-templates/>
	</xsl:template>
	
	<xsl:template match="tei:reloc_h">
		<xsl:choose>
			<xsl:when test="contains($visning, 'dipl')">
				<xsl:choose>
					<xsl:when test="attribute::type='relocate-nec'">
					    <xsl:choose>
					        <xsl:when test="$handwriting='off'"></xsl:when>
					        <xsl:otherwise>
					            <xsl:element name="A">
					                <xsl:attribute name="name">
					                    <xsl:value-of select="substring-before(attribute::n, '_')"/>
					                </xsl:attribute>
					            </xsl:element>
					            <xsl:element name="SPAN">
					                <xsl:attribute name="style">font-size: 10pt;</xsl:attribute>
					                <xsl:element name="A">
					                    <xsl:attribute name="style">text-decoration: none; color: #CC77FF; font-family: Arial Unicode MS;</xsl:attribute>
					                    <xsl:attribute name="href">
					                        <xsl:text>#</xsl:text><xsl:value-of select="substring-after(attribute::n, '_')"/>
					                    </xsl:attribute>
					                    <xsl:text>&#x21BA;</xsl:text>
					                </xsl:element>
					            </xsl:element>
					        </xsl:otherwise>
					    </xsl:choose>
					    

						<xsl:element name="SPAN">
							<xsl:attribute name="style">background-color: #CC77FF;</xsl:attribute>
							<xsl:apply-templates/>
						</xsl:element>
					</xsl:when>
					<xsl:when test="attribute::type='relocate-opt'">
					    <xsl:choose>
					        <xsl:when test="$handwriting='off'"></xsl:when>
					        <xsl:otherwise>
					            <xsl:element name="A">
					                <xsl:attribute name="name">
					                    <xsl:value-of select="substring-before(attribute::n, '_')"/>
					                </xsl:attribute>
					            </xsl:element>
					            <xsl:element name="SPAN">
					                <xsl:attribute name="style">font-size: 10pt;</xsl:attribute>
					                <xsl:element name="A">
					                    <xsl:attribute name="style">text-decoration: none; color: #CC77FF; font-family: Arial Unicode MS;</xsl:attribute>
					                    <xsl:attribute name="href">
					                        <xsl:text>#</xsl:text><xsl:value-of select="substring-after(attribute::n, '_')"/>
					                    </xsl:attribute>
					                    <xsl:text>&#x21BA;</xsl:text>
					                </xsl:element>
					            </xsl:element>
					        </xsl:otherwise>
					    </xsl:choose>

						<xsl:element name="SPAN">
							<xsl:attribute name="style">background-color: #CC77FF;</xsl:attribute>
							<xsl:apply-templates/>
						</xsl:element>
					</xsl:when>
					<xsl:when test="attribute::type='fetch-nec'">
					    <xsl:choose>
					        <xsl:when test="$handwriting='off'">
					            <xsl:if test="descendant::node()">
					                <xsl:apply-templates/>
					            </xsl:if>
					        </xsl:when>
					        <xsl:otherwise>
					            <xsl:element name="A">
					                <xsl:attribute name="name">
					                    <xsl:value-of select="substring-after(attribute::n, '_')"/>
					                </xsl:attribute>
					            </xsl:element>
					            <xsl:element name="SPAN">
					                <xsl:attribute name="style">font-size: 10pt; color: #CC77FF;  font-family: Arial Unicode MS;</xsl:attribute>
					                <xsl:element name="A">
					                    <xsl:attribute name="style">text-decoration: none;</xsl:attribute>
					                    <xsl:attribute name="href">
					                        <xsl:text>#</xsl:text><xsl:value-of select="substring-before(attribute::n, '_')"/>
					                    </xsl:attribute>
					                    <xsl:text>&#x21BB;</xsl:text>
					                    <xsl:if test="descendant::node()">
					                        <xsl:apply-templates/>
					                    </xsl:if>
					                </xsl:element>
					            </xsl:element>
					        </xsl:otherwise>
					    </xsl:choose>
					</xsl:when>
					<xsl:when test="attribute::type='fetch-opt'">
					    <xsl:choose>
					        <xsl:when test="$handwriting='off'">
					            <xsl:if test="descendant::node()">
					                <xsl:apply-templates/>
					            </xsl:if>
					        </xsl:when>
					        <xsl:otherwise>
					            <xsl:element name="A">
					                <xsl:attribute name="name">
					                    <xsl:value-of select="substring-after(attribute::n, '_')"/>
					                </xsl:attribute>
					            </xsl:element>
					            <xsl:element name="SPAN">
					                <xsl:attribute name="style">font-size: 10pt; color: #CC77FF;  font-family: Arial Unicode MS;</xsl:attribute>
					                <xsl:element name="A">
					                    <xsl:attribute name="style">text-decoration: none;</xsl:attribute>
					                    <xsl:attribute name="href">
					                        <xsl:text>#</xsl:text><xsl:value-of select="substring-before(attribute::n, '_')"/>
					                    </xsl:attribute>
					                    <xsl:text>&#x21BB;</xsl:text>
					                    <xsl:if test="descendant::node()">
					                        <xsl:apply-templates/>
					                    </xsl:if>
					                </xsl:element>
					            </xsl:element>
					        </xsl:otherwise>
					    </xsl:choose>
					</xsl:when>
					<xsl:otherwise>
						<xsl:element name="A">
							<xsl:attribute name="name">
								<xsl:value-of select="substring-after(attribute::n, '_')"/>
							</xsl:attribute>
						</xsl:element>
						<xsl:element name="SPAN">
							<xsl:attribute name="style">font-size: 10pt; color: #CC77FF; font-family: Arial Unicode MS;</xsl:attribute>
							<xsl:element name="A">
								<xsl:attribute name="style">text-decoration: none;</xsl:attribute>
								<xsl:attribute name="href">
									<xsl:text>#</xsl:text><xsl:value-of select="substring-before(attribute::n, '_')"/>
								</xsl:attribute>
								<xsl:text>&#x21BB;</xsl:text>
							</xsl:element>
						</xsl:element>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="contains($visning, 'study')">
				<xsl:choose>
					<xsl:when test="attribute::type='relocate-nec'">
						<xsl:element name="A">
							<xsl:attribute name="name">
								<xsl:value-of select="substring-before(attribute::n, '_')"/>
							</xsl:attribute>
						</xsl:element>
						<xsl:element name="SPAN">
							<xsl:attribute name="style">font-size: 10pt;</xsl:attribute>
							<xsl:element name="A">
								<xsl:attribute name="style">text-decoration: none; color: #CC77FF; font-family: Arial Unicode MS;</xsl:attribute>
								<xsl:attribute name="href">
									<xsl:text>#</xsl:text><xsl:value-of select="substring-after(attribute::n, '_')"/>
								</xsl:attribute>
								<xsl:text>&#x21BA;</xsl:text>
							</xsl:element>
						</xsl:element>
					</xsl:when>
					<xsl:when test="attribute::type='relocate-opt'">
						<xsl:element name="A">
							<xsl:attribute name="name">
								<xsl:value-of select="substring-before(attribute::n, '_')"/>
							</xsl:attribute>
						</xsl:element>
						<xsl:element name="SPAN">
							<xsl:attribute name="style">font-size: 10pt;</xsl:attribute>
							<xsl:element name="A">
								<xsl:attribute name="style">text-decoration: none; color: #CC77FF; font-family: Arial Unicode MS;</xsl:attribute>
								<xsl:attribute name="href">
									<xsl:text>#</xsl:text><xsl:value-of select="substring-after(attribute::n, '_')"/>
								</xsl:attribute>
								<xsl:text>&#x21BA;</xsl:text>
							</xsl:element>
						</xsl:element>
						<xsl:element name="SPAN">
							<xsl:attribute name="style">background-color: #CC77FF;</xsl:attribute>
							<xsl:apply-templates/>
						</xsl:element>
					</xsl:when>
					<xsl:when test="attribute::type='fetch-nec'">
						<xsl:variable name="fetch">
							<xsl:value-of select="attribute::n"/>
						</xsl:variable>
						<xsl:element name="A">
							<xsl:attribute name="name">
								<xsl:value-of select="substring-after(attribute::n, '_')"/>
							</xsl:attribute>
						</xsl:element>
						<xsl:element name="SPAN">
							<xsl:attribute name="style">font-size: 10pt; color: #CC77FF;  font-family: Arial Unicode MS;</xsl:attribute>
							<xsl:element name="A">
								<xsl:attribute name="style">text-decoration: none;</xsl:attribute>
								<xsl:attribute name="href">
									<xsl:text>#</xsl:text><xsl:value-of select="substring-before(attribute::n, '_')"/>
								</xsl:attribute>
								<xsl:text>&#x21BB;</xsl:text>
							</xsl:element>
							<xsl:apply-templates select="ancestor::tei:text/descendant::tei:reloc_h[attribute::type='relocate-nec' and attribute::n=$fetch]" mode="relocated"/>
						</xsl:element>
					</xsl:when>
					<xsl:when test="attribute::type='fetch-opt'">
						<xsl:element name="A">
							<xsl:attribute name="name">
								<xsl:value-of select="substring-after(attribute::n, '_')"/>
							</xsl:attribute>
						</xsl:element>
						<xsl:element name="SPAN">
							<xsl:attribute name="style">font-size: 10pt; color: #CC77FF;  font-family: Arial Unicode MS;</xsl:attribute>
							<xsl:element name="A">
								<xsl:attribute name="style">text-decoration: none;</xsl:attribute>
								<xsl:attribute name="href">
									<xsl:text>#</xsl:text><xsl:value-of select="substring-before(attribute::n, '_')"/>
								</xsl:attribute>
								<xsl:text>&#x21BB;</xsl:text>
							</xsl:element>
						</xsl:element>
					</xsl:when>
					<xsl:otherwise/>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="contains($visning, 'norm')">
				<xsl:choose>
					<xsl:when test="attribute::type='relocate-nec'">
						<xsl:element name="A">
							<xsl:attribute name="name">
								<xsl:value-of select="substring-before(attribute::n, '_')"/>
							</xsl:attribute>
						</xsl:element>
						<xsl:element name="SPAN">
							<xsl:attribute name="style">font-size: 10pt;</xsl:attribute>
							<xsl:element name="A">
								<xsl:attribute name="style">text-decoration: none; color: #CC77FF; font-family: Arial Unicode MS;</xsl:attribute>
								<xsl:attribute name="href">
									<xsl:text>#</xsl:text><xsl:value-of select="substring-after(attribute::n, '_')"/>
								</xsl:attribute>
								<xsl:text>&#x21BA;</xsl:text>
							</xsl:element>
						</xsl:element>
					</xsl:when>
					<xsl:when test="attribute::type='relocate-opt'">
						<xsl:element name="A">
							<xsl:attribute name="name">
								<xsl:value-of select="substring-before(attribute::n, '_')"/>
							</xsl:attribute>
						</xsl:element>
						<xsl:element name="SPAN">
							<xsl:attribute name="style">font-size: 10pt;</xsl:attribute>
							<xsl:element name="A">
								<xsl:attribute name="style">text-decoration: none; color: #CC77FF; font-family: Arial Unicode MS;</xsl:attribute>
								<xsl:attribute name="href">
									<xsl:text>#</xsl:text><xsl:value-of select="substring-after(attribute::n, '_')"/>
								</xsl:attribute>
								<xsl:text>&#x21BA;</xsl:text>
							</xsl:element>
						</xsl:element>
						<xsl:element name="SPAN">
							<xsl:attribute name="style">background-color: #CC77FF;</xsl:attribute>
							<xsl:apply-templates/>
						</xsl:element>
					</xsl:when>
					<xsl:when test="attribute::type='fetch-nec'">
						<xsl:variable name="fetch">
							<xsl:value-of select="attribute::n"/>
						</xsl:variable>
						<xsl:element name="A">
							<xsl:attribute name="name">
								<xsl:value-of select="substring-after(attribute::n, '_')"/>
							</xsl:attribute>
						</xsl:element>
						<xsl:element name="SPAN">
							<xsl:attribute name="style">font-size: 10pt; color: #CC77FF;  font-family: Arial Unicode MS;</xsl:attribute>
							<xsl:element name="A">
								<xsl:attribute name="style">text-decoration: none;</xsl:attribute>
								<xsl:attribute name="href">
									<xsl:text>#</xsl:text><xsl:value-of select="substring-before(attribute::n, '_')"/>
								</xsl:attribute>
								<xsl:text>&#x21BB;</xsl:text>
							</xsl:element>
							<xsl:apply-templates select="ancestor::tei:text/descendant::tei:reloc_h[attribute::type='relocate-nec' and attribute::n=$fetch]" mode="relocated"/>
						</xsl:element>
					</xsl:when>
					<xsl:when test="attribute::type='fetch-opt'">
						<xsl:element name="A">
							<xsl:attribute name="name">
								<xsl:value-of select="substring-after(attribute::n, '_')"/>
							</xsl:attribute>
						</xsl:element>
						<xsl:element name="SPAN">
							<xsl:attribute name="style">font-size: 10pt; color: #CC77FF;  font-family: Arial Unicode MS;</xsl:attribute>
							<xsl:element name="A">
								<xsl:attribute name="style">text-decoration: none;</xsl:attribute>
								<xsl:attribute name="href">
									<xsl:text>#</xsl:text><xsl:value-of select="substring-before(attribute::n, '_')"/>
								</xsl:attribute>
								<xsl:text>&#x21BB;</xsl:text>
							</xsl:element>
						</xsl:element>
					</xsl:when>
					<xsl:otherwise/>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="tei:reloc_h" mode="relocated">
		<xsl:apply-templates/>
	</xsl:template>
	
	
	
	
	
</xsl:stylesheet>
