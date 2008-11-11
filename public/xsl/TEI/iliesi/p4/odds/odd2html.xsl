<!-- 
Text Encoding Initiative Consortium XSLT stylesheet family
$Date: 2005/02/20 22:43:15 $, $Revision: 1.16 $, $Author: rahtz $
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
<xsl:stylesheet version="1.0"
  xmlns:a="http://relaxng.org/ns/compatibility/annotations/1.0"
  xmlns:teix="http://www.tei-c.org/ns/Examples"
  xmlns:xs="http://www.w3.org/2001/XMLSchema" 
  xmlns:rng="http://relaxng.org/ns/structure/1.0"
  xmlns:estr="http://exslt.org/strings"
  xmlns:pantor="http://www.pantor.com/ns/local"
  xmlns:exsl="http://exslt.org/common"
  xmlns:tei="http://www.tei-c.org/ns/1.0"
  xmlns:edate="http://exslt.org/dates-and-times"
  extension-element-prefixes="exsl estr edate"
  exclude-result-prefixes="exsl rng edate estr tei a pantor teix xs" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">


<xsl:import href="../html/tei.xsl"/>
<xsl:import href="../html/teihtml-odds.xsl"/>
<xsl:output method="html"/>
<xsl:key name="NameToID" match="*" use="@ident"/>

<xsl:param name="BITS">Bits</xsl:param>
<xsl:param name="STDOUT"></xsl:param>
<xsl:param name="TAG"/>
<xsl:param name="alignNavigationPanel">left</xsl:param>
<xsl:param name="authorWord"></xsl:param>
<xsl:param name="autoToc">false</xsl:param>
<xsl:param name="bottomNavigationPanel">true</xsl:param>
<xsl:param name="cssFile">tei.css</xsl:param>
<xsl:param name="dateWord"></xsl:param>
<xsl:param name="displayMode">rng</xsl:param>
<xsl:param name="feedbackURL">http://www.tei-c.org/Consortium/TEI-contact.html</xsl:param>
<xsl:param name="feedbackWords">Contact</xsl:param>
<xsl:param name="footnoteFile">true</xsl:param>
<xsl:param name="homeLabel">TEI P5 Home</xsl:param>
<xsl:param name="homeURL">http://www.tei-c.org/</xsl:param>
<xsl:param name="homeWords">TEI Home</xsl:param>
<xsl:param name="indent-width" select="3"/>
<xsl:param name="institution">Text Encoding Initiative</xsl:param>
<xsl:param name="line-width" select="80"/>
<xsl:param name="numberBackHeadings">A.1</xsl:param>
<xsl:param name="numberFrontHeadings"></xsl:param>
<xsl:param name="numberHeadings">1.1.</xsl:param>
<xsl:param name="oddmode">html</xsl:param>
<xsl:param name="outputDir">Guidelines</xsl:param>
<xsl:param name="pageLayout">CSS</xsl:param>
<xsl:param name="searchURL">http://search.ox.ac.uk/web/related/natproj/tei</xsl:param>
<xsl:param name="searchWords">Search this site</xsl:param>
<xsl:param name="showTitleAuthor">1</xsl:param>
<xsl:param name="splitBackmatter">yes</xsl:param>
<xsl:param name="splitFrontmatter">yes</xsl:param>
<xsl:param name="splitLevel">1</xsl:param>
<xsl:param name="subTocDepth">-1</xsl:param>
<xsl:param name="tocDepth">3</xsl:param>
<xsl:param name="topNavigationPanel"></xsl:param>
<xsl:param name="verbose">false</xsl:param>
<xsl:template name="copyrightStatement">Copyright TEI Consortium 2004</xsl:template>
<xsl:variable name="top" select="/"/>

<xsl:template name="metaHook">
  <xsl:param name="title"/>
 <meta name="DC.Title" content="{$title}"/>
 <meta name="DC.Language" content="(SCHEME=iso639) en"/> 
 <meta name="DC.Creator" content="TEI,Oxford University Computing Services, 13 Banbury Road, Oxford OX2 6NN, United Kingdom"/>
 <meta name="DC.Creator.Address" content="tei@oucs.ox.ac.uk"/>
</xsl:template>

<xsl:template name="bodyHook">
  <xsl:attribute name="background">background.gif</xsl:attribute>
</xsl:template>


<xsl:template match="processing-instruction()">
<!--
  <xsl:if test="name(.) = 'tei'">
    <xsl:choose>
      <xsl:when test="starts-with(.,'winita')">
    <p>
    <span style="color: red">NOTE: the following example 
    may not have been converted to XML yet!</span>
    </p>
     </xsl:when>
    </xsl:choose>
  </xsl:if>
-->
</xsl:template>


<!-- all notes go in the note file, numbered sequentially, whatever
     they say -->
<xsl:template match="div0">
    <xsl:apply-templates/>
</xsl:template>

<xsl:template match="divGen[@type='index']">
<xsl:variable name="Index">
<Indexterms>
 <xsl:for-each select="//index">
  <index c="{@level}" a="{@level1}" b="{@level2}">
     <file>
       <xsl:apply-templates select="ancestor::div1" mode="generateLink"/>
     </file>
     <section>
       <xsl:apply-templates select="(ancestor::div1|ancestor::div2|ancestor::div3|ancestor::div4|ancestor::div5)[last()]" mode="ident">
         <xsl:with-param name="minimal"></xsl:with-param>
       </xsl:apply-templates>
     </section>
     <loc>
       <xsl:text>IDX-</xsl:text><xsl:number level="any"/>
     </loc>
  </index>
</xsl:for-each>
<xsl:for-each select="//term">
   <xsl:if test="not(@rend='noindex')">
  <index c="{text()}" a="{text()}">
     <file>
       <xsl:apply-templates select="ancestor::div1" mode="generateLink"/>
     </file>
     <section>
       <xsl:apply-templates select="(ancestor::div1|ancestor::div2|ancestor::div3|ancestor::div4|ancestor::div5)[last()]" mode="ident">
         <xsl:with-param name="minimal"></xsl:with-param>
       </xsl:apply-templates>
     </section>
     <loc>
       <xsl:text>TDX-</xsl:text><xsl:number level="any"/>
     </loc>
  </index>
   </xsl:if>
</xsl:for-each>
<!--
  <xsl:message>   ....of gi  elements  </xsl:message>
<xsl:for-each select="//gi">
   <xsl:if test="not(@rend='noindex')">
  <index a="{text()}">
    <xsl:attribute name="c">
      <xsl:text>&lt;</xsl:text>
      <xsl:value-of select="."/><xsl:text>&gt;</xsl:text>
    </xsl:attribute>
     <file>
       <xsl:apply-templates select="ancestor::div1" mode="generateLink"/>
     </file>
     <section>
       <xsl:apply-templates select="(ancestor::div1|ancestor::div2|ancestor::div3|ancestor::div4|ancestor::div5)[last()]" mode="header">
         <xsl:with-param name="minimal"></xsl:with-param>
       </xsl:apply-templates>
     </section>
     <loc>
       <xsl:text>GDX-</xsl:text><xsl:number level="any"/>
     </loc>
  </index>
   </xsl:if>
</xsl:for-each>
-->
</Indexterms>
</xsl:variable>
  <xsl:variable name="sindex">
    <Indexterms>
    <xsl:for-each select="exsl:node-set($Index)/Indexterms/index">
    <xsl:sort select="@a"/>
    <xsl:sort select="@b"/>
    <xsl:copy-of select="."/>
  </xsl:for-each>
</Indexterms>
</xsl:variable>
<dl>
<xsl:for-each select="exsl:node-set($sindex)/Indexterms/index">
  <xsl:if test="not(@a=preceding-sibling::index/@a)">
    <dt><xsl:value-of select="@c"/></dt>
    <dd>
      <xsl:for-each select=".|following-sibling::index[@a=current()/@a]">
          <xsl:if test="@b and not(@b=preceding-sibling::index/@b)">
            <br/>&#160;&#160;<xsl:value-of select="@b"/><br/>
          </xsl:if>
          <a href="{file}#{loc}"><xsl:value-of select="section"/></a>&#160;
      </xsl:for-each>
    </dd>
  </xsl:if>
</xsl:for-each>
</dl>
</xsl:template>

<xsl:template match="docAuthor">
  <p align="center"><em><xsl:value-of select="@n"/><xsl:text> </xsl:text>
   <xsl:apply-templates/></em></p>
</xsl:template>

<xsl:template match="docTitle">
  <p align="center">
   <b><xsl:apply-templates/></b>
  </p>
</xsl:template>

<xsl:template match="note" mode="printnotes">
 <xsl:param name="root"/>
<xsl:if test="not(ancestor::bibl)">
<xsl:variable name="identifier">
    <xsl:number level="any"/>
</xsl:variable>
<p>
 <a name="{concat('Note',$identifier)}"><xsl:value-of select="$identifier"/>. </a>
 <xsl:apply-templates/>
</p>
</xsl:if>
</xsl:template>

<xsl:template match="note">
<xsl:choose>
 <xsl:when test="ancestor::bibl">
  (<xsl:apply-templates/>)
 </xsl:when>

 <xsl:when test="@place='display'">
   <blockquote>NOTE <xsl:number level="any"/>:
    <xsl:apply-templates/>
   </blockquote>
 </xsl:when>

 <xsl:when test="@place='divtop'">
   <blockquote><i><xsl:apply-templates/></i></blockquote>
 </xsl:when>

 <xsl:otherwise>
 <xsl:variable name="identifier">
    <xsl:number level="any"/>
  </xsl:variable>
  <a class="notelink" 
      href="{$masterFile}-notes.html#{concat('Note',$identifier)}">
    <sup><xsl:value-of select="$identifier"/></sup></a>
 </xsl:otherwise>
</xsl:choose>
</xsl:template>

<xsl:template match="revisionDesc//date">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="term">
  <a><xsl:attribute name="name">TDX-<xsl:number level="any"/>
  </xsl:attribute></a>
  <em><xsl:apply-templates/></em>
</xsl:template>

<xsl:template match="titlePage">
  <p><center><xsl:apply-templates/></center></p><hr/>
</xsl:template>

<xsl:template match="titlePart">
  <p align="center"><b><xsl:apply-templates/></b></p>
</xsl:template>

<xsl:template name="calculateNumber">
 <xsl:param name="numbersuffix"/>
 <xsl:choose>
   <xsl:when test="local-name() = 'TEI'">
        <xsl:value-of select="teiHeader//title"/>
   </xsl:when>
   <xsl:when test="local-name(.)='div0'">
     <xsl:number format="I"/>
     <xsl:value-of select="$numbersuffix"/>
   </xsl:when>
   <xsl:when test="local-name(.)='div1'">
    <xsl:choose>
     <xsl:when test="ancestor::back">
       <xsl:if test="not($numberBackHeadings='')">
        <xsl:value-of select="$appendixWords"/><xsl:text> </xsl:text>
        <xsl:number format="{$numberBackHeadings}" from="back" level="any"/>
        <xsl:value-of select="$numbersuffix"/>
       </xsl:if>
     </xsl:when>
     <xsl:when test="ancestor::front">
       <xsl:if test="not($numberFrontHeadings='')">
         <xsl:number format="{$numberFrontHeadings}" from="front" level="any"/>
        <xsl:value-of select="$numbersuffix"/>
       </xsl:if>
     </xsl:when>
     <xsl:when test="not($numberHeadings ='')">
       <xsl:choose>
       <xsl:when test="$prenumberedHeadings">
       		<xsl:value-of select="@n"/>
       </xsl:when>
       <xsl:otherwise>
 	 <xsl:number format="1" from="body" level="any"/>
        <xsl:value-of select="$numbersuffix"/>
       </xsl:otherwise>
       </xsl:choose>
     </xsl:when>
   </xsl:choose>
  </xsl:when>
  <xsl:when test="ancestor::back">
     <xsl:if test="not($numberBackHeadings='')">
        <xsl:value-of select="$appendixWords"/><xsl:text> </xsl:text>
        <xsl:for-each select="ancestor::div1">
          <xsl:number level="any" from="back" format="{$numberBackHeadings}"/>
          <!--          <xsl:text>.</xsl:text>-->
        </xsl:for-each>
        <xsl:number format="{$numberHeadings}" from="div1"
         level="multiple" count="div2|div3|div4|div5|div6"/>
          <xsl:value-of select="$numbersuffix"/>
     </xsl:if>
   </xsl:when>
   <xsl:when test="ancestor::front">
     <xsl:if test="not($numberFrontHeadings='')">
      <xsl:for-each select="ancestor::div1">
         <xsl:number level="any" from="front" format="{$numberFrontHeadings}"/>
         <xsl:value-of select="$numbersuffix"/>
      </xsl:for-each>
      <xsl:number format="{$numberFrontHeadings}" from="div1"
            level="multiple" count="div2|div3|div4|div5|div6"/>
         <xsl:value-of select="$numbersuffix"/>
      </xsl:if>
   </xsl:when>
   <xsl:when test="not($numberHeadings ='')">
       <xsl:choose>
       <xsl:when test="$prenumberedHeadings">
       		<xsl:value-of select="@n"/>
   </xsl:when>
   <xsl:otherwise>
       <xsl:variable name="pre">
        <xsl:for-each select="ancestor::div1">
          <xsl:number level="any" from="body" format="{$numberHeadings}"/>
        </xsl:for-each>
       </xsl:variable>
       <xsl:variable name="post">
            <xsl:choose>
             <xsl:when test="local-name(.)='div2'">
          <xsl:number level="multiple" from="div1" format="1"
            count="div2|div3|div4|div5|div6"/>
           </xsl:when>
             <xsl:when test="local-name(.)='div3'">
          <xsl:number level="multiple" from="div1" format="1.1"
            count="div2|div3|div4|div5|div6"/>
             </xsl:when>
              <xsl:when test="local-name(.)='div4'">
       <xsl:number level="multiple" from="div1" format="1.1.1"
            count="div2|div3|div4|div5|div6"/>
                </xsl:when>
            </xsl:choose>

       </xsl:variable>
       <xsl:value-of select="$pre"/><xsl:value-of select="$post"/>
         <xsl:value-of select="$numbersuffix"/>
   </xsl:otherwise>
  </xsl:choose>
</xsl:when>
</xsl:choose>
</xsl:template>

<xsl:template name="header">
 <xsl:param name="minimal"/>
 <xsl:param name="toc"/>
 <xsl:variable name="depth">
     <xsl:apply-templates select="." mode="depth"/>
 </xsl:variable>
 <xsl:if test="not($depth &gt; $numberHeadingsDepth)">
   <xsl:call-template name="calculateNumber">
       <xsl:with-param name="numbersuffix" select="$headingNumberSuffix"/>
     </xsl:call-template>
 </xsl:if>
 <xsl:if test="not($minimal)">
    <xsl:value-of select="$headingNumberSuffix"/>
    <xsl:choose>
      <xsl:when test="contains(name(.),'Spec')">
	<xsl:call-template name="makeLink">
	  <xsl:with-param name="class">toc</xsl:with-param>
	  <xsl:with-param name="id">
	    <xsl:value-of select="@id"/>
	  </xsl:with-param>
	</xsl:call-template>
      </xsl:when>
      <xsl:when test="not($toc='')">
        <xsl:call-template name="makeInternalLink">
          <xsl:with-param name="class">toc</xsl:with-param>
          <xsl:with-param name="dest"><xsl:value-of select="$toc"/></xsl:with-param>
          <xsl:with-param name="body">
            <xsl:apply-templates mode="plain" select="head"/>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
       <xsl:apply-templates mode="plain" select="head"/>
      </xsl:otherwise>
     </xsl:choose>
 </xsl:if>

</xsl:template>

<xsl:template name="linkListContents">
  <xsl:variable name="thisname">
    <xsl:value-of select="local-name()"/>
  </xsl:variable>
    <xsl:choose>
      <xsl:when test="$thisname='TEI'">
	<xsl:for-each select="text/front">
	  <xsl:for-each select=".//div1">
	    <xsl:variable name="pointer">
	      <xsl:apply-templates mode="generateLink" select="."/>
	    </xsl:variable>
	    <p class="{$style}">
	      <a class="{$style}" href="{$pointer}">
	      <xsl:call-template name="header"/></a>
	    </p>
	  </xsl:for-each>
	  <hr/>
	</xsl:for-each>
	<xsl:for-each select="text/body">
	  <xsl:for-each select=".//div1">
	    <xsl:variable name="pointer">
	      <xsl:apply-templates mode="generateLink" select="."/>
	    </xsl:variable>
	    <p class="{$style}">
	      <a class="{$style}" href="{$pointer}">
	      <xsl:call-template name="header"/></a>
	    </p>
	  </xsl:for-each>
	</xsl:for-each>
	<xsl:for-each select="text/back">
	  <hr/>
	  <xsl:for-each select=".//div1">
	    <xsl:variable name="pointer">
	      <xsl:apply-templates mode="generateLink" select="."/>
	    </xsl:variable>
	    <p class="{$style}">
	      <a class="{$style}" href="{$pointer}">
	      <xsl:call-template name="header"/></a>
	    </p>
	  </xsl:for-each>
	</xsl:for-each>
      </xsl:when>
      <xsl:otherwise>
	<!-- root -->
	<xsl:variable name="BaseFile">
	  <xsl:value-of select="$masterFile"/>
	  <xsl:if test="ancestor::teiCorpus">
	    <xsl:text>-</xsl:text>
	    <xsl:choose>
	      <xsl:when test="@id"><xsl:value-of select="@id"/></xsl:when> 
	      <xsl:otherwise><xsl:number/></xsl:otherwise>
	    </xsl:choose>
	  </xsl:if>
	</xsl:variable>
	<p class="{$style}">
	  <a class="{$style}" href="{$BaseFile}.html">
	  <xsl:value-of select="$homeLabel"/></a>
	</p>
	<hr/>
	    <xsl:for-each select="ancestor::div2|ancestor::div3|ancestor::div4|ancestor::div5">
	      <p class="{$style}">
		<a class="{$style}">
		  <xsl:attribute name="href">
		    <xsl:apply-templates mode="generateLink" select="."/>
		  </xsl:attribute>
		  <xsl:call-template name="header"/>
		</a>
	      </p>
	      <hr/>
	    </xsl:for-each>
	    
	    
	    <p class="{$style}">
	      <a class="{$style}">
		<xsl:attribute name="href">
		  <xsl:apply-templates mode="generateLink" select="."/>
		</xsl:attribute>
		<xsl:call-template name="header"/>
	    </a></p>
	    
	    <!-- ... any children it has -->
	    <xsl:for-each select="div2|div3|div4|div5">
	      <p class="{$style}-sub"><a class="{$style}-sub">
		<xsl:attribute name="href">
		  <xsl:apply-templates mode="generateLink" select="."/>
		</xsl:attribute>
		<xsl:call-template name="header"/>
	      </a></p>
	    </xsl:for-each>
	    
	    
	    <hr/>
	    <!-- preceding divisions -->
	    <xsl:for-each select="preceding::div1">
	      <p class="{$style}">
		<a class="{$style}">
		  <xsl:attribute name="href">
		    <xsl:apply-templates mode="generateLink" select="."/>
		  </xsl:attribute>
		  <xsl:call-template name="header"/>
	      </a></p>
	    </xsl:for-each>
	    
	    <!-- current division -->
	    <p class="{$style}-this">
	      <a class="{$style}-this">
		<xsl:attribute name="href">
		  <xsl:apply-templates mode="generateLink" select="."/>
		</xsl:attribute>
		<xsl:call-template name="header"/>
	    </a></p>
	    
	    <!-- following divisions -->
	    <xsl:for-each select="following::div1">
	      <p class="{$style}">
		<a class="{$style}">
		  <xsl:attribute name="href">
		    <xsl:apply-templates mode="generateLink" select="."/>
		  </xsl:attribute>
		  <xsl:call-template name="header"/>
	      </a></p>
	    </xsl:for-each>
	  </xsl:otherwise>
	</xsl:choose>
</xsl:template>

<!-- this overrides the standard template, to allow for
     <div1> elements being numbered across <div0>
-->
<xsl:template name="locateParent">
      <xsl:apply-templates select="ancestor::div1" mode="ident"/>
</xsl:template>

<xsl:template name="locateParentdiv">
  <xsl:apply-templates select="ancestor::div1" mode="ident"/>
</xsl:template>

<xsl:template name="logoPicture">
<img src="jaco001d.gif" alt="" width="180" />
</xsl:template>

<xsl:variable name="headingNumberSuffix"><xsl:text> </xsl:text></xsl:variable>

<xsl:template name="maintoc"> 
  <xsl:param name="force"/>
   <xsl:for-each select="ancestor-or-self::TEI.2/text/front">
    <xsl:apply-templates 
      select=".//div1" mode="maketoc">
     <xsl:with-param name="forcedepth" select="$force"/>
    </xsl:apply-templates>
   </xsl:for-each>

   <xsl:for-each select="ancestor-or-self::TEI.2/text/body">
    <xsl:apply-templates 
      select=".//div1" mode="maketoc">
     <xsl:with-param name="forcedepth" select="$force"/>
    </xsl:apply-templates>
   </xsl:for-each>

   <xsl:for-each select="ancestor-or-self::TEI.2/text/back">
    <xsl:apply-templates 
      select=".//div1" mode="maketoc">
     <xsl:with-param name="forcedepth" select="$force"/>
   </xsl:apply-templates>
   </xsl:for-each>
</xsl:template>

<xsl:template name="processFootnotes">
  <xsl:apply-templates select="//note" mode="printnotes"/>
</xsl:template>

<xsl:template name="xrefpanel">
<xsl:param name="homepage"/>
<xsl:param name="mode"/>

<p align="{$alignNavigationPanel}">

   <xsl:variable name="Parent">
     <xsl:call-template name="locateParent"/>
     <xsl:text>.html</xsl:text>
   </xsl:variable>
   <xsl:choose>
    <xsl:when test="$Parent = '.html'">
      <xsl:call-template name="upLink">
        <xsl:with-param name="up" select="$homepage"/>
        <xsl:with-param name="title">
          <xsl:call-template name="contentsWord"/>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
        <xsl:call-template name="generateUpLink"/>
    </xsl:otherwise>
   </xsl:choose>

  <xsl:choose>
    <xsl:when test="local-name(.)='div0'">
      <xsl:call-template name="previousLink">
      <xsl:with-param name="previous" select="preceding-sibling::div0[1]"/>
     </xsl:call-template>
    </xsl:when>
    <xsl:when test="local-name(.)='div1'">
      <xsl:call-template name="previousLink">
      <xsl:with-param name="previous" select="preceding::div1[1]"/>
     </xsl:call-template>
    </xsl:when>
    <xsl:when test="local-name(.)='div2'">
      <xsl:call-template name="previousLink">
      <xsl:with-param name="previous" select="preceding-sibling::div2[1]"/>
     </xsl:call-template>
    </xsl:when>
    <xsl:when test="local-name(.)='div3'">
      <xsl:call-template name="previousLink">
      <xsl:with-param name="previous" select="preceding-sibling::div3[1]"/> 
     </xsl:call-template>
   </xsl:when>
  </xsl:choose>

  <xsl:choose>
    <xsl:when test="local-name(.)='div0'">
      <xsl:call-template name="nextLink">
      <xsl:with-param name="next" select="following-sibling::div0[1]"/>
     </xsl:call-template>
    </xsl:when>
    <xsl:when test="local-name(.)='div1'">
      <xsl:call-template name="nextLink">
      <xsl:with-param name="next" select="following::div1[1]"/>
     </xsl:call-template>
    </xsl:when>
    <xsl:when test="local-name(.)='div2'">
      <xsl:call-template name="nextLink">
      <xsl:with-param name="next" select="following-sibling::div2[1]"/>
     </xsl:call-template>
    </xsl:when>
    <xsl:when test="local-name(.)='div3'">
      <xsl:call-template name="nextLink">
      <xsl:with-param name="next" select="following-sibling::div3[1]"/> 
     </xsl:call-template>
   </xsl:when>
  </xsl:choose>

</p>
</xsl:template>



</xsl:stylesheet>

