<!-- 
Text Encoding Initiative Consortium XSLT stylesheet family
$Date: 2005/02/27 23:31:17 $, $Revision: 1.6 $, $Author: rahtz $

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

  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">



<!-- top-level stuff -->

<xsl:template match="docImprint"/>


<xsl:template match="front|titlePart">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="titlePage">
    <hr/>
    <p>
      <!-- first, the complete <docTitle> in bold -->
      <span class="docTitle">
        <xsl:value-of select="normalize-space(docTitle)"/>
      </span>
    </p>
    <xsl:if test="docAuthor">
      <p>
	<xsl:text>by </xsl:text>
	<xsl:for-each select="docAuthor">
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
	  <span class="docAuthor">
	    <xsl:apply-templates select="." mode="print"/>
	  </span>
	</xsl:for-each>
      </p>
    </xsl:if>
    <xsl:if test="docDate">
      <p class="docDate">
	<xsl:text>on </xsl:text>
	<xsl:apply-templates mode="print" select="docDate"/>
      </p>
    </xsl:if>
    <hr/>
</xsl:template>

<xsl:template match="body|back" mode="split">
  <xsl:for-each select="*">
   <xsl:choose>
    <xsl:when test="starts-with(local-name(.),'div')">
       <xsl:apply-templates select="." mode="split"/>
    </xsl:when>
    <xsl:otherwise>
       <xsl:apply-templates select="."/>
    </xsl:otherwise>
   </xsl:choose>
  </xsl:for-each>
</xsl:template>

<xsl:template match="teiHeader"/>

<!-- author and title -->
<xsl:template match="docTitle"/>
<xsl:template match="docAuthor"/>
<xsl:template match="docDate"/>

<xsl:template match="docDate" mode="print">
    <xsl:apply-templates/>
</xsl:template>

<xsl:template match="docAuthor" mode="author">
     <xsl:if test="preceding-sibling::docAuthor">
	<xsl:text>, </xsl:text>
     </xsl:if>
    <xsl:apply-templates/>
</xsl:template>



</xsl:stylesheet>
