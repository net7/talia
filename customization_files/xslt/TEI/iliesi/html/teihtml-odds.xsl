<?xml version="1.0" encoding="utf-8"?>
<!-- $Date: 
Text Encoding Initiative Consortium XSLT stylesheet family
2001/10/01 $, $Revision: 1.17 $, $Author: rahtz $

XSL HTML stylesheet to format TEI XML documents 

 
Copyright 1999-2005 Sebastian Rahtz / Text Encoding Initiative Consortium
    This is an XSLT stylesheet for transforming TEI (version P4) XML documents

    Version 4.3.5. Date Thu Mar 10 16:22:10 GMT 2005

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
  xmlns:tei="http://www.tei-c.org/ns/1.0"
  xmlns:teix="http://www.tei-c.org/ns/Examples"
  xmlns:local="http://www.pantor.com/ns/local"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:fo="http://www.w3.org/1999/XSL/Format"
  xmlns:edate="http://exslt.org/dates-and-times"
  xmlns:exsl="http://exslt.org/common"
  xmlns:estr="http://exslt.org/strings"
  exclude-result-prefixes="exsl estr edate fo a tei rng local teix" 
  extension-element-prefixes="edate exsl estr"
  version="1.0">


 <xsl:include href="../odds/teiodds.xsl"/>
 <xsl:include href="../common/teicommon.xsl"/>

  <xsl:key name="FILES"   match="moduleSpec[@ident]"   use="@ident"/>
  <xsl:key name="IDS"     match="*[@id]"           use="@id"/>
  <xsl:key name="PATTERNS" match="macroSpec" use="@ident"/>
  <xsl:key name="PATTERNDOCS" match="macroSpec" use='1'/>
  <xsl:key name="CLASSDOCS" match="classSpec" use='1'/>
  <xsl:key name="TAGDOCS" match="elementSpec" use='1'/>
  <xsl:variable name="uc">ABCDEFGHIJKLMNOPQRSTUVWXYZ</xsl:variable>
  <xsl:variable name="lc">abcdefghijklmnopqrstuvwxyz</xsl:variable>

<xsl:param name="displayMode">rnc</xsl:param>

<xsl:template match="elementSpec">
   <xsl:if test="parent::specGrp">
   <dt>Element: <xsl:value-of select="@ident"/></dt>
   <dd>
     <xsl:apply-templates select="." mode="tangle"/>
     </dd>
   </xsl:if>
 </xsl:template>
 
<xsl:template match="classSpec">
   <xsl:if test="parent::specGrp">
   <dt>Class: <xsl:value-of select="@ident"/></dt>
   <dd>
     <xsl:apply-templates select="." mode="tangle"/>
     </dd>
   </xsl:if>
 </xsl:template>
 

<xsl:template match="classSpec">
   <xsl:if test="parent::specGrp">
   <dt>Class: <xsl:value-of select="@ident"/></dt>
   <dd>
     <xsl:apply-templates select="." mode="tangle"/>
     </dd>
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
    <dt/>
    <dd><a href="#{$W}">&#171; <i>include    
    <xsl:for-each select="key('IDS',$W)">
      <xsl:number level="any"/>
      <xsl:if test="@n">
	<xsl:text>: </xsl:text><xsl:value-of select="@n"/>
      </xsl:if>
    </xsl:for-each>
  </i>
</a>
<xsl:text> &#187; </xsl:text>
    </dd>
  </xsl:when>
  <xsl:otherwise>
    <p><a href="#{$W}">&#171; <i>include    
    <xsl:for-each select="key('IDS',$W)">
      <xsl:number level="any"/>
      <xsl:if test="@n">
	<xsl:text>: </xsl:text><xsl:value-of select="@n"/>
      </xsl:if>
    </xsl:for-each>
  </i>
</a>
<xsl:text> &#187; </xsl:text>
    </p>
  </xsl:otherwise>
</xsl:choose>
</xsl:template>
 
<xsl:template match="specGrp">

  <p><b>Specification group <xsl:number level="any"/>
  <xsl:if test="@n">
    <xsl:text>: </xsl:text><xsl:value-of select="@n"/>
  </xsl:if>
  </b>
    <a name="{@xml:id}"></a>
  </p>
  <dl>
    <xsl:apply-templates/>
  </dl>
</xsl:template>

<xsl:template match="specGrp/p">
  <dt/><dd><xsl:apply-templates/></dd>
</xsl:template>

<xsl:template match="attDef" mode="summary">
  <xsl:variable name="name">
    <xsl:choose>
      <xsl:when test="altIdent">
	<xsl:value-of select="altIdent"/>
      </xsl:when>
      <xsl:otherwise>
	<xsl:value-of select="@ident"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
 <tr>
 <td valign="top"><tt><b>
 <xsl:value-of select="$name"/>
 </b></tt></td>
 <td colspan="2"><xsl:apply-templates select="desc" mode="show"/></td>
 </tr>
 <xsl:apply-templates select="valList"/>
</xsl:template>

<xsl:template match="attDef">
  <xsl:variable name="name">
    <xsl:choose>
      <xsl:when test="altIdent">
	<xsl:value-of select="altIdent"/>
      </xsl:when>
      <xsl:otherwise>
	<xsl:value-of select="@ident"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
 <tr>
 <td valign="top"><tt><b>
 <xsl:value-of select="$name"/>
 </b></tt></td>
 <td colspan="2"><xsl:apply-templates select="desc" mode="show"/></td>
 </tr>
<tr>
  <td></td>
  <td><i>Status: </i>
    <xsl:choose>
      <xsl:when test="@usage='mwa'">Mandatory when applicable</xsl:when>
    <xsl:when test="@usage='opt'">Optional</xsl:when>
    <xsl:when test="@usage='rec'">Recommended</xsl:when>
    <xsl:when test="@usage='req'"><hi>Required</hi></xsl:when>
    <xsl:when test="@usage='rwa'">Required when applicable</xsl:when>
    </xsl:choose>
  </td>
</tr>
 <xsl:apply-templates/>
</xsl:template>

<xsl:template match="attDef/datatype">
 <tr>
   <td></td>
   <td colspan="2" valign="top"><i>Datatype:</i>
     <xsl:call-template name="bitOut">
       <xsl:with-param name="grammar"></xsl:with-param>
       <xsl:with-param name="content">
	 <Wrapper>
	   <xsl:copy-of select="rng:*"/>
	 </Wrapper>
       </xsl:with-param>
       <xsl:with-param name="element">code</xsl:with-param>
   </xsl:call-template>
   </td>
  </tr>
</xsl:template>

<xsl:template match="attDef/eg">
  <tr>
    <td></td>
    <td valign="top" colspan='2'>
      <i>Example: </i>
      <xsl:call-template name="verbatim">
	<xsl:with-param name="text">
	  <xsl:apply-templates/>
      </xsl:with-param></xsl:call-template>
  </td></tr>
</xsl:template>


<xsl:template match="attList" mode="show">
      <xsl:call-template name="displayAttList">
	<xsl:with-param name="mode">summary</xsl:with-param>
      </xsl:call-template>
</xsl:template>

<xsl:template match="attList" mode="weave">
  <tr>
    <td valign="top"><i>Attributes </i></td>
    <td>
      <xsl:call-template name="displayAttList">
	<xsl:with-param name="mode">all</xsl:with-param>
      </xsl:call-template>
    </td>
  </tr>
</xsl:template>

<xsl:template match="classSpec" mode="weavebody">
  <xsl:variable name="name">
    <xsl:choose>
      <xsl:when test="altIdent">
	<xsl:value-of select="altIdent"/>
      </xsl:when>
      <xsl:otherwise>
	<xsl:value-of select="@ident"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <tr>
    <td valign='top'><tt><b><xsl:value-of select="$name"/></b></tt></td>
    <td colspan="2"><xsl:apply-templates select="desc" mode="show"/></td>
  </tr>
  <xsl:apply-templates mode="weave"/>
<!--
  <tr>
    <td valign="top"><i>Member of classes</i></td>
    <td colspan="2">
      <xsl:call-template name="generateClassParents"/>
      &#160;
    </td>
  </tr>
-->
  <tr>
    <td valign="top"><i>Members</i></td>
    <td colspan="2">
      <xsl:call-template name="generateMembers"/>
    </td>
  </tr>
  <xsl:call-template name="HTMLmakeTagsetInfo"/>
</xsl:template>


<xsl:template match="classes"  mode="weave">
  <xsl:if test="memberOf">
    <tr><td valign="top"><i>Class</i></td><td colspan="2">
    <xsl:for-each select="memberOf">
      <xsl:choose>
	<xsl:when test="key('IDENTS',@key)">
	<xsl:variable name="Key"><xsl:value-of select="@key"/></xsl:variable>
	  <xsl:for-each select="key('IDENTS',@key)">
	    <xsl:if test="not(generate-id(.)=generate-id(key('IDENTS',$Key)[1]))">
	      <xsl:text> |  </xsl:text>
	    </xsl:if>
	    <xsl:call-template name="linkTogether">
	      <xsl:with-param name="url" select="@id"/>
	      <xsl:with-param name="name" select="@ident"/>
	    </xsl:call-template>
	  </xsl:for-each>
	</xsl:when>
	<xsl:otherwise>
	    <xsl:call-template name="linkTogether">
	      <xsl:with-param name="name" select="@key"/>
	      <xsl:with-param name="url">
	      <xsl:value-of select="$TEISERVER"/>tag.xq?name=<xsl:value-of select="@key"/>
	      </xsl:with-param>
	    </xsl:call-template>
	</xsl:otherwise>
      </xsl:choose>
      <xsl:text> </xsl:text>
      
    </xsl:for-each>
    </td></tr>
  </xsl:if>
</xsl:template>

<xsl:template match="defaultVal">
 <tr><td></td><td valign="top" colspan='2'><i>Default: </i>
 <xsl:apply-templates/>
 </td></tr>
</xsl:template>


<xsl:template match="desc" mode="weave"/>
<xsl:template match="eg">
  <xsl:call-template name="verbatim">
    <xsl:with-param name="autowrap">false</xsl:with-param>
    <xsl:with-param name="startnewline">
      <xsl:if test="parent::exemplum">true</xsl:if>
    </xsl:with-param>    
    <xsl:with-param name="text">
      <xsl:apply-templates/>
    </xsl:with-param>
  </xsl:call-template>
</xsl:template>



<xsl:template match="elementSpec" mode="weavebody">
  <xsl:variable name="name">
    <xsl:choose>
      <xsl:when test="altIdent">
	<xsl:value-of select="altIdent"/>
      </xsl:when>
      <xsl:otherwise>
	<xsl:value-of select="@ident"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <tr><td valign='top'>
  <tt><b><xsl:value-of select="$name"/></b></tt></td>
  <td colspan="2"><xsl:apply-templates select="desc" mode="show"/></td>
  </tr>
  <xsl:if test="not(attList)">
    <tr>
      <td valign="top"><i>Attributes </i></td>
      <td>
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
      </td>
    </tr>
  </xsl:if>
  <xsl:apply-templates mode="weave"/>
  <xsl:call-template name="HTMLmakeTagsetInfo"/>
</xsl:template>

<xsl:template match="elementSpec/content" mode="weave">
  <xsl:variable name="name">
    <xsl:choose>
      <xsl:when test="../altIdent">
	<xsl:value-of select="../altIdent"/>
      </xsl:when>
      <xsl:otherwise>
	<xsl:value-of select="../@ident"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <tr><td valign='top'><i>Declaration</i></td><td colspan='2'>
  <xsl:call-template name="bitOut">
    <xsl:with-param name="grammar"></xsl:with-param>
    <xsl:with-param name="content">
      <Wrapper>
	<rng:element name="{$name}">
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
  </td>
  </tr>
</xsl:template>

<xsl:template match="elementSpec|classSpec" mode="show">
  <xsl:param name="atts"/>
  <xsl:variable name="name">
    <xsl:choose>
      <xsl:when test="altIdent">
	<xsl:value-of select="altIdent"/>
      </xsl:when>
      <xsl:otherwise>
	<xsl:value-of select="@ident"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <b>&lt;<a href="ref-{@id}.html"><xsl:value-of select="$name"/></a>&gt; </b>
  <xsl:value-of select="desc"/>
  <xsl:choose>
    <xsl:when test="attList//attDef">
      <xsl:choose>
	<xsl:when test="not($atts='')">
	  <table class="attList">
	    <xsl:variable name="HERE" select="."/>
	    <xsl:for-each select="estr:tokenize($atts)">
	      <xsl:variable name="TOKEN" select="."/>
	      <xsl:for-each  select="$HERE/attList//attDef[@ident=$TOKEN]">
		<xsl:variable name="aname">
		  <xsl:choose>
		    <xsl:when test="altIdent">
		      <xsl:value-of select="altIdent"/>
		    </xsl:when>
		    <xsl:otherwise>
		      <xsl:value-of select="@ident"/>
		    </xsl:otherwise>
		  </xsl:choose>
		</xsl:variable>
		<tr>
		  <td valign="top"><b><xsl:value-of select="$aname"/></b></td>
		  <td colspan="2"><xsl:apply-templates select="desc" mode="show"/></td>
		</tr>
	      </xsl:for-each>
	    </xsl:for-each>
	  </table>
	</xsl:when>
	<xsl:otherwise>
	  <table class="attList">
	    <xsl:apply-templates select="attList" mode="summary"/>
	  </table>
	</xsl:otherwise>
      </xsl:choose>
    </xsl:when>
    <xsl:otherwise>
      <table  class="attList">
	<tr>
	  <td valign="top" colspan='2'>
	  No attributes other than those globally
	  available (see definition for tei.global.attributes)</td>
	</tr>
      </table>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="exemplum" mode="weave">
 <tr><td valign='top'><i>Example</i></td><td colspan='2'>
  <xsl:apply-templates/>
 </td></tr>
</xsl:template>


<xsl:template match="gloss" mode="weave"/>
<xsl:template match="gloss"/>
<xsl:template match="item"> 
 <xsl:choose>
   <xsl:when test="parent::list[@type='gloss']"> 
     &#9;<xsl:apply-templates/>
   </xsl:when>
   <xsl:when test="parent::list[@type='elementlist']"> 
     &#9;<xsl:apply-templates/>
   </xsl:when>
   <xsl:otherwise>
     <li><xsl:apply-templates/></li>
   </xsl:otherwise>
 </xsl:choose>
</xsl:template>




<xsl:template match="macroSpec" mode="weavebody">
  <xsl:variable name="name">
    <xsl:choose>
      <xsl:when test="altIdent">
	<xsl:value-of select="altIdent"/>
      </xsl:when>
      <xsl:otherwise>
	<xsl:value-of select="@ident"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

      <tr><td valign='top'>
      <tt><b><xsl:value-of select="$name"/></b></tt></td>
      <td colspan="2"><xsl:apply-templates select="desc" mode="show"/></td>
      </tr>
      <xsl:apply-templates mode="weave"/>
      <xsl:call-template name="HTMLmakeTagsetInfo"/>
</xsl:template>

<xsl:template match="macroSpec/content" mode="weave">
  <tr><td valign='top'><i>Declaration</i></td><td colspan='2'>
  <xsl:call-template name="bitOut">
    <xsl:with-param name="grammar">true</xsl:with-param>
    <xsl:with-param name="content">
      <Wrapper>
	<xsl:variable name="entCont">
	  <Stuff>
	    <xsl:apply-templates select="rng:*"/>
	  </Stuff>
	</xsl:variable>
	<xsl:variable name="entCount">
	  <xsl:for-each select="exsl:node-set($entCont)/Stuff">
	    <xsl:value-of select="count(*)"/>
	  </xsl:for-each>
	</xsl:variable>
	<xsl:choose>
	  <xsl:when test='.="TEI.singleBase"'/>
	  <xsl:otherwise>
	    <rng:define name="{../@ident}">
	      <xsl:if test="starts-with(.,'component')">
		<xsl:attribute name="combine">choice</xsl:attribute>
	      </xsl:if>
	      <xsl:copy-of select="rng:*"/>
	    </rng:define>
	  </xsl:otherwise>
	</xsl:choose>
      </Wrapper>
  </xsl:with-param></xsl:call-template>
  </td></tr>    
</xsl:template>

<xsl:template match="moduleSpec">
<hr/>
<p><strong>Module </strong><em><xsl:value-of select="@ident"/></em>:
<xsl:apply-templates select="desc"  mode="show"/>
<ul>
<li>Elements defined:
<xsl:for-each select="key('ElementModule',@ident)">
  <xsl:call-template name="linkTogether">
    <xsl:with-param name="url" select="@id"/>
    <xsl:with-param name="name" select="@ident"/>
  </xsl:call-template>
  <xsl:text> </xsl:text>
</xsl:for-each>
</li>
<li>Classes defined:
<xsl:for-each select="key('ClassModule',@ident)">
  <xsl:call-template name="linkTogether">
    <xsl:with-param name="url" select="@id"/>
    <xsl:with-param name="name" select="@ident"/>
  </xsl:call-template>
  <xsl:text> </xsl:text>
</xsl:for-each>
</li>
<li>Macros defined:
<xsl:for-each select="key('MacroModule',@ident)">
  <xsl:call-template name="linkTogether">
    <xsl:with-param name="url" select="@id"/>
    <xsl:with-param name="name" select="@ident"/>
  </xsl:call-template>
  <xsl:text> </xsl:text>
</xsl:for-each>
</li>
</ul>
<hr/>
</p>
</xsl:template>


<xsl:template match="ptr">
  <xsl:choose>
    <xsl:when test="parent::listRef">
      <xsl:if test="count(preceding-sibling::ptr)=0">
	<tr><td valign="top"><i>See further</i></td><td colspan="2">
	<xsl:if test="count(preceding-sibling::ptr)&gt;0">; </xsl:if>
	<xsl:apply-imports/>
	</td></tr>
      </xsl:if>
    </xsl:when>
    <xsl:otherwise>
      <xsl:apply-imports/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="remarks" mode="weave">
  <xsl:if test="*//text()">
    <tr><td valign="top"><i>Note</i></td><td colspan="2">
    <xsl:apply-templates/>
    </td></tr>
  </xsl:if>
</xsl:template>


<xsl:template match="schema">
  <hr/> 
  <xsl:call-template name="processSchemaFragment"/>
  <hr/>
</xsl:template>

<xsl:template match="specDesc">
  <li>  
    <xsl:call-template name="processSpecDesc"/>
  </li>
</xsl:template>


<xsl:template match="specList">
<ul class="specList">
  <xsl:apply-templates/>
</ul>
</xsl:template>


<xsl:template match="valDesc">
  <tr>
    <td></td><td><i>Values: </i> <xsl:apply-templates/></td>
  </tr>
</xsl:template>

<xsl:template match="attDef/remarks">
  <tr>
    <td></td><td><xsl:apply-templates/></td>
  </tr>
</xsl:template>




<xsl:template match="valList" mode="contents">
      <xsl:choose>
        <xsl:when test="@type='semi'">Suggested values include:</xsl:when>
        <xsl:when test="@type='open'">Sample values include:</xsl:when>
        <xsl:when test="@type='closed'">Legal values are:</xsl:when>
        <xsl:otherwise>Values are:</xsl:otherwise>
      </xsl:choose>
      <table class="valList">
       <xsl:for-each select="valItem">
	 <xsl:variable name="name">
	   <xsl:choose>
	     <xsl:when test="altIdent">
	       <xsl:value-of select="altIdent"/>
	     </xsl:when>
	     <xsl:otherwise>
	       <xsl:value-of select="@ident"/>
	     </xsl:otherwise>
	   </xsl:choose>
	 </xsl:variable>
         <tr><td valign="top"><b><xsl:value-of select="$name"/></b></td>
         <td valign="top">
               <xsl:value-of select="gloss"/></td>
         </tr>
        </xsl:for-each>
      </table>
</xsl:template>


<xsl:template match="valList">
 <xsl:choose>
 <xsl:when test="ancestor::elementSpec or ancestor::classSpec or ancestor::macroSpec">
    <tr><td></td><td valign="top">
    <xsl:apply-templates select="." mode="contents"/>
    </td></tr>
 </xsl:when>
 <xsl:otherwise>
   <xsl:apply-templates select="." mode="contents"/>
  </xsl:otherwise>
 </xsl:choose>
</xsl:template>

<xsl:template match="teix:egXML">
<pre>
  <xsl:apply-templates mode="verbatim"/>
</pre>
</xsl:template>




<xsl:template name="HTMLmakeTagsetInfo">
 <tr><td valign="top"><i>Module</i></td><td colspan="2">
  <xsl:call-template name="makeTagsetInfo"/>
 </td></tr>
</xsl:template>

<xsl:template name="bitOut">
<xsl:param name="grammar"/>
<xsl:param name="content"/>
<xsl:param  name="element">pre</xsl:param> 
<xsl:element name="{$element}">
  <xsl:attribute name="class">eg</xsl:attribute>
  <xsl:choose>
    <xsl:when test="$displayMode='rng'">
      <xsl:apply-templates select="exsl:node-set($content)/Wrapper/*" 
			   mode="verbatim"/>
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
	<xsl:apply-templates mode="literal"/>
      </xsl:for-each>
    </xsl:otherwise>
  </xsl:choose>
</xsl:element>
</xsl:template>


<xsl:template name="displayAttList">
<xsl:param name="mode"/>
      <table class="attList">
	<tr><td>
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
	    <table>
	      <xsl:choose>
		<xsl:when test="$mode='all'">
		  <xsl:apply-templates/>
		</xsl:when>
		<xsl:otherwise>
		  <xsl:apply-templates mode="summary"/>
		</xsl:otherwise>
	      </xsl:choose>
	    </table>
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
	</td>
	</tr>
      </table>
</xsl:template>



<xsl:template name="embolden">
      <xsl:param name="text"/>
        <b><xsl:copy-of select="$text"/></b>
</xsl:template>


<xsl:template name="italicize">
  <xsl:param name="text"/>
    <i><xsl:copy-of select="$text"/></i>
</xsl:template>

<xsl:template name="logoFramePicture"/>


<xsl:template name="makeAnchor">
 <xsl:param name="name"/>
 <xsl:choose>
   <xsl:when test="$name">
     <a  name="{$name}"/>
   </xsl:when>
   <xsl:when test="@id"><a name="{@id}"></a></xsl:when>
 </xsl:choose>
</xsl:template>

<xsl:template name="makeLink">
 <xsl:param name="class"/>
 <xsl:param name="id"/>
 <xsl:param name="name"/>
 <xsl:param name="text"/>
    <a class="{$class}" href="ref-{$id}.html"><xsl:copy-of  select="$text"/></a>
</xsl:template>

<xsl:template name="refdoc">
  <xsl:if test="$verbose='true'">
    <xsl:message>   refdoc for <xsl:value-of 
    select="name(.)"/> - <xsl:value-of select="@id"/> </xsl:message>
  </xsl:if>
  <xsl:variable name="objectname">
    <xsl:choose>
      <xsl:when test="altIdent">
	<xsl:value-of select="altIdent"/>
      </xsl:when>
      <xsl:otherwise>
	<xsl:value-of select="@ident"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="name">
    <xsl:choose>
      <xsl:when test="local-name(.)='elementSpec'">
	<xsl:text>&lt;</xsl:text>
	<xsl:value-of select="$objectname"/>
	<xsl:text>&gt;</xsl:text>
      </xsl:when>
      <xsl:otherwise>
	<xsl:value-of select="$objectname"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  [<a href="ref-{@id}.html"><xsl:value-of select="$name"/></a>]
  <xsl:variable name="BaseFile">
    <xsl:value-of select="$masterFile"/>
    <xsl:if test="ancestor::teiCorpus.2">
      <xsl:text>-</xsl:text>
      <xsl:choose>
	<xsl:when test="@id"><xsl:value-of select="@id"/></xsl:when> 
	<xsl:otherwise><xsl:number/></xsl:otherwise>
      </xsl:choose>
    </xsl:if>
  </xsl:variable>
  <xsl:call-template name="outputChunk">
    <xsl:with-param name="ident">
      <xsl:text>ref-</xsl:text><xsl:value-of select="@id"/>
    </xsl:with-param>
    <xsl:with-param name="content">
      <html>
	<xsl:comment>THIS IS A GENERATED FILE. DO NOT EDIT (7)</xsl:comment>
	<head><title><xsl:value-of select="$name"/></title>
	<xsl:if test="not($cssFile = '')">
	  <link rel="stylesheet" type="text/css" href="{$cssFile}"/>
	</xsl:if>
	</head>
	<body>
	  <xsl:call-template name="bodyHook"/>
	  <a name="TOP"></a>
	  <div class="teidiv">
	    <xsl:call-template name="stdheader">
	      <xsl:with-param name="title">
		<xsl:value-of select="$name"/>
	      </xsl:with-param>
	    </xsl:call-template>
	    <p><a name="{@id}"></a>
	    <table class="wovenodd" border='1'>
	      <xsl:apply-templates select="." mode="weavebody"/>
	    </table></p>
	    <p class="wovenodd" align="{$alignNavigationPanel}">
	      <a  class="navlink" href="REFCLA.html">Classes</a> |
	      <a  class="navlink" href="REFENT.html">Macros</a> |
	      <a  class="navlink" href="REFTAG.html">Elements</a>
	    </p>
	  </div>
      </body></html>
    </xsl:with-param>
  </xsl:call-template>
</xsl:template>

<xsl:template name="teiStartHook"/>

<xsl:template name="ttembolden">
      <xsl:param name="text"/>
        <b><tt><xsl:copy-of select="$text"/></tt></b>
</xsl:template>


<xsl:template name="typewriter">
      <xsl:param name="text"/>
        <tt><xsl:copy-of select="$text"/></tt>
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
