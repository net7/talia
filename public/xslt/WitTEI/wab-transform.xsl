<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE TEI [
<!ENTITY nbsp "&#160;">
<!ENTITY emdash "&#2014;">
<!ENTITY dash  "&#x2014;">
]>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:tei="http://www.tei-c.org/ns/1.0" version="1.0">
    <xsl:output method="html" doctype-public="-//W3C/DTD XHTML 1.0 STRICT//EN"
    doctype-system="http:://www.w3.org/TR/xhtml1-strict.dtd" encoding="ISO-8859-1"/>
    
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
    <xsl:param name="visning" select="norm"/>
    <xsl:param name="typo"/>
    <xsl:param name="handwriting"/>
    <xsl:param name="interactive"/>
    <xsl:param name="prosjekt" select="discovery"/>
    
    <xsl:param name="el"/>
    <xsl:param name="i"/>
    <xsl:param name="im"/>
    <xsl:param name="our"/>
    <xsl:param name="d"/>
    <xsl:param name="d_c"/>
    <xsl:param name="dn"/>
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
    
    <!--<xsl:template name="legend">
        <xsl:param name="visning"/>
        <xsl:param name="typo"/>
        <xsl:param name="handwriting"/>
        <xsl:param name="interactive"/>
        
        <xsl:param name="el"/>
        <xsl:param name="i"/>
        <xsl:param name="im"/>
        <xsl:param name="our"/>
        <xsl:param name="d"/>
        <xsl:param name="d_c"/>
        <xsl:param name="dn"/>
        <xsl:param name="dnpc"/>
        <xsl:param name="dncr"/>
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
        <xsl:element name="form">
            <xsl:attribute name="enctype">multipart/form-data</xsl:attribute>
            <xsl:attribute name="action">http://wab.aksis.uib.no/transform/transformer_legend.php</xsl:attribute>
            <xsl:attribute name="method">post</xsl:attribute>
            <xsl:attribute name="target">_blank</xsl:attribute>
            
            <xsl:element name="input">
                <xsl:attribute name="type">hidden</xsl:attribute>
                <xsl:attribute name="name">modus</xsl:attribute>
                <xsl:attribute name="value">wab</xsl:attribute>
            </xsl:element>
            <xsl:element name="input">
                <xsl:attribute name="type">hidden</xsl:attribute>
                <xsl:attribute name="name">xsl</xsl:attribute>
                <xsl:attribute name="value">http://wab.aksis.uib.no/cost-a32/wab-transform.xsl</xsl:attribute>
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
            </xsl:element>
        </xsl:element>
    </xsl:template>-->
    
    
    <!-- This template writes the body into a HTML template -->
    
    <xsl:template match="/">
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
                
                <xsl:element name="script">
                    <xsl:attribute name="language">JavaScript1.1</xsl:attribute>
                    <xsl:attribute name="name">openNote</xsl:attribute>
                    <xsl:comment>
                        function openNote(text)
                        {
                        noteWindow = window.open('', 'WAB-note', 'width=480, height=320, resizable=yes, scrollbars=yes, toolbar=no, location=no, directories=no,status=no, menubar=no');
                        noteWindow.document.write(text)
                        }
                        //
                    </xsl:comment>
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
                
                <SCRIPT>
                    function newwindow(theUrl) {
                    window.open(theUrl, 'jav', 'width=640,height=320,resizable=no,scrollbars=auto');
                    }
                </SCRIPT>
                
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
                <!--<xsl:call-template name="legend">
                    <xsl:with-param name="visning" select="$visning"/>
                    <xsl:with-param name="typo" select="$typo"/>
                    <xsl:with-param name="handwriting" select="$handwriting"/>
                    <xsl:with-param name="interactive" select="$interactive"/>
                    <xsl:with-param name="el" select="$el"/>
                    <xsl:with-param name="i" select="$i"/>
                    <xsl:with-param name="im" select="$im"/>
                    <xsl:with-param name="our" select="$our"/>
                    <xsl:with-param name="d" select="$d"/>
                    <xsl:with-param name="d_c" select="$d_c"/>
                    <xsl:with-param name="dn" select="$dn"></xsl:with-param>
                    <xsl:with-param name="dnpc" select="$dnpc"/>
                    <xsl:with-param name="dncr" select="$dncr"/>
                    <xsl:with-param name="trs" select="$trs"/>
                    <xsl:with-param name="trsn" select="$trsn"/>
                    <xsl:with-param name="npc" select="$npc"/>
                    <xsl:with-param name="npcn" select="$npcn"/>
                    <xsl:with-param name="tra" select="$tra"/>
                    <xsl:with-param name="tran" select="$tran"/>
                    <xsl:with-param name="lb" select="$lb"/>
                    <xsl:with-param name="unclear" select="$unclear"/>
                    <xsl:with-param name="seg" select="$seg"/>
                    <xsl:with-param name="seg-ded" select="$seg-ded"/>
                    <xsl:with-param name="seg-def" select="$seg-def"/>
                    <xsl:with-param name="seg-dir" select="$seg-dir"/>
                    <xsl:with-param name="seg-ex" select="$seg-ex"/>
                    <xsl:with-param name="seg-intr" select="$seg-intr"/>
                    <xsl:with-param name="seg-mot" select="$seg-mot"/>
                    <xsl:with-param name="seg-pic" select="$seg-pic"/>
                    <xsl:with-param name="seg-pre" select="$seg-pre"/>
                    <xsl:with-param name="q" select="$q"/>
                    <xsl:with-param name="seg-rhe" select="$seg-rhe"/>
                    <xsl:with-param name="seg-sal" select="$seg-sal"/>
                    <xsl:with-param name="seg-not" select="$seg-not"/>
                    <xsl:with-param name="seg-cod" select="$seg-cod"/>
                    <xsl:with-param name="sm" select="$sm"/>
                    <xsl:with-param name="sm-back" select="$sm-back"/>
                    <xsl:with-param name="sm-bar" select="$sm-bar"/>
                    <xsl:with-param name="sm-epsi" select="$sm-epsi"/>
                    <xsl:with-param name="sm-im" select="$sm-im"/>
                    <xsl:with-param name="sm-qm" select="$sm-qm"/>
                    <xsl:with-param name="sm-slash" select="$sm-slash"/>
                    <xsl:with-param name="sm-tick" select="$sm-tick"/>
                        
                </xsl:call-template>-->
                
                <!--<xsl:element name="form">
                    <xsl:attribute name="enctype">multipart/form-data</xsl:attribute>
                    <xsl:attribute name="action">http://wab.aksis.uib.no/transform/transformer_legend.php</xsl:attribute>
                    <xsl:attribute name="method">post</xsl:attribute>
                    
                    <xsl:element name="input">
                        <xsl:attribute name="type">hidden</xsl:attribute>
                        <xsl:attribute name="name">modus</xsl:attribute>
                        <xsl:attribute name="value">wab</xsl:attribute>
                    </xsl:element>
                    <xsl:element name="input">
                        <xsl:attribute name="type">hidden</xsl:attribute>
                        <xsl:attribute name="name">xsl</xsl:attribute>
                        <xsl:attribute name="value">http://wab.aksis.uib.no/cost-a32/wab-transform.xsl</xsl:attribute>
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
                </xsl:element>-->

                
                
                <!--<form enctype='multipart/form-data' action='http://wab.aksis.uib.no/transform/transformer_legend.php' method='post'>

    <input type='hidden' name='modus' value='wab'/>
                    <input type='hidden' name='xsl'   value='http://wab.aksis.uib.no/cost-a32/wab-transform.xsl'/>
                    <input type='hidden' name='xml'   value='http://wab.aksis.uib.no/cost-a32/wab_legend.xml'/>
    <input type='hidden' name='interactive' value='yes'/>
    <input type='hidden' name='visning' value='dipl'/>               

    <input class='submit' type='submit' value=' legend '/>
    </form>-->


                    
                    
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
    
    <!-- The basic text-elements are handled by the following templates -->
    
    <xsl:template match="tei:div">
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="tei:table">
        <xsl:element name="TABLE">
            <xsl:attribute name="border">1</xsl:attribute>
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
    
    <xsl:template match="tei:pb">
        <xsl:variable name="pagename">
            <xsl:value-of select="substring-before(attribute::n, ' ')"/>
        </xsl:variable>
        <xsl:variable name="pageref">
            <xsl:value-of select="substring-after(attribute::n, ' ')"/>
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
                            <xsl:value-of select="attribute::corresp"/>
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
    
    <!--<xsl:template match="tei:lb">
        <xsl:choose>
            <xsl:when test="contains($typo, 'hide')">
                <xsl:choose>
                    <xsl:when test="contains($lb, 'excl') and $visning='norm'">
                        <xsl:choose>
                            <xsl:when test="$visning = 'norm'">
                                <xsl:text>&#x0020;</xsl:text>
                            </xsl:when>
                            <xsl:otherwise></xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
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
            <xsl:otherwise>
                <xsl:choose>
                    <xsl:when test="contains($lb, 'excl')">
                        <xsl:choose>
                            <xsl:when test="$visning = 'norm'">
                                <xsl:text>&#x0020;</xsl:text>
                            </xsl:when>
                            <xsl:otherwise></xsl:otherwise>
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
                                    <xsl:when test="attribute::rend='shyphen'"></xsl:when>
                                    <xsl:when test="attribute::rend='shyphen-pb'">
                                        <xsl:text>&#x002D;</xsl:text>
                                        <xsl:element name="BR"/>
                                    </xsl:when>
                                    <xsl:when test="attribute::rend='shyphen0'"></xsl:when>
                                    <xsl:when test="attribute::rend='hl'">
                                        <xsl:element name="BR"/>
                                    </xsl:when>
                                    <xsl:otherwise><xsl:text>&#x0020;</xsl:text></xsl:otherwise>
                                </xsl:choose>
                            </xsl:when>
                            <xsl:otherwise/>
                        </xsl:choose>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>-->
    
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
                            <xsl:attribute name="style">text-align: left; margin-left: 100px;</xsl:attribute>
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
            <xsl:when test="contains(attribute::emph, '_h') and $handwriting='off'"></xsl:when>
            <xsl:when test="contains(attribute::div, '_h') and $handwriting='off'"></xsl:when>
            <xsl:when test="contains(attribute::add, '_h') and $handwriting='off'"></xsl:when>
            <xsl:when test="contains(attribute::del, '_h') and $handwriting='off'"></xsl:when>
            <xsl:when test="contains(attribute::corr, '_h') and $handwriting='off'"></xsl:when>
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
                                        <xsl:when test="$handwriting='off'">
                                            
                                        </xsl:when>
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
                                                <xsl:when test="$visning='typo'">
                                                    <xsl:choose>
                                                        <xsl:when test="child::tei:seg[attribute::type='nm'] or child::tei:seg[attribute::type='nl'] or child::tei:seg[attribute::type='nr']">
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
                                                        <xsl:otherwise>
                                                            
                                                        </xsl:otherwise>
                                                    </xsl:choose>
                                                </xsl:when>
                                            </xsl:choose>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:if>
                                <xsl:if test="descendant::tei:seg[contains(attribute::type, 'secm')]">
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
                                                <xsl:text>text-align: left;</xsl:text>
                                                <xsl:choose>
                                                    <xsl:when test="ancestor::node()[contains(attribute::rend, 'crossed')] or contains(attribute::emph, 'crossed') or contains(attribute::emph, 'vdline')">background-color: #BEBEBE;</xsl:when>
                                                    <xsl:when test="contains(attribute::emph, 'clirm_h') and not($typo='hide')">background-color: #BEBEBE;</xsl:when>
                                                    <xsl:when test="contains(attribute::emph, 'slirm_h') and not($typo='hide')">background-color: #BEBEBE;</xsl:when>
                                                    <xsl:when test="contains(attribute::emph, 'wlirm_h') and not($typo='hide')">background-color: #BEBEBE;</xsl:when>
                                                    <xsl:when test="contains(attribute::emph, 'zigzagrm_h') and not($typo='hide')">background-color: #BEBEBE;</xsl:when>
                                                    <xsl:otherwise></xsl:otherwise>
                                                </xsl:choose>
                                                <xsl:choose>
                                                    <xsl:when test="contains(attribute::emph, 'ringed_h')">color: #0000FF;</xsl:when>
                                                    <xsl:when test="contains(attribute::add, 'H') and not($typo='hide' ) and not($visning='norm')">color: #0000FF;</xsl:when>
                                                    <xsl:otherwise></xsl:otherwise>
                                                </xsl:choose>
                                                <xsl:choose>
                                                    <xsl:when test="contains(attribute::emph, 'ringed_h')">border: 2px solid purple;</xsl:when>
                                                    <xsl:otherwise></xsl:otherwise>
                                                </xsl:choose>
                                                <xsl:choose>
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
                                                            <xsl:choose>
                                                                <xsl:when test="contains(attribute::del, 'del_d_h')">
                                                                    <xsl:choose>
                                                                        <xsl:when test="contains($d, 'dipl')">
                                                                            <xsl:text>text-decoration: line-through; color: #0000FF;</xsl:text>
                                                                        </xsl:when>
                                                                        <xsl:when test="contains($d, 'study')">
                                                                            <xsl:text>text-decoration: line-through; color: #0000FF;</xsl:text>
                                                                        </xsl:when>
                                                                        <xsl:otherwise/>
                                                                    </xsl:choose>
                                                                </xsl:when>
                                                                <xsl:when test="contains(attribute::del, 'del_dnpc_h')">
                                                                    <xsl:choose>
                                                                        <xsl:when test="contains($dnpc, 'dipl')">
                                                                            <xsl:attribute name="style">color: #0000FF; text-decoration: line-through;</xsl:attribute>
                                                                        </xsl:when>
                                                                        <xsl:when test="contains($dnpc, 'study')"></xsl:when>
                                                                        <xsl:otherwise></xsl:otherwise>
                                                                    </xsl:choose>
                                                                </xsl:when>
                                                                <xsl:otherwise></xsl:otherwise>
                                                            </xsl:choose>
                                                        </xsl:attribute>
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
                                                                    <xsl:choose>
                                                                        <xsl:when test="contains(attribute::del, type_d_h)">
                                                                            <xsl:choose>
                                                                                <xsl:when test="contains($d, 'dipl')"><xsl:attribute name="style">color: #000000;</xsl:attribute></xsl:when>
                                                                                <xsl:when test="contains($d, 'study')"></xsl:when>
                                                                                <xsl:otherwise></xsl:otherwise>
                                                                            </xsl:choose>
                                                                        </xsl:when>
                                                                        <xsl:when test="contains(attribute::del, type_dnpc_h)">
                                                                            <xsl:choose>
                                                                                <xsl:when test="contains($dnpc, 'dipl')"><xsl:attribute name="style">color: #000000;</xsl:attribute></xsl:when>
                                                                                <xsl:when test="contains($dnpc, 'study')"></xsl:when>
                                                                                <xsl:otherwise></xsl:otherwise>
                                                                            </xsl:choose>
                                                                        </xsl:when>
                                                                        <xsl:otherwise></xsl:otherwise>
                                                                    </xsl:choose>
                                                                    <xsl:choose>
                                                                        <xsl:when test="ancestor::tei:reloc and not(ancestor::tei:ab)">
                                                                            <xsl:variable name="p-num">
                                                                                <xsl:number count="tei:ab" from="tei:reloc"/>
                                                                            </xsl:variable>
                                                                            !!<xsl:value-of select="$p-num"/>!!
                                                                        </xsl:when>
                                                                        <xsl:otherwise></xsl:otherwise>
                                                                    </xsl:choose>
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
                                                                                                <xsl:when test="contains($d, 'study')"></xsl:when>
                                                                                                <xsl:otherwise></xsl:otherwise>
                                                                                            </xsl:choose>
                                                                                        </xsl:when>
                                                                                        <xsl:when test="contains(attribute::del, type_dnpc_h)">
                                                                                            <xsl:choose>
                                                                                                <xsl:when test="contains($dnpc, 'dipl')"><xsl:attribute name="style">color: #000000;</xsl:attribute></xsl:when>
                                                                                                <xsl:when test="contains($dnpc, 'study')"></xsl:when>
                                                                                                <xsl:otherwise></xsl:otherwise>
                                                                                            </xsl:choose>
                                                                                        </xsl:when>
                                                                                        <xsl:otherwise></xsl:otherwise>
                                                                                    </xsl:choose>
                                                                                    <xsl:apply-templates/>
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
                                                                                        <xsl:when test="contains($d, 'study')"></xsl:when>
                                                                                        <xsl:otherwise></xsl:otherwise>
                                                                                    </xsl:choose>
                                                                                </xsl:when>
                                                                                <xsl:when test="contains(attribute::del, type_dnpc_h)">
                                                                                    <xsl:choose>
                                                                                        <xsl:when test="contains($dnpc, 'dipl')"><xsl:attribute name="style">color: #000000;</xsl:attribute></xsl:when>
                                                                                        <xsl:when test="contains($dnpc, 'study')"></xsl:when>
                                                                                        <xsl:otherwise></xsl:otherwise>
                                                                                    </xsl:choose>
                                                                                </xsl:when>
                                                                                <xsl:otherwise></xsl:otherwise>
                                                                            </xsl:choose>
                                                                            <xsl:apply-templates/>
                                                                        </xsl:element>
                                                                    </xsl:when>
                                                                    <xsl:otherwise>
                                                                        <xsl:choose>
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
                                                                                        <!--<xsl:apply-templates/>-->
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
                                                                                    <xsl:apply-templates/>
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
                                                                            <xsl:apply-templates/>
                                                                        </xsl:element>
                                                                    </xsl:when>
                                                                    <xsl:otherwise>
                                                                        <xsl:choose>
                                                                            <xsl:when test="contains(attribute::del, type_d_h)">
                                                                                <xsl:choose>
                                                                                    <xsl:when test="contains($d, 'dipl')">
                                                                                        <xsl:element name="SPAN">
                                                                                            <xsl:attribute name="style">color: #000000;</xsl:attribute>
                                                                                            <xsl:apply-templates/>
                                                                                        </xsl:element>
                                                                                    </xsl:when>
                                                                                    <xsl:when test="contains($d, 'norm')">
                                                                                        <xsl:apply-templates/>
                                                                                    </xsl:when>
                                                                                    <xsl:otherwise>
                                                                                        <xsl:apply-templates/>
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
                                                                                    <xsl:when test="contains($dnpc, 'norm')">
                                                                                        
                                                                                    </xsl:when>
                                                                                    <xsl:otherwise>

                                                                                    </xsl:otherwise>
                                                                                </xsl:choose>
                                                                            </xsl:when>
                                                                            <xsl:otherwise>
                                                                                <xsl:apply-templates/>
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
                                                        <xsl:choose>
                                                            <xsl:when test="contains(attribute::del, 'del_d_h')">
                                                                <xsl:choose>
                                                                    <xsl:when test="contains($d, 'study')">
                                                                        <xsl:attribute name="style">color: #0000FF; text-decoration: line-through;</xsl:attribute>
                                                                    </xsl:when>
                                                                    <xsl:when test="contains($d, 'norm')"></xsl:when>
                                                                    <xsl:otherwise>
                                                                        <xsl:attribute name="style">text-decoration: line-through; color: #0000FF;</xsl:attribute>
                                                                    </xsl:otherwise>
                                                                </xsl:choose>
                                                            </xsl:when>
                                                            <xsl:when test="contains(attribute::del, 'del_dnpc_h')">
                                                                <xsl:choose>
                                                                    <xsl:when test="contains($dnpc, 'study')">
                                                                        <xsl:attribute name="style"></xsl:attribute>
                                                                    </xsl:when>
                                                                    <xsl:when test="contains($dnpc, 'norm')"></xsl:when>
                                                                    <xsl:otherwise>
                                                                        <xsl:attribute name="style">text-decoration: line-through; color: #0000FF;</xsl:attribute>
                                                                    </xsl:otherwise>
                                                                </xsl:choose>
                                                            </xsl:when>
                                                            <xsl:otherwise></xsl:otherwise>
                                                        </xsl:choose>
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
                                                                                <xsl:when test="contains($d, 'study')"></xsl:when>
                                                                                <xsl:when test="contains($d, 'norm')"></xsl:when>
                                                                                <xsl:otherwise>
                                                                                    <xsl:attribute name="style">color: #000000;</xsl:attribute>
                                                                                </xsl:otherwise>
                                                                            </xsl:choose>
                                                                        </xsl:when>
                                                                        <xsl:when test="contains(attribute::del, type_dnpc_h)">
                                                                            <xsl:choose>
                                                                                <xsl:when test="contains($dnpc, 'study')"></xsl:when>
                                                                                <xsl:when test="contains($dnpc, 'norm')"></xsl:when>
                                                                                <xsl:otherwise>
                                                                                    <xsl:attribute name="style">color: #000000;</xsl:attribute>
                                                                                </xsl:otherwise>
                                                                            </xsl:choose>
                                                                        </xsl:when>
                                                                        <xsl:otherwise></xsl:otherwise>
                                                                    </xsl:choose>
                                                                <xsl:apply-templates/>
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
                                                                                <xsl:apply-templates/>
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
    
    <xsl:template match="tei:list" mode="tooltip">
        <xsl:apply-templates mode="tooltip"/>
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
            <xsl:when test="contains(attribute::type, 'wabmarks')">
                <xsl:choose>
                    <xsl:when test="$visning = 'dipl' or $visning = 'study'">
                        <xsl:choose>
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
                                                            <xsl:apply-templates select="self::tei:seg[contains(attribute::type, 'mr')]" mode="margins"/>
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
                            <xsl:when test="contains(attribute::type, 'secm')">
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:choose>
                                    <xsl:when test="contains(attribute::type, '_h') or contains(attribute::type, 'S1')">
                                        <xsl:choose>
                                            <xsl:when test="$handwriting = 'off'"></xsl:when>
                                            <xsl:otherwise>
                                                <xsl:element name="SPAN">
                                                    <xsl:attribute name="style">color: #0000FF; font-size: 60%;</xsl:attribute>
                                                    <xsl:apply-templates/>                                           
                                                </xsl:element>
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
                                
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:choose>
                                    <xsl:when test="$visning='typo'">
                                        <xsl:apply-templates/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        
                                    </xsl:otherwise>
                                </xsl:choose>
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
            <xsl:when test="attribute::type='ill-space'"><!-- Sjekk visning -->
                <xsl:call-template name="spaces">
                    <xsl:with-param name="i" select="1"/>
                    <xsl:with-param name="max" select="substring-after(attribute::type, '_')"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="attribute::type='int-ref'"><!-- Sjekk visning -->
                <xsl:text>[int-ref: </xsl:text>
                <xsl:element name="A">
                    <xsl:attribute name="href"><xsl:value-of select="attribute::n"/></xsl:attribute>
                    <xsl:attribute name="style">color: #0000FF;</xsl:attribute>
                    <xsl:apply-templates/>
                </xsl:element>
                <xsl:text>]</xsl:text>
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
                    <xsl:when test="$handwriting = 'off'"></xsl:when>
                    <xsl:otherwise>
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
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="attribute::rend='el_H1'">
                <xsl:choose>
                    <xsl:when test="$handwriting = 'off'"></xsl:when>
                    <xsl:otherwise>
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
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="attribute::rend='el_s'">
                <xsl:choose>
                    <xsl:when test="$handwriting = 'off'"></xsl:when>
                    <xsl:otherwise>
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
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="attribute::rend='el_S1'">
                <xsl:choose>
                    <xsl:when test="$handwriting = 'off'"></xsl:when>
                    <xsl:otherwise>
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
            <xsl:when test="attribute::rend='fremd'">
                <xsl:choose>
                    <xsl:when test="contains($visning, 'dipl')"></xsl:when>
                    <xsl:when test="contains($visning, 'study')"></xsl:when>
                    <xsl:when test="contains($visning, 'norm')"></xsl:when>
                    <xsl:otherwise>
                        <xsl:apply-templates/>
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
                                    <xsl:text>&#x02C5;</xsl:text>
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
                                    <xsl:text>&#x02C5;</xsl:text>
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
                                    <xsl:text>&#x02C5;</xsl:text>
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
                                                    <xsl:attribute name="style">vertical-align: super; font-size: 10pt; color: #0000FF;</xsl:attribute>
                                                    <xsl:text>&#x02C5;</xsl:text>
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
                                                    <xsl:text>&#x02C5;</xsl:text>
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
                                                    <xsl:text>&#x02C5;</xsl:text>
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
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <!--<xsl:when test="attribute::rend='im_h'">
                <xsl:choose>
                <xsl:when test="$handwriting = 'off'"></xsl:when>
                <xsl:otherwise>
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
                <xsl:attribute name="style">vertical-align: super; font-size: 10pt; color: #0000FF;</xsl:attribute>
                <xsl:text>&#x02C5;</xsl:text>
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
                <xsl:text>&#x02C5;</xsl:text>
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
                <xsl:text>&#x02C5;</xsl:text>
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
                </xsl:otherwise>
                </xsl:choose>
                </xsl:when>-->
            <xsl:when test="attribute::rend='im_H1'">
                <xsl:choose>
                    <xsl:when test="$handwriting = 'off'"></xsl:when>
                    <xsl:otherwise>
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
                                                    <xsl:attribute name="style">vertical-align: super; font-size: 10pt; color: #0000FF;</xsl:attribute>
                                                    <xsl:text>&#x02C5;</xsl:text>
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
                                                    <xsl:text>&#x02C5;</xsl:text>
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
                                                    <xsl:text>&#x02C5;</xsl:text>
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
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="attribute::rend='im_hm'"><!-- Sjekk visning -->
                <xsl:choose>
                    <xsl:when test="$handwriting = 'off'"></xsl:when>
                    <xsl:otherwise>
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
                                                    <xsl:attribute name="style">vertical-align: super; font-size: 10pt; color: #0000FF;</xsl:attribute>
                                                    <xsl:text>&#x02C5;</xsl:text>
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
                                                    <xsl:text>&#x02C5;</xsl:text>
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
                                                    <xsl:text>&#x02C5;</xsl:text>
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
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="attribute::rend='im_S1'">
                <xsl:choose>
                    <xsl:when test="$handwriting = 'off'"></xsl:when>
                    <xsl:otherwise>
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
                                                    <xsl:attribute name="style">vertical-align: super; font-size: 10pt; color: #0000FF;</xsl:attribute>
                                                    <xsl:text>&#x02C5;</xsl:text>
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
                                                    <xsl:text>&#x02C5;</xsl:text>
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
                                                    <xsl:text>&#x02C5;</xsl:text>
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
                                            <xsl:attribute name="style">vertical-align: super; font-size: 10pt; color: #888BBD;</xsl:attribute>
                                            <xsl:text>&#x02C5;</xsl:text>
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
                                            <xsl:text>&#x02C5;</xsl:text>
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
                                    <xsl:text>&#x02C5;</xsl:text>
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
                                    <xsl:text>&#x02C5;</xsl:text>
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
                                    <xsl:text>&#x02C5;</xsl:text>
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
                    <xsl:when test="$handwriting = 'off'"></xsl:when>
                    <xsl:otherwise>
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
                                    <xsl:attribute name="style">color: #0000FF;</xsl:attribute>
                                    <xsl:apply-templates/>
                                </xsl:element>
                            </xsl:when>
                            <xsl:when test="contains($visning, 'study')">
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">color: #0000FF;</xsl:attribute>
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
            <xsl:when test="attribute::rend='i_H1'">
                <xsl:choose>
                    <xsl:when test="$handwriting = 'off'"></xsl:when>
                    <xsl:otherwise>
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
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="attribute::rend='i_s'">
                <xsl:choose>
                    <xsl:when test="$handwriting = 'off'"></xsl:when>
                    <xsl:otherwise>
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
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="attribute::rend='i_S1'">
                <xsl:choose>
                    <xsl:when test="$handwriting = 'off'"></xsl:when>
                    <xsl:otherwise>
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
                            <xsl:when test="contains($typo, 'hide')"/>
                            <xsl:otherwise>
                                <xsl:choose>
                                    <xsl:when test="contains($visning, 'dipl')">
                                        <xsl:element name="SPAN">
                                            <xsl:attribute name="style">color: #0000FF; vertical-align: sub; font-size: 10pt;</xsl:attribute>
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
                    <xsl:when test="$handwriting = 'off'"></xsl:when>
                    <xsl:otherwise>
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
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="attribute::rend='ipp_H5'">
                <xsl:choose>
                    <xsl:when test="$handwriting = 'off'"></xsl:when>
                    <xsl:otherwise>
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
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="attribute::rend='irm_S1'"><!-- Sjekk visning -->
                <xsl:choose>
                    <xsl:when test="$handwriting = 'off'"></xsl:when>
                    <xsl:otherwise>
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
            <xsl:when test="attribute::rend='ilom_h'">
                <xsl:choose>
                    <xsl:when test="$handwriting = 'off'"></xsl:when>
                    <xsl:otherwise>
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
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="attribute::rend='ip_h'">
                <xsl:choose>
                    <xsl:when test="$handwriting = 'off'"></xsl:when>
                    <xsl:otherwise>
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
                                                    <xsl:attribute name="style">color: #800080</xsl:attribute>
                                                    <xsl:text>&lt;&lt;</xsl:text>
                                                </xsl:element>
                                                <xsl:element name="SPAN">
                                                    <xsl:attribute name="style">vertical-align: super; font-size: 10pt; color: #0000FF;</xsl:attribute>
                                                    <xsl:text>&#x02C5;</xsl:text>
                                                    <xsl:apply-templates/>
                                                </xsl:element>
                                                <xsl:element name="SPAN">
                                                    <xsl:attribute name="style">color: #800080</xsl:attribute>
                                                    <xsl:text>&gt;&gt;</xsl:text>
                                                </xsl:element>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:when>
                                    <xsl:when test="contains($visning, 'study')">
                                        <xsl:choose>
                                            <xsl:when test="contains($im, 'dipl')">
                                                <xsl:element name="SPAN">
                                                    <xsl:attribute name="style">color: #800080</xsl:attribute>
                                                    <xsl:text>&lt;&lt;</xsl:text>
                                                </xsl:element>
                                                <xsl:element name="SPAN">
                                                    <xsl:attribute name="style">vertical-align: super; font-size: 10pt; color: #0000FF;</xsl:attribute>
                                                    <xsl:text>&#x02C5;</xsl:text>
                                                    <xsl:apply-templates/>
                                                </xsl:element>
                                                <xsl:element name="SPAN">
                                                    <xsl:attribute name="style">color: #800080</xsl:attribute>
                                                    <xsl:text>&gt;&gt;</xsl:text>
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
                                                    <xsl:attribute name="style">color: #800080</xsl:attribute>
                                                    <xsl:text>&lt;&lt;</xsl:text>
                                                </xsl:element>
                                                <xsl:element name="SPAN">
                                                    <xsl:attribute name="style">vertical-align: super; font-size: 10pt; color: #0000FF;</xsl:attribute>
                                                    <xsl:text>&#x02C5;</xsl:text>
                                                    <xsl:apply-templates/>
                                                </xsl:element>
                                                <xsl:element name="SPAN">
                                                    <xsl:attribute name="style">color: #800080</xsl:attribute>
                                                    <xsl:text>&gt;&gt;</xsl:text>
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
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="attribute::rend='ipp_h'">
                <xsl:choose>
                    <xsl:when test="$handwriting = 'off'"></xsl:when>
                    <xsl:otherwise>
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
                                                    <xsl:attribute name="style">color: #800080</xsl:attribute>
                                                    <xsl:text>&lt;&lt;</xsl:text>
                                                </xsl:element>
                                                <xsl:element name="SPAN">
                                                    <xsl:attribute name="style">vertical-align: super; font-size: 10pt; color: #0000FF;</xsl:attribute>
                                                    <xsl:text>&#x02C5;</xsl:text>
                                                    <xsl:apply-templates/>
                                                </xsl:element>
                                                <xsl:element name="SPAN">
                                                    <xsl:attribute name="style">color: #800080</xsl:attribute>
                                                    <xsl:text>&gt;&gt;</xsl:text>
                                                </xsl:element>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:when>
                                    <xsl:when test="contains($visning, 'study')">
                                        <xsl:choose>
                                            <xsl:when test="contains($im, 'dipl')">
                                                <xsl:element name="SPAN">
                                                    <xsl:attribute name="style">color: #800080</xsl:attribute>
                                                    <xsl:text>&lt;&lt;</xsl:text>
                                                </xsl:element>
                                                <xsl:element name="SPAN">
                                                    <xsl:attribute name="style">vertical-align: super; font-size: 10pt; color: #0000FF;</xsl:attribute>
                                                    <xsl:text>&#x02C5;</xsl:text>
                                                    <xsl:apply-templates/>
                                                </xsl:element>
                                                <xsl:element name="SPAN">
                                                    <xsl:attribute name="style">color: #800080</xsl:attribute>
                                                    <xsl:text>&gt;&gt;</xsl:text>
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
                                                    <xsl:attribute name="style">color: #800080</xsl:attribute>
                                                    <xsl:text>&lt;&lt;</xsl:text>
                                                </xsl:element>
                                                <xsl:element name="SPAN">
                                                    <xsl:attribute name="style">vertical-align: super; font-size: 10pt; color: #0000FF;</xsl:attribute>
                                                    <xsl:text>&#x02C5;</xsl:text>
                                                    <xsl:apply-templates/>
                                                </xsl:element>
                                                <xsl:element name="SPAN">
                                                    <xsl:attribute name="style">color: #800080</xsl:attribute>
                                                    <xsl:text>&gt;&gt;</xsl:text>
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
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="attribute::rend='ipnpc_h'">
                <xsl:choose>
                    <xsl:when test="$handwriting = 'off'"></xsl:when>
                    <xsl:otherwise>
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
                                                    <xsl:attribute name="style">color: #800080</xsl:attribute>
                                                    <xsl:text>&lt;&lt;</xsl:text>
                                                </xsl:element>
                                                <xsl:element name="SPAN">
                                                    <xsl:attribute name="style">vertical-align: super; font-size: 10pt; color: #0000FF;</xsl:attribute>
                                                    <xsl:text>&#x02C5;</xsl:text>
                                                    <xsl:apply-templates/>
                                                </xsl:element>
                                                <xsl:element name="SPAN">
                                                    <xsl:attribute name="style">color: #800080</xsl:attribute>
                                                    <xsl:text>&gt;&gt;</xsl:text>
                                                </xsl:element>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:when>
                                    <xsl:when test="contains($visning, 'study')">
                                        <xsl:choose>
                                            <xsl:when test="contains($im, 'dipl')">
                                                <xsl:element name="SPAN">
                                                    <xsl:attribute name="style">color: #800080</xsl:attribute>
                                                    <xsl:text>&lt;&lt;</xsl:text>
                                                </xsl:element>
                                                <xsl:element name="SPAN">
                                                    <xsl:attribute name="style">vertical-align: super; font-size: 10pt; color: #0000FF;</xsl:attribute>
                                                    <xsl:text>&#x02C5;</xsl:text>
                                                    <xsl:apply-templates/>
                                                </xsl:element>
                                                <xsl:element name="SPAN">
                                                    <xsl:attribute name="style">color: #800080</xsl:attribute>
                                                    <xsl:text>&gt;&gt;</xsl:text>
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
                                                    <xsl:attribute name="style">color: #800080</xsl:attribute>
                                                    <xsl:text>&lt;&lt;</xsl:text>
                                                </xsl:element>
                                                <xsl:element name="SPAN">
                                                    <xsl:attribute name="style">vertical-align: super; font-size: 10pt; color: #0000FF;</xsl:attribute>
                                                    <xsl:text>&#x02C5;</xsl:text>
                                                    <xsl:apply-templates/>
                                                </xsl:element>
                                                <xsl:element name="SPAN">
                                                    <xsl:attribute name="style">color: #800080</xsl:attribute>
                                                    <xsl:text>&gt;&gt;</xsl:text>
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
                    <xsl:when test="$handwriting = 'off'"></xsl:when>
                    <xsl:otherwise>
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
            <xsl:when test="attribute::rend='iupmm_h'"><!-- Sjekk visning -->
                <xsl:choose>
                    <xsl:when test="$handwriting = 'off'"></xsl:when>
                    <xsl:otherwise>
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
                    <xsl:when test="$handwriting = 'off'"></xsl:when>
                    <xsl:otherwise>
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
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="attribute::rend='upm_h'">
                <xsl:choose>
                    <xsl:when test="$handwriting = 'off'"></xsl:when>
                    <xsl:otherwise>
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
    
    <xsl:template match="tei:app">
        <xsl:choose>
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
                            <xsl:text>&#x2194;</xsl:text>
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
                            <xsl:text>&#x2194;</xsl:text>
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
            <xsl:when test="attribute::type='co_h'">
                <xsl:choose>
                    <xsl:when test="$handwriting = 'off'"></xsl:when>
                    <xsl:otherwise>
                        <xsl:choose>
                            <xsl:when test="contains($visning, 'dipl')">
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">color: #0000FF;</xsl:attribute>
                                    <xsl:text>[</xsl:text>
                                </xsl:element>
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">color: #0000FF;</xsl:attribute>
                                    <xsl:apply-templates select="child::tei:rdg[attribute::type='alt1']"/>
                                </xsl:element>
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">color: #0000FF; font-size: 75%;</xsl:attribute>
                                    <xsl:text>&#x2194;</xsl:text>
                                </xsl:element>
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">color: #0000FF;</xsl:attribute>
                                    <xsl:apply-templates select="child::tei:rdg[attribute::type='alt2']"/>
                                </xsl:element>
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
                                    <xsl:text>&#x2194;</xsl:text>
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
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="attribute::type='co_H1'">
                <xsl:choose>
                    <xsl:when test="$handwriting = 'off'"></xsl:when>
                    <xsl:otherwise>
                        <xsl:choose>
                            <xsl:when test="contains($visning, 'dipl')">
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">color: #0000FF;</xsl:attribute>
                                    <xsl:text>[</xsl:text>
                                </xsl:element>
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">color: #0000FF;</xsl:attribute>
                                    <xsl:apply-templates select="child::tei:rdg[attribute::type='alt1']"/>
                                </xsl:element>
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">color: #0000FF; font-size: 75%;</xsl:attribute>
                                    <xsl:text>&#x2194;</xsl:text>
                                </xsl:element>
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">color: #0000FF;</xsl:attribute>
                                    <xsl:apply-templates select="child::tei:rdg[attribute::type='alt2']"/>
                                </xsl:element>
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
                                    <xsl:text>&#x2194;</xsl:text>
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
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="attribute::type='corr-co'">
                <xsl:choose>
                    <xsl:when test="contains($visning, 'dipl')">
                        <xsl:apply-templates select="child::tei:rdg[attribute::type='alt1']"/>
                    </xsl:when>
                    <xsl:when test="contains($visning, 'study')">
                        <xsl:element name="SPAN">
                            <xsl:attribute name="style">color: #009900;</xsl:attribute>
                            <xsl:text>{</xsl:text>
                        </xsl:element>
                        <xsl:apply-templates select="child::tei:rdg[attribute::type='alt2']"/>
                        <xsl:element name="SPAN">
                            <xsl:attribute name="style">color: #009900;</xsl:attribute>
                            <xsl:text>}</xsl:text>
                        </xsl:element>
                    </xsl:when>
                    <xsl:when test="contains($visning, 'norm')">
                        <xsl:apply-templates select="child::tei:rdg[attribute::type='alt2']"/>
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
                    <xsl:when test="$handwriting = 'off'"></xsl:when>
                    <xsl:otherwise>
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
                    <xsl:when test="$handwriting = 'off'"></xsl:when>
                    <xsl:otherwise>
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
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="attribute::type='dsl_H1'">
                <xsl:choose>
                    <xsl:when test="$handwriting = 'off'"></xsl:when>
                    <xsl:otherwise>
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
            <xsl:when test="attribute::type='o_c'">
                <xsl:choose>
                    <xsl:when test="contains($visning, 'dipl')">
                        <xsl:element name="SPAN">
                            <xsl:attribute name="style">color: brown;</xsl:attribute>
                            <xsl:text>[</xsl:text>
                        </xsl:element>
                        <xsl:apply-templates select="child::tei:rdg[attribute::type='o_c1']"/>
                        <xsl:element name="SPAN">
                            <xsl:attribute name="style">color: brown;</xsl:attribute>
                            <xsl:text>|</xsl:text>
                        </xsl:element>
                        <xsl:apply-templates select="child::tei:rdg[attribute::type='o_c2']"/>
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
                        <xsl:apply-templates select="child::tei:rdg[attribute::type='o_c2']"/>
                    </xsl:when>
                    <xsl:when test="contains($visning, 'norm')">
                        <xsl:apply-templates select="child::tei:rdg[attribute::type='o_c2']"/>
                    </xsl:when>
                    <xsl:otherwise/>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="attribute::type='o_h'"><!-- Sjekk visning -->
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
                                    <xsl:apply-templates select="child::tei:rdg[attribute::type='o1']"/>
                                </xsl:element>
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">color: brown;</xsl:attribute>
                                    <xsl:text>|</xsl:text>
                                </xsl:element>
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">color: #0000FF;</xsl:attribute>
                                    <xsl:apply-templates select="child::tei:rdg[attribute::type='o2']"/>
                                </xsl:element>
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
                                    <xsl:apply-templates select="child::tei:rdg[attribute::type='o_H11']"/>
                                </xsl:element>
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">color: brown;</xsl:attribute>
                                    <xsl:text>|</xsl:text>
                                </xsl:element>
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">color: #0000FF;</xsl:attribute>
                                    <xsl:apply-templates select="child::tei:rdg[attribute::type='o_H12']"/>
                                </xsl:element>
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">color: brown;</xsl:attribute>
                                    <xsl:text>]</xsl:text>
                                </xsl:element>
                            </xsl:when>
                            <xsl:when test="contains($visning, 'study')">
                                <xsl:apply-templates select="child::tei:rdg[attribute::type='o_H12']"/>
                            </xsl:when>
                            <xsl:when test="contains($visning, 'norm')">
                                <xsl:apply-templates select="child::tei:rdg[attribute::type='o_H12']"/>
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
                    <xsl:when test="$handwriting = 'off'"></xsl:when>
                    <xsl:otherwise>
                        <xsl:choose>
                            <xsl:when test="contains($typo, 'hide')"/>
                            <xsl:otherwise>
                                <xsl:choose>
                                    <xsl:when test="contains($visning, 'dipl')">
                                        <xsl:element name="SPAN">
                                            <xsl:attribute name="style">color: brown;</xsl:attribute>
                                            <xsl:text>[</xsl:text>
                                        </xsl:element>
                                        <xsl:apply-templates
                                            select="child::tei:rdg[attribute::type='on1_h']"/>
                                        <!-- Alois vurder om det ikke skal hete on1_h og on2_h -->
                                        <xsl:element name="SPAN">
                                            <xsl:attribute name="style">color: brown;</xsl:attribute>
                                            <xsl:text>|</xsl:text>
                                        </xsl:element>
                                        <xsl:element name="SPAN">
                                            <xsl:attribute name="style">color: #0000FF;</xsl:attribute>
                                            <xsl:apply-templates
                                                select="child::tei:rdg[attribute::type='on2_h']"/>
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
                                            select="child::tei:rdg[attribute::type='on2']"/>
                                    </xsl:when>
                                    <xsl:when test="contains($visning, 'norm')">
                                        <xsl:apply-templates select="child::tei:rdg[attribute::type='on2']"/>
                                    </xsl:when>
                                    <xsl:otherwise/>
                                </xsl:choose>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="attribute::type='on_S1'">
                <xsl:choose>
                    <xsl:when test="$handwriting = 'off'"></xsl:when>
                    <xsl:otherwise>
                        <xsl:choose>
                            <xsl:when test="contains($typo, 'hide')"/>
                            <xsl:otherwise>
                                <xsl:choose>
                                    <xsl:when test="contains($visning, 'dipl')">
                                        <xsl:element name="SPAN">
                                            <xsl:attribute name="style">color: brown;</xsl:attribute>
                                            <xsl:text>[</xsl:text>
                                        </xsl:element>
                                        <xsl:apply-templates select="child::tei:rdg[attribute::type='on_S11']"/>
                                        <!-- Alois vurder om det ikke skal hete on1_h og on2_h -->
                                        <xsl:element name="SPAN">
                                            <xsl:attribute name="style">color: brown;</xsl:attribute>
                                            <xsl:text>|</xsl:text>
                                        </xsl:element>
                                        <xsl:element name="SPAN">
                                            <xsl:attribute name="style">color: #0000FF;</xsl:attribute>
                                            <xsl:apply-templates select="child::tei:rdg[attribute::type='on_S12']"/>
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
                                            select="child::tei:rdg[attribute::type='on_S12']"/>
                                    </xsl:when>
                                    <xsl:when test="contains($visning, 'norm')">
                                        <xsl:apply-templates select="child::tei:rdg[attribute::type='on_S12']"/>
                                    </xsl:when>
                                    <xsl:otherwise/>
                                </xsl:choose>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="attribute::type='oncr_h'">
                <xsl:choose>
                    <xsl:when test="$handwriting = 'off'"></xsl:when>
                    <xsl:otherwise>
                        <xsl:choose>
                            <xsl:when test="contains($typo, 'hide')"/>
                            <xsl:otherwise>
                                <xsl:choose>
                                    <xsl:when test="contains($visning, 'dipl')">
                                        <xsl:element name="SPAN">
                                            <xsl:attribute name="style">color: brown;</xsl:attribute>
                                            <xsl:text>[</xsl:text>
                                        </xsl:element>
                                        <xsl:apply-templates
                                            select="child::tei:rdg[attribute::type='oncr1_h']"/>
                                        <!-- Alois vurder om det ikke skal hete on1_h og on2_h -->
                                        <xsl:element name="SPAN">
                                            <xsl:attribute name="style">color: brown;</xsl:attribute>
                                            <xsl:text>|</xsl:text>
                                        </xsl:element>
                                        <xsl:element name="SPAN">
                                            <xsl:attribute name="style">color: #0000FF;</xsl:attribute>
                                            <xsl:apply-templates
                                                select="child::tei:rdg[attribute::type='oncr2_h']"/>
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
                                            select="child::tei:rdg[attribute::type='oncr2']"/>
                                    </xsl:when>
                                    <xsl:when test="contains($visning, 'norm')">
                                        <xsl:apply-templates select="child::tei:rdg[attribute::type='oncr2']"/>
                                    </xsl:when>
                                    <xsl:otherwise/>
                                </xsl:choose>
                            </xsl:otherwise>
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
                        <xsl:apply-templates select="child::tei:rdg[attribute::type='os1']"/>
                        <xsl:element name="SPAN">
                            <xsl:attribute name="style">color: brown;</xsl:attribute>
                            <xsl:text>|</xsl:text>
                        </xsl:element>
                        <xsl:apply-templates select="child::tei:rdg[attribute::type='os2']"/>
                        <xsl:element name="SPAN">
                            <xsl:attribute name="style">color: brown;</xsl:attribute>
                            <xsl:text>]</xsl:text>
                        </xsl:element>
                    </xsl:when>
                    <xsl:when test="contains($visning, 'study')">
                        <xsl:apply-templates select="child::tei:rdg[attribute::type='os2']"/>
                    </xsl:when>
                    <xsl:when test="contains($visning, 'norm')">
                        <xsl:apply-templates select="child::tei:rdg[attribute::type='os2']"/>
                    </xsl:when>
                    <xsl:otherwise/>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="attribute::type='os_h'"> <!-- Sjekk visning -->
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
                                    <xsl:apply-templates select="child::tei:rdg[attribute::type='os1']"/>
                                </xsl:element>
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">color: brown;</xsl:attribute>
                                    <xsl:text>|</xsl:text>
                                </xsl:element>
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">color: #0000FF;</xsl:attribute>
                                    <xsl:apply-templates select="child::tei:rdg[attribute::type='os2']"/>
                                </xsl:element>
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">color: brown;</xsl:attribute>
                                    <xsl:text>]</xsl:text>
                                </xsl:element>
                            </xsl:when>
                            <xsl:when test="contains($visning, 'study')">
                                <xsl:apply-templates select="child::tei:rdg[attribute::type='os2']"/>
                            </xsl:when>
                            <xsl:when test="contains($visning, 'norm')">
                                <xsl:apply-templates select="child::tei:rdg[attribute::type='os2']"/>
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
                        <xsl:apply-templates select="child::tei:rdg[attribute::type='ospace1']"/>
                        <xsl:element name="SPAN">
                            <xsl:attribute name="style">color: brown;</xsl:attribute>
                            <xsl:text>|</xsl:text>
                        </xsl:element>
                        <xsl:apply-templates select="child::tei:rdg[attribute::type='ospace2']"/>
                        <xsl:element name="SPAN">
                            <xsl:attribute name="style">color: brown;</xsl:attribute>
                            <xsl:text>]</xsl:text>
                        </xsl:element>
                    </xsl:when>
                    <xsl:when test="contains($visning, 'study')">
                        <xsl:apply-templates select="child::tei:rdg[attribute::type='ospace2']"/>
                    </xsl:when>
                    <xsl:when test="contains($visning, 'norm')">
                        <xsl:apply-templates select="child::tei:rdg[attribute::type='ospace2']"/>
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
            <xsl:when test="attribute::type='s_S1'">
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
                    <xsl:when test="$handwriting = 'off'"></xsl:when>
                    <xsl:otherwise>
                        <xsl:choose>
                            <xsl:when test="contains($typo, 'hide')"/>
                            <xsl:otherwise>
                                <xsl:element name="SPAN">
                                    <xsl:apply-templates/>
                                </xsl:element>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="attribute::type='on2_h'">
                <xsl:choose>
                    <xsl:when test="$handwriting = 'off'"></xsl:when>
                    <xsl:otherwise>
                        <xsl:choose>
                            <xsl:when test="contains($typo, 'hide')"/>
                            <xsl:otherwise>
                                <xsl:element name="SPAN">
                                    <xsl:apply-templates/>
                                </xsl:element>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="attribute::type='on_S11'">
                <xsl:choose>
                    <xsl:when test="$handwriting = 'off'"></xsl:when>
                    <xsl:otherwise>
                        <xsl:choose>
                            <xsl:when test="contains($typo, 'hide')"/>
                            <xsl:otherwise>
                                <xsl:element name="SPAN">
                                    <xsl:apply-templates/>
                                </xsl:element>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="attribute::type='on_S12'">
                <xsl:choose>
                    <xsl:when test="$handwriting = 'off'"></xsl:when>
                    <xsl:otherwise>
                        <xsl:choose>
                            <xsl:when test="contains($typo, 'hide')"/>
                            <xsl:otherwise>
                                <xsl:element name="SPAN">
                                    <xsl:apply-templates/>
                                </xsl:element>
                            </xsl:otherwise>
                        </xsl:choose>
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
                    <xsl:when test="contains($typo, 'hide')">
                        <xsl:choose>
                            <xsl:when test="contains($visning, 'dipl')">
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">color: #000000; text-decoration: line-through;</xsl:attribute>
                                    <xsl:apply-templates/>
                                </xsl:element>
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">vertical-align: super; color: #FF0000;</xsl:attribute>
                                    <xsl:text>ch</xsl:text>
                                </xsl:element>
                            </xsl:when>
                            <xsl:when test="contains($visning, 'study')">
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">color: #000000; text-decoration: line-through;</xsl:attribute>
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
            <xsl:when test="attribute::type='d_h'">
                <xsl:choose>
                    <xsl:when test="$handwriting = 'off'"></xsl:when>
                    <xsl:otherwise>
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
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="attribute::type='d_H1'">
                <xsl:choose>
                    <xsl:when test="$handwriting = 'off'"></xsl:when>
                    <xsl:otherwise>
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
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="attribute::type='d_h_c'"><!-- Sjekk visning -->
                <xsl:choose>
                    <xsl:when test="$handwriting = 'off'"></xsl:when>
                    <xsl:otherwise>
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
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="attribute::type='d_h_ch'">
                <xsl:choose>
                    <xsl:when test="$handwriting = 'off'"></xsl:when>
                    <xsl:otherwise>
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
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="attribute::type='d_S1'">
                <xsl:choose>
                    <xsl:when test="$handwriting = 'off'"></xsl:when>
                    <xsl:otherwise>
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
                    <xsl:when test="$handwriting = 'off'"></xsl:when>
                    <xsl:otherwise>
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
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="attribute::type='dn_H1'">
                <xsl:choose>
                    <xsl:when test="$handwriting = 'off'"></xsl:when>
                    <xsl:otherwise>
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
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="attribute::type='dn_S1'">
                <xsl:choose>
                    <xsl:when test="$handwriting = 'off'"></xsl:when>
                    <xsl:otherwise>
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
                    <xsl:when test="$handwriting = 'off'"></xsl:when>
                    <xsl:otherwise>
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
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="attribute::type='dnpc_H1'">
                <xsl:choose>
                    <xsl:when test="$handwriting = 'off'"></xsl:when>
                    <xsl:otherwise>
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
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="attribute::type='dnpc_S1'">
                <xsl:choose>
                    <xsl:when test="$handwriting = 'off'"></xsl:when>
                    <xsl:otherwise>
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
                    <xsl:when test="attribute::type='trco'">
                        <xsl:apply-templates select="child::tei:orig[attribute::type='trco1']"/>
                    </xsl:when>
                    <xsl:when test="attribute::type='trcon'">
                        <xsl:apply-templates select="child::tei:orig[attribute::type='trcon1']"/>
                    </xsl:when>
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
                                            <xsl:text>&#x21D3;</xsl:text>
                                        </xsl:element>
                                    </xsl:when>
                                    <xsl:when test="contains($npc, 'norm')">
                                        <xsl:element name="SPAN">
                                            <xsl:attribute name="style">color: #FF0000;</xsl:attribute>
                                            <xsl:text>&#x21D3;</xsl:text>
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
                                            <xsl:text>&#x21D3;</xsl:text>
                                        </xsl:element>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:element name="SPAN">
                                            <xsl:attribute name="style">color: #FF0000;</xsl:attribute>
                                            <xsl:text>&#x21D3;</xsl:text>
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
                                            <xsl:text>&#x21D3;</xsl:text>
                                        </xsl:element>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:element name="SPAN">
                                            <xsl:attribute name="style">color: #FF0000;</xsl:attribute>
                                            <xsl:text>&#x21D3;</xsl:text>
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
                                            <xsl:text>&#x21D3;</xsl:text>
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
                                            <xsl:text>&#x21D3;</xsl:text>
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
                                            <xsl:text>&#x21D3;</xsl:text>
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
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="tei:emph">
        <xsl:choose>
            <xsl:when test="attribute::rend='arrback'">
                <xsl:element name="SPAN">
                    <xsl:attribute name="style">background-color: #CC77FF; font-family: Arial Unicode MS;</xsl:attribute>
                    <xsl:text>&#x21BA;</xsl:text>
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:when>
            <xsl:when test="attribute::rend='arrback_h'">
                <xsl:choose>
                    <xsl:when test="$handwriting = 'off'"></xsl:when>
                    <xsl:otherwise>
                        <xsl:element name="SPAN">
                            <xsl:attribute name="style">background-color: #CC77FF; font-family: Arial Unicode MS;</xsl:attribute>
                            <xsl:text>&#x21BA;</xsl:text>
                            <xsl:apply-templates/>
                        </xsl:element>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="attribute::rend='arrforward'">
                <xsl:element name="SPAN">
                    <xsl:attribute name="style">background-color: #CC77FF; font-family: Arial Unicode MS;</xsl:attribute>
                    <xsl:text>&#x21BB;</xsl:text>
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:when>
            <xsl:when test="attribute::rend='arrforward_h'">
                <xsl:choose>
                    <xsl:when test="$handwriting = 'off'"></xsl:when>
                    <xsl:otherwise>
                        <xsl:element name="SPAN">
                            <xsl:attribute name="style">background-color: #CC77FF; font-family: Arial Unicode MS;</xsl:attribute>
                            <xsl:text>&#x21BB;</xsl:text>
                            <xsl:apply-templates/>
                        </xsl:element>
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
                    <xsl:when test="$handwriting = 'off'"></xsl:when>
                    <xsl:otherwise>
                        <xsl:element name="SPAN">
                            <xsl:attribute name="style">background-color: #BEBEBE;</xsl:attribute>
                            <xsl:apply-templates/>
                        </xsl:element>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="attribute::rend='clilm'">
                <xsl:element name="SPAN">
                    <xsl:attribute name="style">background-color: #BEBEBE;</xsl:attribute>
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:when>
            <xsl:when test="attribute::rend='clilm_h'">
                <xsl:choose>
                    <xsl:when test="$handwriting = 'off'"></xsl:when>
                    <xsl:otherwise>
                        <xsl:choose>
                            <xsl:when test="contains($typo, 'hide')"/>
                            <xsl:otherwise>
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">background-color: #BEBEBE;</xsl:attribute>
                                    <xsl:apply-templates/>
                                </xsl:element>
                            </xsl:otherwise>
                        </xsl:choose>                  
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
                    <xsl:when test="$handwriting = 'off'"></xsl:when>
                    <xsl:otherwise>
                        <xsl:choose>
                            <xsl:when test="contains($typo, 'hide')"/>
                            <xsl:otherwise>
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">background-color: #BEBEBE;</xsl:attribute>
                                    <xsl:apply-templates/>
                                </xsl:element>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="attribute::rend='clirm_h_ch'"><!-- Sjekk visning. OK AP 2008-10-01 -->
                <xsl:choose>
                    <xsl:when test="$handwriting = 'off'"></xsl:when>
                    <xsl:otherwise>
                        <xsl:choose>
                            <xsl:when test="contains($typo, 'hide')"/>
                            <xsl:otherwise>
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">background-color: #BEBEBE;</xsl:attribute>
                                    <xsl:apply-templates/>
                                </xsl:element>
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
                                    <xsl:text>&#x2195;</xsl:text>
                                    <!--<xsl:text>&#x2336;</xsl:text>-->
                                </xsl:element>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text>&#x2195;</xsl:text>
                        <!--<xsl:text>&#x2336;</xsl:text>-->
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="attribute::rend='crossed'"><!-- Sjekk visning -->
                <xsl:element name="SPAN">
                    <xsl:attribute name="style">background-color: #BEBEBE;</xsl:attribute>
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:when>
            <xsl:when test="attribute::rend='crossed_h'"><!-- Sjekk visning -->
                <xsl:choose>
                    <xsl:when test="$handwriting = 'off'"></xsl:when>
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
                    <xsl:when test="$handwriting = 'off'"></xsl:when>
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
                    <xsl:when test="$handwriting = 'off'"></xsl:when>
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
                    <xsl:when test="$handwriting = 'off'"></xsl:when>
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
                    <xsl:when test="$handwriting = 'off'"></xsl:when>
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
                    <xsl:when test="$handwriting = 'off'"></xsl:when>
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
                    <xsl:when test="$handwriting = 'off'"></xsl:when>
                    <xsl:otherwise>
                        <xsl:element name="SPAN">
                            <xsl:attribute name="style">background-color: #CC77FF;</xsl:attribute>
                            <xsl:text>&#x2022;</xsl:text>
                        </xsl:element>
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
                    <xsl:when test="$handwriting = 'off'"></xsl:when>
                    <xsl:otherwise>
                        <xsl:element name="SPAN">
                            <xsl:attribute name="style">background-color: #CC77FF;</xsl:attribute>
                            <xsl:text>&#x2022;</xsl:text>
                        </xsl:element>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="attribute::rend='H'"><!-- Sjekk koding -->
                <xsl:element name="SPAN">
                    <xsl:attribute name="style">background-color: #BEBEBE;</xsl:attribute>
                    <xsl:apply-templates/>
                </xsl:element>
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
            <xsl:when test="attribute::rend='qmlm_h'"><!-- Sjekk visning -->
                <xsl:choose>
                    <xsl:when test="$handwriting = 'off'"></xsl:when>
                    <xsl:otherwise>
                        <xsl:element name="SPAN">
                            <xsl:attribute name="style">background-color: #BEBEBE; color: #0000FF;</xsl:attribute>
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
            <xsl:when test="attribute::rend='qmrm_h'"><!-- Sjekk visning -->
                <xsl:choose>
                    <xsl:when test="$handwriting = 'off'"></xsl:when>
                    <xsl:otherwise>
                        <xsl:element name="SPAN">
                            <xsl:attribute name="style">background-color: #BEBEBE; color: #0000FF;</xsl:attribute>
                            <xsl:apply-templates/>
                        </xsl:element>
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
                <xsl:element name="DIV">
                    <xsl:attribute name="style">border: 2px solid purple; display: inline-block;</xsl:attribute>
                    <xsl:attribute name="width">100%</xsl:attribute>
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:when>
            <xsl:when test="attribute::rend='ringed_h'"><!-- Sjekk visning -->
                <xsl:choose>
                    <xsl:when test="$handwriting = 'off'"></xsl:when>
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
                <xsl:element name="SPAN">
                    <xsl:attribute name="style">background-color: #BEBEBE;</xsl:attribute>
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:when>
            <xsl:when test="attribute::rend='slilm_h'">
                <xsl:choose>
                    <xsl:when test="$handwriting = 'off'"></xsl:when>
                    <xsl:otherwise>
                        <xsl:choose>
                            <xsl:when test="contains($typo, 'hide')"/>
                            <xsl:otherwise>
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">background-color: #BEBEBE;</xsl:attribute>
                                    <xsl:apply-templates/>
                                </xsl:element>
                            </xsl:otherwise>
                        </xsl:choose>
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
                    <xsl:when test="$handwriting = 'off'"></xsl:when>
                    <xsl:otherwise>
                        <xsl:choose>
                            <xsl:when test="contains($typo, 'hide')"/>
                            <xsl:otherwise>
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">background-color: #BEBEBE;</xsl:attribute>
                                    <xsl:apply-templates/>
                                </xsl:element>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="attribute::rend='space'">
                <xsl:text>&nbsp;&nbsp;</xsl:text>
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
                    <xsl:when test="$handwriting = 'off'"></xsl:when>
                    <xsl:otherwise>
                        <xsl:element name="SPAN">
                            <xsl:attribute name="style">background-color: #CC77FF;</xsl:attribute>
                            <xsl:text>&#x2022;</xsl:text>
                        </xsl:element>
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
                    <xsl:when test="$handwriting = 'off'"></xsl:when>
                    <xsl:otherwise>
                        <xsl:element name="SPAN">
                            <xsl:attribute name="style">background-color: #CC77FF;</xsl:attribute>
                            <xsl:text>&#x2022;</xsl:text>
                        </xsl:element>
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
                    <xsl:when test="$handwriting = 'off'"></xsl:when>
                    <xsl:otherwise>
                        <xsl:choose>
                            <xsl:when test="contains($typo, 'hide')"/>
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
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="attribute::rend='us1_h_ch'">
                <xsl:choose>
                    <xsl:when test="$handwriting = 'off'"></xsl:when>
                    <xsl:otherwise>
                        <xsl:choose>
                            <xsl:when test="contains($typo, 'hide')"/>
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
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="attribute::rend='us1_ch'">
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
                    <xsl:when test="$handwriting = 'off'"></xsl:when>
                    <xsl:otherwise>
                        <xsl:choose>
                            <xsl:when test="contains($typo, 'hide')"/>
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
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="attribute::rend='us1_X'">
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
                    <xsl:when test="$handwriting = 'off'"></xsl:when>
                    <xsl:otherwise>
                        <xsl:choose>
                            <xsl:when test="contains($typo, 'hide')"/>
                            <xsl:otherwise>
                                <xsl:choose>
                                    <xsl:when test="contains($visning, 'dipl')">
                                        <xsl:element name="SPAN">
                                            <xsl:attribute name="style">border-bottom-width: thin; border-bottom-color: #0000FF; border-bottom-style: double;</xsl:attribute>
                                            <xsl:apply-templates/>
                                        </xsl:element>
                                    </xsl:when>
                                    <xsl:when test="contains($visning, 'study')">
                                        <xsl:element name="SPAN">
                                            <xsl:attribute name="style">border-bottom-width: thin; border-bottom-color: #0000FF; border-bottom-style: double;</xsl:attribute>
                                            <xsl:apply-templates/>
                                        </xsl:element>
                                    </xsl:when>
                                    <xsl:when test="contains($visning, 'norm')">
                                        <xsl:element name="SPAN">
                                            <xsl:attribute name="style">border-bottom-width: thin; border-bottom-color: #0000FF; border-bottom-style: double;</xsl:attribute>
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
                    <xsl:when test="$handwriting = 'off'"></xsl:when>
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
                    <xsl:when test="$handwriting = 'off'"></xsl:when>
                    <xsl:otherwise>
                        <xsl:choose>
                            <xsl:when test="contains($typo, 'hide')"/>
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
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="attribute::rend='uw1_H1'">
                <xsl:choose>
                    <xsl:when test="$handwriting = 'off'"></xsl:when>
                    <xsl:otherwise>
                        <xsl:choose>
                            <xsl:when test="contains($typo, 'hide')"/>
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
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="attribute::rend='uw1_S1'">
                <xsl:choose>
                    <xsl:when test="$handwriting = 'off'"></xsl:when>
                    <xsl:otherwise>
                        <xsl:choose>
                            <xsl:when test="contains($typo, 'hide')"/>
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
                    <xsl:when test="$handwriting = 'off'"></xsl:when>
                    <xsl:otherwise>
                        <xsl:choose>
                            <xsl:when test="contains($typo, 'hide')"/>
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
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="attribute::rend='vdline'">
                <xsl:element name="SPAN">
                    <xsl:attribute name="style">background-color: #BEBEBE; display: block;</xsl:attribute>
                    <xsl:apply-templates/>
                </xsl:element>
                <xsl:element name="SPAN">
                    <xsl:attribute name="style">color: #FF0000;</xsl:attribute>
                    <xsl:element name="SUP">
                        <xsl:text>[c]</xsl:text>
                    </xsl:element>
                </xsl:element>
            </xsl:when>
            <xsl:when test="attribute::rend='vdline_c'">
                <xsl:element name="SPAN">
                    <xsl:attribute name="style">background-color: #BEBEBE; display: block;</xsl:attribute>
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:when>
            <xsl:when test="attribute::rend='vdline_h'">
                <xsl:choose>
                    <xsl:when test="$handwriting = 'off'"></xsl:when>
                    <xsl:otherwise>
                        <xsl:element name="SPAN">
                            <xsl:attribute name="style">background-color: #BEBEBE; display: block;</xsl:attribute>
                            <xsl:apply-templates/>
                        </xsl:element>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="attribute::rend='vdline_h_ch'"><!-- Sjekk visning -->
                <xsl:choose>
                    <xsl:when test="$handwriting = 'off'"></xsl:when>
                    <xsl:otherwise>
                        <xsl:element name="SPAN">
                            <xsl:attribute name="style">background-color: #BEBEBE; display: block;</xsl:attribute>
                            <xsl:apply-templates/>
                        </xsl:element>
                        <xsl:element name="SUP">
                            <xsl:attribute name="style">color: #FF0000;</xsl:attribute>
                            <xsl:text>ch</xsl:text>
                        </xsl:element>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="attribute::rend='vdline_S1'">
                <xsl:choose>
                    <xsl:when test="$handwriting = 'off'"></xsl:when>
                    <xsl:otherwise>
                        <xsl:element name="SPAN">
                            <xsl:attribute name="style">background-color: #BEBEBE; display: block;</xsl:attribute>
                            <xsl:apply-templates/>
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
            <xsl:when test="attribute::rend='wlilm_c'">
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
                    <xsl:when test="$handwriting = 'off'"></xsl:when>
                    <xsl:otherwise>
                        <xsl:choose>
                            <xsl:when test="contains($typo, 'hide')"/>
                            <xsl:otherwise>
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">background-color: #BEBEBE;</xsl:attribute>
                                    <xsl:apply-templates/>
                                </xsl:element>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="attribute::rend='wlilm_S1'">
                <xsl:choose>
                    <xsl:when test="$handwriting = 'off'"></xsl:when>
                    <xsl:otherwise>
                        <xsl:choose>
                            <xsl:when test="contains($typo, 'hide')"/>
                            <xsl:otherwise>
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">background-color: #BEBEBE;</xsl:attribute>
                                    <xsl:apply-templates/>
                                </xsl:element>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="attribute::rend='wlirm'">
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
                <xsl:choose>
                    <xsl:when test="$handwriting = 'off'"></xsl:when>
                    <xsl:otherwise>
                        <xsl:choose>
                            <xsl:when test="contains($typo, 'hide')"/>
                            <xsl:otherwise>
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">background-color: #BEBEBE;</xsl:attribute>
                                    <xsl:apply-templates/>
                                </xsl:element>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="attribute::rend='wlirm_h_ch'">
                <xsl:choose>
                    <xsl:when test="$handwriting = 'off'"></xsl:when>
                    <xsl:otherwise>
                        <xsl:choose>
                            <xsl:when test="contains($typo, 'hide')"/>
                            <xsl:otherwise>
                                <xsl:element name="SPAN">
                                    <xsl:attribute name="style">background-color: #BEBEBE;</xsl:attribute>
                                    <xsl:apply-templates/>
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
                    <xsl:attribute name="style">background-color: #BEBEBE; display: block;</xsl:attribute>
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:when>
            <xsl:when test="attribute::rend='zigzaglm_h'"><!--  Sjekk koding -->
                <xsl:choose>
                    <xsl:when test="$handwriting = 'off'"></xsl:when>
                    <xsl:otherwise>
                        <xsl:element name="SPAN">
                            <xsl:attribute name="style">background-color: #BEBEBE; display: block;</xsl:attribute>
                            <xsl:apply-templates/>
                        </xsl:element>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="attribute::rend='zigzagrm'"><!--  Sjekk koding -->
                <xsl:element name="SPAN">
                    <xsl:attribute name="style">background-color: #BEBEBE; display: block;</xsl:attribute>
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:when>
            <xsl:when test="attribute::rend='zigzagrm_h'"><!--  Sjekk koding -->
                <xsl:choose>
                    <xsl:when test="$handwriting = 'off'"></xsl:when>
                    <xsl:otherwise>
                        <xsl:element name="SPAN">
                            <xsl:attribute name="style">background-color: #BEBEBE; display: block;</xsl:attribute>
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
    
    <xsl:template match="tei:gap">
        <xsl:choose>
            <xsl:when test="attribute::extent">
                <xsl:choose>
                    <xsl:when test="contains(attribute::extent, 'words')">
                        <xsl:text>&#x21D3;</xsl:text>
                    </xsl:when>
                    <xsl:when test="contains(attribute::extent, 'lines')">
                        <xsl:text>&#x21D3;</xsl:text>
                    </xsl:when>
                    <xsl:when test="contains(attribute::extent, 'characters')">
                        <xsl:text>&#x21D3;</xsl:text>
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
                    <xsl:when test="contains(attribute::type, 'fetch')"></xsl:when>
                    <xsl:when test="contains(attribute::type, 'relocate')">
                        <xsl:apply-templates/>
                    </xsl:when>
                    <xsl:when test="attribute::type='reloc1'">
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
                    <xsl:when test="contains(attribute::type, 'fetch')"></xsl:when>
                    <xsl:when test="contains(attribute::type, 'relocate')">
                        <xsl:apply-templates/>
                    </xsl:when>
                    <xsl:when test="attribute::type='reloc1'">
                        <!--<xsl:element name="SPAN">
                            <xsl:attribute name="style">color: #FF0000;</xsl:attribute>
                            <xsl:text>[to:</xsl:text>
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
                            </xsl:element>-->
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
                    <xsl:when test="attribute::type='reloc2'">
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
                        <!--                        <xsl:element name="SPAN">
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
                            <xsl:apply-templates/>
                            <xsl:element name="SPAN">
                            <xsl:attribute name="style">color: #FF0000;</xsl:attribute>
                            <xsl:text>]</xsl:text>
                            </xsl:element>-->
                    </xsl:when>
                    <xsl:otherwise/>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="contains($visning, 'norm')">
                <xsl:choose>
                    <xsl:when test="contains(attribute::type, 'fetch')"></xsl:when>
                    <xsl:when test="contains(attribute::type, 'relocate')">
                        <xsl:apply-templates/>
                    </xsl:when>
                    <xsl:when test="attribute::type='reloc1'">
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
                    <xsl:when test="attribute::type='reloc2'">
                        <xsl:element name="A">
                            <xsl:attribute name="name">
                                <xsl:value-of select="substring-after(attribute::n, '_')"/>
                            </xsl:attribute>
                        </xsl:element>
                        <xsl:element name="SPAN">
                            <xsl:attribute name="style">font-size: 10pt;</xsl:attribute>
                            <xsl:element name="A">
                                <xsl:attribute name="style">text-decoration: none; color: #CC77FF; font-family: Arial Unicode MS;</xsl:attribute>
                                <xsl:attribute name="href">
                                    <xsl:text>#</xsl:text>
                                    <xsl:value-of select="substring-before(attribute::n, '_')"/>
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
    
    <!-- lagt til av AP 26.10.-->
    
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
                                <xsl:attribute name="style">text-decoration: none;</xsl:attribute>
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
                                <xsl:attribute name="style">text-decoration: none;</xsl:attribute>
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
                                <xsl:attribute name="style">text-decoration: none;</xsl:attribute>
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
                                <xsl:attribute name="style">text-decoration: none;</xsl:attribute>
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
                                <xsl:attribute name="style">text-decoration: none;</xsl:attribute>
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
                                <xsl:attribute name="style">text-decoration: none;</xsl:attribute>
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
    
</xsl:stylesheet>
