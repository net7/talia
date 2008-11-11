<!-- 
Text Encoding Initiative Consortium XSLT stylesheet family
$Date: 2005/02/20 22:34:36 $, $Revision: 1.6 $, $Author: rahtz $

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
  
  
  <xsl:template name="noteN">
    <xsl:variable name="place" select="@place"/>
    <xsl:choose>
      <xsl:when test="@id">
	<xsl:value-of select="@id"/>
      </xsl:when>
      <xsl:when test="@n">
	<xsl:value-of select="@n"/>
      </xsl:when>
      <xsl:when test="ancestor::front">
	<xsl:number level="any"  count="note[@place=$place]" from="front"/>
      </xsl:when>
      <xsl:when test="ancestor::back">
	<xsl:number level="any"  count="note[@place=$place]" from="back"/>
      </xsl:when>
      <xsl:otherwise>
	<xsl:number level="any" count="note[@place=$place]" from="body"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template match="note">    
    <xsl:choose> 
      <xsl:when test="@place='inline'">
	<xsl:text> (</xsl:text>
	<xsl:apply-templates/>
	<xsl:text>)</xsl:text>
      </xsl:when>
<!--   notes by ILIESI   -->
     <xsl:when test="ancestor::bibl|@type='apparato'">
        <span style="color:#FF0000; font-weight:bold" >
          <xsl:apply-templates />
        </span> 
     </xsl:when>
      <xsl:when test="@place='npp'">
        <span style="font-size: 50%">
          <xsl:apply-templates />
        </span>
      </xsl:when>
      <xsl:when test="@place='margin'">
        <xsl:apply-templates/>
      </xsl:when>
      <xsl:when test="@type='apparato'">
        <span style="color:#FF0000; font-weight:bold" >
          <xsl:apply-templates />
        </span> 
      </xsl:when>
      <xsl:when test="@type='riferimento'">
          <xsl:apply-templates />
      </xsl:when>
 <!--   end ILIESI   --> 
      <xsl:when test="ancestor::bibl">
        (<xsl:apply-templates/>)
      </xsl:when>
     <xsl:when test="@place='display'">
	<blockquote>NOTE:
	<xsl:apply-templates/>
	</blockquote>
      </xsl:when>
      <xsl:when test="@place='foot' or @place='end'">
	<xsl:variable name="identifier">
	  <xsl:call-template name="noteN"/>
	</xsl:variable>
	<xsl:choose>
	  <xsl:when test="$footnoteFile">
	    <a class="notelink" href="{$masterFile}-notes.html#{concat('Note',$identifier)}">
	    <sup><xsl:value-of select="$identifier"/></sup></a>
	  </xsl:when>
	  <xsl:otherwise>
	    <a class="notelink" href="#{concat('Note',$identifier)}">
	    <sup><xsl:value-of select="$identifier"/></sup></a>
	  </xsl:otherwise>
	</xsl:choose>
      </xsl:when>      
      <xsl:otherwise>
	<xsl:text> [Note: </xsl:text>
	<xsl:apply-templates select="." mode="printnotes"/>
	<xsl:text>]</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  
  <xsl:template match="note" mode="printnotes">
    <xsl:if test="not(ancestor::bibl)">
      <xsl:variable name="identifier">
	<xsl:call-template name="noteN"/>
      </xsl:variable>
      <xsl:variable name="parent">
	<xsl:call-template name="locateParentdiv"/>
      </xsl:variable>
      <xsl:if test="$verbose">
	<xsl:message>Note <xsl:value-of select="$identifier"/> with parent <xsl:value-of select="$parent"/></xsl:message>
      </xsl:if>
      <div class="note">
	<a name="{concat('Note',$identifier)}"><xsl:value-of select="$identifier"/>. </a>
	<xsl:apply-templates/>
      </div>
    </xsl:if>
  </xsl:template>
  
  
  <xsl:template name="writeNotes">
    <html><xsl:call-template name="addLangAtt"/> 
    <head>
      <title>Notes for
      <xsl:apply-templates select="descendant-or-self::text/front//docTitle//text()"/></title>
      <xsl:call-template name="includeCSS"/>
    </head>
    <body>
      <xsl:call-template name="bodyHook"/>
      <xsl:call-template name="bodyJavaScriptHook"/>
      <xsl:call-template name="stdheader">
	<xsl:with-param name="title">
	  <xsl:text>Notes for </xsl:text>
	  <xsl:apply-templates select="descendant-or-self::text/front//docTitle//text()"/>
	</xsl:with-param>
      </xsl:call-template>
      
      <div class="notes">
	<div class="noteHeading"><xsl:value-of select="$noteHeading"/></div>
	<xsl:apply-templates
	    select="descendant::note[@place]"
	    mode="printnotes"/>
      </div>
      
      <xsl:call-template name="stdfooter">
	<xsl:with-param name="date">
	  <xsl:choose>
	    <xsl:when test="ancestor-or-self::TEI.2/teiHeader/revisionDesc//date[1]">
	      <xsl:value-of select="ancestor-or-self::TEI.2/teiHeader/revisionDesc//date[1]"/>
	    </xsl:when>
	    <xsl:otherwise>
	      <xsl:value-of select="ancestor-or-self::TEI.2//front//docDate"/>
	    </xsl:otherwise>    
	  </xsl:choose>
	</xsl:with-param>
	<xsl:with-param name="author">
	  <xsl:apply-templates select="ancestor-or-self::TEI.2//front//docAuthor" mode="author"/>
	</xsl:with-param>
      </xsl:call-template>
    </body>
    </html>
  </xsl:template>
  
  
  <xsl:template match="note[@type='action']">
    <div align="right">
      <b>Action <xsl:number level="any" count="note[@type='action']"/></b>:
      <i><xsl:apply-templates/></i>
    </div>
  </xsl:template>
  
  <xsl:template match="divGen[@type='actions']">
    <h3>Actions arising</h3>
    <dl>
      <xsl:for-each select="/TEI.2/text//note[@type='action']">
	<dt><b><xsl:number level="any" count="note[@type='action']"/></b></dt>
	<dd><xsl:apply-templates/></dd>      
      </xsl:for-each>
    </dl>
  </xsl:template>
  

<xsl:template name="partialFootNotes">
  <xsl:param name="currentID"/>
  <xsl:choose>
    <xsl:when test="$currentID='current'"/>
    <xsl:when test="$currentID='' and $splitLevel=-1">
      <xsl:call-template name="printNotes"/>
    </xsl:when>
    <xsl:when test="$currentID=''">
      <xsl:for-each select=" descendant::text">
	      <xsl:call-template name="printNotes"/>
      </xsl:for-each>
      </xsl:when>
      <xsl:otherwise>
	<xsl:choose>
	  <xsl:when test="count(key('IDS',$currentID))&gt;0">
	    <xsl:for-each select="key('IDS',$currentID)">  
	      <xsl:call-template name="printNotes"/>
	    </xsl:for-each>
	  </xsl:when>
	  <xsl:otherwise>
	    <xsl:apply-templates
		select="ancestor-or-self::TEI.2/descendant::text" 
		mode="xpath">
	       <xsl:with-param name="xpath" select="$currentID" />
	       <xsl:with-param name="action">notes</xsl:with-param>
	    </xsl:apply-templates>
	  </xsl:otherwise>
	</xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
</xsl:template>

<xsl:template name="printNotes">
  <xsl:if test="descendant::note[@place]">
    <xsl:choose>
      <xsl:when test="not($footnoteFile='')">
	<xsl:variable name="BaseFile">
	  <xsl:value-of select="$masterFile"/>
	  <xsl:call-template name="addCorpusID"/>
	</xsl:variable>
	<xsl:call-template name="outputChunk">
	  <xsl:with-param name="ident">
	    <xsl:value-of select="concat($BaseFile,'-notes')"/>
	  </xsl:with-param>
	  <xsl:with-param name="content">
	    <xsl:call-template name="writeNotes"/>
	  </xsl:with-param>
	</xsl:call-template>
      </xsl:when>
      <xsl:otherwise>	
	<div class="notes">
	  <div class="noteHeading"><xsl:value-of select="$noteHeading"/></div>
	  <xsl:apply-templates
	      select="descendant::note[@place]"
	      mode="printnotes"/>
	</div>
      </xsl:otherwise>
    </xsl:choose>

  </xsl:if>
</xsl:template>

</xsl:stylesheet>
