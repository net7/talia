<!-- 
TEI XSLT stylesheet family
$Date: 2004/05/10 21:58:08 $, $Revision: 1.2 $, $Author: rahtz $

XSL FO stylesheet to format TEI XML documents 

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
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
  xmlns:tei="http://www.tei-c.org/ns/1.0"
  xmlns:fo="http://www.w3.org/1999/XSL/Format">

<xsl:template match='figure'>
 <fo:float>
   <xsl:attribute name="id">
        <xsl:call-template name="idLabel"/>
   </xsl:attribute>
 <fo:block text-align="center">
 <xsl:variable name="File">
  <xsl:variable name="ent">
   <xsl:value-of select="unparsed-entity-uri(@entity)"/>
  </xsl:variable>
  <xsl:choose> 
  <xsl:when test="@file">
   <xsl:value-of select="@file"/>
  </xsl:when>
  <xsl:when test="@url">
   <xsl:value-of select="@url"/>
  </xsl:when>
  <xsl:when test="starts-with($ent,'file:')">
<!-- some XSL processors, eg xt, turn plain names into a full file: URL -->
 <xsl:value-of select="substring-after($ent,'file:')"/>
  </xsl:when>
  <xsl:otherwise>
 <xsl:value-of select="$ent"/>
  </xsl:otherwise>
  </xsl:choose>
 </xsl:variable>
 <xsl:if test="not($File='')">
  <fo:external-graphic>
    <xsl:attribute name="src">
      <xsl:if test="not(starts-with($File,'./'))">
        <xsl:value-of select="$graphicsPrefix"/>
      </xsl:if>
      <xsl:value-of select="$File"/>
      <xsl:if test="not(contains($File,'.'))">
        <xsl:value-of select="$graphicsSuffix"/>
      </xsl:if>
    </xsl:attribute>
 <xsl:choose>
  <xsl:when test="@scale">
      <xsl:attribute name="content-width">
         <xsl:value-of select="@scale * 100"/><xsl:text>%</xsl:text>
      </xsl:attribute>
  </xsl:when>
  <xsl:when test="@width and not(@width=0)">
      <xsl:attribute name="content-width">
         <xsl:value-of select="@width"/>
      </xsl:attribute>
  </xsl:when>
  <xsl:when test="@height and not(@height=0)">
      <xsl:attribute name="content-height">
         <xsl:value-of select="@height"/>
      </xsl:attribute>
  </xsl:when>
  <xsl:when test="$autoScaleFigures">
      <xsl:attribute name="content-width">
          <xsl:value-of select="$autoScaleFigures"/></xsl:attribute>
  </xsl:when>
  </xsl:choose>
 </fo:external-graphic>
 </xsl:if>
 </fo:block>
 <fo:block>
   <xsl:call-template name="figureCaptionstyle"/>
     <xsl:value-of select="$figureWord"/>
     <xsl:call-template name="calculateFigureNumber"/>
     <xsl:text>. </xsl:text>
      <xsl:apply-templates select="head"/>
  </fo:block>
 </fo:float>
</xsl:template>

<xsl:template match='figure' mode="xref">
   <xsl:if test="$xrefShowTitle">
     <xsl:value-of select="$figureWord"/>
     <xsl:text> </xsl:text>
   </xsl:if>
   <xsl:call-template name="calculateFigureNumber"/>
   <xsl:if test="$xrefShowHead='true'">
     <xsl:if test="head">
       <xsl:text> (</xsl:text>
         <xsl:apply-templates select="head"/>
       <xsl:text>)</xsl:text>
     </xsl:if>
   </xsl:if>
   <xsl:if test="$xrefShowPage='true'">
    on page
   <fo:page-number-citation>
    <xsl:attribute name="ref-id">
      <xsl:call-template name="idLabel"/>     
    </xsl:attribute>
    </fo:page-number-citation> 
   </xsl:if>
</xsl:template>

<xsl:template match="figure[@rend='inline']">
 <xsl:variable name="File">
  <xsl:choose> 
  <xsl:when test="@file">
   <xsl:value-of select="@file"/>
  </xsl:when>
  <xsl:when test="@url">
   <xsl:value-of select="@url"/>
  </xsl:when>
  <xsl:otherwise>
 <xsl:value-of select="substring-after(unparsed-entity-uri(@entity),'file:')"/>
  </xsl:otherwise>
  </xsl:choose>
 </xsl:variable>
  <fo:external-graphic text-align="relative">
   <xsl:attribute name="id">
        <xsl:call-template name="idLabel"/>
   </xsl:attribute>
    <xsl:attribute name="src">
      <xsl:if test="not(starts-with($File,'./'))">
        <xsl:value-of select="$graphicsPrefix"/>
      </xsl:if>
      <xsl:value-of select="$File"/>
      <xsl:if test="not(contains($File,'.'))">
        <xsl:value-of select="$graphicsSuffix"/>
      </xsl:if>
    </xsl:attribute>
 <xsl:choose>
  <xsl:when test="@scale">
      <xsl:attribute name="content-width">
        <xsl:value-of select="@scale * 100"/><xsl:text>%</xsl:text>
      </xsl:attribute>
  </xsl:when>
  <xsl:when test="@width">
      <xsl:attribute name="content-width">
        <xsl:value-of select="@width"/>
      </xsl:attribute>
  </xsl:when> 
  <xsl:when test="@height">
      <xsl:attribute name="content-height">
        <xsl:value-of select="@height"/>
      </xsl:attribute>
  </xsl:when>
 <xsl:when test="$autoScaleFigures">
      <xsl:attribute name="content-width">
          <xsl:value-of select="$autoScaleFigures"/></xsl:attribute>
  </xsl:when>
 </xsl:choose>
 </fo:external-graphic>
<xsl:choose>
 <xsl:when test="$captionInlinefigures">
 <fo:block>
     <xsl:call-template name="figureCaptionstyle"/>
     <xsl:text>Figure </xsl:text>
     <xsl:call-template name="calculateFigureNumber"/>
      <xsl:text>. </xsl:text>
      <xsl:apply-templates select="head"/>
  </fo:block>
 </xsl:when>
 <xsl:otherwise>
  <xsl:if test="head">
   <fo:block text-align="center">
      <xsl:apply-templates select="head"/>
  </fo:block>
 </xsl:if>
 </xsl:otherwise>
</xsl:choose>
</xsl:template>


<xsl:template name="calculateFigureNumber">
     <xsl:number  from="text" level="any"/>
</xsl:template>

<xsl:template match="figDesc"/>

</xsl:stylesheet>
