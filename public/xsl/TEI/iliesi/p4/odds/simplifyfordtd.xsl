<?xml version="1.0" encoding="utf-8"?>
<!-- 
Text Encoding Initiative Consortium XSLT stylesheet family
$Date: 2005/01/23 22:54:38 $, $Revision: 1.7 $, $Author: rahtz $

XSL stylesheet to process TEI documents using ODD markup

 
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
  xmlns:s="http://www.ascc.net/xml/schematron"
  xmlns:exsl="http://exslt.org/common"
  extension-element-prefixes="exsl"
  xmlns:xsp="http://apache.org/xsp/core/v1"
  xmlns:xi="http://www.w3.org/2001/XInclude"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" 
  xmlns:a="http://relaxng.org/ns/compatibility/annotations/1.0" 
  xmlns:f="http://axkit.org/NS/xsp/perform/v1" 
  xmlns:tei="http://www.tei-c.org/ns/1.0" 
  exclude-result-prefixes="exsl rng a f tei s xs" 
  xmlns:rng="http://relaxng.org/ns/structure/1.0" 
  version="1.0">

<xsl:output indent="yes"/>


<xsl:key name="Die" match="rng:define[rng:notAllowed and count(rng:*)=1]" use="@name"/>
<xsl:key name="All" match="rng:define" use="@name"/>
<xsl:key name="Refs" match="rng:ref" use="@name"/>

<xsl:template match="*|@*|text()|comment()">
  <xsl:copy>
    <xsl:apply-templates select="*|@*|text()|comment()"/>
  </xsl:copy>
</xsl:template>

<xsl:template match="rng:ref">
  <xsl:if test="not(count(key('All',@name))=1 and key('Die',@name))">
    <xsl:copy>
      <xsl:apply-templates select="*|@*|text()|comment()"/>
    </xsl:copy>
  </xsl:if>
</xsl:template>

<xsl:template match="rng:define">
  <xsl:choose>
    <xsl:when test="key('Refs',@name)">
      <xsl:copy>
	<xsl:apply-templates select="*|@*|text()|comment()"/>
      </xsl:copy>
    </xsl:when>
  </xsl:choose>
</xsl:template>

<xsl:template match="rng:oneOrMore/rng:notAllowed">
  <xsl:if test="not(following-sibling::*)">
    <xsl:copy/>
  </xsl:if>
</xsl:template>

<xsl:template match="rng:zeroOrMore/rng:notAllowed">
  <xsl:if test="not(following-sibling::*)">
    <xsl:copy/>
  </xsl:if>
</xsl:template>

<xsl:template match="rng:choice[count(rng:*)=0]"><rng:notAllowed/></xsl:template>
<xsl:template match="rng:define[count(rng:*)=0]">
  <xsl:copy>
    <xsl:copy-of select="@*"/>
    <rng:notAllowed/>
  </xsl:copy>
</xsl:template>
<xsl:template match="rng:group[count(rng:*)=0]"/>
<xsl:template match="rng:define/rng:group[count(rng:*)=0]"><rng:notAllowed/></xsl:template>
<xsl:template match="rng:optional[count(rng:*)=0]"/>
<xsl:template match="rng:zeroOrMore[count(rng:*)=0]"/>
<xsl:template match="rng:oneOrMore[count(rng:*)=0]"/>
<xsl:template match="rng:zeroOrMore[count(rng:*)=1 and rng:notAllowed]"/>
<xsl:template match="rng:oneOrMore[count(rng:*)=1 and rng:notAllowed]"/>
<xsl:template match="rng:choice[count(rng:*)=1 and rng:notAllowed]"/>

<xsl:template match="rng:element[.//rng:anyName]">
  <rng:text/>
</xsl:template>

</xsl:stylesheet>

