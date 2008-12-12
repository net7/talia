
<!-- 
Text Encoding Initiative Consortium XSLT stylesheet family
$Date: 2005/02/20 22:34:36 $, $Revision: 1.15 $, $Author: rahtz $

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

<xsl:template match="figDesc"/>
<xsl:template match="figure/head"/>
<xsl:param name="dpi">96</xsl:param>

<xsl:template match="figure">
  <xsl:if test="@file|@url|@entity">
    <xsl:call-template name="showGraphic">
      <xsl:with-param name="ID">
	<xsl:choose>
	  <xsl:when test="@id">
	    <xsl:value-of select="@id"/>
	  </xsl:when>
<!--Added by ILIESI-->
	  <xsl:when test="@n">
            <xsl:value-of select="@n"/>
	  </xsl:when>
<!--	  end -->
	</xsl:choose>
<!--        <xsl:if test="@id">
	  <xsl:value-of select="@id"/>
	</xsl:if>
-->      </xsl:with-param>
    </xsl:call-template>
  </xsl:if>
  <xsl:apply-templates/>
  <xsl:if test="head">
    <p class="caption">
      <xsl:choose>
	<xsl:when test="ancestor::front and
			$numberFrontFigures='true'">
	  <xsl:value-of select="$figureWord"/>
	  <xsl:text> </xsl:text>
	  <xsl:number level="any"   count="figure[head]" from="front"/>.<xsl:text> </xsl:text>
	</xsl:when>
	<xsl:when test="ancestor::back and
			$numberBackFigures='true'">
	  <xsl:value-of select="$figureWord"/>
	  <xsl:text> </xsl:text>
	  <xsl:number level="any"  count="figure[head]" from="back"/>.<xsl:text> </xsl:text>
	</xsl:when>
	<xsl:when test="ancestor::body and $numberFigures='true'" >
	  <xsl:value-of select="$figureWord"/>
	  <xsl:text> </xsl:text>
	  <xsl:number level="any"   count="figure[head]" from="body"/>.<xsl:text> </xsl:text>
	</xsl:when>
      </xsl:choose>
      <xsl:apply-templates select="head" mode="plain"/>
    </p>
  </xsl:if>
</xsl:template>

<xsl:template match="graphic">
  <xsl:call-template name="showGraphic">
      <xsl:with-param name="ID">
	<xsl:for-each select="..">
	  <xsl:if test="@id">
	    <xsl:value-of select="@id"/>
	  </xsl:if>
	  </xsl:for-each>
      </xsl:with-param>
    </xsl:call-template>
</xsl:template>

<xsl:template name="showGraphic">
  <xsl:param name="ID"/>
  <xsl:if test="not($ID='')">
    <a name="{$ID}"/>
  </xsl:if>
  <xsl:variable name="File">
    <xsl:choose> 
<!-- Added by ILIESI-->
      <xsl:when test="@n">
        <xsl:text>http://151.100.146.63/img/</xsl:text><xsl:value-of select="@n"/>
      </xsl:when>
<!-- end     -->
      <xsl:when test="@url">
	<xsl:value-of select="@url"/>
	<xsl:if test="not(contains(@url,'.'))">
	  <xsl:value-of select="$graphicsSuffix"/>
	</xsl:if>
      </xsl:when>
      <xsl:when test="@file">
	<xsl:value-of select="@file"/>
	<xsl:if test="not(contains(@file,'.'))">
	  <xsl:value-of select="$graphicsSuffix"/>
	</xsl:if>
      </xsl:when>
      <xsl:when test="@entity">
	<xsl:variable name="entity">
	  <xsl:value-of select="unparsed-entity-uri(@entity)"/>
	</xsl:variable>
	<xsl:choose>
	  <xsl:when test="starts-with($entity,'file:')">
	    <xsl:value-of select="substring-after($entity,'file:')"/>
	  </xsl:when>
	  <xsl:otherwise>
	    <xsl:value-of select="$entity"/>
	  </xsl:otherwise>
	</xsl:choose>
      </xsl:when>
      <xsl:otherwise>
	<xsl:message terminate="yes">Cant work out how to do a graphic </xsl:message>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="Alt">
    <xsl:choose>
      <xsl:when test="figDesc">
	<xsl:value-of select="figDesc//text()"/>
      </xsl:when>
      <xsl:when test="head">
	<xsl:value-of select="head/text()"/>
      </xsl:when>
      <xsl:when test="parent::figure/figDesc">
	<xsl:value-of select="parent::figure/figDesc//text()"/>
      </xsl:when>
      <xsl:when test="parent::figure/head">
	<xsl:value-of select="parent::figure/head/text()"/>
      </xsl:when>
    </xsl:choose>
  </xsl:variable>
  <xsl:choose>
    <xsl:when test="$showFigures='true'">
      <img src="{$graphicsPrefix}{$File}">
	<xsl:if test="not($ID='')">
	  <xsl:attribute name="name"><xsl:value-of select="$ID"/></xsl:attribute>
	</xsl:if>
	<xsl:if test="@rend">
	  <xsl:attribute name="class"><xsl:value-of  select="@rend"/></xsl:attribute>
	</xsl:if>
	<xsl:if test="@width">
	  <xsl:call-template name="setDimension">
	    <xsl:with-param name="value">
	      <xsl:value-of select="@width"/>
	    </xsl:with-param>
	    <xsl:with-param name="name">width</xsl:with-param>
	  </xsl:call-template>
	</xsl:if>
	<xsl:if test="@height">
	  <xsl:call-template name="setDimension">
	    <xsl:with-param name="value">
	      <xsl:value-of select="@height"/>
	    </xsl:with-param>
	    <xsl:with-param name="name">height</xsl:with-param>
	  </xsl:call-template>
	</xsl:if>
	<xsl:attribute name="alt">
	  <xsl:value-of select="$Alt"/>
	</xsl:attribute>
	<xsl:call-template name="imgHook"/>
	</img>
    </xsl:when>
    <xsl:otherwise>
      <hr/>
      <p><xsl:value-of select="$figureWord"/>
      <xsl:text> </xsl:text>
      <xsl:for-each
	  select="self::figure|parent::figure">
	<xsl:number level="any" count="figure[head]"/>
      </xsl:for-each>
      file <xsl:value-of select="$File"/>
      [<xsl:value-of select="$Alt"/>]
      </p>
      <hr/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="imgHook"/>

<xsl:template name="setDimension">
  <xsl:param name="name"/>
  <xsl:param name="value"/>
  <xsl:variable name="calcvalue">
    <xsl:choose>
      <xsl:when test="contains($value,'in')">
	<xsl:value-of select="round($dpi * substring-before($value,'in'))"/>
      </xsl:when>
      <xsl:when test="contains($value,'pt')">
	<xsl:value-of select="round($dpi * (substring-before($value,'pt') div 72))"/>
      </xsl:when>
      <xsl:when test="contains($value,'cm')">
	<xsl:value-of select="round($dpi * (
			      substring-before($value,'cm') div 2.54 ))"/>
      </xsl:when>
      <xsl:when test="contains($value,'px')">
	<xsl:value-of select="substring-before($value,'px')"/>
      </xsl:when>
      <xsl:otherwise>
	<xsl:value-of select="$value"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:if test="$calcvalue&gt;0">
    <xsl:attribute name="{$name}">
      <xsl:value-of  select="$calcvalue"/>
    </xsl:attribute>
  </xsl:if>
</xsl:template>

</xsl:stylesheet>
