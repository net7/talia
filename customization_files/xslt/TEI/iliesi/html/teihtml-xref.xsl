<!-- 
Text Encoding Initiative Consortium XSLT stylesheet family
$Date: 2005/02/22 20:40:00 $, $Revision: 1.12 $, $Author: rahtz $

XSL stylesheet to format TEI XML documents to HTML or XSL FO

 
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
  xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:exsl="http://exslt.org/common"
    extension-element-prefixes="exsl"
    exclude-result-prefixes="tei exsl"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

<xsl:param name="overrideMasterFile"></xsl:param>
<!-- cross-referencing -->

<!-- work out an ID for a given <div> -->
 <xsl:template match="*" mode="ident">
 <xsl:variable name="BaseFile">
 <xsl:value-of select="$masterFile"/>
 <xsl:call-template name="addCorpusID"/>
</xsl:variable>
  <xsl:choose>
  <xsl:when test="@id">
    <xsl:choose>
     <xsl:when test="$useIDs">
       <xsl:value-of select="@id"/>
     </xsl:when>
     <xsl:otherwise>
      <xsl:value-of select="$BaseFile"/>-<xsl:value-of select="local-name(.)"/>-<xsl:value-of select="generate-id()"/>
     </xsl:otherwise>
    </xsl:choose>
  </xsl:when>
  <xsl:when test="self::div and not(ancestor::div)"> 
  <xsl:variable name="xpath">
       <xsl:for-each select="ancestor-or-self::*">
    <xsl:value-of select="local-name()" />
    <xsl:text />.<xsl:number />
    <xsl:if test="position() != last()">_</xsl:if>
  </xsl:for-each>
  </xsl:variable>
   <xsl:value-of select="substring-after($xpath,'TEI.2.1_text.1_')"/>
  </xsl:when>
  <xsl:when test="self::divGen"> 
  <xsl:variable name="xpath">
    <xsl:for-each select="ancestor-or-self::*">
      <xsl:value-of select="local-name()" />
      <xsl:text />.<xsl:number />
      <xsl:if test="position() != last()">_</xsl:if>
    </xsl:for-each>
  </xsl:variable>
  <xsl:value-of select="substring-after($xpath,'TEI_.1_text.1_')"/>
  </xsl:when>
  <xsl:otherwise>
    <xsl:value-of select="$BaseFile"/>-<xsl:value-of select="name(.)"/>-<xsl:value-of select="generate-id()"/>
  </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- when a <div> is referenced, see whether its  plain anchor, 
 or needs a parent HTML name prepended -->


<xsl:template match="TEI.2" mode="generateLink">
  <xsl:variable name="BaseFile">
    <xsl:value-of select="$masterFile"/>
    <xsl:call-template name="addCorpusID"/>
  </xsl:variable>
  <xsl:value-of select="concat($BaseFile,$standardSuffix)"/>
</xsl:template>

<xsl:template match="*" mode="generateLink">
  <xsl:variable name="ident">
    <xsl:apply-templates select="." mode="ident"/>
  </xsl:variable>
  <xsl:variable name="depth">
    <xsl:apply-templates select="." mode="depth"/>
  </xsl:variable>
  <xsl:variable name="Hash">
    <xsl:choose>
      <xsl:when test="$makeFrames='true' and not($STDOUT='true')">
	<xsl:value-of select="$masterFile"/>
	<xsl:call-template name="addCorpusID"/>
	<xsl:text>.html</xsl:text>
      </xsl:when>
      <xsl:otherwise>
	<xsl:value-of select="$overrideMasterFile"/>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:text>#</xsl:text>
  </xsl:variable>
  <xsl:choose>
    <xsl:when test="$rawXML='true' and $depth &lt;= $splitLevel">
      <xsl:text>JavaScript:void(gotoSection('','</xsl:text>
      <xsl:value-of select="$ident"/>
      <xsl:text>'));</xsl:text>
    </xsl:when>
    <xsl:when test="$STDOUT='true' and $depth &lt;= $splitLevel">
      <xsl:value-of select="$masterFile"/>
      <xsl:value-of select="$urlChunkPrefix"/>
      <xsl:value-of select="$ident"/>
    </xsl:when>
    <xsl:when test="ancestor::back and not($splitBackmatter)">
      <xsl:value-of select="concat($Hash,$ident)"/>
    </xsl:when>
    <xsl:when test="ancestor::front and not($splitFrontmatter)">
      <xsl:value-of select="concat($Hash,$ident)"/>
    </xsl:when>
    <xsl:when test="$splitLevel= -1 and ancestor::teiCorpus.2">
      <xsl:value-of select="$masterFile"/>
      <xsl:call-template name="addCorpusID"/>
      <xsl:value-of select="$standardSuffix"/>
      <xsl:value-of select="concat($Hash,$ident)"/>
    </xsl:when>
    <xsl:when test="$splitLevel= -1">
      <xsl:value-of select="concat($Hash,$ident)"/>
    </xsl:when>
    <xsl:when test="$depth &lt;= $splitLevel">
      <xsl:value-of select="concat($ident,$standardSuffix)"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:variable name="parent">
	<xsl:call-template name="locateParentdiv"/>
      </xsl:variable>
      <xsl:choose>
	<xsl:when test="$rawXML='true'">
	  <xsl:text>JavaScript:void(gotoSection("</xsl:text>
	  <xsl:value-of select="$ident"/>
	  <xsl:text>","</xsl:text>
	  <xsl:value-of select="$parent"/>
	  <xsl:text>"));</xsl:text>
	</xsl:when>
	<xsl:when test="$STDOUT='true'">
	  <xsl:value-of select="$masterFile"/>
	  <xsl:value-of select="$urlChunkPrefix"/>
	  <xsl:value-of select="$parent"/>
	  <xsl:value-of select="concat($standardSuffix,'#')"/>
	  <xsl:value-of select="$ident"/>
	</xsl:when>
	<xsl:otherwise>
	  <xsl:value-of select="$parent"/>
	  <xsl:value-of select="concat($standardSuffix,'#')"/>
	  <xsl:value-of select="$ident"/>
	</xsl:otherwise>
      </xsl:choose>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="locateParentdiv">
 <xsl:choose>
  <xsl:when test="ancestor-or-self::div and $splitLevel &lt; 0">
     <xsl:apply-templates
     select="ancestor::div[last()]" mode="ident"/>
  </xsl:when>
  <xsl:when test="ancestor-or-self::div">
  <xsl:apply-templates
     select="ancestor::div[last() - $splitLevel]" mode="ident"/>
  </xsl:when>
  <xsl:otherwise>
   <xsl:choose>
    <xsl:when test="$splitLevel = 0">
      <xsl:apply-templates select="ancestor::div1|ancestor::div0" mode="ident"/>
    </xsl:when>
    <xsl:when test="$splitLevel = 1">
      <xsl:apply-templates select="(ancestor::div2|ancestor::div1|ancestor::div0)[last()]" mode="ident"/>
    </xsl:when>
    <xsl:when test="$splitLevel = 2">
      <xsl:apply-templates select="(ancestor::div3|ancestor::div2)[last()]" mode="ident"/>
    </xsl:when>
    <xsl:when test="$splitLevel = 3">
      <xsl:apply-templates select="(ancestor::div4|ancestor::div3)[last()]" mode="ident"/>
    </xsl:when>
    <xsl:when test="$splitLevel = 4">
      <xsl:apply-templates select="(ancestor::div5|ancestor::div4)[last()]" mode="ident"/>
    </xsl:when>
   </xsl:choose>
  </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="locateParent">
  <xsl:choose>
  <xsl:when test="self::div">
  <xsl:apply-templates
     select="ancestor::div[last() - $splitLevel + 1]" mode="ident"/>
  </xsl:when>
  <xsl:when test="ancestor::div">
  <xsl:apply-templates
     select="ancestor::div[last() - $splitLevel]" mode="ident"/>
  </xsl:when>
  <xsl:otherwise>
   <xsl:choose>
    <xsl:when test="$splitLevel = 0">
      <xsl:apply-templates select="ancestor::div1|ancestor::div0" mode="ident"/>
    </xsl:when>
    <xsl:when test="$splitLevel = 1">
      <xsl:apply-templates select="ancestor::div2|ancestor::div1|ancestor::div0" mode="ident"/>
    </xsl:when>
    <xsl:when test="$splitLevel = 2">
      <xsl:apply-templates select="ancestor::div3|ancestor::div2" mode="ident"/>
    </xsl:when>
    <xsl:when test="$splitLevel = 3">
      <xsl:apply-templates select="ancestor::div4|ancestor::div3" mode="ident"/>
    </xsl:when>
    <xsl:when test="$splitLevel = 4">
      <xsl:apply-templates select="ancestor::div5|ancestor::div4" mode="ident"/>
    </xsl:when>
   </xsl:choose>
  </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="anchor">
   <a name="{@id}"/>
</xsl:template>

<xsl:template match="note" mode="generateLink">
    <xsl:text>#Note</xsl:text>
    <xsl:call-template name="noteN"/>
</xsl:template>


<xsl:template match="label|figure|table|item|p|bibl|anchor|cell|lg|list|sp" 
  mode="generateLink">
  <xsl:variable name="ident">
   <xsl:apply-templates select="." mode="ident"/>
  </xsl:variable>
 <xsl:variable name="file">
 <xsl:apply-templates 
   select="ancestor::*[starts-with(local-name(),'div')][1]"  
   mode="generateLink"/>
 </xsl:variable>
 <xsl:choose>
  <xsl:when test="starts-with($file,'#')">
    <xsl:text>#</xsl:text><xsl:value-of select="$ident"/>
  </xsl:when>
  <xsl:when test="contains($file,'#')">
    <xsl:value-of select="substring-before($file,'#')"/>
    <xsl:text>#</xsl:text><xsl:value-of select="$ident"/>
  </xsl:when>
  <xsl:otherwise>
    <xsl:value-of select="$file"/>
    <xsl:text>#</xsl:text><xsl:value-of select="$ident"/>
  </xsl:otherwise>
 </xsl:choose>
</xsl:template>


<xsl:template name="makeAnchor">
  <xsl:if test="@id"><a name="{@id}"/></xsl:if>  
</xsl:template>

<xsl:template name="makeInternalLink">
  <xsl:param name="target"/>
  <xsl:param name="ptr"/>
  <xsl:param name="dest"/>
  <xsl:param name="body"/>
  <xsl:param name="class">link_<xsl:value-of
  select="local-name(.)"/></xsl:param>
  <xsl:variable name="W">
    <xsl:choose>
      <xsl:when test="$target"><xsl:value-of select="$target"/></xsl:when>
      <xsl:when test="contains($dest,'#')">
	<xsl:value-of select="substring-after($dest,'#')"/>
      </xsl:when>
      <xsl:otherwise>
	<xsl:value-of select="$dest"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <a>
    <xsl:if test="@n">
      <xsl:attribute name="title">
	<xsl:value-of select="@n"/>
      </xsl:attribute>
    </xsl:if>
    <xsl:attribute name="class">
      <xsl:choose>
	<xsl:when test="@rend"><xsl:value-of select="@rend"/></xsl:when>
	<xsl:otherwise><xsl:value-of select="$class"/></xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
    <xsl:attribute name="href">
      <xsl:choose>
	<xsl:when test="starts-with($dest,'#') or
			contains($dest,'.html') or contains($dest,'ID=')">
	  <xsl:value-of select="$dest"/>
	</xsl:when>
	<xsl:otherwise>
	  <xsl:apply-templates select="key('IDS',$W)"
			       mode="generateLink"/>
	</xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
    <xsl:choose>
      <xsl:when test="not($body='')">
	<xsl:value-of select="$body"/>
      </xsl:when>
      <xsl:when test="$ptr='true'">
	<xsl:apply-templates mode="xref" select="key('IDS',$W)">
	  <xsl:with-param name="minimal" select="$minimalCrossRef"/>
	</xsl:apply-templates>
      </xsl:when>
      <xsl:otherwise>
	<xsl:apply-templates/>
      </xsl:otherwise>
    </xsl:choose>
  </a>
</xsl:template>

<xsl:template name="makeExternalLink">
  <xsl:param name="ptr"/>
  <xsl:param name="dest"/>
  <xsl:param name="class">link_<xsl:value-of select="local-name(.)"/></xsl:param>
  <a>
    <xsl:attribute name="class">
      <xsl:choose>
	<xsl:when test="@rend"><xsl:value-of select="@rend"/></xsl:when>
	<xsl:otherwise><xsl:value-of select="$class"/></xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
    <xsl:if test="@type">
      <xsl:attribute name="type">
	<xsl:value-of select="@type"/>
      </xsl:attribute>
    </xsl:if>
    <xsl:attribute name="href">
      <xsl:value-of select="$dest"/>
      <xsl:if test="contains(@from,'id (')">
	<xsl:text>#</xsl:text>
	<xsl:value-of select="substring(@from,5,string-length(normalize-space(@from))-1)"/>
      </xsl:if>
    </xsl:attribute>
    <xsl:choose>
      <xsl:when test="@rend='new'">
	<xsl:attribute name="target">_blank</xsl:attribute>
      </xsl:when>
      <xsl:when test="@rend='noframe' or $splitLevel=-1 or substring(@url,string-length(@url),1)='/'">
	<xsl:attribute name="target">_top</xsl:attribute>
      </xsl:when>
      <xsl:when test="contains($dest,'://') or starts-with($dest,'.') or starts-with($dest,'/')">
	<xsl:attribute name="target">_top</xsl:attribute>
      </xsl:when>
      <xsl:when test="substring($dest,string-length($dest),1)='/'">
	<xsl:attribute name="target">_top</xsl:attribute>
      </xsl:when>
      <xsl:when test="$splitLevel=-1">
	<xsl:attribute name="target">_top</xsl:attribute>
      </xsl:when>
    </xsl:choose>
    <xsl:if test="@n">
      <xsl:attribute name="title">
	<xsl:value-of select="@n"/>
      </xsl:attribute> 
    </xsl:if>
    <xsl:call-template name="xrefHook"/>
    <xsl:choose>
      <xsl:when test="$ptr='true'">
	<xsl:element name="{$fontURL}">
	<xsl:choose>
	  <xsl:when test="starts-with($dest,'mailto:')">
	    <xsl:value-of select="substring-after($dest,'mailto:')"/>
	  </xsl:when>
	  <xsl:when test="starts-with($dest,'file:')">
	    <xsl:value-of select="substring-after($dest,'file:')"/>
	  </xsl:when>
	  <xsl:otherwise>
	    <xsl:value-of select="$dest"/>
	  </xsl:otherwise>
	</xsl:choose>
	</xsl:element>
      </xsl:when>
      <xsl:otherwise>
	<xsl:apply-templates/>
      </xsl:otherwise>
    </xsl:choose>
  </a>
</xsl:template>

<xsl:template name="generateEndLink">
  <xsl:param name="where"/>
<!--
<xsl:message>find link end for <xsl:value-of select="$where"/>,<xsl:value-of select="name(key('IDS',$where))"/></xsl:message>
-->
  <xsl:apply-templates select="key('IDS',$where)" mode="generateLink"/>
</xsl:template>

</xsl:stylesheet>
