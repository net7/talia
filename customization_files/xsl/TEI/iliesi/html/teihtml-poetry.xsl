<!-- $Date: 
Text Encoding Initiative Consortium XSLT stylesheet family
2001/10/01 $, $Revision: 1.2 $, $Author: rahtz $

XSL HTML stylesheet to format TEI XML documents 

 
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

  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
  xmlns:fo="http://www.w3.org/1999/XSL/Format"
  >

<xsl:template match="div[@type='frontispiece']">
 <xsl:apply-templates/>
</xsl:template>

<xsl:template match="div[@type='epistle']">
 <xsl:apply-templates/>
</xsl:template>

<xsl:template match="div[@type='illustration']">
 <xsl:apply-templates/>
</xsl:template>

<!--
<xsl:template match="div[@type='canto']">
  <xsl:variable name="divlevel" select="count(ancestor::div)"/>
  <xsl:call-template name="NumberedHeading">
    <xsl:with-param name="level"><xsl:value-of select="$divlevel"/></xsl:with-param>
  </xsl:call-template>
  <xsl:apply-templates/>
</xsl:template>

-->

<xsl:template match="byline">
 <p align="center">
   <xsl:apply-templates/>
 </p>
</xsl:template>

<xsl:template match="epigraph">
 <p 		align="center">
   <xsl:apply-templates/>
 </p>
</xsl:template>

<xsl:template match="closer">
 <p 	
	space-before.optimum="4pt"
	space-after.optimum="4pt">
   <xsl:apply-templates/>
 </p>
</xsl:template>

<xsl:template match="salute">
 <p  align="left">
   <xsl:apply-templates/>
 </p>
</xsl:template>

<xsl:template match="signed">
 <p  align="left">
   <xsl:apply-templates/>
 </p>
</xsl:template>

<xsl:template match="epigraph/lg">
    <table>
      <xsl:apply-templates/>
    </table>
</xsl:template>
<!--lg by ILIESI-->
  <xsl:template match="q[@type='ct']/lg">
    <xsl:apply-templates mode="no_tabella"/>
  </xsl:template>
      
<xsl:template match="lg/l" mode="no_tabella">
  <xsl:apply-templates/><br/>
</xsl:template>
<!--end ILIESI  -->
  
  <xsl:template match="l">
    <xsl:apply-templates/><br/>
  </xsl:template>
  
<!-- mode added  by ILIESI 
 <xsl:template match="lg/l">
 end ILIESI-->
  
<xsl:template match="lg/l" mode="tabella">
  <tr><td>
  <xsl:choose>
    <xsl:when test="@rend='Alignr'">
      <xsl:attribute name="align">right</xsl:attribute>
    </xsl:when>
    <xsl:when test="@rend='Alignc'">
     <xsl:attribute name="align">center</xsl:attribute>
    </xsl:when>
    <xsl:when test="@rend='Alignl'">
      <xsl:attribute name="align">left</xsl:attribute>
      <xsl:text>&#xA0;&#xA0;</xsl:text>
    </xsl:when>
    <xsl:otherwise>
      <xsl:attribute name="align"><xsl:value-of select="$cellAlign"/></xsl:attribute>
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
</xsl:otherwise>
</xsl:choose>
  <xsl:apply-templates/>
</td></tr> 
</xsl:template>

<xsl:template match="lg">
    <table class="lg">
 <!--     mode added by ILIESI
      <xsl:apply-templates />
      end ILIESI-->
      <xsl:apply-templates mode="tabella"/>
    </table>
</xsl:template>

</xsl:stylesheet>
