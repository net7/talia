<?xml version="1.0" encoding="utf-8"?>
<!-- 
Text Encoding Initiative Consortium XSLT stylesheet family
$Date: 2004/11/23 10:05:33 $, $Revision: 1.3 $, $Author: rahtz $

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

  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
  >
<!-- elaborated by Nick  Nicholas <nicholas@uci.edu>, March 2001 -->
<xsl:template match="sp">
<dl>
 <dt>
   <xsl:if test="@id"><a name="{@id}"/></xsl:if>
   <xsl:apply-templates select="speaker"/>
 </dt>
<dd><xsl:apply-templates select="p | l | lg | seg | ab | stage"/></dd>
</dl>
</xsl:template>

<!-- paragraphs inside speeches do very little-->
 <xsl:template match="sp/p">
    <xsl:apply-templates/>
</xsl:template>


<xsl:template match="p/stage">
<em><xsl:apply-templates/></em>
</xsl:template>

<xsl:template match="stage">
<p><em>
      <xsl:apply-templates/>
</em></p>
</xsl:template>

<xsl:template match="castList">
<ul>
	<xsl:apply-templates/>
</ul>
</xsl:template>

<xsl:template match="castGroup">
<ul>
	<xsl:apply-templates/>
</ul>
</xsl:template>

<xsl:template match="castItem">
<li>
	<xsl:apply-templates/>
</li>
</xsl:template>

<xsl:template match="role">
<strong>
	<xsl:apply-templates/>
</strong>
</xsl:template>

<xsl:template match="roleDesc">
<blockquote>
	<xsl:apply-templates/>
</blockquote>
</xsl:template>

<xsl:template match="actor">
<em>
	<xsl:apply-templates/>
</em>
</xsl:template>

<xsl:template match="set">
<em>
	<xsl:apply-templates/>
</em>
</xsl:template>

<xsl:template match="view">
<em>
	<xsl:apply-templates/>
</em>
</xsl:template>

<xsl:template match="camera">
<em>
	<xsl:apply-templates/>
</em>
</xsl:template>

<xsl:template match="caption">
<em>
	<xsl:apply-templates/>
</em>
</xsl:template>

<xsl:template match="sound">
<em>
	<xsl:apply-templates/>
</em>
</xsl:template>

<xsl:template match="tech">
<em>
	<xsl:apply-templates/>
</em>
</xsl:template>


</xsl:stylesheet>


