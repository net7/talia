<?xml version="1.0" encoding="utf-8"?>
<!-- 
Text Encoding Initiative Consortium XSLT stylesheet family
$Date: 2005/02/20 11:57:42 $, $Revision: 1.12 $, $Author: rahtz $
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
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    version="1.0">
  <!-- ************************************************* -->
  <xsl:param name="spacer">&gt;</xsl:param>
  
<xsl:template
      match="div|div0|div1|div2|div3|div4|div5|div6"> 
    <xsl:variable name="depth">
      <xsl:apply-templates select="." mode="depth"/>
    </xsl:variable>
    <!-- depending on depth and splitting level, 
	 we may do one of two things: -->
    <xsl:choose>
      <!-- 1. our section depth is below the splitting level -->
      <xsl:when test="$STDOUT='true' or $depth &gt; $splitLevel or
		      @rend='nosplit' or ancestor::TEI.2/@rend='nosplit'">
	<div>
	  <xsl:attribute name="class">
	    <xsl:choose>
	      <xsl:when test="@type">
		<xsl:value-of select="@type"/>
	      </xsl:when>
	      <xsl:otherwise>teidiv</xsl:otherwise>
	    </xsl:choose>
	  </xsl:attribute>
	  <xsl:call-template name="doDivBody">
	    <xsl:with-param name="Type" select="$depth"/>
	  </xsl:call-template>
	</div>
      </xsl:when>
      <!-- 2. we are at or above splitting level, 
	   so start a new file
      -->
      <xsl:when test ="$depth &lt;= $splitLevel and parent::front
		       and $splitFrontmatter">
	<xsl:call-template name="outputChunk">
	  <xsl:with-param name="ident">
	    <xsl:apply-templates select="." mode="ident"/>
	  </xsl:with-param>
	  <xsl:with-param name="content">
	    <xsl:choose>
	      <xsl:when test="$pageLayout='CSS'">
		<xsl:call-template name="pageLayoutCSS">       
		  <xsl:with-param name="currentID" select="'current'"/>
		</xsl:call-template>
	      </xsl:when>
	      <xsl:when test="$pageLayout='Table'">
		<xsl:call-template name="pageLayoutTable">       
		  <xsl:with-param name="currentID" select="'current'"/>
		</xsl:call-template>
	      </xsl:when>
	      <xsl:otherwise>
		<xsl:call-template name="writeDiv"/>
	      </xsl:otherwise>
	    </xsl:choose>
	  </xsl:with-param>
	</xsl:call-template>
      </xsl:when>

      <xsl:when test ="$depth &lt;= $splitLevel and parent::back
		       and $splitBackmatter">
	<xsl:call-template name="outputChunk">
	  <xsl:with-param name="ident">
	    <xsl:apply-templates select="." mode="ident"/>
	  </xsl:with-param>
	  <xsl:with-param name="content">
	    <xsl:choose>
	      <xsl:when test="$pageLayout='CSS'">
		<xsl:call-template name="pageLayoutCSS">       
		  <xsl:with-param name="currentID" select="'current'"/>
		</xsl:call-template>
	      </xsl:when>
	      <xsl:when test="$pageLayout='Table'">
		<xsl:call-template name="pageLayoutTable">       
		  <xsl:with-param name="currentID" select="'current'"/>
		</xsl:call-template>
	      </xsl:when>
	      <xsl:otherwise>
		<xsl:call-template name="writeDiv"/>
	      </xsl:otherwise>
	    </xsl:choose>
	  </xsl:with-param>
	</xsl:call-template>
      </xsl:when>

      <xsl:when test="$depth &lt;= $splitLevel">
	<xsl:call-template name="outputChunk">
	  <xsl:with-param name="ident">
	    <xsl:apply-templates select="." mode="ident"/>
	  </xsl:with-param>
	  <xsl:with-param name="content">
	    <xsl:choose>
	      <xsl:when test="$pageLayout='CSS'">
		<xsl:call-template name="pageLayoutCSS">       
		  <xsl:with-param name="currentID" select="'current'"/>
		</xsl:call-template>
	      </xsl:when>
	      <xsl:when test="$pageLayout='Table'">
		<xsl:call-template name="pageLayoutTable">       
		  <xsl:with-param name="currentID" select="'current'"/>
		</xsl:call-template>
	      </xsl:when>
	      <xsl:otherwise>
		<xsl:call-template name="writeDiv"/>
	      </xsl:otherwise>
	    </xsl:choose>
	  </xsl:with-param>
	</xsl:call-template>
      </xsl:when>

      <xsl:otherwise>
	<div>
	  <xsl:attribute name="class">
	    <xsl:choose>
	      <xsl:when test="@type">
		<xsl:value-of select="@type"/>
	      </xsl:when>
	      <xsl:otherwise>teidiv</xsl:otherwise>
	    </xsl:choose>
	  </xsl:attribute>
	  <xsl:call-template name="doDivBody">
	    <xsl:with-param name="Type" select="$depth"/>
	  </xsl:call-template>
	</div>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <!-- table of contents -->
  
<xsl:template match="divGen[@type='toc']">
    <h2><xsl:value-of select="$tocWords"/></h2>
    <xsl:call-template name="maintoc"/>
  </xsl:template>
  <!-- anything with a head can go in the TOC -->
  
<xsl:template match="*" mode="maketoc">
    <xsl:param name="forcedepth"/>
    <xsl:variable name="myName">
      <xsl:value-of select="local-name(.)"/>
    </xsl:variable>
    <xsl:if test="head or $autoHead='true'">
      <xsl:variable name="Depth">
	<xsl:choose>
	  <xsl:when test="not($forcedepth='')">
	    <xsl:value-of select="$forcedepth"/>
	  </xsl:when>
	  <xsl:otherwise>
	    <xsl:value-of select="$tocDepth"/>
	  </xsl:otherwise>
	</xsl:choose>
      </xsl:variable>
      <xsl:variable name="thislevel">
	<xsl:choose>
	  <xsl:when test="$myName = 'div'">
	    <xsl:value-of select="count(ancestor::div)"/>
	  </xsl:when>
	  <xsl:when test="starts-with($myName,'div')">
	    <xsl:choose>
	      <xsl:when test="ancestor-or-self::div0">
		<xsl:value-of select="substring-after($myName,'div')"/>
	      </xsl:when>
	      <xsl:otherwise>
		<xsl:value-of select="substring-after($myName,'div') - 1"/>
	      </xsl:otherwise>
	    </xsl:choose>
	  </xsl:when>
	  <xsl:otherwise>99</xsl:otherwise>
	</xsl:choose>
      </xsl:variable>
      <xsl:variable name="pointer">
	<xsl:apply-templates mode="generateLink" select="."/>
      </xsl:variable>
      <li class="toc">
	<xsl:call-template name="header">
	  <xsl:with-param name="toc" select="$pointer"/>
	  <xsl:with-param name="minimal"></xsl:with-param>
	</xsl:call-template>
	<xsl:if test="$thislevel &lt; $Depth">
	  <xsl:call-template name="continuedToc"/>
	</xsl:if>
      </li>
    </xsl:if>
  </xsl:template>
  
<xsl:template name="continuedToc">
    <xsl:if test="div|div0|div1|div2|div3|div4|div5|div6">
      <ul class="toc">
	<xsl:apply-templates select="div|div0|div1|div2|div3|div4|div5|div6" mode="maketoc"/>
      </ul>
    </xsl:if>
  </xsl:template>
  
<xsl:template match="div|div0|div1|div2|div3|div4|div5|div6" mode="depth">
    <xsl:choose>
      <xsl:when test="local-name(.) = 'div'">
	<xsl:value-of select="count(ancestor::div)"/>
      </xsl:when>
      <xsl:otherwise>
	<xsl:choose>
	  <xsl:when test="ancestor-or-self::div0">
	    <xsl:value-of select="substring-after(local-name(.),'div')"/>
	  </xsl:when>
	  <xsl:otherwise>
	    <xsl:value-of select="substring-after(local-name(.),'div') - 1"/>
	  </xsl:otherwise>
	</xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
<xsl:template match="*" mode="depth">99</xsl:template>
  <!-- headings etc -->
  
<xsl:template match="head">
    <xsl:variable name="parent" select="local-name(..)"/>
    <xsl:if test="not(starts-with($parent,'div'))">
      <xsl:apply-templates/>
    </xsl:if>
  </xsl:template>
  
<xsl:template mode="plain" match="head">
    <xsl:if test="preceding-sibling::head">
      <xsl:text> </xsl:text>
    </xsl:if>
    <xsl:apply-templates mode="plain"/>
  </xsl:template>
  
<xsl:template match="p">
    <xsl:choose>
      <xsl:when test="list">
	<xsl:apply-templates select="list[1]" mode="inpara"/> 
      </xsl:when> 
      <xsl:otherwise>
	<p>
	  <xsl:choose>
	    <xsl:when test="@rend and starts-with(@rend,'class:')">
	      <xsl:attribute name="class">
		<xsl:value-of select="substring-after(@rend,'class:')"/>
	      </xsl:attribute>
	    </xsl:when>
	    <xsl:when test="@rend">
	      <xsl:attribute name="class"><xsl:value-of select="@rend"/></xsl:attribute>
	    </xsl:when>
	  </xsl:choose>
	  <xsl:choose>
	    <xsl:when test="@id">
	      <a name="{@id}"/>
	    </xsl:when>
	    <xsl:when test="$generateParagraphIDs='true'">
	      <a name="{generate-id()}"/>
	    </xsl:when>
	  </xsl:choose>
	  <xsl:if test="$numberParagraphs='true'">
	    <xsl:number/><xsl:text> </xsl:text>
	  </xsl:if>
	  <xsl:apply-templates/>
	</p>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
<xsl:template match="gi" mode="plain">
    <xsl:text>&lt;</xsl:text>
    <xsl:apply-templates/>
    <xsl:text>&gt;</xsl:text>
  </xsl:template>
  
<xsl:template match="*" mode="plain">
    <xsl:apply-templates/>
  </xsl:template>

<xsl:template match="titleStmt/title">
  <xsl:if test="preceding-sibling::title"><br/></xsl:if>
  <xsl:apply-templates/>
</xsl:template>


</xsl:stylesheet>
