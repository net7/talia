<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet 
    xmlns:xd="http://www.pnp-software.com/XSLTdoc"
    xmlns:a="http://relaxng.org/ns/compatibility/annotations/1.0"
  xmlns:edate="http://exslt.org/dates-and-times"
  xmlns:estr="http://exslt.org/strings"
  xmlns:exsl="http://exslt.org/common"
  xmlns:fo="http://www.w3.org/1999/XSL/Format"
  xmlns:local="http://www.pantor.com/ns/local"
  xmlns:rng="http://relaxng.org/ns/structure/1.0"
  xmlns:tei="http://www.tei-c.org/ns/1.0"
  xmlns:teix="http://www.tei-c.org/ns/Examples"
  xmlns:html="http://www.w3.org/1999/xhtml"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  extension-element-prefixes="exsl estr edate" 
  exclude-result-prefixes="xd exsl estr edate a fo local rng tei teix" 
  version="1.0">
  <xd:doc type="stylesheet">
    <xd:short>
    TEI stylesheet
    dealing  with elements from the
      drama module, making HTML output.
      </xd:short>
    <xd:detail>
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

   
   
      </xd:detail>
    <xd:author>Sebastian Rahtz sebastian.rahtz@oucs.ox.ac.uk</xd:author>
    <xd:cvsId>$Id: drama.xsl,v 1.1 2006/02/16 15:31:45 giacomi Exp $</xd:cvsId>
    <xd:copyright>2005, TEI Consortium</xd:copyright>
  </xd:doc>
  <xd:doc>
    <xd:short>Process elements  actor</xd:short>
    <xd:detail>&#160;</xd:detail>
  </xd:doc>
  <xsl:template match="actor">
    <em>
      <xsl:apply-templates/>
    </em>
  </xsl:template>
  <xd:doc>
    <xd:short>Process elements  camera</xd:short>
    <xd:detail>&#160;</xd:detail>
  </xd:doc>
  <xsl:template match="camera">
    <em>
      <xsl:apply-templates/>
    </em>
  </xsl:template>
  <xd:doc>
    <xd:short>Process elements  caption</xd:short>
    <xd:detail>&#160;</xd:detail>
  </xd:doc>
  <xsl:template match="caption">
    <em>
      <xsl:apply-templates/>
    </em>
  </xsl:template>
  <xd:doc>
    <xd:short>Process elements  castGroup</xd:short>
    <xd:detail>&#160;</xd:detail>
  </xd:doc>
  <xsl:template match="castGroup">
    <ul>
      <xsl:apply-templates/>
    </ul>
  </xsl:template>
  <xd:doc>
    <xd:short>Process elements  castItem</xd:short>
    <xd:detail>&#160;</xd:detail>
  </xd:doc>
  <xsl:template match="castItem">
    <li>
      <xsl:apply-templates/>
    </li>
  </xsl:template>
  <xd:doc>
    <xd:short>Process elements  castList</xd:short>
    <xd:detail>&#160;</xd:detail>
  </xd:doc>
  <xsl:template match="castList">
    <xsl:if test="head">
      <p>
	<em>
	<xsl:for-each select="head">
	  <xsl:apply-templates/>
	</xsl:for-each>
	</em>
      </p>
    </xsl:if>
    <ul>
      <xsl:apply-templates/>
    </ul>
  </xsl:template>

  <xd:doc>
    <xd:short>Process elements  castList/head</xd:short>
    <xd:detail>&#160;</xd:detail>
  </xd:doc>
  <xsl:template match="castList/head"/>

  <xd:doc>
    <xd:short>Process elements  p/stage</xd:short>
    <xd:detail>&#160;</xd:detail>
  </xd:doc>
  <xsl:template match="p/stage">
    <em>
      <xsl:apply-templates/>
    </em>
  </xsl:template>
  <xd:doc>
    <xd:short>Process elements  role</xd:short>
    <xd:detail>&#160;</xd:detail>
  </xd:doc>

  <xd:doc>
    <xd:short>Process elements  sp/stage</xd:short>
    <xd:detail>&#160;</xd:detail>
  </xd:doc>
  <xsl:template match="sp/stage">
    <em>
      <xsl:apply-templates/>
    </em>
  </xsl:template>
  <xd:doc>
    <xd:short>Process elements  role</xd:short>
    <xd:detail>&#160;</xd:detail>
  </xd:doc>
  <xsl:template match="role">
    <strong>
      <xsl:apply-templates/>
    </strong>
  </xsl:template>
  <xd:doc>
    <xd:short>Process elements  roleDesc</xd:short>
    <xd:detail>&#160;</xd:detail>
  </xd:doc>
  <xsl:template match="roleDesc">
    <blockquote>
      <xsl:apply-templates/>
    </blockquote>
  </xsl:template>
  <xd:doc>
    <xd:short>Process elements  set</xd:short>
    <xd:detail>&#160;</xd:detail>
  </xd:doc>
  <xsl:template match="set">
    <em>
      <xsl:apply-templates/>
    </em>
  </xsl:template>
  <xd:doc>
    <xd:short>Process elements  sound</xd:short>
    <xd:detail>&#160;</xd:detail>
  </xd:doc>
  <xsl:template match="sound">
    <em>
      <xsl:apply-templates/>
    </em>
  </xsl:template>
  <xd:doc>
    <xd:short>Process elements  sp</xd:short>
    <xd:detail>
      <p> elaborated by Nick  Nicholas &lt;nicholas@uci.edu&gt;, March 2001 </p>
    </xd:detail>
  </xd:doc>
  <xsl:template match="sp">
    <dl>
      <dt>
        <xsl:if test="@id">
          <a name="{@id}"/>
        </xsl:if>
        <xsl:apply-templates select="speaker"/>
      </dt>
      <dd>
        <xsl:apply-templates select="p | l | lg | seg | ab | stage"/>
      </dd>
    </dl>
  </xsl:template>
  <xd:doc>
    <xd:short>Process elements  sp/p</xd:short>
    <xd:detail>&#160;</xd:detail>
  </xd:doc>
  <xsl:template match="sp/p">
    <xsl:apply-templates/>
  </xsl:template>
  <xd:doc>
    <xd:short>Process elements  stage</xd:short>
    <xd:detail>&#160;</xd:detail>
  </xd:doc>
  <xsl:template match="stage">
    <p>
      <em>
        <xsl:apply-templates/>
      </em>
    </p>
  </xsl:template>

  <xd:doc>
    <xd:short>Process elements  tech</xd:short>
    <xd:detail>&#160;</xd:detail>
  </xd:doc>
  <xsl:template match="tech">
    <em>
      <xsl:apply-templates/>
    </em>
  </xsl:template>

  <xd:doc>
    <xd:short>Process elements  view</xd:short>
    <xd:detail>&#160;</xd:detail>
  </xd:doc>
  <xsl:template match="view">
    <em>
      <xsl:apply-templates/>
    </em>
  </xsl:template>
</xsl:stylesheet>
