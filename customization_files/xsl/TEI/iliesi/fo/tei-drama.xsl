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

<xsl:template match="sp">
<fo:block 
	text-align="justify" 
	start-indent="1em"
	text-indent="-1em"
 	space-before="3pt"
	>
      <xsl:apply-templates/>
</fo:block>
</xsl:template>

<!-- paragraphs inside speeches do very little-->
 <xsl:template match="sp/p">
  <fo:inline> 
    <xsl:apply-templates/>
  </fo:inline>
</xsl:template>


<xsl:template match="speaker">
<fo:inline>
 <xsl:call-template name="rend">
   <xsl:with-param name="defaultvalue" select="string('italic')"/>
   <xsl:with-param name="defaultstyle" select="string('font-style')"/>
 </xsl:call-template>
      <xsl:apply-templates/><xsl:text> </xsl:text>
</fo:inline>
</xsl:template>

<xsl:template match="p/stage">
<fo:inline>
 <xsl:call-template name="rend">
   <xsl:with-param name="defaultvalue" select="string('normal')"/>
   <xsl:with-param name="defaultstyle" select="string('font-style')"/>
 </xsl:call-template>
      <xsl:apply-templates/>
</fo:inline>
</xsl:template>

<xsl:template match="stage">
<fo:block>
 <xsl:attribute name="text-indent">1em</xsl:attribute>
 <xsl:call-template name="rend">
   <xsl:with-param name="defaultvalue" select="string('normal')"/>
   <xsl:with-param name="defaultstyle" select="string('font-style')"/>
 </xsl:call-template>
      <xsl:apply-templates/>
</fo:block>
</xsl:template>

</xsl:stylesheet>
