<!-- 
TEI XSLT stylesheet family
$Date: 2004/12/12 22:10:16 $, $Revision: 1.5 $, $Author: rahtz $

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

<xsl:template name="makeInternalLink">
  <xsl:param name="ptr"/>
  <xsl:param name="target"/>
  <xsl:param name="dest"/>
  <xsl:param name="body"/>
  <xsl:variable name="W">
    <xsl:choose>
      <xsl:when test="$target"><xsl:value-of select="$target"/></xsl:when>
      <xsl:when test="contains($dest,'#')">
	<xsl:value-of select="substring-after($dest,'#')"/>
      </xsl:when>
      <xsl:otherwise>
	<xsl:value-of select="$dest"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <fo:basic-link internal-destination="{$W}">
    <xsl:call-template name="linkStyle"/>
    <xsl:choose>
      <xsl:when test="not($body='')">
	<xsl:value-of select="$body"/>
      </xsl:when>
      <xsl:when test="$ptr='true'">
	<xsl:apply-templates mode="xref" select="key('IDS',$W)">
	  <xsl:with-param name="minimal" select="$minimalCrossRef"/>
	</xsl:apply-templates>
      </xsl:when>
      <xsl:otherwise>
	<xsl:apply-templates/>
      </xsl:otherwise>
    </xsl:choose>
  </fo:basic-link>
</xsl:template>

<xsl:template name="makeExternalLink">
  <xsl:param name="ptr"/>
  <xsl:param name="dest"/>
  <fo:basic-link external-destination="{$dest}">
	<xsl:choose>
	  <xsl:when test="$ptr='true'">
	    <xsl:call-template name="showXrefURL">
	      <xsl:with-param name="dest">
		<xsl:value-of select="$dest"/>
	      </xsl:with-param>
	    </xsl:call-template>
	  </xsl:when>
	  <xsl:otherwise>
	    <xsl:apply-templates/>
	  </xsl:otherwise>
	</xsl:choose>
  </fo:basic-link>
</xsl:template>

<xsl:template name="generateEndLink">
  <xsl:param name="where"/>
  <xsl:apply-templates select="$where"/>
</xsl:template>

</xsl:stylesheet>
