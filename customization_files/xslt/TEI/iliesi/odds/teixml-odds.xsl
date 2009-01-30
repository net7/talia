<?xml version="1.0" encoding="utf-8"?>
<!--
Text Encoding Initiative Consortium XSLT stylesheet family
$Date: 2005/02/06 16:03:30 $, $Revision: 1.16 $, $Author: rahtz $

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
  xmlns:a="http://relaxng.org/ns/compatibility/annotations/1.0"
  xmlns:rng="http://relaxng.org/ns/structure/1.0"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" 
  xmlns:tei="http://www.tei-c.org/ns/1.0"
  xmlns:teix="http://www.tei-c.org/ns/Examples"
  xmlns:local="http://www.pantor.com/ns/local"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:fo="http://www.w3.org/1999/XSL/Format"
  xmlns:edate="http://exslt.org/dates-and-times"
  xmlns:exsl="http://exslt.org/common"
  xmlns:estr="http://exslt.org/strings"
  exclude-result-prefixes="exsl estr edate fo a tei rng local teix xs" 
  extension-element-prefixes="edate exsl estr"
  version="1.0">


<xsl:param name="oddmode">tei</xsl:param>
 <xsl:include href="teiodds.xsl"/>
 <xsl:include href="../common/teicommon.xsl"/>
  <xsl:key name="FILES"   match="moduleSpec[@ident]"   use="@ident"/>
  <xsl:key name="IDS"     match="*[@id]"           use="@id"/>
  <xsl:key name="PATTERNS" match="macroSpec" use="@ident"/>
  <xsl:key name="MACRODOCS" match="macroSpec" use='1'/>
  <xsl:key name="CLASSDOCS" match="classSpec" use='1'/>
  <xsl:key name="TAGDOCS" match="elementSpec" use='1'/>
  <xsl:variable name="uc">ABCDEFGHIJKLMNOPQRSTUVWXYZ</xsl:variable>
  <xsl:variable name="lc">abcdefghijklmnopqrstuvwxyz</xsl:variable>

<xsl:param name="displayMode">rng</xsl:param>


<xsl:template match="val">
  <hi rend="val">  <xsl:apply-templates/></hi>
</xsl:template>

<xsl:template match="moduleRef">
  <ref target="#{@key}"/>
</xsl:template>

<xsl:template match="elementSpec">
   <xsl:if test="parent::specGrp">
   <label>Element: <xsl:value-of select="@ident"/></label>
   <item>
     <xsl:apply-templates select="." mode="tangle"/>
     </item>
   </xsl:if>
 </xsl:template>
 
<xsl:template match="classSpec">
   <xsl:if test="parent::specGrp">
   <label>Class: <xsl:value-of select="@ident"/></label>
   <item>
     <xsl:apply-templates select="." mode="tangle"/>
     </item>
   </xsl:if>
 </xsl:template>
 

<xsl:template match="macroSpec">
   <xsl:if test="parent::specGrp">
   <label>Macro: <xsl:value-of select="@ident"/></label>
   <item>
     <xsl:apply-templates select="." mode="tangle"/>
     </item>
   </xsl:if>
 </xsl:template>
 
<xsl:template  match="specGrpRef">
  <xsl:variable name="W">
    <xsl:choose>
      <xsl:when test="starts-with(@target,'#')">
	<xsl:value-of select="substring-after(@target,'#')"/>
      </xsl:when>
      <xsl:otherwise>
	<xsl:value-of select="@target"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
<xsl:choose>
  <xsl:when test="parent::specGrp">
    <label/><item>&#171; <emph>include
  <ref target="#{$W}"><xsl:for-each select="key('IDS',$W)">
    <xsl:number level="any"/>
    <xsl:if test="@n">
      <xsl:text>: </xsl:text><xsl:value-of select="@n"/>
    </xsl:if>
  </xsl:for-each></ref></emph>
  <xsl:text> &#187; </xsl:text></item>
  </xsl:when>
  <xsl:when test="parent::p">
    &#171; <emph>include
    <ref target="#{$W}"><xsl:for-each select="key('IDS',$W)">
      <xsl:number level="any"/>
      <xsl:if test="@n">
	<xsl:text>: </xsl:text><xsl:value-of select="@n"/>
      </xsl:if>
    </xsl:for-each></ref></emph>
    <xsl:text> &#187; </xsl:text>
  </xsl:when>
  <xsl:otherwise>
    <p>&#171; <emph>include
    <ref target="#{$W}"><xsl:for-each select="key('IDS',$W)">
      <xsl:number level="any"/>
      <xsl:if test="@n">
	<xsl:text>: </xsl:text><xsl:value-of select="@n"/>
      </xsl:if>
    </xsl:for-each></ref></emph>
    <xsl:text> &#187; </xsl:text></p>
  </xsl:otherwise>
</xsl:choose>
</xsl:template>

<xsl:template match="rng:*|*|@*|processing-instruction()|author|title">
 <xsl:copy>
  <xsl:apply-templates select="*|rng:*|@*|processing-instruction()|comment()|text()"/>
 </xsl:copy>
</xsl:template>

<xsl:template match="specGrp/p">
  <label/><item><xsl:apply-templates/></item>
</xsl:template>

<xsl:template match="altIdent"/>

<xsl:template match="attDef" mode="summary">
 <label><code><xsl:call-template name="identifyMe"/></code></label>
 <item>
   <xsl:apply-templates select="desc" mode="show"/>
   <xsl:apply-templates select="valList"/>
 </item>
</xsl:template>

<xsl:template match="attDef">
 <label><code><xsl:call-template name="identifyMe"/></code></label>
 <item>
   <xsl:apply-templates select="desc" mode="show"/>
   <xsl:apply-templates select="valList"/>
 </item>
</xsl:template>

<xsl:template match="attDef/datatype">
 <label>
   <emph>Datatype:</emph>
 </label>
 <item>
   <xsl:call-template name="Literal"/>
 </item>
</xsl:template>

<xsl:template match="attDef/exemplum">
 <label><emph>Example: </emph></label>
 <item>
 <xsl:call-template name="verbatim">
  <xsl:with-param name="text">
  <xsl:apply-templates/>
  </xsl:with-param>
</xsl:call-template>
</item>
</xsl:template>


<xsl:template match="attList" mode="show">
      <xsl:call-template name="displayAttList">
	<xsl:with-param name="mode">summary</xsl:with-param>
      </xsl:call-template>
</xsl:template>

<xsl:template match="attList" mode="summary">
<xsl:if test="attDef">
  <list type="gloss">
    <xsl:apply-templates mode="summary"/>
  </list>
</xsl:if>
</xsl:template>

<xsl:template match="attList[@org='choice']">
<label>Choice:</label>
<item>
  <list type="gloss">
    <xsl:apply-templates mode="summary"/>
  </list>
</item>
</xsl:template>

<xsl:template match="equiv" mode="weave">
  <xsl:if test="@name">
    <p><xsl:text> Equivalent</xsl:text>
    <xsl:if test="@uri"> in \texttt{<xsl:value-of select="@uri"/>}</xsl:if>
    <xsl:text>: </xsl:text>
    <xsl:value-of select="@name"/></p>
  </xsl:if>
</xsl:template>


<xsl:template match="attList" mode="weave">
  <p><emph>Attributes: </emph>
  <xsl:call-template name="displayAttList">
    <xsl:with-param name="mode">all</xsl:with-param>
  </xsl:call-template>
  </p>
</xsl:template>

<xsl:template match="body">
<xsl:copy>
  <xsl:apply-templates select="*|rng:*|@*|processing-instruction()|comment()|text()"/>
</xsl:copy>
</xsl:template>

<xsl:template match="classSpec" mode="weavebody">
  
  <xsl:apply-templates mode="weave"/>
  
  <p>    <emph>Member of classes</emph>
  <xsl:call-template name="generateClassParents"/>
  </p>
  
  <p><emph>Members</emph>
  <xsl:call-template name="generateMembers"/>
  </p>
  
  <xsl:call-template name="HTMLmakeTagsetInfo"/>
  
</xsl:template>


<xsl:template match="classes"  mode="weave">
  <xsl:if test="memberOf">
    <p><emph>Classes</emph>
      <xsl:for-each select="memberOf">
	<xsl:choose>
	  <xsl:when test="key('IDENTS',@key)">
	    <xsl:variable name="Key"><xsl:value-of select="@key"/></xsl:variable>
	    <xsl:for-each select="key('IDENTS',@key)">
	      <xsl:text>: </xsl:text>
	      <xsl:call-template name="linkTogether">
		<xsl:with-param name="name" select="@ident"/>
		<xsl:with-param name="url" select="@id"/>
	      </xsl:call-template>
	    </xsl:for-each>
	  </xsl:when>
	  <xsl:otherwise>
	    <xsl:text>: </xsl:text>
	    <xsl:value-of select="@key"/>
	  </xsl:otherwise>
	</xsl:choose>
      </xsl:for-each>
    </p>
  </xsl:if>
</xsl:template>

<xsl:template match="defaultVal">
  <label><emph>Default: </emph></label>
  <item>
    <xsl:apply-templates/>
  </item>
</xsl:template>

<xsl:template match="desc" mode="weave"/>

<xsl:template match="div0|div1|div2|div3|div4">
  <div>
    <xsl:apply-templates select="*|rng:*|@*|processing-instruction()|comment()|text()"/>
  </div>
</xsl:template>

<xsl:template match="elementSpec" mode="weavebody">
  <xsl:if test="not(attList)">
    <p><emph>Attributes: </emph>
      <xsl:choose>
	<xsl:when test="count(../classes/memberOf)&gt;0">
	  <xsl:text>Global attributes 
	  and those inherited from </xsl:text>
	  <xsl:for-each select="..">
	    <xsl:call-template name="generateClassParents"/>
	  </xsl:for-each>
	</xsl:when>
	<xsl:otherwise>
	  Global attributes only
	</xsl:otherwise>
      </xsl:choose>
    </p>
  </xsl:if>
  <xsl:apply-templates mode="weave"/>
  <xsl:call-template name="HTMLmakeTagsetInfo"/>
</xsl:template>

<xsl:template match="elementSpec/content" mode="weave">
<p><emph>Declaration: </emph>
  <xsl:call-template name="bitOut">
    <xsl:with-param name="grammar"></xsl:with-param>
    <xsl:with-param name="content">
      <Wrapper>
	<rng:element name="{../@ident}">
	  <rng:ref name="tei.global.attributes"/>
	  <xsl:for-each select="../classes/memberOf">
	    <xsl:for-each select="key('IDENTS',@key)">
	      <xsl:if test="attList">
		<rng:ref name="{@ident}.attributes"/>
	      </xsl:if>
	    </xsl:for-each>
	  </xsl:for-each>
	  <xsl:apply-templates
	   select="../attList" mode="tangle"/>
	  <xsl:copy-of select="rng:*"/>
	</rng:element>
      </Wrapper>
    </xsl:with-param>
  </xsl:call-template>
</p>
</xsl:template>

<xsl:template match="elementSpec/exemplum" mode="weave">
<p><emph>Example: </emph></p>
 <xsl:apply-templates/>
</xsl:template>

<xsl:template match="elementSpec|classSpec" mode="show">
  <xsl:param name="atts"/>
  <hi>&lt;<xsl:call-template name="identifyMe"/>&gt; </hi>
  <xsl:value-of select="desc"/>
  <xsl:choose>
    <xsl:when test="attList//attDef">
      <xsl:choose>
	<xsl:when test="not($atts='  ')">
	  Selected attributes: <list type="gloss">
	  <xsl:for-each select="attList//attDef">
	    <xsl:if test="contains($atts,concat(' ',@ident,' '))">
	      <label>
		<xsl:call-template name="identifyMe"/>
	      </label>
	      <item>
		<xsl:apply-templates select="desc" mode="show"/>
	      </item>
	    </xsl:if>
	  </xsl:for-each>
	  </list>
	</xsl:when>
	<xsl:otherwise>
	  <xsl:apply-templates select="attList" mode="summary"/>
	</xsl:otherwise>
      </xsl:choose>
    </xsl:when>
    <xsl:otherwise>
      <list>
	<item>
	  No attributes other than those globally
	  available (see definition for tei.global.attributes)
	</item>
      </list>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="equiv"/>

<xsl:template match="exemplum">
<p><emph>Example: </emph></p>
 <xsl:apply-templates/>
</xsl:template>



<xsl:template match="gloss" mode="weave"/>
<xsl:template match="gloss"/>

<xsl:template match="macroSpec" mode="weavebody">
      <xsl:apply-templates mode="weave"/>
      <xsl:call-template name="HTMLmakeTagsetInfo"/>
</xsl:template>

<xsl:template match="macroSpec/content" mode="weave">
  <p><emph>Declaration: </emph>
  <xsl:call-template name="bitOut">
    <xsl:with-param name="grammar">true</xsl:with-param>
    <xsl:with-param name="content">
      <Wrapper>
	<rng:define name="{../@ident}">
	  <xsl:if test="starts-with(.,'component')">
	    <xsl:attribute name="combine">choice</xsl:attribute>
	  </xsl:if>
	  <xsl:copy-of select="rng:*"/>
	</rng:define>
      </Wrapper>
    </xsl:with-param>
  </xsl:call-template>
  </p>
</xsl:template>

<xsl:template match="moduleSpec">
  <xsl:choose>
    <xsl:when test="parent::p">
      Module <emph><xsl:value-of select="@ident"/></emph>:
      <xsl:apply-templates select="desc"  mode="show"/>
    </xsl:when>
    <xsl:otherwise>
      <p>Module <emph><xsl:value-of select="@ident"/></emph>:
      <xsl:apply-templates select="desc"  mode="show"/></p>
    </xsl:otherwise>
  </xsl:choose>
  <list>
    <item>Elements defined:
    <xsl:for-each select="key('ElementModule',@ident)">
      <xsl:call-template name="linkTogether">
    <xsl:with-param name="url" select="@id"/>
    <xsl:with-param name="name" select="@ident"/>
      </xsl:call-template>
      <xsl:text>: </xsl:text>
    </xsl:for-each>
    </item>
    <item>Classes defined:
    <xsl:for-each select="key('ClassModule',@ident)">
      <xsl:call-template name="linkTogether">
	<xsl:with-param name="url" select="@id"/>
	<xsl:with-param name="name" select="@ident"/>
      </xsl:call-template>
      <xsl:text>: </xsl:text>
    </xsl:for-each>
    </item>
    <item>Macros defined:
    <xsl:for-each select="key('MacroModule',@ident)">
      <xsl:call-template name="linkTogether">
	<xsl:with-param name="url" select="@id"/>
	<xsl:with-param name="name" select="@ident"/>
      </xsl:call-template>
      <xsl:text>: </xsl:text>
    </xsl:for-each>
    </item>
  </list>
</xsl:template>

<xsl:template match="p">
  <p>
    <xsl:apply-templates/>
  </p>
</xsl:template>

<xsl:template match="remarks" mode="weave">
    <xsl:apply-templates/>
</xsl:template>

<xsl:template match="remarks">
  <xsl:if test="*//text()">
    <label>Notes: </label>
    <item><xsl:apply-templates/></item>
  </xsl:if>
</xsl:template>


<xsl:template match="schemaSpec">
  <div>
    <head>Schema <xsl:call-template name="identifyMe"/></head>
    <xsl:call-template name="processSchemaFragment"/>
  </div>
</xsl:template>

<xsl:template match="specDesc">
  <item>  
    <xsl:call-template name="processSpecDesc"/>
  </item>
</xsl:template>


<xsl:template match="specList">
<list rend="specList">
  <xsl:apply-templates/>
</list>
</xsl:template>


<xsl:template match="valDesc">
  <label><emph>Values: </emph></label>
  <item>
    <xsl:apply-templates/>
  </item>
</xsl:template>



<xsl:template match="valList" mode="contents">
      <xsl:choose>
        <xsl:when test="@type='semi'"> Suggested values include:</xsl:when>
        <xsl:when test="@type='open'"> Sample values include:</xsl:when>
        <xsl:when test="@type='closed'"> Legal values are:</xsl:when>
        <xsl:otherwise> Values are:</xsl:otherwise>
      </xsl:choose>
      <list type="gloss">
       <xsl:for-each select="valItem">
         <label><xsl:call-template name="identifyMe"/></label>
         <item>
               <xsl:value-of select="gloss"/>
	 </item>
        </xsl:for-each>
      </list>
</xsl:template>


<xsl:template match="valList">
    <xsl:apply-templates select="." mode="contents"/>
</xsl:template>

<xsl:template match="teix:egXML">
  <xsl:call-template name="verbatim">
    <xsl:with-param name="label">
      <xsl:if test="not(parent::exemplum)">
	<xsl:text>Example </xsl:text>
	<xsl:call-template name="compositeNumber"/>
      </xsl:if>
    </xsl:with-param>
    <xsl:with-param name="text">
      <xsl:apply-templates mode="verbatim"/>
    </xsl:with-param>
  </xsl:call-template>
</xsl:template>

<xsl:template name="HTMLmakeTagsetInfo">
  <p><emph>Module: </emph>
    <xsl:call-template name="makeTagsetInfo"/>
  </p>
</xsl:template>


<xsl:template name="Literal">
  <eg>
    <xsl:apply-templates mode="literal"/>
  </eg>
</xsl:template>



<xsl:template name="bitOut">
<xsl:param name="grammar"/>
<xsl:param name="content"/>
<xsl:param  name="element">eg</xsl:param> 
<q rend="eg">
<xsl:choose>
<xsl:when test="$displayMode='rng'">
  <xsl:for-each  select="exsl:node-set($content)/Wrapper">
    <xsl:apply-templates mode="verbatim"/>
  </xsl:for-each>
</xsl:when>
<xsl:when test="$displayMode='rnc'">
<xsl:call-template name="make-body-from-r-t-f">
  <xsl:with-param name="schema">
    <xsl:for-each  select="exsl:node-set($content)/Wrapper">
      <xsl:call-template name="make-compact-schema"/>
    </xsl:for-each>
  </xsl:with-param>
</xsl:call-template>
</xsl:when>
<xsl:otherwise>
  <xsl:for-each  select="exsl:node-set($content)/Wrapper">
    <xsl:apply-templates mode="verbatim"/>
  </xsl:for-each>
</xsl:otherwise>
</xsl:choose>
</q>
</xsl:template>

<xsl:template name="displayAttList">
<xsl:param name="mode"/>
	<xsl:choose>
	  <xsl:when test=".//attDef">
	    <xsl:choose>
	      <xsl:when test="count(../classes/memberOf)&gt;0">
		<xsl:text>(In addition to global attributes 
		and those inherited from </xsl:text>
		<xsl:for-each select="..">
		  <xsl:call-template name="generateClassParents"/>
		</xsl:for-each>
		<xsl:text>)</xsl:text>
	      </xsl:when>
	      <xsl:otherwise>
		(In addition to global attributes)        
	      </xsl:otherwise>
	    </xsl:choose>
	    <list type="gloss">
	      <xsl:choose>
		<xsl:when test="$mode='all'">
		  <xsl:apply-templates/>
		</xsl:when>
		<xsl:otherwise>
		  <xsl:apply-templates mode="summary"/>
		</xsl:otherwise>
	      </xsl:choose>
	    </list>
	  </xsl:when>
	  <xsl:otherwise>
	    <xsl:choose>
	      <xsl:when test="count(../classes/memberOf)&gt;0">
		<xsl:text>Global attributes 
		and those inherited from </xsl:text>
		<xsl:for-each select="..">
		  <xsl:call-template name="generateClassParents"/>
		</xsl:for-each>
	      </xsl:when>
	      <xsl:otherwise>
		Global attributes only
	      </xsl:otherwise>
	    </xsl:choose>
	  </xsl:otherwise>
	</xsl:choose>
</xsl:template>



<xsl:template name="embolden">
      <xsl:param name="text"/>
        <hi><xsl:copy-of select="$text"/></hi>
</xsl:template>


<xsl:template name="identifyMe">
  <xsl:choose>
    <xsl:when test="altIdent">
      <xsl:value-of select="altIdent"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="@ident"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="italicize">
  <xsl:param name="text"/>
    <emph><xsl:copy-of select="$text"/></emph>
</xsl:template>

<xsl:template name="logoFramePicture"/>

<xsl:template match="specGrp">
  <list type="gloss">
    <xsl:copy-of select="@id"/>
    <head>Specification group <xsl:number level="any"/></head>
    <xsl:apply-templates/>
  </list>
</xsl:template>

<xsl:template name="makeAnchor">
 <xsl:param name="name"/>
</xsl:template>

<xsl:template name="makeLink">
 <xsl:param name="class"/>
 <xsl:param name="id"/>
 <xsl:param name="name"/>
 <xsl:param name="text"/>
    <ref rend="{$class}" target="#{$name}"><xsl:copy-of  select="$text"/></ref>
</xsl:template>

<xsl:template name="refdoc">
  <xsl:param name="name"/>
  <xsl:if test="$verbose='true'">
    <xsl:message>   refdoc for <xsl:value-of select="name(.)"/> -  <xsl:value-of select="@ident"/> </xsl:message>
  </xsl:if>
    <div>
      <xsl:choose>
	<xsl:when test="@xml:id">
	  <xsl:copy-of select="@xml:id"/>
	</xsl:when>
	<xsl:otherwise>
	  <xsl:attribute name="id"
			 namespace="http://www.w3.org/XML/1998/namespace">
	  <xsl:value-of select="@ident"/>
	  </xsl:attribute>
	</xsl:otherwise>
      </xsl:choose>
      <head>
	<xsl:call-template name="identifyMe"/>
	[<xsl:value-of select="substring-before(local-name(.),'Spec')"/>]
      </head>
      <p><emph>Description: </emph>
      <xsl:apply-templates select="desc" mode="show"/></p>
      <xsl:apply-templates select="." mode="weavebody"/>
  </div>
</xsl:template>

<xsl:template name="teiStartHook"/>

<xsl:template name="ttembolden">
      <xsl:param name="text"/>
        <hi><code><xsl:copy-of select="$text"/></code></hi>
</xsl:template>

<xsl:template name="typewriter">
  <xsl:param name="text"/>
  <code>
    <xsl:copy-of select="$text"/>
  </code>
</xsl:template>


<xsl:template name="verbatim">
  <xsl:param name="label"/>
  <xsl:param name="text"/>
  <xsl:param name="startnewline">false</xsl:param>
  <xsl:param name="autowrap">false</xsl:param>
  <eg>
    <xsl:if test="not($label='')">
      <xsl:attribute name="n">
	<xsl:value-of select="$label"/>
      </xsl:attribute>
    </xsl:if>
    <xsl:if test="$startnewline='true'">
      <xsl:text>&#10;</xsl:text>
    </xsl:if>
    <xsl:choose>
      <xsl:when test="$autowrap='false'">
	<xsl:value-of select="$text"/>
      </xsl:when>
      <xsl:otherwise>           
	<xsl:variable name="lines" select="estr:tokenize($text,'&#10;')"/>
	<xsl:apply-templates select="$lines[1]" 
			     mode="normalline"/>
      </xsl:otherwise>
    </xsl:choose>
  </eg>
</xsl:template>

<xsl:template name="makeInternalLink">
  <xsl:param name="ptr"/>
  <xsl:param name="target"/>
  <xsl:param name="dest"/>
  <xsl:param name="body"/>
  <xsl:variable name="W">
    <xsl:choose>
      <xsl:when test="$target"><xsl:value-of select="$target"/></xsl:when>
      <xsl:otherwise>
	<xsl:value-of select="$dest"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:choose>
    <xsl:when test="not($body='')">
      <ref target="#{$W}"><xsl:value-of select="$body"/></ref>
    </xsl:when>
    <xsl:when test="$ptr='true'">
      <ptr target="#{$W}"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:apply-templates/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="makeExternalLink">
  <xsl:param name="ptr"/>
  <xsl:param name="dest"/>
  <xsl:choose>
    <xsl:when test="$ptr='true'">
      <ptr  target="{$dest}"/>
    </xsl:when>
    <xsl:otherwise>
      <ref  target="{$dest}">
	<xsl:apply-templates/>
      </ref>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="generateEndLink">
  <xsl:param name="where"/>
  <xsl:apply-templates select="$where"/>
</xsl:template>

</xsl:stylesheet>
