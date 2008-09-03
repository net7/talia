<?xml version="1.0" encoding="ISO-8859-1"?>
<!DOCTYPE TEI [
<!ENTITY nbsp "&#160;">
<!ENTITY emdash "&#2014;">
<!ENTITY dash  "&#x2014;">
]>
<!--
add rend="el_X" innhold blå
del type="d_h" overstrøkningstrek blå
...
sjekk alle _h, _X koder -> blå 
-->
<!-- inkluder phr i interaktiv stylesheet -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:tei="http://www.tei-c.org/ns/1.0" version="1.0">

    <xsl:output method="html" doctype-public="-//W3C/DTD XHTML 1.0 STRICT//EN" doctype-system="http:://www.w3.org/TR/xhtml1-strict.dtd" encoding="ISO-8859-1"/>

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
    <xsl:param name="visning"/>
    <xsl:param name="typo"/>
    <xsl:param name="interactive"/>

    <xsl:param name="el"/>
    <xsl:param name="i"/>
    <xsl:param name="im"/>
    <xsl:param name="our"/>
    <xsl:param name="d"/>
    <xsl:param name="d_c"/>
    <xsl:param name="dn"/>
    <xsl:param name="dnpc"/>
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
        <xsl:element name="HTML">
            <xsl:element name="HEAD">
                <!--<xsl:element name="TITLE">WAB DISCOVERY (2007-): Wittgenstein's Nachlass</xsl:element>-->
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
                                    <xsl:text>Magic edition</xsl:text>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:element>
                <xsl:element name="script">
                    <xsl:attribute name="language">JavaScript1.1</xsl:attribute>
                    <xsl:attribute name="name">openBilde</xsl:attribute>
                    <xsl:comment>
                        function openBilde(string)
                        {
                        window.open(string,'','width=640, height=600, resizable=yes, scrollbars=yes, toolbar=no, location=no, directories=no,status=no, menubar=yes');
                        }
                        //
                    </xsl:comment>
                </xsl:element>
                <xsl:element name="LINK">
                    <xsl:attribute name="rel">stylesheet</xsl:attribute>
                    <xsl:attribute name="href">webstil.css</xsl:attribute>
                    <!--<xsl:attribute name="href">139A.css</xsl:attribute>-->
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
                <xsl:element name="script">
                    <xsl:attribute name="type">text/javascript</xsl:attribute>
                    
                    /***********************************************
                    * Cool DHTML tooltip script- © Dynamic Drive DHTML code library (www.dynamicdrive.com)
                    * This notice MUST stay intact for legal use
                    * Visit Dynamic Drive at http://www.dynamicdrive.com/ for full source code
                    ***********************************************/
                    
                    var offsetxpoint=-60 //Customize x offset of tooltip
                    var offsetypoint=20 //Customize y offset of tooltip
                    var ie=document.all
                    var ns6=document.getElementById &amp;&amp; !document.all
                    var enabletip=false
                    if (ie||ns6)
                    var tipobj=document.all? document.all["dhtmltooltip"] : document.getElementById? document.getElementById("dhtmltooltip") : ""
                    
                    function ietruebody(){
                    return (document.compatMode &amp;&amp; document.compatMode!="BackCompat")? document.documentElement : document.body
                    }
                    
                    function ddrivetip(thetext, thecolor, thewidth){
                    if (ns6||ie){
                    if (typeof thewidth!="undefined") tipobj.style.width=thewidth+"px"
                    if (typeof thecolor!="undefined" &amp;&amp; thecolor!="") tipobj.style.backgroundColor=thecolor
                    tipobj.innerHTML=thetext
                    enabletip=true
                    return false
                    }
                    }
                    
                    function positiontip(e){
                    if (enabletip){
                    var curX=(ns6)?e.pageX : event.clientX+ietruebody().scrollLeft;
                    var curY=(ns6)?e.pageY : event.clientY+ietruebody().scrollTop;
                    //Find out how close the mouse is to the corner of the window
                    var rightedge=ie&amp;&amp;!window.opera? ietruebody().clientWidth-event.clientX-offsetxpoint : window.innerWidth-e.clientX-offsetxpoint-20
                    var bottomedge=ie&amp;&amp;!window.opera? ietruebody().clientHeight-event.clientY-offsetypoint : window.innerHeight-e.clientY-offsetypoint-20
                    
                    var leftedge=(offsetxpoint&lt;0)? offsetxpoint*(-1) : -1000
                    
                    //if the horizontal distance isn't enough to accomodate the width of the context menu
                    if (rightedge&lt;tipobj.offsetWidth)
                    //move the horizontal position of the menu to the left by it's width
                    tipobj.style.left=ie? ietruebody().scrollLeft+event.clientX-tipobj.offsetWidth+"px" : window.pageXOffset+e.clientX-tipobj.offsetWidth+"px"
                    else if (curX&lt;leftedge)
                    tipobj.style.left="5px"
                    else
                    //position the horizontal position of the menu where the mouse is positioned
                    tipobj.style.left=curX+offsetxpoint+"px"
                    
                    //same concept with the vertical position
                    if (bottomedge&lt;tipobj.offsetHeight)
                    tipobj.style.top=ie? ietruebody().scrollTop+event.clientY-tipobj.offsetHeight-offsetypoint+"px" : window.pageYOffset+e.clientY-tipobj.offsetHeight-offsetypoint+"px"
                    else
                    tipobj.style.top=curY+offsetypoint+"px"
                    tipobj.style.visibility="visible"
                    }
                    }
                    
                    function hideddrivetip(){
                    if (ns6||ie){
                    enabletip=false
                    tipobj.style.visibility="hidden"
                    tipobj.style.left="-1000px"
                    tipobj.style.backgroundColor=''
                    tipobj.style.width=''
                    }
                    }
                    
                    document.onmousemove=positiontip
                    
                </xsl:element>
                <xsl:element name="TABLE">
                    <xsl:attribute name="width">800px</xsl:attribute>
                    <xsl:attribute name="border">0</xsl:attribute>
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
                </xsl:element>
                <xsl:element name="BR"/>
                <xsl:element name="HR"/>
                <xsl:element name="BR"/>
                <xsl:element name="A">
                    <xsl:attribute name="name">text</xsl:attribute>
                </xsl:element>
                <xsl:element name="A">
                    <xsl:attribute name="href">#legend</xsl:attribute>
                    <xsl:text>legend</xsl:text>
                </xsl:element>
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
                <xsl:element name="HR"/>
                <xsl:element name="A">
                    <xsl:attribute name="name">legend</xsl:attribute>
                </xsl:element>
                <xsl:element name="A">
                    <xsl:attribute name="href">#text</xsl:attribute>
                    <xsl:text>top</xsl:text>
                </xsl:element>
                <xsl:element name="TABLE">
                    <xsl:attribute name="width">800px</xsl:attribute>
                    <xsl:attribute name="border">0</xsl:attribute>
                    <xsl:element name="TR">
                        <xsl:attribute name="valign">top</xsl:attribute>
                        <xsl:element name="TD">
                            <xsl:attribute name="valign">top</xsl:attribute>
                            <xsl:attribute name="width">10%</xsl:attribute>
                        </xsl:element>
                        <xsl:element name="TD">
                            <xsl:attribute name="valign">top</xsl:attribute>
                            <xsl:element name="DIV">
                                <xsl:attribute name="style">font-weight: bold;</xsl:attribute>
                                <xsl:text>Legend:</xsl:text>
                            </xsl:element>
                            <xsl:element name="BR"/>
                            <xsl:apply-templates select="document($legend)/tei:TEI/tei:text/tei:body/tei:div[attribute::type='legend']"/>
                        </xsl:element>
                        <xsl:element name="TD">
                            <xsl:attribute name="valign">top</xsl:attribute>
                            <xsl:attribute name="width">10%</xsl:attribute>
                        </xsl:element>
                    </xsl:element>
                </xsl:element>
            </xsl:element>
        </xsl:element>
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
                    <xsl:text>Title: </xsl:text>
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
                                    <xsl:text>Magic edition</xsl:text>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:otherwise>
                    </xsl:choose>
<!--                    <xsl:if test="$visning = 'dipl'">
                        <xsl:text>&nbsp;&dash;&nbsp;Diplomatic edition</xsl:text>
                    </xsl:if>
                    <xsl:if test="$visning = 'norm'">
                        <xsl:text>&nbsp;&dash;&nbsp;Normalized edition</xsl:text>
                    </xsl:if>
                    <xsl:if test="$visning = 'study'">
                        <xsl:text>&nbsp;&dash;&nbsp;Study edition</xsl:text>
                    </xsl:if>-->
                </xsl:element>
            </xsl:element>
            <xsl:element name="TR">
                <xsl:element name="TD">
                    <xsl:attribute name="width">100px</xsl:attribute>
                    <xsl:attribute name="valign">top</xsl:attribute>
                    <xsl:text>Author: </xsl:text>
                </xsl:element>
                <xsl:element name="TD">
                    <xsl:apply-templates select="child::tei:author"/>
                </xsl:element>
            </xsl:element>
            <xsl:element name="TR">
                <xsl:element name="TD">
                    <xsl:attribute name="width">100px</xsl:attribute>
                    <xsl:attribute name="valign">top</xsl:attribute>
                    <xsl:text>Editor:  </xsl:text>
                </xsl:element>
                <xsl:element name="TD">
                    <xsl:apply-templates select="child::tei:editor"/>
                </xsl:element>
            </xsl:element>
            <xsl:element name="TR">
                <xsl:element name="TD">
                    <xsl:attribute name="width">100px</xsl:attribute>
                    <xsl:attribute name="valign">top</xsl:attribute>
                    <xsl:text>Funders &amp; Partners:  </xsl:text>
                </xsl:element>
                <xsl:element name="TD">
                    <xsl:apply-templates select="child::tei:funder"/>
                </xsl:element>
            </xsl:element>
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
                        <xsl:text>Rights: </xsl:text>
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
                    <xsl:text>Source: </xsl:text>
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

    <!-- The basic text-elements are handled by the following templates -->

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
<!--        <xsl:element name="BR"/>
<xsl:element name="BR"/>-->
        <xsl:choose>
            <xsl:when test="ancestor::tei:p">
                <xsl:element name="TABLE">
                    <xsl:attribute name="width">100%</xsl:attribute>
                    <xsl:attribute name="style">border-bottom-style: solid; <!--border-left-style: solid; border-right-style: solid;--> border-width: 1px; color: #FF0000;</xsl:attribute>
                    <xsl:element name="TR">
                        <xsl:element name="TD"/>
                    </xsl:element>
                </xsl:element>
                <xsl:element name="TABLE">
                    <xsl:attribute name="width">100%</xsl:attribute>
                    <xsl:attribute name="style">border-top-style: solid; <!--border-left-style: solid; border-right-style: solid;--> border-width: 1px; color: #FF0000;</xsl:attribute>
                    <xsl:element name="TR">
                        <xsl:element name="TD"/>
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
                                <xsl:attribute name="style">border-bottom-style: solid; <!--border-left-style: solid; border-right-style: solid;--> border-width: 1px; color: #FF0000;</xsl:attribute>
                                <xsl:element name="TR">
                                    <xsl:element name="TD"/>
                                </xsl:element>
                            </xsl:element>
                            <xsl:element name="TABLE">
                                <xsl:attribute name="width">100%</xsl:attribute>
                                <xsl:attribute name="style">border-top-style: solid; <!--border-left-style: solid; border-right-style: solid;--> border-width: 1px; color: #FF0000;</xsl:attribute>
                                <xsl:element name="TR">
                                    <xsl:element name="TD"/>
                                </xsl:element>
                            </xsl:element>
                        </xsl:element>
                    </xsl:element>
                </xsl:element>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:element name="SPAN">
            <xsl:attribute name="style">float: right;</xsl:attribute>
            <xsl:element name="A">
                <xsl:attribute name="href">
                    <xsl:value-of select="attribute::corresp"/>
                </xsl:attribute>
                <xsl:attribute name="target">_blank</xsl:attribute>
                <xsl:text>¤</xsl:text>
            </xsl:element>
            <xsl:text> </xsl:text>
            <xsl:element name="SPAN">
                <xsl:attribute name="style">font-size: 10pt; color: #FF0000;</xsl:attribute>
                <xsl:value-of select="substring-after($pagename, '_')"/>
            </xsl:element>
        </xsl:element>
    </xsl:template>

    <xsl:template match="tei:lb">
        <xsl:choose>
            <xsl:when test="contains($typo, 'hide')">
                <xsl:choose>
                    <xsl:when test="contains($lb, 'excl')"/>
                    <xsl:otherwise>
                        <xsl:choose>
                            <xsl:when test="attribute::rend='shyphen'">
                                <xsl:text>-</xsl:text>
                                <xsl:element name="BR"/>
                            </xsl:when>
                            <xsl:when test="attribute::rend='shyphen-pb'">
                                <xsl:text>-</xsl:text>
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
            <xsl:otherwise>
                <xsl:choose>
                    <xsl:when test="contains($lb, 'excl')"/>
                    <xsl:otherwise>
                        <xsl:choose>
                            <xsl:when test="contains($visning, 'dipl')">
                                <xsl:choose>
                                    <xsl:when test="attribute::rend='shyphen'">
                                        <xsl:text>-</xsl:text>
                                        <xsl:element name="BR"/>
                                    </xsl:when>
                                    <xsl:when test="attribute::rend='shyphen-pb'">
                                        <xsl:text>-</xsl:text>
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
                            <xsl:when test="contains($visning, 'study')">
                                <xsl:choose>
                                    <xsl:when test="attribute::rend='shyphen'">
                                        <xsl:text>-</xsl:text>
                                        <xsl:element name="BR"/>
                                    </xsl:when>
                                    <xsl:when test="attribute::rend='shyphen-pb'">
                                        <xsl:text>-</xsl:text>
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
                                    <xsl:when test="attribute::rend='shyphen'"> </xsl:when>
                                    <xsl:when test="attribute::rend='shyphen-pb'">
                                        <xsl:text>-</xsl:text>
                                        <xsl:element name="BR"/>
                                    </xsl:when>
                                    <xsl:when test="attribute::rend='shyphen0'"> </xsl:when>
                                    <xsl:when test="attribute::rend='hl'">
                                        <xsl:element name="BR"/>
                                    </xsl:when>
                                    <xsl:otherwise> </xsl:otherwise>
                                </xsl:choose>
                            </xsl:when>
                            <xsl:otherwise/>
                        </xsl:choose>
                    </xsl:otherwise>
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
                                    <xsl:attribute name="style">text-align: right; margin-right:
                                        250px;</xsl:attribute>
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
                    <xsl:call-template name="spaces">
                        <xsl:with-param name="i" select="1"/>
                        <xsl:with-param name="max" select="substring-after(attribute::rend, '_')"/>
                    </xsl:call-template>
                </xsl:if>
                <xsl:apply-templates/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="spaces">
        <xsl:param name="i"/>
        <xsl:param name="max"/>
        <xsl:if test="$i &lt;= $max">
            <xsl:text> </xsl:text>
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

    <xsl:template match="tei:p">
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
            <xsl:otherwise>
                <xsl:choose>
<!--                    <xsl:when test="contains($sm-check, '\')">
                        <xsl:text>YAY</xsl:text>
                        <xsl:apply-templates/>
                    </xsl:when>-->
                   <xsl:when test="descendant::tei:seg[contains(self::tei:seg, '&#8726;')] and not($sm-back='show')">
                       <!--<xsl:text>YAY</xsl:text>-->
                   </xsl:when>
                    <xsl:when test="descendant::tei:seg[contains(self::tei:seg, '&#8739;')] and not($sm-bar='show')">
                    </xsl:when>
                    <xsl:when test="descendant::tei:seg[contains(self::tei:seg, '&#1013;')] and not($sm-epsi='show')">
                    </xsl:when>
                    <xsl:when test="descendant::tei:seg[contains(self::tei:seg, '¥')] and not($sm-im='show')">
                    </xsl:when>
                    <xsl:when test="descendant::tei:seg[contains(self::tei:seg, '&#8253;')] and not($sm-qm='show')">
                    </xsl:when>
                    <xsl:when test="descendant::tei:seg[contains(self::tei:seg, '&#8725;')] and not($sm-slash='show')">
                    </xsl:when>
                    <xsl:when test="descendant::tei:seg[contains(self::tei:seg, '&#8227;')] and not($sm-tick='show')">
                    </xsl:when>
                    <!--             <xsl:when test="descendant::tei:seg[contains(self::tei:seg, 'bar.sm')] and $sm-bar='hide'">
                    </xsl:when>
                    <xsl:when test="descendant::tei:seg[contains(self::tei:seg, 'epsilon.sm')] and $sm-epsi='hide'">
                    </xsl:when>
                    <xsl:when test="descendant::tei:seg[contains(self::tei:seg, 'im.sm')] and $sm-im='hide'">
                    </xsl:when>
                    <xsl:when test="descendant::tei:seg[contains(self::tei:seg, 'qm.sm')] and $sm-qm='hide'">
                    </xsl:when>
                    <xsl:when test="descendant::tei:seg[contains(self::tei:seg, 'slash.sm')] and $sm-slash='hide'">
                    </xsl:when>
                    <xsl:when test="descendant::tei:seg[contains(self::tei:seg, 'tick.sm')] and $sm-tick='hide'">
                    </xsl:when>-->
                    <xsl:otherwise>
                        <xsl:choose>
                            <xsl:when test="ancestor::tei:p and ancestor::tei:reloc">
                                <xsl:choose>
                                    <xsl:when test="$visning='norm'">
                                        <xsl:element name="DIV">
                                            <xsl:attribute name="style">margin-bottom: 10px; width:
                                                700px;</xsl:attribute>
                                            <xsl:if test="not(contains(attribute::rend, 'conline'))">
                                                <xsl:element name="BR"/>
                                            </xsl:if>
                                            <xsl:choose>
                                                <xsl:when test="attribute::xml:id">
                                                    <xsl:element name="SPAN">
                                                        <xsl:attribute name="onMouseover">
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
                                                        </xsl:attribute>
                                                        <xsl:attribute name="onMouseout">hideddrivetip()</xsl:attribute>
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
                                            <xsl:attribute name="style">margin-bottom: 10px; width:
                                                700px;</xsl:attribute>
                                            <xsl:element name="BR"/>
                                            <xsl:choose>
                                                <xsl:when test="attribute::xml:id">
                                                    <xsl:element name="SPAN">
                                                        <xsl:attribute name="onMouseover">
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
                                                        </xsl:attribute>
                                                        <xsl:attribute name="onMouseout">hideddrivetip()</xsl:attribute>
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
                                                <xsl:attribute name="width">200px</xsl:attribute>
                                                <xsl:attribute name="align">left</xsl:attribute>
                                            </xsl:element>
                                        </xsl:if>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:element name="table">
                                    <xsl:attribute name="border">0</xsl:attribute>
                                    <xsl:attribute name="cellpadding">0</xsl:attribute>
                                    <xsl:attribute name="cellspacing">0</xsl:attribute>
                                    <xsl:attribute name="width">800px</xsl:attribute>
                                    <xsl:element name="tr">
                                        <xsl:element name="td">
                                            <xsl:attribute name="width">75px</xsl:attribute>
                                            <xsl:attribute name="valign">top</xsl:attribute>
                                            <xsl:text> </xsl:text>
                                        </xsl:element>
                                        <xsl:element name="td">
                                            <xsl:attribute name="width">20px</xsl:attribute>
                                            <xsl:attribute name="valign">top</xsl:attribute>
                                            <xsl:attribute name="text-align">right</xsl:attribute>
                                            <xsl:if test="contains(attribute::rend, 'conline')">
                                                <xsl:choose>
                                                    <xsl:when test="contains(attribute::rend, 'conline_h')">
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
                                                            <xsl:otherwise/>
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
                                                            <xsl:otherwise/>
                                                        </xsl:choose>
                                                    </xsl:otherwise>
                                                </xsl:choose>
                                            </xsl:if>
                                            <xsl:text> </xsl:text>
                                        </xsl:element>
                                        <xsl:element name="td">
                                            <xsl:attribute name="width">5px</xsl:attribute>
                                            <xsl:text> </xsl:text>
                                        </xsl:element>
                                        <xsl:element name="td">
                                            <xsl:attribute name="style">text-align: left;</xsl:attribute>
                                            <xsl:attribute name="valign">top</xsl:attribute>
                                            <xsl:attribute name="width">700px</xsl:attribute>
                                            <xsl:choose>
                                                <xsl:when test="$visning='norm'">
                                                    <xsl:element name="DIV">
                                                        <xsl:attribute name="style">margin-bottom: 10px; width:
                                                            700px;</xsl:attribute>
                                                        <xsl:if test="not(contains(attribute::rend, 'conline'))">
                                                            <xsl:element name="BR"/>
                                                        </xsl:if>
                                                        <xsl:choose>
                                                            <xsl:when test="attribute::xml:id">
                                                                <xsl:element name="SPAN">
                                                                    <xsl:attribute name="onMouseover">
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
                                                                    </xsl:attribute>
                                                                    <xsl:attribute name="onMouseout">hideddrivetip()</xsl:attribute>
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
                                                        <xsl:attribute name="style">margin-bottom: 10px; width:
                                                            700px;</xsl:attribute>
                                                        <xsl:element name="BR"/>
                                                        <xsl:choose>
                                                            <xsl:when test="attribute::xml:id">
                                                                <xsl:element name="SPAN">
                                                                    <xsl:attribute name="onMouseover">
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
                                                                    </xsl:attribute>
                                                                    <xsl:attribute name="onMouseout">hideddrivetip()</xsl:attribute>
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
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:element>
                                    </xsl:element>
                                </xsl:element>
                            </xsl:otherwise>
                        </xsl:choose>
                        
                        
                        <!-- Removed. Only relevant if you have nesting paragraphps.
                            <xsl:if test="descendant::p">
                            <xsl:apply-templates select="descendant::p[not(parent::note)]" mode="added"/>
                            </xsl:if>-->
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="tei:list" mode="tooltip">
        <xsl:apply-templates mode="tooltip"/>
    </xsl:template>

    <!-- Removed. AP says this is redundant now
    <xsl:template match="tei:choice">
        <xsl:choose>
            <xsl:when test="attribute::type='pagen'">
                <xsl:choose>
                    <xsl:when test="contains($visning, 'dipl')">
                        <xsl:apply-templates select="child::tei:orig"/>
                    </xsl:when>
                    <xsl:when test="contains($visning, 'study')">
                        <xsl:apply-templates select="child::tei:orig"/>
                    </xsl:when>
                    <xsl:when test="contains($visning, 'norm')">
                        <xsl:apply-templates select="child::tei:orig"/>
                    </xsl:when>
                    <xsl:otherwise></xsl:otherwise>
                </xsl:choose>                
            </xsl:when>
            <xsl:when test="attribute::type='trs'">
                <xsl:choose>
                    <xsl:when test="contains($visning, 'dipl')">
                        <xsl:apply-templates select="child::tei:orig"/>
                    </xsl:when>
                    <xsl:when test="contains($visning, 'study')">
                        <xsl:element name="SPAN">
                            <xsl:attribute name="style">color: #FF0000;</xsl:attribute>
                            <xsl:apply-templates select="child::tei:reg"/>
                        </xsl:element>
                    </xsl:when>
                    <xsl:when test="contains($visning, 'norm')">
                        <xsl:element name="SPAN">
                            <xsl:attribute name="style">color: #FF0000;</xsl:attribute>
                            <xsl:apply-templates select="child::tei:reg"/>
                        </xsl:element>
                    </xsl:when>
                    <xsl:otherwise></xsl:otherwise>
                </xsl:choose>                
            </xsl:when>
            <xsl:when test="attribute::type='trsn'">
                <xsl:choose>
                    <xsl:when test="contains($visning, 'dipl')">
                        <xsl:apply-templates select="child::tei:orig"/>
                    </xsl:when>
                    <xsl:when test="contains($visning, 'study')">
                        <xsl:element name="SPAN">
                            <xsl:attribute name="style">color: #FF0000;</xsl:attribute>
                            <xsl:apply-templates select="child::tei:reg"/>
                        </xsl:element>
                    </xsl:when>
                    <xsl:when test="contains($visning, 'norm')">
                        <xsl:element name="SPAN">
                            <xsl:apply-templates select="child::tei:reg"/>
                        </xsl:element>
                    </xsl:when>
                    <xsl:otherwise></xsl:otherwise>
                </xsl:choose>                
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="tei:choice" mode="pagination">
        <xsl:choose>
            <xsl:when test="contains($visning, 'dipl')">
                <xsl:element name="SPAN">
                    <xsl:attribute name="style">color: #FF0000;</xsl:attribute>
                <xsl:apply-templates select="child::tei:reg"/>
                </xsl:element>
            </xsl:when>
            <xsl:when test="contains($visning, 'study')">
                <xsl:element name="SPAN">
                    <xsl:attribute name="style">color: #FF0000;</xsl:attribute>
                    <xsl:apply-templates select="child::tei:reg"/>
                </xsl:element>
            </xsl:when>
            <xsl:when test="contains($visning, 'norm')">
                <xsl:element name="SPAN">
                    <xsl:attribute name="style">color: #FF0000;</xsl:attribute>
                    <xsl:apply-templates select="child::tei:reg"/>
                </xsl:element>
            </xsl:when>
            <xsl:otherwise></xsl:otherwise>
        </xsl:choose>
        </xsl:template>-->

    <xsl:template match="tei:hi">
        <xsl:choose>
            <xsl:when test="attribute::rend='indl'"/>
            <xsl:when test="attribute::rend='literal_'"/>
            <xsl:when test="attribute::rend='literal_el'"/>
            <xsl:when test="attribute::rend='nr_h'"/>
            <xsl:when test="attribute::rend='nl_h'"/>
            <xsl:when test="attribute::rend='bl'"/>
            <xsl:when test="attribute::rend='subhead_'"/>
            <xsl:when test="attribute::rend='subhead_el'"/>
            <xsl:when test="attribute::rend='table_'"/>
            <xsl:when test="attribute::rend='table_el'"/>
            <xsl:otherwise>
                <xsl:apply-templates/>
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

    <xsl:template match="tei:seg">
        <xsl:choose>
            <xsl:when test="contains(attribute::type, 'wabmarks')"/>
            <xsl:when test="attribute::type='secmr_h'"/>
            <xsl:when test="attribute::type='secml_h'"/>
            <xsl:when test="attribute::type='nm_h'"/>
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
            <xsl:when test="attribute::type='subhead'">
                <xsl:choose>
                    <!-- added by ap: begin-->
                    <xsl:when test="contains($visning, 'dipl')">
                        <xsl:element name="SPAN">
                            <xsl:attribute name="style">font-size: 200%</xsl:attribute>
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
            <xsl:when test="attribute::type='illspace'">
                <xsl:call-template name="spaces">
                    <xsl:with-param name="i" select="1"/>
                    <xsl:with-param name="max" select="substring-after(attribute::type, '_')"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="attribute::type='notation' and not(attribute::corresp)">
                <xsl:choose>
                    <xsl:when test="contains($seg-not, 'mark')">
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
            <xsl:when test="attribute::type='notation' and attribute::corresp">
                <xsl:choose>
                    <xsl:when test="contains($seg-not, 'mark')">
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
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="tei:add">
        <xsl:choose>
            <xsl:when test="attribute::rend='el'">
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
                <xsl:choose>
                    <xsl:when test="contains($typo, 'hide')"/>
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
                    <xsl:when test="contains($typo, 'hide')"/>
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
                                    <xsl:attribute name="style">vertical-align: super; font-size: 10pt; <!--color: #008000;--></xsl:attribute>
                                    <xsl:text>&#709;</xsl:text>
                                    <xsl:apply-templates/>
                                </xsl:element>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:when test="contains($visning, 'study')">
                        <xsl:choose>
                            <xsl:when test="contains($im, 'dipl')">
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">vertical-align: super; font-size:
                                        10pt; <!--color: #008000;--></xsl:attribute>
                                    <xsl:text>&#709;</xsl:text>
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
                                    <xsl:attribute name="style">vertical-align: super; font-size:
                                        10pt; <!--color: #008000;--></xsl:attribute>
                                    <xsl:text>&#709;</xsl:text>
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
                    <xsl:when test="contains($typo, 'hide')"/>
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
                                            <xsl:attribute name="style">vertical-align: super;
                                                font-size: 10pt; color: #0000FF;</xsl:attribute>
                                            <xsl:text>&#709;</xsl:text>
                                            <xsl:apply-templates/>
                                        </xsl:element>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:when>
                            <xsl:when test="contains($visning, 'study')">
                                <xsl:choose>
                                    <xsl:when test="contains($im, 'dipl')">
                                        <xsl:element name="SPAN">
                                            <xsl:attribute name="style">vertical-align: super;
                                                font-size: 10pt; color: #0000FF;</xsl:attribute>
                                            <xsl:text>&#709;</xsl:text>
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
                                            <xsl:attribute name="style">vertical-align: super;
                                                font-size: 10pt; color: #0000FF;</xsl:attribute>
                                            <xsl:text>&#709;</xsl:text>
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
                                    <xsl:attribute name="style">vertical-align: super; font-size:
                                        10pt; <!--color: #008000;--></xsl:attribute>
                                    <xsl:text>&#711;</xsl:text>
                                    <xsl:apply-templates/>
                                </xsl:element>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:when test="contains($visning, 'study')">
                        <xsl:choose>
                            <xsl:when test="contains($im, 'dipl')">
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">vertical-align: super; font-size:
                                        10pt; <!--color: #008000;--></xsl:attribute>
                                    <xsl:text>&#711;</xsl:text>
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
                                    <xsl:attribute name="style">vertical-align: super; font-size:
                                        10pt; <!--color: #008000;--></xsl:attribute>
                                    <xsl:text>&#711;</xsl:text>
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
            <xsl:when test="attribute::rend='imw_h'">
                <xsl:choose>
                    <xsl:when test="contains($typo, 'hide')"/>
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
                                            <xsl:attribute name="style">vertical-align: super;
                                                font-size: 10pt; color: #0000FF;</xsl:attribute>
                                            <xsl:text>&#711;</xsl:text>
                                            <xsl:apply-templates/>
                                        </xsl:element>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:when>
                            <xsl:when test="contains($visning, 'study')">
                                <xsl:choose>
                                    <xsl:when test="contains($im, 'dipl')">
                                        <xsl:element name="SPAN">
                                            <xsl:attribute name="style">vertical-align: super;
                                                font-size: 10pt; color: #0000FF;</xsl:attribute>
                                            <xsl:text>&#711;</xsl:text>
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
                                            <xsl:attribute name="style">vertical-align: super;
                                                font-size: 10pt; color: #0000FF;</xsl:attribute>
                                            <xsl:text>&#711;</xsl:text>
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
                    <xsl:when test="contains($typo, 'hide')"/>
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
                                            <xsl:attribute name="style">vertical-align: super;
                                                font-size: 10pt; color: #888BBD;</xsl:attribute>
                                            <xsl:text>&#709;</xsl:text>
                                            <xsl:apply-templates/>
                                        </xsl:element>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:when>
                            <xsl:when test="contains($visning, 'study')">
                                <xsl:choose>
                                    <xsl:when test="contains($im, 'dipl')">
                                        <xsl:element name="SPAN">
                                            <xsl:attribute name="style">vertical-align: super;
                                                font-size: 10pt; color: #888BBD;</xsl:attribute>
                                            <xsl:text>&#709;</xsl:text>
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
                                    <xsl:attribute name="style"><!--color: #008000;-->
                                        vertical-align: super; font-size: 10pt;</xsl:attribute>
                                    <xsl:apply-templates/>
                                </xsl:element>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:when test="contains($visning, 'study')">
                        <xsl:choose>
                            <xsl:when test="contains($i, 'dipl')">
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style"><!--color: #008000;-->
                                        vertical-align: super; font-size: 10pt;</xsl:attribute>
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
                                    <xsl:attribute name="style"><!--color: #008000;-->
                                        vertical-align: super; font-size: 10pt;</xsl:attribute>
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
                    <xsl:when test="contains($typo, 'hide')"/>
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
                                            <xsl:attribute name="style">color: #0000FF;
                                                vertical-align: super; font-size: 10pt;</xsl:attribute>
                                            <xsl:apply-templates/>
                                        </xsl:element>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:when>
                            <xsl:when test="contains($visning, 'study')">
                                <xsl:choose>
                                    <xsl:when test="contains($i, 'dipl')">
                                        <xsl:element name="SPAN">
                                            <xsl:attribute name="style">color: #0000FF;
                                                vertical-align: super; font-size: 10pt;</xsl:attribute>
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
            <xsl:when test="attribute::rend='H'">
                <xsl:choose>
                    <xsl:when test="contains($typo, 'hide')"/>
                    <xsl:otherwise>
                        <xsl:choose>
                            <xsl:when test="contains($visning, 'dipl')">
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">color: #0000FF; vertical-align:
                                        super; font-size: 10pt;</xsl:attribute>
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
            <xsl:when test="attribute::rend='ib'">
                <xsl:choose>
                    <xsl:when test="contains($visning, 'dipl')">
                        <xsl:element name="SPAN">
                            <xsl:attribute name="style"><!--color: #008000;--> vertical-align: sub;
                                font-size: 10pt;</xsl:attribute>
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
                    <xsl:when test="contains($typo, 'hide')"/>
                    <xsl:otherwise>
                        <xsl:choose>
                            <xsl:when test="contains($visning, 'dipl')">
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">color: #0000FF; vertical-align: sub;
                                        font-size: 10pt;</xsl:attribute>
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
            <xsl:when test="attribute::rend='ilm'">
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
                    <xsl:when test="contains($typo, 'hide')"/>
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
            <xsl:when test="attribute::rend='irm'">
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
            <xsl:when test="attribute::rend='irm_h'">
                <xsl:choose>
                    <xsl:when test="contains($typo, 'hide')"/>
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
            <xsl:when test="attribute::rend='ilom'">
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
                    <xsl:when test="contains($typo, 'hide')"/>
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
                <xsl:choose>
                    <xsl:when test="contains($typo, 'hide')"/>
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
                    <xsl:when test="contains($typo, 'hide')"/>
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
                    <xsl:when test="contains($typo, 'hide')"/>
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
                    <xsl:attribute name="style">color: #FF0000;</xsl:attribute>
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>



    <xsl:template match="tei:app">
        <xsl:choose>
            <xsl:when test="attribute::type='em'">
                <xsl:choose>
                    <xsl:when test="contains($visning, 'dipl')">
                        <xsl:apply-templates select="child::tei:rdg[attribute::type='em1']"/>
                    </xsl:when>
                    <xsl:when test="contains($visning, 'study')">
                        <xsl:element name="SPAN">
                            <xsl:attribute name="style">color: #009900;</xsl:attribute>
                            <xsl:text>{</xsl:text>
                        </xsl:element>
                        <xsl:apply-templates select="child::tei:rdg[attribute::type='em2']"/>
                        <xsl:element name="SPAN">
                            <xsl:attribute name="style">color: #009900;</xsl:attribute>
                            <xsl:text>}</xsl:text>
                        </xsl:element>
                    </xsl:when>
                    <xsl:when test="contains($visning, 'norm')">
                        <xsl:apply-templates select="child::tei:rdg[attribute::type='em2']"/>
                    </xsl:when>
                    <xsl:otherwise/>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="attribute::type='dsf'">
                <xsl:choose>
                    <xsl:when test="contains($visning, 'dipl')">
                        <xsl:for-each select="child::tei:rdg">
                            <xsl:apply-templates/>
                        </xsl:for-each>
                    </xsl:when>
                    <xsl:when test="contains($visning, 'study')">
                        <xsl:element name="SPAN">
                            <xsl:attribute name="style">color: #0000FF;</xsl:attribute>
                            <xsl:text>[</xsl:text>
                        </xsl:element>
                        <xsl:apply-templates select="child::tei:rdg[attribute::type='alt1']"/>
                        <xsl:element name="SPAN">
                            <xsl:attribute name="style">color: #0000FF;</xsl:attribute>
                            <xsl:text>|</xsl:text>
                        </xsl:element>
                        <xsl:apply-templates select="child::tei:rdg[attribute::type='alt2']"/>
                        <xsl:element name="SPAN">
                            <xsl:attribute name="style">color: #0000FF;</xsl:attribute>
                            <xsl:text>]</xsl:text>
                        </xsl:element>
                    </xsl:when>
                    <xsl:when test="contains($visning, 'norm')">
                        <xsl:apply-templates select="child::tei:rdg[attribute::type='alt1']"/>
                    </xsl:when>
                    <xsl:otherwise/>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="attribute::type='dsf_h'">
                <xsl:choose>
                    <xsl:when test="contains($typo, 'hide')"/>
                    <xsl:otherwise>
                        <xsl:choose>
                            <xsl:when test="contains($visning, 'dipl')">
                                <xsl:for-each select="child::tei:rdg">
                                    <xsl:apply-templates/>
                                </xsl:for-each>
                            </xsl:when>
                            <xsl:when test="contains($visning, 'study')">
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">color: #0000FF;</xsl:attribute>
                                    <xsl:text>[</xsl:text>
                                </xsl:element>
                                <xsl:apply-templates select="child::tei:rdg[attribute::type='alt1']"/>
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">color: #0000FF;</xsl:attribute>
                                    <xsl:text>|</xsl:text>
                                </xsl:element>
                                <xsl:apply-templates select="child::tei:rdg[attribute::type='alt2']"/>
                                <xsl:element name="SUP">
                                    <!-- Sjekk visningen (VO) -->
                                    <xsl:attribute name="style">color: #0000FF;</xsl:attribute>
                                    <xsl:text>h</xsl:text>
                                </xsl:element>
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">color: #0000FF;</xsl:attribute>
                                    <xsl:text>]</xsl:text>
                                </xsl:element>
                            </xsl:when>
                            <xsl:when test="contains($visning, 'norm')">
                                <xsl:apply-templates select="child::tei:rdg[attribute::type='alt1']"/>
                            </xsl:when>
                            <xsl:otherwise/>
                        </xsl:choose>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="attribute::type='dsl'">
                <xsl:choose>
                    <xsl:when test="contains($visning, 'dipl')">
                        <xsl:for-each select="child::tei:rdg">
                            <xsl:apply-templates/>
                        </xsl:for-each>
                    </xsl:when>
                    <xsl:when test="contains($visning, 'study')">
                        <xsl:element name="SPAN">
                            <xsl:attribute name="style">color: #0000FF;</xsl:attribute>
                            <xsl:text>[</xsl:text>
                        </xsl:element>
                        <xsl:apply-templates select="child::tei:rdg[attribute::type='alt1']"/>
                        <xsl:element name="SPAN">
                            <xsl:attribute name="style">color: #0000FF;</xsl:attribute>
                            <xsl:text>|</xsl:text>
                        </xsl:element>
                        <xsl:apply-templates select="child::tei:rdg[attribute::type='alt2']"/>
                        <xsl:element name="SPAN">
                            <xsl:attribute name="style">color: #0000FF;</xsl:attribute>
                            <xsl:text>]</xsl:text>
                        </xsl:element>
                    </xsl:when>
                    <xsl:when test="contains($visning, 'norm')">
                        <xsl:apply-templates select="child::tei:rdg[attribute::type='alt2']"/>
                    </xsl:when>
                    <xsl:otherwise/>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="attribute::type='dsl_h'">
                <xsl:choose>
                    <xsl:when test="contains($typo, 'hide')"/>
                    <xsl:otherwise>
                        <xsl:choose>
                            <xsl:when test="contains($visning, 'dipl')">
                                <xsl:for-each select="child::tei:rdg">
                                    <xsl:apply-templates/>
                                </xsl:for-each>
                            </xsl:when>
                            <xsl:when test="contains($visning, 'study')">
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">color: #0000FF;</xsl:attribute>
                                    <xsl:text>[</xsl:text>
                                </xsl:element>
                                <xsl:apply-templates select="child::tei:rdg[attribute::type='alt1']"/>
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">color: #0000FF;</xsl:attribute>
                                    <xsl:text>|</xsl:text>
                                </xsl:element>
                                <xsl:apply-templates select="child::tei:rdg[attribute::type='alt2']"/>
                                <xsl:element name="SUP">
                                    <!-- Sjekk visningen (VO) -->
                                    <xsl:attribute name="style">color: #0000FF;</xsl:attribute>
                                    <xsl:text>h</xsl:text>
                                </xsl:element>
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">color: #0000FF;</xsl:attribute>
                                    <xsl:text>]</xsl:text>
                                </xsl:element>
                            </xsl:when>
                            <xsl:when test="contains($visning, 'norm')">
                                <xsl:apply-templates select="child::tei:rdg[attribute::type='alt2']"/>
                            </xsl:when>
                            <xsl:otherwise/>
                        </xsl:choose>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="attribute::type='dsl-em'">
                <xsl:choose>
                    <xsl:when test="contains($visning, 'dipl')">
                        <xsl:apply-templates select="child::tei:rdg[attribute::type='em1']"/>
                    </xsl:when>
                    <xsl:when test="contains($visning, 'study')">
                        <xsl:apply-templates select="child::tei:rdg[attribute::type='em2']"/>
                    </xsl:when>
                    <xsl:when test="contains($visning, 'norm')">
                        <xsl:apply-templates select="child::tei:rdg[attribute::type='em2']"/>
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
                        <xsl:apply-templates select="child::tei:rdg[attribute::type='o1']"/>
                        <xsl:element name="SPAN">
                            <xsl:attribute name="style">color: brown;</xsl:attribute>
                            <xsl:text>|</xsl:text>
                        </xsl:element>
                        <xsl:apply-templates select="child::tei:rdg[attribute::type='o2']"/>
                        <xsl:element name="SPAN">
                            <xsl:attribute name="style">color: brown;</xsl:attribute>
                            <xsl:text>]</xsl:text>
                        </xsl:element>
                    </xsl:when>
                    <xsl:when test="contains($visning, 'study')">
                        <xsl:apply-templates select="child::tei:rdg[attribute::type='o2']"/>
                    </xsl:when>
                    <xsl:when test="contains($visning, 'norm')">
                        <xsl:apply-templates select="child::tei:rdg[attribute::type='o2']"/>
                    </xsl:when>
                    <xsl:otherwise/>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="attribute::type='on'">
                <xsl:choose>
                    <xsl:when test="contains($visning, 'dipl')">
                        <xsl:element name="SPAN">
                            <xsl:attribute name="style">color: brown;</xsl:attribute>
                            <xsl:text>[</xsl:text>
                        </xsl:element>
                        <xsl:apply-templates select="child::tei:rdg[attribute::type='on1']"/>
                        <xsl:element name="SPAN">
                            <xsl:attribute name="style">color: brown;</xsl:attribute>
                            <xsl:text>|</xsl:text>
                        </xsl:element>
                        <xsl:apply-templates select="child::tei:rdg[attribute::type='on2']"/>
                        <xsl:element name="SPAN">
                            <xsl:attribute name="style">color: brown;</xsl:attribute>
                            <xsl:text>]</xsl:text>
                        </xsl:element>
                    </xsl:when>
                    <xsl:when test="contains($visning, 'study')">
                        <xsl:apply-templates select="child::tei:rdg[attribute::type='on2']"/>
                    </xsl:when>
                    <xsl:when test="contains($visning, 'norm')">
                        <xsl:apply-templates select="child::tei:rdg[attribute::type='on2']"/>
                    </xsl:when>
                    <xsl:otherwise/>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="attribute::type='on_h'">
                <xsl:choose>
                    <xsl:when test="contains($typo, 'hide')"/>
                    <xsl:otherwise>
                        <xsl:choose>
                            <xsl:when test="contains($visning, 'dipl')">
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">color: brown;</xsl:attribute>
                                    <xsl:text>[</xsl:text>
                                </xsl:element>
                                <xsl:apply-templates select="child::tei:rdg[attribute::type='on1_h']"/>
                                <!-- Alois vurder om det ikke skal hete on1_h og on2_h -->
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">color: brown;</xsl:attribute>
                                    <xsl:text>|</xsl:text>
                                </xsl:element>
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">color: #0000FF;</xsl:attribute>
                                    <xsl:apply-templates select="child::tei:rdg[attribute::type='on2_h']"/>
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
                                <xsl:apply-templates select="child::tei:rdg[attribute::type='on2']"/>
                            </xsl:when>
                            <xsl:when test="contains($visning, 'norm')">
                                <xsl:apply-templates select="child::tei:rdg[attribute::type='on2']"/>
                            </xsl:when>
                            <xsl:otherwise/>
                        </xsl:choose>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="attribute::type='co'">
                <xsl:choose>
                    <xsl:when test="contains($visning, 'dipl')">
                        <xsl:element name="SPAN">
                            <xsl:attribute name="style">color: #0000FF;</xsl:attribute>
                            <xsl:text>[</xsl:text>
                        </xsl:element>
                        <xsl:apply-templates select="child::tei:rdg[attribute::type='alt1']"/>
                        <xsl:element name="SPAN">
                            <xsl:attribute name="style">color: #0000FF; font-size: 75%;</xsl:attribute>
                            <xsl:text>&#8596;</xsl:text>
                        </xsl:element>
                        <xsl:apply-templates select="child::tei:rdg[attribute::type='alt2']"/>
                        <xsl:element name="SPAN">
                            <xsl:attribute name="style">color: #0000FF;</xsl:attribute>
                            <xsl:text>]</xsl:text>
                        </xsl:element>
                    </xsl:when>
                    <xsl:when test="contains($visning, 'study')">
                        <xsl:element name="SPAN">
                            <xsl:attribute name="style">color: #0000FF;</xsl:attribute>
                            <xsl:text>[</xsl:text>
                        </xsl:element>
                        <xsl:apply-templates select="child::tei:rdg[attribute::type='alt1']"/>
                        <xsl:element name="SPAN">
                            <xsl:attribute name="style">color: #0000FF; font-size: 75%;</xsl:attribute>
                            <xsl:text>&#8596;</xsl:text>
                        </xsl:element>
                        <xsl:apply-templates select="child::tei:rdg[attribute::type='alt2']"/>
                        <xsl:element name="SPAN">
                            <xsl:attribute name="style">color: #0000FF;</xsl:attribute>
                            <xsl:text>]</xsl:text>
                        </xsl:element>
                    </xsl:when>
                    <xsl:when test="contains($visning, 'norm')">
                        <xsl:apply-templates select="child::tei:rdg[attribute::type='alt2']"/>
                    </xsl:when>
                    <xsl:otherwise/>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="attribute::type='s'">
                <xsl:choose>
                    <xsl:when test="contains($visning, 'dipl')">
                        <xsl:for-each select="child::tei:rdg">
                            <xsl:apply-templates/>
                        </xsl:for-each>
                    </xsl:when>
                    <xsl:when test="contains($visning, 'study')">
                        <xsl:element name="SPAN">
                            <xsl:attribute name="style">color: #0000FF;</xsl:attribute>
                            <xsl:text>[</xsl:text>
                        </xsl:element>
                        <xsl:for-each select="child::tei:rdg">
                            <xsl:apply-templates/>
                            <xsl:if test="following-sibling::tei:rdg">
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">color: #0000FF;</xsl:attribute>
                                    <xsl:text>|</xsl:text>
                                </xsl:element>
                            </xsl:if>
                        </xsl:for-each>
                        <xsl:element name="SPAN">
                            <xsl:attribute name="style">color: #0000FF;</xsl:attribute>
                            <xsl:text>]</xsl:text>
                        </xsl:element>
                    </xsl:when>
                    <xsl:when test="contains($visning, 'norm')">
                        <xsl:element name="SPAN">
                            <xsl:attribute name="style">color: #0000FF;</xsl:attribute>
                            <xsl:text>[</xsl:text>
                        </xsl:element>
                        <xsl:for-each select="child::tei:rdg">
                            <xsl:apply-templates/>
                            <xsl:if test="following-sibling::tei:rdg">
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">color: #0000FF;</xsl:attribute>
                                    <xsl:text>|</xsl:text>
                                </xsl:element>
                            </xsl:if>
                        </xsl:for-each>
                        <xsl:element name="SPAN">
                            <xsl:attribute name="style">color: #0000FF;</xsl:attribute>
                            <xsl:text>]</xsl:text>
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

    <xsl:template match="tei:rdg">
        <xsl:choose>
            <xsl:when test="attribute::type='o1'">
                <xsl:element name="SPAN">
                    <xsl:attribute name="style">text-decoration: line-through;</xsl:attribute>
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
                    <xsl:when test="contains($typo, 'hide')"/>
                    <xsl:otherwise>
                        <xsl:element name="SPAN">
                            <xsl:apply-templates/>
                        </xsl:element>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="attribute::type='on2_h'">
                <xsl:choose>
                    <xsl:when test="contains($typo, 'hide')"/>
                    <xsl:otherwise>
                        <xsl:element name="SPAN">
                            <xsl:apply-templates/>
                        </xsl:element>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="attribute::type='alt1' and parent::tei:app[attribute::type='dsl']">
                <xsl:element name="SPAN">
                    <xsl:attribute name="style">text-decoration: line-through;</xsl:attribute>
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:when>
            <xsl:when test="attribute::type='alt1' and parent::tei:app[attribute::type='co']">
                <xsl:element name="SPAN">
                    <xsl:attribute name="style">text-decoration: line-through;</xsl:attribute>
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:when>
            <xsl:when test="attribute::type='alt2' and parent::tei:app[attribute::type='dsf']">
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

    <xsl:template match="tei:del">
        <xsl:choose>
            <xsl:when test="attribute::type='d'">
                <xsl:choose>
                    <xsl:when test="contains($visning, 'dipl')">
                        <xsl:choose>
                            <xsl:when test="contains($d, 'study')">
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">color: #000000; text-decoration: line-through;</xsl:attribute>
                                    <xsl:apply-templates/>
                                </xsl:element>
                            </xsl:when>
                            <xsl:when test="contains($d, 'norm')"/>
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
                            <xsl:when test="contains($d, 'norm')"/>
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
            <xsl:when test="attribute::type='d_ch'">
                <xsl:choose>
                    <xsl:when test="contains($typo, 'hide')">
                        <xsl:choose>
                            <xsl:when test="contains($visning, 'dipl')">
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">color: #000000; text-decoration:
                                        line-through;</xsl:attribute>
                                    <xsl:apply-templates/>
                                </xsl:element>
                            </xsl:when>
                            <xsl:when test="contains($visning, 'study')">
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">color: #000000; text-decoration:
                                        line-through;</xsl:attribute>
                                    <xsl:apply-templates/>
                                </xsl:element>
                            </xsl:when>
                            <xsl:when test="contains($visning, 'norm')"/>
                            <xsl:otherwise/>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:choose>
                            <xsl:when test="contains($visning, 'dipl')">
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">text-decoration: line-through;
                                        color: #0000FF;</xsl:attribute>
                                    <xsl:element name="SPAN">
                                        <xsl:attribute name="style">color: #000000;</xsl:attribute>
                                        <xsl:apply-templates/>
                                    </xsl:element>
                                </xsl:element>
                                <xsl:element name="SUP">
                                    <xsl:attribute name="style">color: #0000FF;</xsl:attribute>
                                    <xsl:text>ch</xsl:text>
                                </xsl:element>
                            </xsl:when>
                            <xsl:when test="contains($visning, 'study')">
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">text-decoration: line-through;
                                        color: #0000FF;</xsl:attribute>
                                    <xsl:element name="SPAN">
                                        <xsl:attribute name="style">color: #000000;</xsl:attribute>
                                        <xsl:apply-templates/>
                                    </xsl:element>
                                </xsl:element>
                                <xsl:element name="SUP">
                                    <xsl:attribute name="style">color: #0000FF;</xsl:attribute>
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
                <xsl:choose>
                    <xsl:when test="contains($typo, 'hide')">
                        <xsl:choose>
                            <xsl:when test="contains($visning, 'dipl')">
                                <xsl:apply-templates/>
                            </xsl:when>
                            <xsl:when test="contains($visning, 'study')">
                                <xsl:apply-templates/>
                            </xsl:when>
                            <xsl:when test="contains($visning, 'norm')"/>
                            <xsl:otherwise/>
                        </xsl:choose>
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
                                    <xsl:when test="contains($d, 'norm')"/>
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
                                    <xsl:when test="contains($d, 'dipl')">
                                        <xsl:element name="SPAN">
                                            <xsl:attribute name="style">text-decoration: line-through; color: #0000FF;</xsl:attribute>
                                            <xsl:element name="SPAN">
                                                <xsl:attribute name="style">color: #000000;</xsl:attribute>
                                                <xsl:apply-templates/>
                                            </xsl:element>
                                        </xsl:element>
                                    </xsl:when>
                                    <xsl:when test="contains($d, 'norm')"/>
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
            <xsl:when test="attribute::type='d_h_ch'">
                <xsl:choose>
                    <xsl:when test="contains($typo, 'hide')">
                        <xsl:choose>
                            <xsl:when test="contains($visning, 'dipl')">
                                <xsl:apply-templates/>
                            </xsl:when>
                            <xsl:when test="contains($visning, 'study')">
                                <xsl:apply-templates/>
                            </xsl:when>
                            <xsl:when test="contains($visning, 'norm')"/>
                            <xsl:otherwise/>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:choose>
                            <xsl:when test="contains($visning, 'dipl')">
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">text-decoration: line-through;
                                        color: #0000FF;</xsl:attribute>
                                    <xsl:element name="SPAN">
                                        <xsl:attribute name="style">color: #000000;</xsl:attribute>
                                        <xsl:apply-templates/>
                                    </xsl:element>
                                </xsl:element>
                                <xsl:element name="SUP">
                                    <xsl:attribute name="style">color: #0000FF;</xsl:attribute>
                                    <xsl:text>ch</xsl:text>
                                </xsl:element>
                            </xsl:when>
                            <xsl:when test="contains($visning, 'study')">
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">text-decoration: line-through;
                                        color: #0000FF;</xsl:attribute>
                                    <xsl:element name="SPAN">
                                        <xsl:attribute name="style">color: #000000;</xsl:attribute>
                                        <xsl:apply-templates/>
                                    </xsl:element>
                                </xsl:element>
                                <xsl:element name="SUP">
                                    <xsl:attribute name="style">color: #0000FF;</xsl:attribute>
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
            <xsl:when test="attribute::type='dn_h'">
                <xsl:choose>
                    <xsl:when test="contains($typo, 'hide')">
                        <xsl:choose>
                            <xsl:when test="contains($visning, 'dipl')">
                                <xsl:apply-templates/>
                            </xsl:when>
                            <xsl:when test="contains($visning, 'study')"> </xsl:when>
                            <xsl:when test="contains($visning, 'norm')"> </xsl:when>
                            <xsl:otherwise/>
                        </xsl:choose>
                    </xsl:when>
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
            <xsl:when test="attribute::type='dnpc_h'">
                <xsl:choose>
                    <xsl:when test="contains($typo, 'hide')">
                        <xsl:choose>
                            <xsl:when test="contains($visning, 'dipl')">
                                <xsl:apply-templates/>
                            </xsl:when>
                            <xsl:when test="contains($visning, 'study')"> </xsl:when>
                            <xsl:when test="contains($visning, 'norm')"> </xsl:when>
                            <xsl:otherwise/>
                        </xsl:choose>
                    </xsl:when>
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
                                    <xsl:attribute name="style">color: #000000; border-bottom-width: thin; border-bottom-color: #000000; border-bottom-style: dotted; text-decoration: line-through;</xsl:attribute>
                                    <xsl:apply-templates/>
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
                            </xsl:when>
                            <xsl:when test="contains($d_c, 'norm')"/>
                            <xsl:otherwise>
                                <xsl:apply-templates/>
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
                            </xsl:when>
                            <xsl:when test="contains($d_c, 'study')">
                                <xsl:apply-templates/>
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

    <xsl:template match="tei:corr">
        <xsl:choose>
            <xsl:when test="contains($typo, 'hide')">
                <xsl:choose>
                    <xsl:when test="attribute::type='npc'">
                        <xsl:apply-templates/>
                    </xsl:when>
                    <xsl:when test="attribute::type='npcn'">
                        <xsl:apply-templates/>
                    </xsl:when>
                    <xsl:when test="attribute::type='tra'"> </xsl:when>
                    <xsl:when test="attribute::type='tran'"> </xsl:when>
                    <xsl:when test="attribute::type='trs'">
                        <xsl:apply-templates select="child::tei:orig[attribute::type='trs1']"/>
                    </xsl:when>
                    <xsl:when test="attribute::type='trsn'">
                        <xsl:apply-templates select="child::tei:orig[attribute::type='trsn1']"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:apply-templates/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:choose>
                    <xsl:when test="attribute::type='npc'">
                        <xsl:choose>
                            <xsl:when test="contains($visning, 'dipl')">
                                <xsl:choose>
                                    <xsl:when test="contains($npc, 'study')">
                                        <xsl:element name="SPAN">
                                            <xsl:attribute name="style">color: #FF0000;</xsl:attribute>
                                            <xsl:text>&#8659;</xsl:text>
                                        </xsl:element>
                                    </xsl:when>
                                    <xsl:when test="contains($npc, 'norm')">
                                        <xsl:element name="SPAN">
                                            <xsl:attribute name="style">color: #FF0000;</xsl:attribute>
                                            <xsl:text>&#8659;</xsl:text>
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
                                            <xsl:text>&#8659;</xsl:text>
                                        </xsl:element>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:element name="SPAN">
                                            <xsl:attribute name="style">color: #FF0000;</xsl:attribute>
                                            <xsl:text>&#8659;</xsl:text>
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
                                            <xsl:text>&#8659;</xsl:text>
                                        </xsl:element>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:element name="SPAN">
                                            <xsl:attribute name="style">color: #FF0000;</xsl:attribute>
                                            <xsl:text>&#8659;</xsl:text>
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
                                            <xsl:text>&#8659;</xsl:text>
                                        </xsl:element>
                                    </xsl:when>
                                    <xsl:when test="contains($npcn, 'norm')">
                                        <xsl:element name="SPAN">
                                            <!--<xsl:attribute name="style">color: #FF0000;</xsl:attribute>
                                                <xsl:text>&#x21D3;</xsl:text>-->
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
                                            <!--<xsl:attribute name="style">color: #FF0000;</xsl:attribute>
                                                <xsl:text>&#x21D3;</xsl:text>-->
                                        </xsl:element>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:element name="SPAN">
                                            <xsl:attribute name="style">color: #FF0000;</xsl:attribute>
                                            <xsl:text>&#8659;</xsl:text>
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
                                            <xsl:text>&#8659;</xsl:text>
                                        </xsl:element>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:element name="SPAN">
                                            <!--<xsl:attribute name="style">color: #FF0000;</xsl:attribute>
                                                <xsl:text>&#x21D3;</xsl:text>-->
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
                                            <!--<xsl:attribute name="style">color: #FF0000;</xsl:attribute>-->
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
                                            <!--<xsl:attribute name="style">color: #FF0000;</xsl:attribute>-->
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
                                            <!--<xsl:attribute name="style">color: #FF0000;</xsl:attribute>-->
                                            <xsl:apply-templates/>
                                        </xsl:element>
                                    </xsl:otherwise>
                                </xsl:choose>
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
                                    <!--<xsl:attribute name="style">color: #FF0000;</xsl:attribute>-->
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
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="tei:emph">
        <xsl:choose>
            <xsl:when test="attribute::rend='centered'">
                <xsl:element name="DIV">
                    <xsl:attribute name="align">center</xsl:attribute>
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:when>
            <xsl:when test="attribute::rend='us1'">
                <xsl:choose>
                    <xsl:when test="contains($visning, 'dipl')">
                        <xsl:element name="SPAN">
                            <xsl:attribute name="style">border-bottom-width: thin;
                                border-bottom-color: #000000; border-bottom-style: solid;</xsl:attribute>
                            <xsl:apply-templates/>
                        </xsl:element>
                    </xsl:when>
                    <xsl:when test="contains($visning, 'study')">
                        <xsl:element name="SPAN">
                            <xsl:attribute name="style">border-bottom-width: thin;
                                border-bottom-color: #000000; border-bottom-style: solid;</xsl:attribute>
                            <xsl:apply-templates/>
                        </xsl:element>
                    </xsl:when>
                    <xsl:when test="contains($visning, 'norm')">
                        <xsl:element name="SPAN">
                            <xsl:attribute name="style">border-bottom-width: thin;
                                border-bottom-color: #000000; border-bottom-style: solid;</xsl:attribute>
                            <xsl:apply-templates/>
                        </xsl:element>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:apply-templates/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="attribute::rend='us1_ch'">
                <xsl:choose>
                    <xsl:when test="contains($visning, 'dipl')">
                        <xsl:element name="SPAN">
                            <xsl:attribute name="style">border-bottom-width: thin;
                                border-bottom-color: #000000; border-bottom-style: solid;</xsl:attribute>
                            <xsl:apply-templates/>
                        </xsl:element>
                        <xsl:element name="SUP">
                            <xsl:attribute name="style">color: #0000FF;</xsl:attribute>
                            <xsl:text>ch</xsl:text>
                        </xsl:element>
                    </xsl:when>
                    <xsl:when test="contains($visning, 'study')">
                        <xsl:element name="SPAN">
                            <xsl:attribute name="style">border-bottom-width: thin;
                                border-bottom-color: #000000; border-bottom-style: solid;</xsl:attribute>
                            <xsl:apply-templates/>
                            <xsl:element name="SUP">
                                <xsl:attribute name="style">color: #0000FF;</xsl:attribute>
                                <xsl:text>ch</xsl:text>
                            </xsl:element>
                        </xsl:element>
                    </xsl:when>
                    <xsl:when test="contains($visning, 'norm')">
                        <xsl:element name="SPAN">
                            <xsl:attribute name="style">border-bottom-width: thin;
                                border-bottom-color: #000000; border-bottom-style: solid;</xsl:attribute>
                            <xsl:apply-templates/>
                        </xsl:element>
                        <xsl:element name="SUP">
                            <xsl:attribute name="style">color: #0000FF;</xsl:attribute>
                            <xsl:text>ch</xsl:text>
                        </xsl:element>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:apply-templates/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="attribute::rend='us1_h'">
                <xsl:choose>
                    <xsl:when test="contains($typo, 'hide')"/>
                    <xsl:otherwise>
                        <xsl:choose>
                            <xsl:when test="contains($visning, 'dipl')">
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">border-bottom-width: thin;
                                        border-bottom-color: #0000FF; border-bottom-style: solid;</xsl:attribute>
                                    <xsl:apply-templates/>
                                </xsl:element>
                            </xsl:when>
                            <xsl:when test="contains($visning, 'study')">
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">border-bottom-width: thin;
                                        border-bottom-color: #0000FF; border-bottom-style: solid;</xsl:attribute>
                                    <xsl:apply-templates/>
                                </xsl:element>
                            </xsl:when>
                            <xsl:when test="contains($visning, 'norm')">
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">border-bottom-width: thin;
                                        border-bottom-color: #0000FF; border-bottom-style: solid;</xsl:attribute>
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
                            <xsl:attribute name="style">border-bottom-width: medium;
                                border-bottom-color: #000000; border-bottom-style: double;</xsl:attribute>
                            <xsl:apply-templates/>
                        </xsl:element>
                    </xsl:when>
                    <xsl:when test="contains($visning, 'study')">
                        <xsl:element name="SPAN">
                            <xsl:attribute name="style">border-bottom-width: medium;
                                border-bottom-color: #000000; border-bottom-style: double;</xsl:attribute>
                            <xsl:apply-templates/>
                        </xsl:element>
                    </xsl:when>
                    <xsl:when test="contains($visning, 'norm')">
                        <xsl:element name="SPAN">
                            <xsl:attribute name="style">border-bottom-width: medium;
                                border-bottom-color: #000000; border-bottom-style: double;</xsl:attribute>
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
                    <xsl:when test="contains($typo, 'hide')"/>
                    <xsl:otherwise>
                        <xsl:choose>
                            <xsl:when test="contains($visning, 'dipl')">
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">border-bottom-width: thin;
                                        border-bottom-color: #0000FF; border-bottom-style: double;</xsl:attribute>
                                    <xsl:apply-templates/>
                                </xsl:element>
                            </xsl:when>
                            <xsl:when test="contains($visning, 'study')">
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">border-bottom-width: thin;
                                        border-bottom-color: #0000FF; border-bottom-style: double;</xsl:attribute>
                                    <xsl:apply-templates/>
                                </xsl:element>
                            </xsl:when>
                            <xsl:when test="contains($visning, 'norm')">
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">border-bottom-width: thin;
                                        border-bottom-color: #0000FF; border-bottom-style: double;</xsl:attribute>
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
                            <xsl:attribute name="style">border-bottom-width: thin;
                                border-bottom-color: #000000; border-bottom-style: dashed;</xsl:attribute>
                            <xsl:apply-templates/>
                        </xsl:element>
                    </xsl:when>
                    <xsl:when test="contains($visning, 'study')">
                        <xsl:element name="SPAN">
                            <xsl:attribute name="style">border-bottom-width: thin;
                                border-bottom-color: #000000; border-bottom-style: dashed;</xsl:attribute>
                            <xsl:apply-templates/>
                        </xsl:element>
                    </xsl:when>
                    <xsl:when test="contains($visning, 'norm')">
                        <xsl:element name="SPAN">
                            <xsl:attribute name="style">border-bottom-width: thin;
                                border-bottom-color: #000000; border-bottom-style: dashed;</xsl:attribute>
                            <xsl:apply-templates/>
                        </xsl:element>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:apply-templates/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="attribute::rend='uw1'">
                <xsl:choose>
                    <xsl:when test="contains($visning, 'dipl')">
                        <xsl:element name="SPAN">
                            <xsl:attribute name="style">border-bottom-width: thin;
                                border-bottom-color: #000000; border-bottom-style: dashed;</xsl:attribute>
                            <xsl:apply-templates/>
                        </xsl:element>
                    </xsl:when>
                    <xsl:when test="contains($visning, 'study')">
                        <xsl:element name="SPAN">
                            <xsl:attribute name="style">border-bottom-width: thin;
                                border-bottom-color: #000000; border-bottom-style: dashed;</xsl:attribute>
                            <xsl:apply-templates/>
                        </xsl:element>
                    </xsl:when>
                    <xsl:when test="contains($visning, 'norm')">
                        <xsl:element name="SPAN">
                            <xsl:attribute name="style">border-bottom-width: thin;
                                border-bottom-color: #000000; border-bottom-style: dashed;</xsl:attribute>
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
                    <xsl:when test="contains($typo, 'hide')"/>
                    <xsl:otherwise>
                        <xsl:choose>
                            <xsl:when test="contains($visning, 'dipl')">
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">border-bottom-width: thin;
                                        border-bottom-color: #0000FF; border-bottom-style: dashed;</xsl:attribute>
                                    <xsl:apply-templates/>
                                </xsl:element>
                            </xsl:when>
                            <xsl:when test="contains($visning, 'study')">
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">border-bottom-width: thin;
                                        border-bottom-color: #000000; border-bottom-style: dashed;</xsl:attribute>
                                    <xsl:apply-templates/>
                                </xsl:element>
                            </xsl:when>
                            <xsl:when test="contains($visning, 'norm')">
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">border-bottom-width: thin;
                                        border-bottom-color: #000000; border-bottom-style: dashed;</xsl:attribute>
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
                            <xsl:attribute name="style">border-bottom-width: thin;
                                border-bottom-color: #000000; border-bottom-style: dashed;</xsl:attribute>
                            <xsl:apply-templates/>
                        </xsl:element>
                    </xsl:when>
                    <xsl:when test="contains($visning, 'study')">
                        <xsl:element name="SPAN">
                            <xsl:attribute name="style">border-bottom-width: thin;
                                border-bottom-color: #000000; border-bottom-style: dashed;</xsl:attribute>
                            <xsl:apply-templates/>
                        </xsl:element>
                    </xsl:when>
                    <xsl:when test="contains($visning, 'norm')">
                        <xsl:element name="SPAN">
                            <xsl:attribute name="style">border-bottom-width: thin;
                                border-bottom-color: #000000; border-bottom-style: dashed;</xsl:attribute>
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
                    <xsl:when test="contains($typo, 'hide')"/>
                    <xsl:otherwise>
                        <xsl:choose>
                            <xsl:when test="contains($visning, 'dipl')">
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">border-bottom-width: thin;
                                        border-bottom-color: #0000FF; border-bottom-style: dashed;</xsl:attribute>
                                    <xsl:apply-templates/>
                                </xsl:element>
                            </xsl:when>
                            <xsl:when test="contains($visning, 'study')">
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">border-bottom-width: thin;
                                        border-bottom-color: #000000; border-bottom-style: dashed;</xsl:attribute>
                                    <xsl:apply-templates/>
                                </xsl:element>
                            </xsl:when>
                            <xsl:when test="contains($visning, 'norm')">
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">border-bottom-width: thin;
                                        border-bottom-color: #000000; border-bottom-style: dashed;</xsl:attribute>
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
            <xsl:when test="attribute::rend='space'">
                <xsl:text>  </xsl:text>
                <xsl:element name="SPAN">
                    <xsl:attribute name="style">letter-spacing: 1em;</xsl:attribute>
                    <xsl:apply-templates/>
                </xsl:element>
                <xsl:text>  </xsl:text>
            </xsl:when>
            <xsl:when test="attribute::rend='sup'">
                <xsl:element name="SUP">
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:when>
            <xsl:when test="attribute::rend='vdline'">
                <xsl:element name="SPAN">
                    <xsl:attribute name="style">background-color: #BEBEBE;</xsl:attribute>
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:when>
            <xsl:when test="attribute::rend='vdline_h'">
                <xsl:element name="SPAN">
                    <xsl:attribute name="style">background-color: #BEBEBE;</xsl:attribute>
                    <xsl:apply-templates/>
                </xsl:element>
                <xsl:element name="SUP">
                    <xsl:attribute name="style">color: #0000FF;</xsl:attribute>
                    <xsl:text>[h]</xsl:text>
                </xsl:element>
            </xsl:when>
            <xsl:when test="attribute::rend='clilm'">
                <xsl:element name="SPAN">
                    <xsl:attribute name="style">background-color: #BEBEBE;</xsl:attribute>
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:when>
            <xsl:when test="attribute::rend='clilm_h'">
                <xsl:choose>
                    <xsl:when test="contains($typo, 'hide')"/>
                    <xsl:otherwise>
                        <xsl:element name="SPAN">
                            <xsl:attribute name="style">background-color: #BEBEBE;</xsl:attribute>
                            <xsl:apply-templates/>
                        </xsl:element>
                        <xsl:element name="SUP">
                            <xsl:attribute name="style">color: #0000FF;</xsl:attribute>
                            <xsl:text>[h]</xsl:text>
                        </xsl:element>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="attribute::rend='clirm'">
                <xsl:element name="SPAN">
                    <xsl:attribute name="style">background-color: #BEBEBE;</xsl:attribute>
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:when>
            <xsl:when test="attribute::rend='clirm_h'">
                <xsl:choose>
                    <xsl:when test="contains($typo, 'hide')"/>
                    <xsl:otherwise>
                        <xsl:element name="SPAN">
                            <xsl:attribute name="style">background-color: #BEBEBE;</xsl:attribute>
                            <xsl:apply-templates/>
                        </xsl:element>
                        <xsl:element name="SUP">
                            <xsl:attribute name="style">color: #0000FF;</xsl:attribute>
                            <xsl:text>[h]</xsl:text>
                        </xsl:element>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="attribute::rend='slilm'">
                <xsl:element name="SPAN">
                    <xsl:attribute name="style">background-color: #BEBEBE;</xsl:attribute>
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:when>
            <xsl:when test="attribute::rend='slilm_h'">
                <xsl:choose>
                    <xsl:when test="contains($typo, 'hide')"/>
                    <xsl:otherwise>
                        <xsl:element name="SPAN">
                            <xsl:attribute name="style">background-color: #BEBEBE;</xsl:attribute>
                            <xsl:apply-templates/>
                        </xsl:element>
                        <xsl:element name="SUP">
                            <xsl:attribute name="style">color: #0000FF;</xsl:attribute>
                            <xsl:text>[h]</xsl:text>
                        </xsl:element>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="attribute::rend='slirm'">
                <xsl:element name="SPAN">
                    <xsl:attribute name="style">background-color: #BEBEBE;</xsl:attribute>
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:when>
            <xsl:when test="attribute::rend='slirm_h'">
                <xsl:choose>
                    <xsl:when test="contains($typo, 'hide')"/>
                    <xsl:otherwise>
                        <xsl:element name="SPAN">
                            <xsl:attribute name="style">background-color: #BEBEBE;</xsl:attribute>
                            <xsl:apply-templates/>
                        </xsl:element>
                        <xsl:element name="SUP">
                            <xsl:attribute name="style">color: #0000FF;</xsl:attribute>
                            <xsl:text>[h]</xsl:text>
                        </xsl:element>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="attribute::rend='wlilm'">
                <xsl:element name="SPAN">
                    <xsl:attribute name="style">background-color: #BEBEBE;</xsl:attribute>
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:when>
            <xsl:when test="attribute::rend='wlilm_h'">
                <xsl:choose>
                    <xsl:when test="contains($typo, 'hide')"/>
                    <xsl:otherwise>
                        <xsl:element name="SPAN">
                            <xsl:attribute name="style">background-color: #BEBEBE;</xsl:attribute>
                            <xsl:apply-templates/>
                        </xsl:element>
                        <xsl:element name="SUP">
                            <xsl:attribute name="style">color: #0000FF;</xsl:attribute>
                            <xsl:text>[h]</xsl:text>
                        </xsl:element>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="attribute::rend='wlirm'">
                <xsl:element name="SPAN">
                    <xsl:attribute name="style">background-color: #BEBEBE;</xsl:attribute>
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:when>
            <xsl:when test="attribute::rend='wlirm_h'">
                <xsl:choose>
                    <xsl:when test="contains($typo, 'hide')"/>
                    <xsl:otherwise>
                        <xsl:element name="SPAN">
                            <xsl:attribute name="style">background-color: #BEBEBE;</xsl:attribute>
                            <xsl:apply-templates/>
                        </xsl:element>
                        <xsl:element name="SUP">
                            <xsl:attribute name="style">color: #0000FF;</xsl:attribute>
                            <xsl:text>[h]</xsl:text>
                        </xsl:element>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:element name="SPAN">
                    <xsl:attribute name="style">color: #FF0000;</xsl:attribute>
                    <xsl:text>!! </xsl:text><xsl:value-of select="attribute::rend"/><xsl:text> </xsl:text>
                </xsl:element>
                <!--<xsl:text>&lt;emph rend=&quot;</xsl:text><xsl:value-of select="attribute::rend"/><xsl:text>&quot;&gt;</xsl:text>-->
                <xsl:apply-templates/>
                <!--<xsl:text>&lt;/emph&gt;</xsl:text>-->
                <xsl:element name="SPAN">
                    <xsl:attribute name="style">color: #FF0000;</xsl:attribute>
                    <xsl:text>!!</xsl:text>
                </xsl:element>
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
                            <xsl:text>¿</xsl:text>
                        </xsl:element>
                        <xsl:apply-templates/>
                        <xsl:element name="SPAN">
                            <xsl:attribute name="style">color: #FF0000;</xsl:attribute>
                            <xsl:text>¿</xsl:text>
                        </xsl:element>
                    </xsl:when>
                    <xsl:when test="contains($visning, 'study')">
                        <xsl:element name="SPAN">
                            <xsl:attribute name="style">color: #FF0000;</xsl:attribute>
                            <xsl:text>¿</xsl:text>
                        </xsl:element>
                        <xsl:apply-templates/>
                        <xsl:element name="SPAN">
                            <xsl:attribute name="style">color: #FF0000;</xsl:attribute>
                            <xsl:text>¿</xsl:text>
                        </xsl:element>
                    </xsl:when>
                    <xsl:when test="contains($visning, 'norm')">
                        <xsl:element name="SPAN">
                            <xsl:attribute name="style">color: #FF0000;</xsl:attribute>
                            <xsl:text>¿</xsl:text>
                        </xsl:element>
                        <xsl:apply-templates/>
                        <xsl:element name="SPAN">
                            <xsl:attribute name="style">color: #FF0000;</xsl:attribute>
                            <xsl:text>¿</xsl:text>
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

    <xsl:template match="tei:reloc">
        <xsl:choose>
            <xsl:when test="contains($visning, 'dipl')">
                <xsl:choose>
                    <xsl:when test="attribute::type='reloc1'">
                        <xsl:apply-templates/>
                    </xsl:when>
                    <xsl:otherwise/>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="contains($visning, 'study')">
                <xsl:choose>
                    <xsl:when test="attribute::type='reloc1'">
                    	<xsl:element name="SPAN">
                    		<xsl:attribute name="style">color: #FF0000;</xsl:attribute>
                    		<xsl:text>[</xsl:text>
                    	</xsl:element>
                    	<xsl:apply-templates/>
                    	<xsl:element name="SPAN">
                            <xsl:attribute name="style">color: #FF0000;</xsl:attribute>
                            <xsl:text> to:</xsl:text>
                        </xsl:element>
                        <xsl:element name="A">
                            <xsl:attribute name="name">
                                <xsl:value-of select="substring-before(attribute::n, '_')"/>
                            </xsl:attribute>
                        </xsl:element>
                        <xsl:element name="SPAN">
                            <xsl:attribute name="style">font-size: 10pt;</xsl:attribute>
                            <xsl:element name="A">
                                <xsl:attribute name="href">
                                    <xsl:text>#</xsl:text>
                                    <xsl:value-of select="substring-after(attribute::n, '_')"/>
                                </xsl:attribute>
                                <xsl:value-of select="substring-after(attribute::n, '_')"/>
                            </xsl:element>
                        </xsl:element>
                        <xsl:element name="SPAN">
                            <xsl:attribute name="style">color: #FF0000;</xsl:attribute>
                            <xsl:text>]</xsl:text>
                        </xsl:element>
                    </xsl:when>
                    <xsl:when test="attribute::type='reloc2'">
                        <xsl:element name="SPAN">
                            <xsl:attribute name="style">color: #FF0000;</xsl:attribute>
                            <xsl:text>[from:</xsl:text>
                        </xsl:element>
                        <xsl:element name="A">
                            <xsl:attribute name="name">
                                <xsl:value-of select="substring-after(attribute::n, '_')"/>
                            </xsl:attribute>
                        </xsl:element>
                        <xsl:element name="SPAN">
                            <xsl:attribute name="style">font-size: 10pt;</xsl:attribute>
                            <xsl:element name="A">
                                <xsl:attribute name="href">
                                    <xsl:text>#</xsl:text>
                                    <xsl:value-of select="substring-before(attribute::n, '_')"/>
                                </xsl:attribute>
                                <xsl:value-of select="substring-before(attribute::n, '_')"/>
                            </xsl:element>
                        </xsl:element>
                        <!--<xsl:apply-templates/>-->
                        <xsl:element name="SPAN">
                            <xsl:attribute name="style">color: #FF0000;</xsl:attribute>
                            <xsl:text>]</xsl:text>
                        </xsl:element>
                    </xsl:when>
                    <xsl:otherwise/>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="contains($visning, 'norm')">
                <xsl:choose>
                    <xsl:when test="attribute::type='reloc1'">
                    	<xsl:element name="SPAN">
                    		<xsl:attribute name="style">color: #FF0000;</xsl:attribute>
                    		<xsl:text>[</xsl:text>
                    	</xsl:element>
                    	<xsl:apply-templates/>
                    	<xsl:element name="SPAN">
                    		<xsl:attribute name="style">color: #FF0000;</xsl:attribute>
                    		<xsl:text> to:</xsl:text>
                    	</xsl:element>
                        <xsl:element name="A">
                            <xsl:attribute name="name">
                                <xsl:value-of select="substring-before(attribute::n, '_')"/>
                            </xsl:attribute>
                        </xsl:element>
                        <xsl:element name="SPAN">
                            <xsl:attribute name="style">font-size: 10pt;</xsl:attribute>
                            <xsl:element name="A">
                                <xsl:attribute name="href">
                                    <xsl:text>#</xsl:text>
                                    <xsl:value-of select="substring-after(attribute::n, '_')"/>
                                </xsl:attribute>
                                <xsl:value-of select="substring-after(attribute::n, '_')"/>
                            </xsl:element>
                        </xsl:element>
                        <xsl:element name="SPAN">
                            <xsl:attribute name="style">color: #FF0000;</xsl:attribute>
                            <xsl:text>]</xsl:text>
                        </xsl:element>
                    </xsl:when>
                    <xsl:when test="attribute::type='reloc2'">
                        <xsl:element name="SPAN">
                            <xsl:attribute name="style">color: #FF0000;</xsl:attribute>
                            <xsl:text>[from:</xsl:text>
                        </xsl:element>
                        <xsl:element name="A">
                            <xsl:attribute name="name">
                                <xsl:value-of select="substring-after(attribute::n, '_')"/>
                            </xsl:attribute>
                        </xsl:element>
                        <xsl:element name="SPAN">
                            <xsl:attribute name="style">font-size: 10pt;</xsl:attribute>
                            <xsl:element name="A">
                                <xsl:attribute name="href">
                                    <xsl:text>#</xsl:text>
                                    <xsl:value-of select="substring-before(attribute::n, '_')"/>
                                </xsl:attribute>
                                <xsl:value-of select="substring-before(attribute::n, '_')"/>
                            </xsl:element>
                        </xsl:element>
                        <!--<xsl:apply-templates/>-->
                        <xsl:element name="SPAN">
                            <xsl:attribute name="style">color: #FF0000;</xsl:attribute>
                            <xsl:text>]</xsl:text>
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

    <!-- lagt til av AP 26.10.-->

    <xsl:template match="tei:note">
        <xsl:choose>
            <xsl:when test="contains($visning, 'dipl')">
                <xsl:element name="SPAN">
                    <xsl:attribute name="style">color: #FF0000;</xsl:attribute>
                    <xsl:text>[Ed. comm.:</xsl:text>
                </xsl:element>
                <xsl:apply-templates/>
                <xsl:element name="SPAN">
                    <xsl:attribute name="style">color: #FF0000;</xsl:attribute>
                    <xsl:text>]</xsl:text>
                </xsl:element>
            </xsl:when>
            <xsl:when test="contains($visning, 'study')">
                <xsl:element name="SPAN">
                    <xsl:attribute name="style">color: #FF0000;</xsl:attribute>
                    <xsl:text>[Ed. comm.:</xsl:text>
                </xsl:element>
                <xsl:apply-templates/>
                <xsl:element name="SPAN">
                    <xsl:attribute name="style">color: #FF0000;</xsl:attribute>
                    <xsl:text>]</xsl:text>
                </xsl:element>
            </xsl:when>
            <xsl:when test="contains($visning, 'norm')">
                <xsl:element name="SPAN">
                    <xsl:attribute name="style">color: #FF0000;</xsl:attribute>
                    <xsl:text>[Ed. comm.:</xsl:text>
                </xsl:element>
                <xsl:apply-templates/>
                <xsl:element name="SPAN">
                    <xsl:attribute name="style">color: #FF0000;</xsl:attribute>
                    <xsl:text>]</xsl:text>
                </xsl:element>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>


    <!--    <xsl:template match="tei:lb[@rend='shyphen']"> 
        <xsl:choose>
            <xsl:when test="contains($visning, 'dipl')">&#x002D;<xsl:element name="BR"></xsl:element>
            </xsl:when>
            <xsl:when test="contains($visning, 'study')">&#x002D;<xsl:element name="BR"></xsl:element>
            </xsl:when>
            <xsl:otherwise></xsl:otherwise>
        </xsl:choose>
    </xsl:template>-->




</xsl:stylesheet>