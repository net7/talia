<?xml version="1.0"?>
<!-- 
Text Encoding Initiative Consortium XSLT stylesheet family
$Date: 2005/01/09 14:25:02 $, $Revision: 1.5 $, $Author: rahtz $

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
<!-- $Id: nomorechoice.xsl,v 1.5 2005/01/09 14:25:02 rahtz Exp $ -->

<xsl:transform
 xmlns:exsl="http://exslt.org/common"
 xmlns:xs="http://www.w3.org/2001/XMLSchema" 
 xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 xmlns:rng="http://relaxng.org/ns/structure/1.0"
 xmlns="http://relaxng.org/ns/structure/1.0"
 version="1.0">
  
<xsl:key name="Choices" match="rng:define[@combine='choice']" use="@name"/>
<xsl:key name="Defs" match="rng:define" use="@name"/>
  

<xsl:template match="rng:define">
  <xsl:choose>
  <xsl:when test="key('Choices',@name)">
      <xsl:comment>Killed      <xsl:value-of select="@name"/> here</xsl:comment>
  </xsl:when>
  <xsl:otherwise>
      <xsl:copy>
	<xsl:apply-templates select="*|@*|text()|comment()"/>
      </xsl:copy>
  </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="rng:define[@combine='choice']">
  <xsl:if test="generate-id(.)=generate-id(key('Choices',@name)[1])">
    <xsl:variable name="what"><xsl:value-of select="@name"/></xsl:variable>
    <xsl:variable name="defs">
      <rng:div>
	<xsl:for-each select="key('Choices',@name)">
	  <xsl:apply-templates/>
	</xsl:for-each>
      </rng:div>
    </xsl:variable>
  
    <xsl:for-each select="exsl:node-set($defs)/rng:div">
      <define name="{$what}">
	<xsl:choose>
	  <xsl:when test="count(rng:*)=1 and (rng:empty or rng:notAllowed)">
	    <xsl:copy-of select="*"/>
	  </xsl:when>
	  <xsl:when test="contains($what,'.attributes')">
	    <xsl:copy-of select="*"/>
	  </xsl:when>
	  <xsl:otherwise>
	    <rng:choice>
	      <xsl:for-each select="*">
		<xsl:if test="not(self::rng:notAllowed)">
		  <xsl:copy-of select="."/>
		</xsl:if>
	      </xsl:for-each>
	    </rng:choice>
	  </xsl:otherwise>
	</xsl:choose>
      </define>
    </xsl:for-each>
  </xsl:if>
</xsl:template>

<xsl:template match="*|@*|text()|comment()">
  <xsl:copy>
    <xsl:apply-templates select="*|@*|text()|comment()"/>
  </xsl:copy>
</xsl:template>

<xsl:template match="rng:optional[rng:choice/rng:attribute]">
  <xsl:for-each select="rng:choice/rng:attribute">
    <rng:optional>
      <xsl:copy-of select="."/>
    </rng:optional>
  </xsl:for-each>
</xsl:template>

<xsl:template match="rng:data[@type='token']">
      <rng:text/>
</xsl:template>

</xsl:transform>
