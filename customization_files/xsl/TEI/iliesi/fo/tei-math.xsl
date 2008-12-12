<!-- 
TEI XSLT stylesheet family
$Date: 2004/11/23 10:05:32 $, $Revision: 1.4 $, $Author: rahtz $

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
  xmlns:tei="http://www.tei-c.org/ns/1.0"
  xmlns:fotex="http://www.tug.org/fotex"
  xmlns:m="http://www.w3.org/1998/Math/MathML" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
  xmlns:fo="http://www.w3.org/1999/XSL/Format">

<xsl:template match="m:math">
 <m:math>
  <xsl:copy-of select="@*"/>
  <xsl:apply-templates mode="math"/>
 </m:math>
</xsl:template>

<xsl:template match="m:*|@*|comment()|processing-instruction()|text()" mode="math">
 <xsl:copy>
   <xsl:apply-templates mode="math" select="*|@*|processing-instruction()|text()"/>
 </xsl:copy>
</xsl:template>

<xsl:template match="formula">
  <fo:wrapper>
   <xsl:if test="@xml:id">
    <xsl:attribute name="id"><xsl:value-of select="@xml:id"/></xsl:attribute>
   </xsl:if>
   <xsl:if test="@id">
    <xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute>
   </xsl:if>
   <xsl:apply-templates/>
  </fo:wrapper>
</xsl:template>


<xsl:template match="formula" mode="xref">
 <xsl:number/>
</xsl:template>

<xsl:template match="formula[@type='subeqn']/m:math">
  <xsl:apply-templates mode="math"/>
</xsl:template>

<xsl:template match="table[@rend='eqnarray']">
   <fotex:eqnarray>
     <xsl:for-each select="row">
     <xsl:apply-templates select=".//formula"/>
     <xsl:if test="following-sibling::row">
       <!--        <fo:character character="&#x2028;"/>-->
       <xsl:processing-instruction name="xmltex">\\</xsl:processing-instruction>
     </xsl:if>
     </xsl:for-each>
   </fotex:eqnarray>
</xsl:template>


<xsl:template match="formula[@type='display']/m:math">
 <m:math display="block">
  <xsl:copy-of select="@*"/>
  <xsl:apply-templates mode="math"/>
 </m:math>
</xsl:template>

</xsl:stylesheet>


