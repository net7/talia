<!-- 
TEI XSLT stylesheet family
$Date: 2005/01/31 00:04:14 $, $Revision: 1.4 $, $Author: rahtz $

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
  xmlns:fo="http://www.w3.org/1999/XSL/Format"
  >


<!-- ignore the header -->
<xsl:template match="teiHeader">
<!--
  <fo:block>
    <xsl:for-each select="@*"> 
      <xsl:text>Value of </xsl:text><xsl:value-of select="name(.)"/>
      <xsl:text> is </xsl:text><xsl:value-of select="."/>
    </xsl:for-each>
  </fo:block>
-->
</xsl:template>

<xsl:template name="textTitle">
  <xsl:apply-templates select="front"/>  
</xsl:template>

<!-- author and title -->
<xsl:template match="docTitle">
    <fo:block text-align="left" font-size="{$titleSize}" >
      <xsl:if test="ancestor::group/text/front">
        <xsl:attribute name="id">
      <xsl:choose>
        <xsl:when test="ancestor::text/@id">
         <xsl:value-of select="translate(ancestor::text/@id,'_','-')"/>
       </xsl:when>
        <xsl:when test="ancestor::text/@xml:id">
         <xsl:value-of select="translate(ancestor::text/@xml:id,'_','-')"/>
       </xsl:when>
       <xsl:otherwise>
          <xsl:value-of select="generate-id()"/>
       </xsl:otherwise>
       </xsl:choose>
        </xsl:attribute>
      </xsl:if>
	<fo:inline font-weight="bold">
	<xsl:apply-templates select="titlePart"/></fo:inline>
    </fo:block>
</xsl:template>

<xsl:template match="docImprint"/>

<xsl:template match="docAuthor" mode="heading">
  <xsl:if test="preceding-sibling::docAuthor">
   <xsl:choose>
     <xsl:when test="not(following-sibling::docAuthor)">
	<xsl:text> and </xsl:text>
     </xsl:when>
     <xsl:otherwise>
	<xsl:text>, </xsl:text>
     </xsl:otherwise>
   </xsl:choose>
 </xsl:if>
 <xsl:apply-templates/>
</xsl:template>

<xsl:template match="docAuthor">
    <fo:block font-size="{$authorSize}">
       <fo:inline font-style="italic">
        <xsl:apply-templates/>
       </fo:inline>
    </fo:block>
</xsl:template>

<xsl:template match="docDate">
    <fo:block font-size="{$dateSize}">
	<xsl:apply-templates/></fo:block>
</xsl:template>

<!-- omit if found outside front matter -->
<xsl:template match="div/docDate"/>
<xsl:template match="div/docAuthor"/>
<xsl:template match="div/docTitle"/>
</xsl:stylesheet>
