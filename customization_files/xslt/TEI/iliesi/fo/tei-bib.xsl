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
  xmlns:fo="http://www.w3.org/1999/XSL/Format"
  >

<xsl:template match="bibl">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="listBibl/bibl">
 <fo:block>
     <xsl:call-template name="addID"/>
     <xsl:attribute name="space-before.optimum">
<xsl:value-of select="$spaceBeforeBibl"/></xsl:attribute>
     <xsl:attribute name="space-after.optimum">
<xsl:value-of select="$spaceAfterBibl"/></xsl:attribute>
     <xsl:attribute name="text-indent">-<xsl:value-of select="$indentBibl"/>
</xsl:attribute>
     <xsl:attribute name="start-indent"><xsl:value-of select="$indentBibl"/>
</xsl:attribute>
   <xsl:apply-templates/>
 </fo:block>
</xsl:template>

<xsl:template match="listBibl">
<xsl:choose>
<!-- is it in the back matter? -->
<xsl:when test="ancestor::back">
 <fo:page-sequence>
  <fo:block>
  <xsl:call-template name="listBiblSetup"/>
  </fo:block>
  <xsl:apply-templates/>
 </fo:page-sequence>
</xsl:when>
<xsl:otherwise>
  <xsl:apply-templates/>
</xsl:otherwise>
</xsl:choose>
</xsl:template>

<xsl:template name="listBiblSetup">
    <xsl:call-template name="setupDiv0"/>
     <xsl:call-template name="addID"/>
     <xsl:value-of select="$biblioWords"/>
</xsl:template>

</xsl:stylesheet>
