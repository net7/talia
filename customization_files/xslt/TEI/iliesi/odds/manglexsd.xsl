<?xml version="1.0" encoding="utf-8"?>
<!-- 
Text Encoding Initiative Consortium XSLT stylesheet family
$Date: 2004/12/02 12:01:37 $, $Revision: 1.1 $, $Author: rahtz $

XSL stylesheet to process TEI documents using ODD markup

 
Copyright 1999-2005 Sebastian Rahtz / Text Encoding Initiative Consortium
    This is an XSLT stylesheet for transforming TEI (version P4) XML documents

    Version 4.3.5. Date Thu Mar 10 16:22:08 GMT 2005

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
<!-- separate bits by David Tolpin, combined by Sebastian Rahtz January 2004 


manglexsd.xsl

Take a W3C scheme and sort out inherited content type
problem from trang, which upsets Microsoft

-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  version="1.0"
  xmlns:xsd="http://www.w3.org/2001/XMLSchema"
  xmlns:tei="http://www.tei-c.org/ns/1.0">

<xsl:template match="*|@*|text()|comment()">
  <xsl:copy>
    <xsl:apply-templates select="*|@*|text()|comment()"/>
  </xsl:copy>
</xsl:template>

<xsl:template match="xsd:complexType">
  <xsl:copy>
    <xsl:choose>
      <xsl:when test="@mixed"/>
      <xsl:when test=".//xsd:extension[contains(@base,'macro.phraseSeq')]">
	<xsl:attribute name="mixed">true</xsl:attribute>
      </xsl:when>
      <xsl:when test=".//xsd:extension[contains(@base,'macro.paraContent')]">
	<xsl:attribute name="mixed">true</xsl:attribute>
      </xsl:when>
      <xsl:when test=".//xsd:extension[contains(@base,'macro.specialPara')]">
	<xsl:attribute name="mixed">true</xsl:attribute>
      </xsl:when>
    </xsl:choose>
    <xsl:apply-templates select="*|@*|text()|comment()"/>
  </xsl:copy>
</xsl:template>


</xsl:stylesheet>
