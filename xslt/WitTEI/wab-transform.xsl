<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE TEI [
<!ENTITY nbsp "&#160;">
<!ENTITY emdash "&#2014;">
<!ENTITY dash  "&#x2014;">
]>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:tei="http://www.tei-c.org/ns/1.0" version="1.0">
    <xsl:output method="html" doctype-public="-//W3C/DTD XHTML 1.0 STRICT//EN"
    doctype-system="http:://www.w3.org/TR/xhtml1-strict.dtd" encoding="UTF-8"/>
    
    <!-- Use the below output statement in discovery (comment out the one above) -->
    <!--<xsl:output method="html" encoding="UTF-8"/>-->
    
    <!-- Last update: 2009-02-26 0959 -->
    
    <!-- 
        
        Instructions for manual conversion in Oxygen:
        
        Replace the 'visning' parameter below with one of the following:
        
        <xsl:param name="visning" select="'dipl'"/>
        <xsl:param name="visning" select="'study'"/>
        <xsl:param name="visning" select="'norm'"/>
        
        Replace the 'typo' parameter below with one of the following:
        
        <xsl:param name="typo" select="'show'"/>
        <xsl:param name="typo" select="'hide'"/>
        
    -->
    <xsl:param name="visning" select="'norm'"/>
    <xsl:param name="typo"/>
    <xsl:param name="handwriting"/>
    <xsl:param name="interactive"/>
    <xsl:param name="prosjekt" select="'discovery'"/>
    
    <xsl:param name="el"/>
    <xsl:param name="i"/>
    <xsl:param name="im"/>
    <xsl:param name="our"/>
    <xsl:param name="d"/>
    <xsl:param name="d_c"/>
    <xsl:param name="dn"/>
    <xsl:param name="dn_c"/><!-- Ny variabel - legges til i interaktiv? -->
    <xsl:param name="dnpc"/>
    <xsl:param name="dncr"/><!-- Ny variabel - legges til i interaktiv? -->
    <xsl:param name="trs"/>
    <xsl:param name="trsn"/>
    <xsl:param name="npc"/>
    <xsl:param name="npcn"/>
    <xsl:param name="tra"/>
    <xsl:param name="tran"/>
    
    <xsl:param name="lb"/>
    <xsl:param name="unclear"/>
    
    <xsl:param name="seg"/>
    <xsl:param name="seg-ded"/>
    <xsl:param name="seg-def"/>
    <xsl:param name="seg-dir"/>
    <xsl:param name="seg-ex"/>
    <xsl:param name="seg-intr"/>
    <xsl:param name="seg-mot"/>
    <xsl:param name="seg-pic"/>
    <xsl:param name="seg-pre"/>
    <xsl:param name="q"/>
    <xsl:param name="seg-rhe"/>
    <xsl:param name="seg-sal"/>
    <xsl:param name="seg-not"/>
    <xsl:param name="seg-cod"/>
    
    <xsl:param name="sm"/>
    <xsl:param name="sm-back"/>
    <xsl:param name="sm-bar"/>
    <xsl:param name="sm-epsi"/>
    <xsl:param name="sm-im"/>
    <xsl:param name="sm-qm"/>    
    <xsl:param name="sm-slash"/>
    <xsl:param name="sm-tick"/>
    
    <xsl:variable name="baseURL">
        <xsl:value-of select="'http://wab.aksis.uib.no/cost-a32/'"/>
    </xsl:variable>
    <xsl:variable name="legend">
        <xsl:text>wab_legend.xml</xsl:text>
    </xsl:variable>
    <xsl:variable name="fullURL">
        <xsl:value-of select="concat($baseURL, 'wab_legend.xml')"/>
    </xsl:variable>
    
    
    <!-- This template writes the body into a HTML template -->
    
    <xsl:template match="/">
        <xsl:choose>
            <xsl:when test="$prosjekt='discovery'">
                <xsl:element name="BR"/>
                <xsl:element name="DIV">
                    <xsl:attribute name="width">800px</xsl:attribute>
                    <xsl:apply-templates select="/tei:TEI/tei:text/tei:body"/>
                </xsl:element>
            </xsl:when>
            <xsl:otherwise>
                <xsl:element name="HTML">
                    <xsl:element name="HEAD">
                        <xsl:element name="TITLE">
                            <xsl:value-of select="descendant::tei:titleStmt/child::tei:title"/><xsl:text> - </xsl:text>
                            <xsl:choose>
                                <xsl:when test="$interactive = 'yes'">
                                    <xsl:text>User defined edition</xsl:text>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:choose>
                                        <xsl:when test="$visning = 'dipl'">
                                            <xsl:text>Diplomatic edition</xsl:text>
                                        </xsl:when>
                                        <xsl:when test="$visning = 'norm'">
                                            <xsl:text>Normalized edition</xsl:text>
                                        </xsl:when>
                                        <xsl:when test="$visning = 'study'">
                                            <xsl:text>Study edition</xsl:text>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:text>Typo edition</xsl:text>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:element>
                        <!-- Old position of scripts -->
                        <xsl:element name="LINK">
                            <xsl:attribute name="rel">stylesheet</xsl:attribute>
                            <xsl:attribute name="href">webstil.css</xsl:attribute>
                            <xsl:attribute name="type">text/css</xsl:attribute>
                        </xsl:element>
                        <xsl:element name="STYLE">
                            <xsl:attribute name="type">text/css</xsl:attribute>
                            <xsl:text>
                                #dhtmltooltip{
                                position: absolute;
                                width: 250px;
                                border: 2px solid black;
                                padding: 2px;
                                background-color: lightyellow;
                                visibility: hidden;
                                z-index: 100;
                                /*Remove below line to remove shadow. Below line should always appear last within this CSS*/
                                filter: progid:DXImageTransform.Microsoft.Shadow(color=gray,direction=135);
                                }
                            </xsl:text>
                        </xsl:element> 
                    </xsl:element>
                    <xsl:element name="BODY">
                        <xsl:element name="div">
                            <xsl:attribute name="id">dhtmltooltip</xsl:attribute>
                        </xsl:element>
                        <script type="text/javascript" language="JavaScript1.1" src="http://gandalf.uib.no/wab/cost-a32/ddrivetip.js"/>
                        <script type="text/javascript" language="JavaScript1.1" src="http://gandalf.uib.no/wab/cost-a32/openNote.js"/>
                        <script type="text/javascript" language="JavaScript1.1" src="http://gandalf.uib.no/wab/cost-a32/openBilde.js"/>
                        <script type="text/javascript" language="JavaScript1.1" src="http://gandalf.uib.no/wab/cost-a32/newwindow.js"/>
                        <xsl:element name="TABLE">
                            <xsl:choose>
                                <xsl:when test="$prosjekt = 'discovery'">
                                    <xsl:attribute name="width">700px</xsl:attribute>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:attribute name="width">800px</xsl:attribute>
                                </xsl:otherwise>
                            </xsl:choose>
                            <xsl:attribute name="border">0</xsl:attribute>
                            <xsl:choose>
                                <xsl:when test="$prosjekt = 'discovery'"></xsl:when>
                                <xsl:otherwise>
                                    <xsl:element name="TR">
                                        <xsl:attribute name="valign">top</xsl:attribute>
                                        <xsl:element name="TD">
                                            <xsl:attribute name="valign">top</xsl:attribute>
                                            <xsl:attribute name="width">10%</xsl:attribute>
                                        </xsl:element>
                                        <xsl:element name="TD">
                                            <xsl:attribute name="valign">top</xsl:attribute>
                                            <xsl:apply-templates select="/tei:TEI/tei:teiHeader"/>
                                        </xsl:element>
                                        <xsl:element name="TD">
                                            <xsl:attribute name="valign">top</xsl:attribute>
                                            <xsl:attribute name="width">10%</xsl:attribute>
                                        </xsl:element>
                                    </xsl:element>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:element>
                        <xsl:element name="BR"/>
                        <xsl:if test="not($prosjekt = 'discovery')">
                            <xsl:element name="HR"/>
                        </xsl:if>
                        <xsl:element name="BR"/>
                        <xsl:choose>
                            <xsl:when test="$prosjekt = 'discovery'">
                                <xsl:element name="DIV">
                                    <xsl:attribute name="width">800px</xsl:attribute>
                                    <xsl:apply-templates select="/tei:TEI/tei:text/tei:body/tei:div[attribute::type='text']"/>
                                </xsl:element>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:element name="TABLE">
                                    <xsl:attribute name="width">1000px</xsl:attribute>
                                    <xsl:attribute name="border">0</xsl:attribute>
                                    <xsl:element name="TR">
                                        <xsl:attribute name="valign">top</xsl:attribute>
                                        <xsl:element name="TD">
                                            <xsl:attribute name="valign">top</xsl:attribute>
                                            <xsl:attribute name="width">10%</xsl:attribute>
                                        </xsl:element>
                                        <xsl:element name="TD">
                                            <xsl:attribute name="valign">top</xsl:attribute>
                                            <xsl:apply-templates select="/tei:TEI/tei:text/tei:body/tei:div[attribute::type='text']"/>
                                        </xsl:element>
                                        <xsl:element name="TD">
                                            <xsl:attribute name="valign">top</xsl:attribute>
                                            <xsl:attribute name="width">10%</xsl:attribute>
                                        </xsl:element>
                                    </xsl:element>
                                </xsl:element>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:element>
                </xsl:element>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="tei:teiHeader">
        <xsl:apply-templates select="child::tei:fileDesc"/>
    </xsl:template>
    
    <xsl:template match="tei:fileDesc">
        <xsl:apply-templates select="child::tei:titleStmt"/>
        <xsl:apply-templates select="child::tei:publicationStmt"/>
        <xsl:apply-templates select="child::tei:sourceDesc"/>
    </xsl:template>
    
    
    <xsl:template match="tei:titleStmt">
        <xsl:element name="TABLE">
            <xsl:attribute name="width">600px</xsl:attribute>
            <xsl:element name="TR">
                <xsl:element name="TD">
                    <xsl:attribute name="width">100px</xsl:attribute>
                    <xsl:attribute name="valign">top</xsl:attribute>
                    <xsl:text>Title:&nbsp;</xsl:text>
                </xsl:element>
                <xsl:element name="TD">
                    <xsl:apply-templates select="child::tei:title"/><xsl:text> - </xsl:text>
                    <xsl:choose>
                        <xsl:when test="$interactive = 'yes'">
                            <xsl:text>User defined edition</xsl:text>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:choose>
                                <xsl:when test="$visning = 'dipl'">
                                    <xsl:text>Diplomatic edition</xsl:text>
                                </xsl:when>
                                <xsl:when test="$visning = 'norm'">
                                    <xsl:text>Normalized edition</xsl:text>
                                </xsl:when>
                                <xsl:when test="$visning = 'study'">
                                    <xsl:text>Study edition</xsl:text>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:text>Typewritten-text-only edition</xsl:text>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:otherwise>
                    </xsl:choose>
                    <xsl:element name="BR"></xsl:element>
                    <xsl:text>Click to see legend: </xsl:text>
                    <xsl:element name="form">
                        <xsl:attribute name="enctype">multipart/form-data</xsl:attribute>
                        <xsl:attribute name="action">http://wab.aksis.uib.no/transform/transformer_legend.php</xsl:attribute>
                        <xsl:attribute name="method">post</xsl:attribute>
                        <xsl:attribute name="style">display: inline-block;</xsl:attribute>
                        <xsl:element name="input">
                            <xsl:attribute name="type">hidden</xsl:attribute>
                            <xsl:attribute name="name">modus</xsl:attribute>
                            <xsl:attribute name="value">wab</xsl:attribute>
                        </xsl:element>
                        <xsl:element name="input">
                            <xsl:attribute name="type">hidden</xsl:attribute>
                            <xsl:attribute name="name">xsl</xsl:attribute>
                            <xsl:attribute name="value">http://wab.aksis.uib.no/cost-a32/wab-legend.xsl</xsl:attribute>
                        </xsl:element>
                        <xsl:element name="input">
                            <xsl:attribute name="type">hidden</xsl:attribute>
                            <xsl:attribute name="name">xml</xsl:attribute>
                            <xsl:attribute name="value">http://wab.aksis.uib.no/cost-a32/wab-transform.xsl</xsl:attribute>
                        </xsl:element>
                        <xsl:element name="input">
                            <xsl:attribute name="type">hidden</xsl:attribute>
                            <xsl:attribute name="name">xml</xsl:attribute>
                            <xsl:attribute name="value">http://wab.aksis.uib.no/cost-a32/wab_legend.xml</xsl:attribute>
                        </xsl:element>
                        <xsl:element name="input">
                            <xsl:attribute name="type">hidden</xsl:attribute>
                            <xsl:attribute name="name">interactive</xsl:attribute>
                            <xsl:attribute name="value"><xsl:value-of select="$interactive"/></xsl:attribute>
                        </xsl:element>
                        <xsl:element name="input">
                            <xsl:attribute name="type">hidden</xsl:attribute>
                            <xsl:attribute name="name">visning</xsl:attribute>
                            <xsl:attribute name="value"><xsl:value-of select="$visning"/></xsl:attribute>
                        </xsl:element>
                        <xsl:element name="input">
                            <xsl:attribute name="type">hidden</xsl:attribute>
                            <xsl:attribute name="name">el</xsl:attribute>
                            <xsl:attribute name="value"><xsl:value-of select="$el"/></xsl:attribute>
                        </xsl:element>
                        <xsl:element name="input">
                            <xsl:attribute name="type">hidden</xsl:attribute>
                            <xsl:attribute name="name">i</xsl:attribute>
                            <xsl:attribute name="value"><xsl:value-of select="$i"/></xsl:attribute>
                        </xsl:element>
                        <xsl:element name="input">
                            <xsl:attribute name="type">hidden</xsl:attribute>
                            <xsl:attribute name="name">im</xsl:attribute>
                            <xsl:attribute name="value"><xsl:value-of select="$im"/></xsl:attribute>
                        </xsl:element>
                        <xsl:element name="input">
                            <xsl:attribute name="type">hidden</xsl:attribute>
                            <xsl:attribute name="name">our</xsl:attribute>
                            <xsl:attribute name="value"><xsl:value-of select="$our"/></xsl:attribute>
                        </xsl:element>
                        <xsl:element name="input">
                            <xsl:attribute name="type">hidden</xsl:attribute>
                            <xsl:attribute name="name">d</xsl:attribute>
                            <xsl:attribute name="value"><xsl:value-of select="$d"/></xsl:attribute>
                        </xsl:element>
                        <xsl:element name="input">
                            <xsl:attribute name="type">hidden</xsl:attribute>
                            <xsl:attribute name="name">d_c</xsl:attribute>
                            <xsl:attribute name="value"><xsl:value-of select="$d_c"/></xsl:attribute>
                        </xsl:element>
                        <xsl:element name="input">
                            <xsl:attribute name="type">hidden</xsl:attribute>
                            <xsl:attribute name="name">dn</xsl:attribute>
                            <xsl:attribute name="value"><xsl:value-of select="$dn"/></xsl:attribute>
                        </xsl:element>
                        <xsl:element name="input">
                            <xsl:attribute name="type">hidden</xsl:attribute>
                            <xsl:attribute name="name">dn</xsl:attribute>
                            <xsl:attribute name="value"><xsl:value-of select="$dn_c"/></xsl:attribute>
                        </xsl:element>
                        <xsl:element name="input">
                            <xsl:attribute name="type">hidden</xsl:attribute>
                            <xsl:attribute name="name">dnpc</xsl:attribute>
                            <xsl:attribute name="value"><xsl:value-of select="$dnpc"/></xsl:attribute>
                        </xsl:element>
                        <xsl:element name="input">
                            <xsl:attribute name="type">hidden</xsl:attribute>
                            <xsl:attribute name="name">trs</xsl:attribute>
                            <xsl:attribute name="value"><xsl:value-of select="$trs"/></xsl:attribute>
                        </xsl:element>
                        <xsl:element name="input">
                            <xsl:attribute name="type">hidden</xsl:attribute>
                            <xsl:attribute name="name">trsn</xsl:attribute>
                            <xsl:attribute name="value"><xsl:value-of select="$trsn"/></xsl:attribute>
                        </xsl:element>
                        <xsl:element name="input">
                            <xsl:attribute name="type">hidden</xsl:attribute>
                            <xsl:attribute name="name">npc</xsl:attribute>
                            <xsl:attribute name="value"><xsl:value-of select="$npc"/></xsl:attribute>
                        </xsl:element>
                        <xsl:element name="input">
                            <xsl:attribute name="type">hidden</xsl:attribute>
                            <xsl:attribute name="name">npcn</xsl:attribute>
                            <xsl:attribute name="value"><xsl:value-of select="$npcn"/></xsl:attribute>
                        </xsl:element>
                        <xsl:element name="input">
                            <xsl:attribute name="type">hidden</xsl:attribute>
                            <xsl:attribute name="name">tra</xsl:attribute>
                            <xsl:attribute name="value"><xsl:value-of select="$tra"/></xsl:attribute>
                        </xsl:element>
                        <xsl:element name="input">
                            <xsl:attribute name="type">hidden</xsl:attribute>
                            <xsl:attribute name="name">tran</xsl:attribute>
                            <xsl:attribute name="value"><xsl:value-of select="$tran"/></xsl:attribute>
                        </xsl:element>
                        <xsl:element name="input">
                            <xsl:attribute name="type">hidden</xsl:attribute>
                            <xsl:attribute name="name">lb</xsl:attribute>
                            <xsl:attribute name="value"><xsl:value-of select="$lb"/></xsl:attribute>
                        </xsl:element>
                        <xsl:element name="input">
                            <xsl:attribute name="type">hidden</xsl:attribute>
                            <xsl:attribute name="name">handwriting</xsl:attribute>
                            <xsl:attribute name="value"><xsl:value-of select="$handwriting"/></xsl:attribute>
                        </xsl:element>
                        <xsl:element name="input">
                            <xsl:attribute name="type">hidden</xsl:attribute>
                            <xsl:attribute name="name">seg</xsl:attribute>
                            <xsl:attribute name="value"><xsl:value-of select="$seg"/></xsl:attribute>
                        </xsl:element>
                        <xsl:element name="input">
                            <xsl:attribute name="type">hidden</xsl:attribute>
                            <xsl:attribute name="name">unclear</xsl:attribute>
                            <xsl:attribute name="value"><xsl:value-of select="$unclear"/></xsl:attribute>
                        </xsl:element>
                        <xsl:element name="input">
                            <xsl:attribute name="type">hidden</xsl:attribute>
                            <xsl:attribute name="name">seg-ded</xsl:attribute>
                            <xsl:attribute name="value"><xsl:value-of select="$seg-ded"/></xsl:attribute>
                        </xsl:element>
                        <xsl:element name="input">
                            <xsl:attribute name="type">hidden</xsl:attribute>
                            <xsl:attribute name="name">seg-mot</xsl:attribute>
                            <xsl:attribute name="value"><xsl:value-of select="$seg-mot"/></xsl:attribute>
                        </xsl:element>
                        <xsl:element name="input">
                            <xsl:attribute name="type">hidden</xsl:attribute>
                            <xsl:attribute name="name">seg-pre</xsl:attribute>
                            <xsl:attribute name="value"><xsl:value-of select="$seg-pre"/></xsl:attribute>
                        </xsl:element>
                        <xsl:element name="input">
                            <xsl:attribute name="type">hidden</xsl:attribute>
                            <xsl:attribute name="name">q</xsl:attribute>
                            <xsl:attribute name="value"><xsl:value-of select="$q"/></xsl:attribute>
                        </xsl:element>
                        <xsl:element name="input">
                            <xsl:attribute name="type">hidden</xsl:attribute>
                            <xsl:attribute name="name">seg-not</xsl:attribute>
                            <xsl:attribute name="value"><xsl:value-of select="$seg-not"/></xsl:attribute>
                        </xsl:element>
                        <xsl:element name="input">
                            <xsl:attribute name="type">hidden</xsl:attribute>
                            <xsl:attribute name="name">seg-cod</xsl:attribute>
                            <xsl:attribute name="value"><xsl:value-of select="$seg-cod"/></xsl:attribute>
                        </xsl:element>
                        <xsl:element name="input">
                            <xsl:attribute name="type">hidden</xsl:attribute>
                            <xsl:attribute name="name">sm</xsl:attribute>
                            <xsl:attribute name="value"><xsl:value-of select="$sm"/></xsl:attribute>
                        </xsl:element>
                        <xsl:element name="input">
                            <xsl:attribute name="type">hidden</xsl:attribute>
                            <xsl:attribute name="name">sm-back</xsl:attribute>
                            <xsl:attribute name="value"><xsl:value-of select="$sm-back"/></xsl:attribute>
                        </xsl:element>
                        <xsl:element name="input">
                            <xsl:attribute name="type">hidden</xsl:attribute>
                            <xsl:attribute name="name">sm-bar</xsl:attribute>
                            <xsl:attribute name="value"><xsl:value-of select="$sm-bar"/></xsl:attribute>
                        </xsl:element>
                        <xsl:element name="input">
                            <xsl:attribute name="type">hidden</xsl:attribute>
                            <xsl:attribute name="name">sm-epsi</xsl:attribute>
                            <xsl:attribute name="value"><xsl:value-of select="$sm-epsi"/></xsl:attribute>
                        </xsl:element>
                        <xsl:element name="input">
                            <xsl:attribute name="type">hidden</xsl:attribute>
                            <xsl:attribute name="name">sm-im</xsl:attribute>
                            <xsl:attribute name="value"><xsl:value-of select="$sm-im"/></xsl:attribute>
                        </xsl:element>
                        <xsl:element name="input">
                            <xsl:attribute name="type">hidden</xsl:attribute>
                            <xsl:attribute name="name">sm-qm</xsl:attribute>
                            <xsl:attribute name="value"><xsl:value-of select="$sm-qm"/></xsl:attribute>
                        </xsl:element>
                        <xsl:element name="input">
                            <xsl:attribute name="type">hidden</xsl:attribute>
                            <xsl:attribute name="name">sm-slash</xsl:attribute>
                            <xsl:attribute name="value"><xsl:value-of select="$sm-slash"/></xsl:attribute>
                        </xsl:element>
                        <xsl:element name="input">
                            <xsl:attribute name="type">hidden</xsl:attribute>
                            <xsl:attribute name="name">sm-tick</xsl:attribute>
                            <xsl:attribute name="value"><xsl:value-of select="$sm-tick"/></xsl:attribute>
                        </xsl:element>
                        
                        <xsl:element name="input">
                            <xsl:attribute name="class">submit</xsl:attribute>
                            <xsl:attribute name="type">submit</xsl:attribute>
                            <xsl:attribute name="value">legend</xsl:attribute>
                            <xsl:attribute name="style">font-size: 0.5em</xsl:attribute>
                        </xsl:element>
                    </xsl:element>
                </xsl:element>
            </xsl:element>
            <xsl:element name="TR">
                <xsl:element name="TD">
                    <xsl:attribute name="width">100px</xsl:attribute>
                    <xsl:attribute name="valign">top</xsl:attribute>
                    <xsl:text>Author:&nbsp;</xsl:text>
                </xsl:element>
                <xsl:element name="TD">
                    <xsl:apply-templates select="child::tei:author"/>
                </xsl:element>
            </xsl:element>
            <xsl:element name="TR">
                <xsl:element name="TD">
                    <xsl:attribute name="width">100px</xsl:attribute>
                    <xsl:attribute name="valign">top</xsl:attribute>
                    <xsl:text>Editor: &nbsp;</xsl:text>
                </xsl:element>
                <xsl:element name="TD">
                    <xsl:apply-templates select="child::tei:editor"/>
                </xsl:element>
            </xsl:element>
            <xsl:if test="descendant::tei:funder">
            <xsl:element name="TR">
                <xsl:element name="TD">
                    <xsl:attribute name="width">100px</xsl:attribute>
                    <xsl:attribute name="valign">top</xsl:attribute>
                    <xsl:text>Funders &amp; Partners: &nbsp;</xsl:text>
                </xsl:element>
                <xsl:element name="TD">
                    <xsl:apply-templates select="child::tei:funder"/>
                </xsl:element>
            </xsl:element></xsl:if>
            <xsl:for-each select="child::tei:respStmt">
                <xsl:element name="TR">
                    <xsl:element name="TD">
                        <xsl:attribute name="width">100px</xsl:attribute>
                        <xsl:if test="not(preceding-sibling::tei:respStmt)">
                            <xsl:text>Resp:</xsl:text>
                        </xsl:if>
                    </xsl:element>
                    <xsl:element name="TD">
                        <xsl:apply-templates select="child::tei:name"/>
                        <xsl:text> (</xsl:text>
                        <xsl:apply-templates select="child::tei:resp"/>
                        <xsl:text>)</xsl:text>
                    </xsl:element>
                </xsl:element>
            </xsl:for-each>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="tei:publicationStmt">
        <xsl:element name="TABLE">
            <xsl:attribute name="width">600px</xsl:attribute>
            <xsl:element name="TR">
                <xsl:element name="TD">
                    <xsl:attribute name="width">100px</xsl:attribute>
                    <xsl:attribute name="valign">top</xsl:attribute>
                    <xsl:if test="not(preceding-sibling::tei:name)">
                        <xsl:text>Rights:&nbsp;</xsl:text>
                    </xsl:if>
                </xsl:element>
                <xsl:element name="TD">
                    <xsl:apply-templates select="child::tei:availability"/>
                </xsl:element>
            </xsl:element>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="tei:sourceDesc">
        <xsl:element name="TABLE">
            <xsl:attribute name="width">600px</xsl:attribute>
            <xsl:element name="TR">
                <xsl:element name="TD">
                    <xsl:attribute name="width">100px</xsl:attribute>
                    <xsl:text>Source:&nbsp;</xsl:text>
                </xsl:element>
                <xsl:element name="TD">
                    <xsl:apply-templates select="child::tei:p"/>
                </xsl:element>
            </xsl:element>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="tei:editor">
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="tei:orgName">
        <xsl:choose>
            <xsl:when test="attribute::ref">
                <xsl:element name="A">
                    <xsl:attribute name="href"><xsl:value-of select="attribute::ref"/></xsl:attribute>
                    <xsl:attribute name="target">_blank</xsl:attribute>
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="tei:name">
        <xsl:apply-templates/>
        <xsl:if test="following-sibling::*[1][self::tei:name]">
            <xsl:text>, </xsl:text>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="tei:orgName">
        <xsl:element name="BR"/>
        <xsl:text>Organization: </xsl:text>
        <xsl:apply-templates/>
    </xsl:template>
    

    <!-- Include som henter inn templates for tekstvisning -->
    <xsl:include href="wab-elements.xsl"/>

    
</xsl:stylesheet>
