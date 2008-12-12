<!-- 
TEI XSLT stylesheet family
$Date: 2004/11/23 10:05:32 $, $Revision: 1.3 $, $Author: rahtz $

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

<!-- enable, for new elements to get commented as such-->
<xsl:template match="*">
 <xsl:comment><xsl:text>PASS THROUGH </xsl:text>
   <xsl:value-of select="name()"/>
 </xsl:comment>
 <xsl:apply-templates/>
</xsl:template>

<xsl:template name="rend">
 <xsl:param name="defaultvalue"/>
 <xsl:param name="defaultstyle"/>
 <xsl:param name="rend"/>
<xsl:choose>
 <xsl:when test="$rend=''">
     <xsl:attribute name="{$defaultstyle}">
         <xsl:value-of select="$defaultvalue"/>
    </xsl:attribute>  
 </xsl:when>
 <xsl:when test="contains($rend,';')">
   <xsl:call-template name="applyRend">
     <xsl:with-param name="rendvalue" select="substring-before($rend,';')"/>
   </xsl:call-template>
   <xsl:call-template name="rend">
     <xsl:with-param name="rend" select="substring-after($rend,';')"/>
   </xsl:call-template>
 </xsl:when>
 <xsl:otherwise>
   <xsl:call-template name="applyRend">
     <xsl:with-param name="rendvalue" select="$rend"/>
   </xsl:call-template>   
 </xsl:otherwise>
</xsl:choose>
</xsl:template>

<xsl:template name="applyRend">
  <xsl:param name="rendvalue"/>
   <xsl:choose>
   <xsl:when test="$rendvalue='gothic'">
     <xsl:attribute name="font-family">fantasy</xsl:attribute>
   </xsl:when>
   <xsl:when test="$rendvalue='calligraphic'">
     <xsl:attribute name="font-family">cursive</xsl:attribute>
   </xsl:when>
   <xsl:when test="$rendvalue='ital' or $rendvalue='italic' or $rendvalue='it' or $rendvalue='i'">
     <xsl:attribute name="font-style">italic</xsl:attribute>
   </xsl:when>
   <xsl:when test="$rendvalue='sc'">
     <xsl:attribute name="font-variant">small-caps</xsl:attribute>
   </xsl:when>
   <xsl:when test="$rendvalue='code'">
     <xsl:attribute name="font-family">
       <xsl:value-of select="$typewriterFont"/>
     </xsl:attribute>
   </xsl:when>
   <xsl:when test="$rendvalue='bo' or $rendvalue='bold'">
     <xsl:attribute name="font-weight">bold</xsl:attribute>
   </xsl:when>
   <xsl:when test="$rendvalue='BO'">
     <xsl:attribute name="font-style">italic</xsl:attribute>
     <xsl:attribute name="text-decoration">underline</xsl:attribute>
   </xsl:when>
   <xsl:when test="$rendvalue='UL' or $rendvalue='ul'">
     <xsl:attribute name="text-decoration">underline</xsl:attribute>
   </xsl:when>
   <xsl:when test="$rendvalue='sub'">
     <xsl:attribute name="vertical-align">sub</xsl:attribute>
   </xsl:when>
   <xsl:when test="$rendvalue='small'">
     <xsl:attribute name="font-size">small</xsl:attribute>
   </xsl:when>
   <xsl:when test="$rendvalue='strike'">
     <xsl:attribute name="text-decoration">line-through</xsl:attribute>
   </xsl:when>
   <xsl:when test="$rendvalue='sup'">
     <xsl:attribute name="vertical-align">super</xsl:attribute>
   </xsl:when>
</xsl:choose>
</xsl:template>

<xsl:template name="addID">
      <xsl:attribute name="id">
        <xsl:call-template name="idLabel"/>
      </xsl:attribute>
</xsl:template>

<xsl:template name="idLabel">
   <xsl:choose>
       <xsl:when test="@xml:id">
         <xsl:value-of select="translate(@xml:id,'_','-')"/>
       </xsl:when>
       <xsl:when test="@id">
         <xsl:value-of select="translate(@id,'_','-')"/>
       </xsl:when>
       <xsl:otherwise>
          <xsl:value-of select="generate-id()"/>
       </xsl:otherwise>
   </xsl:choose>
</xsl:template>

<xsl:template match="processing-instruction()[name()='xmltex']" >
<xsl:message>xmltex pi <xsl:value-of select="."/></xsl:message>
   <xsl:copy-of select="."/>
</xsl:template>

</xsl:stylesheet>
