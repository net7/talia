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

<xsl:template match="milestone">
    <fo:block>
    <xsl:text>******************</xsl:text>
    <xsl:value-of select="@unit"/>
    <xsl:text> </xsl:text><xsl:value-of select="@n"/>
    <xsl:text>******************</xsl:text>
    </fo:block>
</xsl:template>

<xsl:template match="pb">
<xsl:choose>
  <xsl:when test="$activePagebreaks">
     <fo:block break-before="page">
     </fo:block>
  </xsl:when>
  <xsl:otherwise>
     <fo:block text-align="center">
      <xsl:text>&#x2701;[</xsl:text>
      <xsl:value-of select="@unit"/>
      <xsl:text> Page </xsl:text>
      <xsl:value-of select="@n"/>
      <xsl:text>]&#x2701;</xsl:text>
     </fo:block>
  </xsl:otherwise>
</xsl:choose>
</xsl:template>

<xsl:template match="eg[@rend='kwic']/lb"/>

<xsl:template match="cell//lb">
 <xsl:text>&#x2028;</xsl:text>
</xsl:template>

<xsl:template match="lb">
<xsl:choose>
  <xsl:when test="$activeLinebreaks">
<!-- this is a *visible* linebreak character 

PassiveTeX implements it as a real line break
-->
       <xsl:text>&#x2028;</xsl:text>
  </xsl:when>
  <xsl:otherwise>
    <fo:inline font-size="8pt">
      <xsl:text>&#x2761;</xsl:text>
    </fo:inline>
  </xsl:otherwise>
</xsl:choose>
<!-- JT's suggestion:
<fo:inline
 xml:space="preserve"
 white-space-collapse="false">&#xA;</fo:inline>
-->
</xsl:template>



</xsl:stylesheet>
