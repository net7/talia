<?xml version="1.0" encoding="utf-8"?>
<!-- $Date: 
Text Encoding Initiative Consortium XSLT stylesheet family
2001/10/01 $, $Revision: 1.10 $, $Author: rahtz $

XSL stylesheet to format TEI XML documents using ODD markup

 
Copyright 1999-2005 Sebastian Rahtz / Text Encoding Initiative Consortium
    This is an XSLT stylesheet for transforming TEI (version P4) XML documents

    Version 4.3.5. Date Thu Mar 10 16:22:09 GMT 2005

    This library is free software; you can redistribute it and/or
    modify it under the terms of the GNU Lesser General Public
    License as published by the Free Software Foundation; either
    version 2.1 of the License, or (at your option) any later version.

    This library is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
    Lesser General Public License for more details.

    You should have received a copy of the GNU Lesser General Public
    License along with this library; if not, write to the Free Software
    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA

    The author may be contacted via the e-mail address

    sebastian.rahtz@computing-services.oxford.ac.uk-->
<xsl:stylesheet 
 xmlns:rng="http://relaxng.org/ns/structure/1.0"
  xmlns:eg="http://www.tei-c.org/ns/Examples"
  xmlns:tei="http://www.tei-c.org/ns/1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:exsl="http://exslt.org/common"
  xmlns:estr="http://exslt.org/strings"
  extension-element-prefixes="exsl estr"
  exclude-result-prefixes="tei exsl estr" 
  version="1.0">
<xsl:import href="../common/teicommon.xsl"/>
<xsl:import href="teiodds.xsl"/>

<xsl:param
    name="TEISERVER">http://localhost/TEI/Roma/xquery/</xsl:param>

<xsl:key name="MODS" match="moduleSpec" use="@ident"/>
<xsl:key name="SPECS" match="specGrp" use="@id"/>
<xsl:key name="LOCAL"
	 match="classSpec|elementSpec|macroSpec" use="@ident"/>
<xsl:key name="LOCALATT"
	 match="attDef" use="concat(../../@ident,'::',@ident)"/>
<xsl:output method="xml" indent="yes"/>
<xsl:param name="verbose"></xsl:param>

<xsl:variable name="MAIN" select="/"/>

<xsl:template match="text">
  <text>
    <xsl:apply-templates/>
    <xsl:if test="not(back)">
      <back>
	<xsl:call-template name="CAT"/>
      </back>
    </xsl:if>
  </text>
</xsl:template>

<xsl:template match="body">
  <body>
    <div0>
      <head><xsl:call-template name="generateTitle"/></head>
      <xsl:apply-templates/>
    </div0>
  </body>
</xsl:template>



<xsl:template match="back">
  <xsl:apply-templates/>
  <xsl:call-template name="CAT"/>
</xsl:template>

<xsl:template name="CAT">
  <div1 xml:id="REFCLA">
    <head>Class catalogue</head>
    <divGen type="classcat"/>
  </div1>
  <div1 xml:id="REFENT">
    <head>Macro catalogue</head>
    <divGen type="macrocat"/>
  </div1>
  <div1 xml:id="REFTAG">
    <head>Element catalogue</head>
    <divGen type="tagcat"/>
  </div1>
</xsl:template>

<xsl:template match="schemaSpec">
  <div>
    <head>Schema [<xsl:value-of select="@ident"/>]</head>
    <eg>
      <xsl:apply-templates mode="verbatim"/>
    </eg>
    <xsl:apply-templates select="specGrp"/>
    <xsl:apply-templates select="moduleRef"/>
    <xsl:apply-templates select="*[@mode='add']"/>
  </div>
</xsl:template>


<xsl:template match="moduleRef">
  <xsl:variable name="test" select="@key"/>
  <xsl:call-template name="findNames">
    <xsl:with-param name="modname">
      <xsl:value-of select="$test"/>
    </xsl:with-param>
  </xsl:call-template>
</xsl:template>

<xsl:template name="findNames">
  <xsl:param name="modname"/>
  <xsl:variable name="HERE" select="."/>
  <xsl:variable name="loc">
    <xsl:value-of select="$TEISERVER"/>
    <xsl:text>allbymod.xq?module=</xsl:text>
    <xsl:value-of select="$modname"/>
  </xsl:variable>
  <xsl:for-each select="document($loc)/List/*">
      <xsl:call-template name="processThing"/>
  </xsl:for-each>
</xsl:template>

<xsl:template name="processThing">
  <xsl:variable name="me" select="@ident"/>
  <xsl:variable name="here" select="."/>
  <xsl:for-each select="$MAIN">
  <xsl:choose>
    <xsl:when test="key('LOCAL',$me)">
      <xsl:for-each select="key('LOCAL',$me)">
	<xsl:choose>
	  <xsl:when test="@mode='delete'"/>
	  <xsl:when test="@mode='change'">
	    <xsl:for-each select="$here">
	      <xsl:apply-templates select="." mode="change"/>
	    </xsl:for-each>
	  </xsl:when>
	  <xsl:otherwise>
	    <xsl:for-each select="$here">
	      <xsl:apply-templates select="." mode="copy"/>
	    </xsl:for-each>
	  </xsl:otherwise>
	</xsl:choose>
      </xsl:for-each>
    </xsl:when>
    <xsl:otherwise>
      <xsl:for-each select="$here">
	<xsl:apply-templates select="."  mode="copy"/>
      </xsl:for-each>
    </xsl:otherwise>
  </xsl:choose>
  </xsl:for-each>
</xsl:template>

<xsl:template match="@mode"/>

<xsl:template match="elementSpec|classSpec|macroSpec"
	      mode="add">
  <xsl:copy-of select="."/>
</xsl:template>

<xsl:template match="elementSpec|classSpec|macroSpec" mode="change">
  <xsl:variable name="me" select="@ident"/>
  <xsl:copy>
    <xsl:apply-templates select="@*" mode="change"/>
    <xsl:for-each select="$MAIN">
      <xsl:for-each select="key('LOCAL',$me)">
	<xsl:choose>
	  <xsl:when test="@mode='delete'"/>
	  <xsl:when test="@mode='replace'">
	    <xsl:copy-of select="."/>
	  </xsl:when>
	  <xsl:otherwise>
	    <xsl:copy-of select="altIdent"/>
	  </xsl:otherwise>
	</xsl:choose>
      </xsl:for-each>
    </xsl:for-each>
    <xsl:apply-templates select="*|text()|comment()" mode="change"/>
  </xsl:copy>
</xsl:template>

<xsl:template match="attDef"      mode="change">
  <xsl:variable name="me" select="concat(../../@ident,'::',@ident)"/>
  <xsl:copy>
    <xsl:apply-templates select="@*" mode="change"/>
    <xsl:for-each select="$MAIN">
      <xsl:for-each select="key('LOCALATT',$me)">
	<xsl:choose>
	  <xsl:when test="@mode='delete'"/>
	  <xsl:when test="@mode='replace'">
	    <xsl:copy-of select="."/>
	  </xsl:when>
	  <xsl:otherwise>
	    <xsl:copy-of select="altIdent"/>
	  </xsl:otherwise>
	</xsl:choose>
      </xsl:for-each>
    </xsl:for-each>
    <xsl:apply-templates select="*|eg:*|text()|comment()" mode="change"/>
  </xsl:copy>
</xsl:template>

<xsl:template match="attList"  mode="change">
  <xsl:variable name="me" select="../@ident"/>
  <xsl:copy>
    <xsl:apply-templates select="@*" mode="change"/>
    <xsl:for-each select="$MAIN">
      <xsl:for-each select="key('LOCAL',$me)/attList">
	<xsl:copy-of select="attDef[@mode='add']"/>
      </xsl:for-each>
    </xsl:for-each>
    <xsl:apply-templates select="*|text()|comment()" mode="change"/>
  </xsl:copy>
</xsl:template>

<xsl:template match="*">
  <xsl:copy>
    <xsl:apply-templates select="@*|*|rng:*|eg:*|text()|comment()"/>
  </xsl:copy>
</xsl:template>

<xsl:template match="@*|comment()|text()" mode="change">
  <xsl:copy/>
</xsl:template>

<xsl:template match="@*|comment()">
  <xsl:copy/>
</xsl:template>

<xsl:template match="text()">
  <xsl:copy-of select="."/>
</xsl:template>

<xsl:template match="eg:*" mode="change">
<xsl:copy-of select="."/>
</xsl:template>

<xsl:template match="eg:*">
<xsl:copy-of select="."/>
</xsl:template>

<xsl:template match="rng:*">
<xsl:copy-of select="."/>
</xsl:template>

<xsl:template match="rng:*" mode="copy">
<xsl:copy-of select="."/>
</xsl:template>


<xsl:template match="*|rng:*" mode="change">
  <xsl:if test="not(@mode='delete')">
    <xsl:copy>
      <xsl:apply-templates select="@*|*|text()|comment()" mode="change"/>
    </xsl:copy>
  </xsl:if>
</xsl:template>


<xsl:template match="*|@*|processing-instruction()|text()" mode="copy">
 <xsl:copy>
  <xsl:apply-templates
   select="*|@*|processing-instruction()|comment()|text()" mode="copy"/>
 </xsl:copy>
</xsl:template>

<xsl:template name="verbatim">
  <xsl:param name="text"/>
  <xsl:param name="startnewline">false</xsl:param>
  <xsl:param name="autowrap">true</xsl:param>
     <pre class="eg">
        <xsl:if test="$startnewline='true'">
         <xsl:text>&#10;</xsl:text>
       </xsl:if>
       <xsl:choose>
         <xsl:when test="$autowrap='false'">
           <xsl:value-of select="."/>
         </xsl:when>
       <xsl:otherwise>           
       <xsl:variable name="lines" select="estr:tokenize($text,'&#10;')"/>
           <xsl:apply-templates select="$lines[1]" 
                mode="normalline"/>
     </xsl:otherwise>
   </xsl:choose>
 </pre>
</xsl:template>

</xsl:stylesheet>
