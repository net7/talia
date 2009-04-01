<!-- 
Text Encoding Initiative Consortium XSLT stylesheet family
$Date: 2004/11/30 10:11:21 $, $Revision: 1.7 $, $Author: rahtz $

XSL stylesheet to format TEI XML documents to HTML or XSL FO

 
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

  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
  version="1.0">

<xsl:template match="table[@rend='simple']">
  <table>
 <xsl:if test="@rend">
     <xsl:attribute name="class"><xsl:value-of
     select="@rend"/></xsl:attribute>
   </xsl:if>
 <xsl:for-each select="@*">
   <xsl:if test="name(.)='summary'
		 or name(.) = 'width'
		 or name(.) = 'border'
		 or name(.) = 'frame'
		 or name(.) = 'rules'
		 or name(.) = 'cellspacing'
		 or name(.) = 'cellpadding'">
     <xsl:copy-of select="."/>
   </xsl:if>
 </xsl:for-each>
 <xsl:call-template name="makeAnchor"/>
  <xsl:apply-templates/></table>
</xsl:template>

<xsl:template match='table'>
 <div>
 <xsl:attribute name="align">
 <xsl:choose>
  <xsl:when test="@align">
      <xsl:value-of select="@align"/>
  </xsl:when>
  <xsl:otherwise>
      <xsl:value-of select="$tableAlign"/>
  </xsl:otherwise>
 </xsl:choose>
 </xsl:attribute>
 <xsl:if test="head">
   <p><xsl:apply-templates select="." mode="xref"/></p>
 </xsl:if>
 <table>
   <xsl:if test="@rend">
     <xsl:attribute name="class"><xsl:value-of
     select="@rend"/></xsl:attribute>
   </xsl:if>
 <xsl:if test="@rend='frame' or @rend='rules'">
  <xsl:attribute name="rules">all</xsl:attribute>
  <xsl:attribute name="border">1</xsl:attribute>
 </xsl:if>
 <xsl:for-each select="@*">
  <xsl:if test="name(.)='summary'
or name(.) = 'width'
or name(.) = 'border'
or name(.) = 'frame'
or name(.) = 'rules'
or name(.) = 'cellspacing'
or name(.) = 'cellpadding'">
    <xsl:copy-of select="."/>
 </xsl:if>
 </xsl:for-each>
 <xsl:apply-templates/>
 </table>
 </div>
</xsl:template>

<xsl:template match='row'>
 <tr>
<xsl:if test="@rend and starts-with(@rend,'class:')">
 <xsl:attribute name="class">
    <xsl:value-of select="substring-after(@rend,'class:')"/>
 </xsl:attribute>
</xsl:if>
<xsl:if test="@role">
 <xsl:attribute name="class"><xsl:value-of select="@role"/></xsl:attribute>
</xsl:if>
 <xsl:apply-templates/>
 </tr>
</xsl:template>

<xsl:template match='cell'>
 <td valign="top">
   <xsl:for-each select="@*">
     <xsl:choose>
       <xsl:when test="name(.) = 'width'
		       or name(.) = 'border'
		       or name(.) = 'cellspacing'
		       or name(.) = 'cellpadding'">
	 <xsl:copy-of select="."/>
       </xsl:when>
       <xsl:when test="name(.)='rend' and starts-with(.,'width:')">
	 <xsl:attribute name="width">
	   <xsl:value-of select="substring-after(.,'width:')"/>
	 </xsl:attribute>
       </xsl:when>
       <xsl:when test="name(.)='rend' and starts-with(.,'class:')">
	 <xsl:attribute name="class">
	   <xsl:value-of select="substring-after(.,'class:')"/>
	 </xsl:attribute>
       </xsl:when>
       <xsl:when test="name(.)='rend'">
	 <xsl:attribute name="bgcolor"><xsl:value-of select="."/></xsl:attribute>
       </xsl:when>
       <xsl:when test="name(.)='cols'">
	 <xsl:attribute name="colspan"><xsl:value-of select="."/></xsl:attribute>
       </xsl:when>
       <xsl:when test="name(.)='rows'">
	 <xsl:attribute name="rowspan"><xsl:value-of select="."/></xsl:attribute>
       </xsl:when>
       <xsl:when test="name(.)='align'">
	 <xsl:attribute name="align"><xsl:value-of select="."/></xsl:attribute>
       </xsl:when>
     </xsl:choose>
   </xsl:for-each>
   <xsl:if test="not(@align) and not($cellAlign='left')">
     <xsl:attribute name="align"><xsl:value-of select="$cellAlign"/></xsl:attribute>
   </xsl:if>
   
   <xsl:if test="@role">
     <xsl:attribute name="class"><xsl:value-of select="@role"/></xsl:attribute>
   </xsl:if>
   <xsl:if test="@id"><a name="{@id}"></a></xsl:if>
   <xsl:apply-templates/>
 </td>
</xsl:template>



</xsl:stylesheet>
