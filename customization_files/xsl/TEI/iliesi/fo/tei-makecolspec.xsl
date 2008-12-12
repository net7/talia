<?xml version="1.0" encoding="utf-8"?>
<!-- 
TEI XSLT stylesheet family
$Date: 2004/11/30 10:11:21 $, $Revision: 1.5 $, $Author: rahtz $

XSL stylesheet to format TEI XML documents to HTML or XSL FO

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
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:fotex="http://www.tug.org/fotex"
  xmlns:exsl="http://exslt.org/common"
  xmlns:tei="http://www.tei-c.org/ns/1.0"
  exclude-result-prefixes="saxon exsl" 
  extension-element-prefixes="saxon exsl fotex"
  xmlns:saxon="http://icl.com/saxon"
  xmlns:fo="http://www.w3.org/1999/XSL/Format"
                version="1.0">


<xsl:template name="deriveColSpecs" >
<xsl:variable name="no">
 <xsl:call-template name="generateTableID"/>
</xsl:variable>


<xsl:choose>
<xsl:when test="$readColSpecFile">
<xsl:variable name="specs">
<xsl:value-of 
  select="count(exsl:node-set($tableSpecs)/Info/TableSpec[$no=@id])"/>
</xsl:variable>
<xsl:choose>
<xsl:when test="$specs &gt; 0">
    <xsl:for-each 
select="exsl:node-set($tableSpecs)/Info/TableSpec[$no=@id]/fo:table-column">
      <xsl:copy-of select="."/>
 </xsl:for-each>
</xsl:when>
<xsl:otherwise>
<!--
 <xsl:message>Build specs for Table <xsl:value-of select="$no"/></xsl:message>
-->
 <xsl:call-template name="calculateTableSpecs"/>
</xsl:otherwise>
</xsl:choose>
</xsl:when>
<xsl:otherwise>
<!--
 <xsl:message>Build specs for Table <xsl:value-of select="$no"/></xsl:message>
-->
 <xsl:call-template name="calculateTableSpecs"/>
</xsl:otherwise>
</xsl:choose>
</xsl:template>

<xsl:template name="calculateTableSpecs">
<xsl:variable name="tds">
 <xsl:for-each select=".//cell">
  <xsl:variable name="stuff">
     <xsl:apply-templates/>
  </xsl:variable>
   <cell>
    <xsl:attribute name="col"><xsl:number/></xsl:attribute>
    <xsl:value-of select="string-length($stuff)"/>
   </cell>
 </xsl:for-each>
</xsl:variable>
<xsl:variable name="total">
  <xsl:value-of select="sum(exsl:node-set($tds)/cell)"/>
</xsl:variable>
<xsl:for-each select="exsl:node-set($tds)/cell">
  <xsl:sort select="@col" data-type="number"/>
  <xsl:variable name="c" select="@col"/>
  <xsl:if test="not(preceding-sibling::cell[$c=@col])">
   <xsl:variable name="len">
    <xsl:value-of select="sum(following-sibling::cell[$c=@col]) + current()"/>
   </xsl:variable>
   <xsl:text>
 </xsl:text>
   <fo:table-column column-number="{@col}" fotex:column-align="L" column-width="{$len div $total * 100}%" />
  </xsl:if>
</xsl:for-each>
   <xsl:text>&#10;</xsl:text>
</xsl:template>

<xsl:template name="generateTableID">
<xsl:choose>
 <xsl:when test="@xml:id">
   <xsl:value-of select="@xml:id"/>
 </xsl:when>
 <xsl:when test="@id">
   <xsl:value-of select="@id"/>
 </xsl:when>
 <xsl:otherwise>
   <xsl:text>Table-</xsl:text><xsl:number level='any'/>
 </xsl:otherwise>
</xsl:choose>
</xsl:template>

</xsl:stylesheet>
