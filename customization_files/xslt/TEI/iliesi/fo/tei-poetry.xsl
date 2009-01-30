<!-- to deal with

THROUGH argument
THROUGH bibl   
THROUGH epigraph
THROUGH group   
THROUGH name    
THROUGH salute
THROUGH signed  
-->
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
<!-- special purpose
 domain-specific elements, whose interpretation
 is open to all sorts of questions -->


<xsl:template match="div[@type='frontispiece']">
 <xsl:apply-templates/>
</xsl:template>

<xsl:template match="div[@type='epistle']">
 <xsl:apply-templates/>
</xsl:template>

<xsl:template match="div[@type='illustration']">
 <xsl:apply-templates/>
</xsl:template>

<xsl:template match="div[@type='canto']">
  <xsl:variable name="divlevel" select="count(ancestor::div)"/>
  <xsl:call-template name="NumberedHeading">
    <xsl:with-param name="level"><xsl:value-of select="$divlevel"/></xsl:with-param>
  </xsl:call-template>
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="div[@type='dedication']">
  <xsl:variable name="divlevel" select="count(ancestor::div)"/>
  <xsl:call-template name="NumberedHeading">
    <xsl:with-param name="level"><xsl:value-of select="$divlevel"/></xsl:with-param>
  </xsl:call-template>
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="byline">
 <fo:block text-align="center">
   <xsl:apply-templates/>
 </fo:block>
</xsl:template>

<xsl:template match="epigraph">
 <fo:block 	
	text-align="center"
	space-before.optimum="4pt"
	space-after.optimum="4pt"
	start-indent="{$exampleMargin}">
   <xsl:apply-templates/>
 </fo:block>
</xsl:template>

<xsl:template match="closer">
 <fo:block 	
	space-before.optimum="4pt"
	space-after.optimum="4pt">
   <xsl:apply-templates/>
 </fo:block>
</xsl:template>

<xsl:template match="salute">
 <fo:block  text-align="left">
   <xsl:apply-templates/>
 </fo:block>
</xsl:template>

<xsl:template match="signed">
 <fo:block  text-align="left">
   <xsl:apply-templates/>
 </fo:block>
</xsl:template>

<xsl:template match="epigraph/lg">
    <fo:block 
	text-align="center"
	space-before.optimum="4pt"
	space-after.optimum="4pt"
	>
      <xsl:apply-templates/>
    </fo:block>
</xsl:template>


<xsl:template match="l">
 <fo:block 	
	space-before.optimum="0pt"
	space-after.optimum="0pt">
   <xsl:choose>
   <xsl:when test="starts-with(@rend,'indent(')">
    <xsl:attribute name="text-indent">
      <xsl:value-of select="concat(substring-before(substring-after(@rend,'('),')'),'em')"/>
    </xsl:attribute>
  </xsl:when>
  <xsl:when test="starts-with(@rend,'indent')">
    <xsl:attribute name="text-indent">1em</xsl:attribute>
  </xsl:when>
  </xsl:choose>
  <xsl:apply-templates/>
 </fo:block> 
</xsl:template>

<xsl:template match="lg">
    <fo:block 
	text-align="start"
	space-before.optimum="4pt"
	space-after.optimum="4pt"
	>
      <xsl:apply-templates/>
    </fo:block>
</xsl:template>

</xsl:stylesheet>
