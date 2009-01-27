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
    exclude-result-prefixes="exsl estr edate a fo local rng tei teix xd" 
    version="1.0">
  <xd:doc type="stylesheet">
    <xd:short>
    TEI stylesheet
    dealing  with elements from the
      core module, making HTML output.
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
    <xd:cvsId>$Id: core.xsl,v 1.1 2006/02/16 15:31:45 giacomi Exp $</xd:cvsId>
    <xd:copyright>2005, TEI Consortium</xd:copyright>
  </xd:doc>
  <xd:doc>
    <xd:short>Process elements  *</xd:short>
    <xd:param name="forcedepth">forcedepth</xd:param>
    <xd:detail>
      <p> anything with a head can go in the TOC </p>
    </xd:detail>
  </xd:doc>
  <xsl:template match="*" mode="maketoc">
    <xsl:param name="forcedepth"/>
    <xsl:variable name="myName">
      <xsl:value-of select="local-name(.)"/>
    </xsl:variable>
    <xsl:if test="head or $autoHead='true'">
      <xsl:variable name="Depth">
        <xsl:choose>
          <xsl:when test="not($forcedepth='')">
            <xsl:value-of select="$forcedepth"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$tocDepth"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <xsl:variable name="thislevel">
        <xsl:choose>
          <xsl:when test="$myName = 'div'">
            <xsl:value-of select="count(ancestor::div)"/>
          </xsl:when>
          <xsl:when test="starts-with($myName,'div')">
            <xsl:choose>
              <xsl:when test="ancestor-or-self::div0">
                <xsl:value-of select="substring-after($myName,'div')"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="substring-after($myName,'div') - 1"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          <xsl:otherwise>99</xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <xsl:variable name="pointer">
        <xsl:apply-templates mode="generateLink" select="."/>
      </xsl:variable>
      <li class="toc">
        <xsl:call-template name="header">
          <xsl:with-param name="toc" select="$pointer"/>
          <xsl:with-param name="minimal">false</xsl:with-param>
        </xsl:call-template>
        <xsl:if test="$thislevel &lt; $Depth">
          <xsl:call-template name="continuedToc"/>
        </xsl:if>
      </li>
    </xsl:if>
  </xsl:template>

  <xd:doc>
    <xd:short>Process elements  ab</xd:short>
    <xd:detail>&#160;</xd:detail>
  </xd:doc>
  <xsl:template match="ab">
    <div>
      <xsl:if test="string-length(@rend) &gt;0">
	<xsl:attribute name="class"><xsl:value-of select="@rend"/></xsl:attribute>
      </xsl:if>
      <xsl:apply-templates/>
    </div>
  </xsl:template>

  <xd:doc>
    <xd:short>Process elements  addrLine</xd:short>
    <xd:detail>&#160;</xd:detail>
  </xd:doc>
  <xsl:template match="addrLine">
    <xsl:apply-templates/>
    <br/>
  </xsl:template>
  <xd:doc>
    <xd:short>Process elements  address</xd:short>
    <xd:detail>&#160;</xd:detail>
  </xd:doc>
  <xsl:template match="address">
    <div class="address">
      <xsl:apply-templates/>
    </div>
  </xsl:template>
  <xd:doc>
    <xd:short>Process elements  analytic</xd:short>
    <xd:detail>&#160;</xd:detail>
  </xd:doc>
  <xsl:template match="analytic">
    <xsl:apply-templates select="author" mode="biblStruct"/>
    <i>
      <xsl:apply-templates select="title[not(@type='short')]" mode="withbr"/>
    </i>
  </xsl:template>
  <xd:doc>
    <xd:short>Process elements  author</xd:short>
    <xd:detail>&#160;</xd:detail>
  </xd:doc>
  <xsl:template match="author" mode="biblStruct"><xsl:value-of select="name/@reg"/><xsl:for-each select="name[position()&gt;1]">, 
  <xsl:apply-templates/>
  </xsl:for-each>.
  <br/></xsl:template>
  <xd:doc>
    <xd:short>Process elements  author</xd:short>
    <xd:detail>&#160;</xd:detail>
  </xd:doc>
  <xsl:template match="author" mode="first">
    <xsl:value-of select="name/@reg"/>
    <xsl:if test="name[position()&gt;1]">
      <xsl:text>(e.a.)</xsl:text>
    </xsl:if>
    <xsl:text>: </xsl:text>
  </xsl:template>
  <xd:doc>
    <xd:short>Process elements  bibl</xd:short>
    <xd:detail>&#160;</xd:detail>
  </xd:doc>
  <xsl:template match="bibl">
    <xsl:variable name="ident">
      <xsl:apply-templates select="." mode="ident"/>
    </xsl:variable>
    <a name="{$ident}"/>
    <xsl:apply-templates/>
  </xsl:template>
  <xd:doc>
    <xd:short>Process elements  bibl/title</xd:short>
    <xd:detail>&#160;</xd:detail>
  </xd:doc>
  <xsl:template match="bibl/title">
    <xsl:choose>
      <xsl:when test="@rend='plain'">
        <xsl:value-of select="."/>
      </xsl:when>
      <xsl:when test="@level='a'">
        <xsl:text>‘</xsl:text>
        <xsl:value-of select="."/>
        <xsl:text>’ </xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <i>
          <xsl:value-of select="."/>
        </i>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xd:doc>
    <xd:short>Process elements  biblScope</xd:short>
    <xd:detail>&#160;</xd:detail>
  </xd:doc>
  <xsl:template match="biblScope">
    <xsl:apply-templates/>
    <xsl:if test="ancestor::biblStruct">. </xsl:if>
  </xsl:template>
  <xd:doc>
    <xd:short>Process elements  biblStruct</xd:short>
    <xd:detail>&#160;</xd:detail>
  </xd:doc>
  <xsl:template match="biblStruct">
    <xsl:if test="@id">
      <a name="{@id}"/>
    </xsl:if>
    <xsl:choose>
      <xsl:when test="@copyOf">
        <a class="biblink" href="{concat('#',substring(@copyOf,5,2))}">Zie <xsl:value-of select="substring(@copyOf,5,2)"/></a>
      </xsl:when>
      <xsl:otherwise>
        <xsl:choose>
          <xsl:when test="descendant::analytic">
            <br/>
            <xsl:apply-templates select="analytic"/>
            <center>
              <table width="90%" border="0">
                <xsl:apply-templates select="monogr" mode="monograll"/>
              </table>
            </center>
          </xsl:when>
          <xsl:otherwise>
            <br/>
            <xsl:apply-templates select="monogr" mode="monogrfirst"/>
            <center>
              <table width="90%" border="0">
                <xsl:apply-templates select="monogr" mode="monogrrest"/>
              </table>
            </center>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xd:doc>
    <xd:short>Process elements  byline</xd:short>
    <xd:detail>
      <p>
</p>
    </xd:detail>
  </xd:doc>
  <xsl:template match="byline">
    <div class="byline">
      <xsl:apply-templates/>
    </div>
  </xsl:template>
  <xd:doc>
    <xd:short>Process elements  change</xd:short>
    <xd:detail>&#160;</xd:detail>
  </xd:doc>
  <xsl:template match="change">
    <tr>
      <td width="15%" valign="top">
        <xsl:value-of select="./date"/>
      </td>
      <td width="85%">
        <xsl:value-of select="./item"/>
      </td>
    </tr>
  </xsl:template>
  <xd:doc>
    <xd:short>Process elements  cit</xd:short>
    <xd:detail>&#160;</xd:detail>
  </xd:doc>
  <xsl:template match="cit">
    <xsl:apply-templates select="q|quote"/>
    <xsl:apply-templates select="bibl"/>
  </xsl:template>
  <xd:doc>
    <xd:short>Process elements  cit</xd:short>
    <xd:detail>&#160;</xd:detail>
  </xd:doc>
  <xsl:template match="cit">
    <p class="cit">
      <xsl:apply-templates/>
    </p>
  </xsl:template>
  <xd:doc>
    <xd:short>Process elements  cit[@rend='display']</xd:short>
    <xd:detail>
      <p> quoting </p>
    </xd:detail>
  </xd:doc>
  <xsl:template match="cit[@rend='display']">
    <blockquote>
      <xsl:apply-templates select="q|quote"/>
      <xsl:apply-templates select="bibl"/>
    </blockquote>
  </xsl:template>

  <xd:doc>
    <xd:short>Process elements  code</xd:short>
    <xd:detail>&#160;</xd:detail>
  </xd:doc>
  <xsl:template match="code">
    <tt>
      <xsl:apply-templates/>
    </tt>
  </xsl:template>

  <xd:doc>
    <xd:short>Process elements  edition</xd:short>
    <xd:detail>&#160;</xd:detail>
  </xd:doc>
  <xsl:template match="edition"><xsl:apply-templates/>.<br/></xsl:template>
  <xd:doc>
    <xd:short>Process elements  editor</xd:short>
    <xd:detail>&#160;</xd:detail>
  </xd:doc>
  <xsl:template match="editor" mode="first">
    <xsl:value-of select="name/@reg"/>
    <xsl:text> (ed.)</xsl:text>
    <xsl:if test="name[position()&gt;1]">
      <xsl:text> (e.a.)</xsl:text>
    </xsl:if>
    <xsl:text>: </xsl:text>
  </xsl:template>
  <xd:doc>
    <xd:short>Process elements  editor</xd:short>
    <xd:detail>&#160;</xd:detail>
  </xd:doc>
  <xsl:template match="editor"><xsl:apply-templates select="name[position()=1]"/><xsl:for-each select="name[position()&gt;1]">, 
  <xsl:apply-templates/>
  </xsl:for-each> (ed).<br/></xsl:template>
  <xd:doc>
    <xd:short>Process elements  eg</xd:short>
    <xd:detail>&#160;</xd:detail>
  </xd:doc>
  <xsl:template match="eg">
    <pre>
      <xsl:if test="$cssFile">
        <xsl:attribute name="class">eg</xsl:attribute>
      </xsl:if>
      <xsl:apply-templates/>
    </pre>
  </xsl:template>
  <xd:doc>
    <xd:short>Process elements  emph</xd:short>
    <xd:detail>&#160;</xd:detail>
  </xd:doc>
  <xsl:template match="emph">
    <xsl:choose>
      <xsl:when test="@rend">
        <xsl:call-template name="rendering"/>
      </xsl:when>
      <xsl:otherwise>
        <em>
          <xsl:apply-templates/>
        </em>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xd:doc>
    <xd:short>Process elements  epigraph</xd:short>
    <xd:detail>&#160;</xd:detail>
  </xd:doc>
  <xsl:template match="epigraph">
    <div class="epigraph">
      <xsl:apply-templates/>
    </div>
  </xsl:template>

  <xd:doc>
    <xd:short>Process elements  epigraph/lg</xd:short>
    <xd:detail>&#160;</xd:detail>
  </xd:doc>
  <xsl:template match="epigraph/lg">
    <table>
      <xsl:apply-templates/>
    </table>
  </xsl:template>
  <xd:doc>
    <xd:short>Process elements  foreign</xd:short>
    <xd:detail>&#160;</xd:detail>
  </xd:doc>
  <xsl:template match="foreign">
    <xsl:choose>
      <xsl:when test="@rend">
        <xsl:call-template name="rendering"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xd:doc>
    <xd:short>Process elements  gap</xd:short>
    <xd:detail>&#160;</xd:detail>
  </xd:doc>
  <xsl:template match="gap">
  [...]<xsl:apply-templates/>
</xsl:template>
  <xd:doc>
    <xd:short>Process elements  gi</xd:short>
    <xd:detail>
      <p> special purpose </p>
    </xd:detail>
  </xd:doc>
  <xsl:template match="gi">
    <code>
      <xsl:text>&lt;</xsl:text>
      <xsl:apply-templates/>
      <xsl:text>&gt;</xsl:text>
    </code>
  </xsl:template>
  <xd:doc>
    <xd:short>Process elements  gi</xd:short>
    <xd:detail>&#160;</xd:detail>
  </xd:doc>
  <xsl:template match="gi" mode="plain">
    <xsl:text>&lt;</xsl:text>
    <xsl:apply-templates/>
    <xsl:text>&gt;</xsl:text>
  </xsl:template>
  <xd:doc>
    <xd:short>Process elements  head</xd:short>
    <xd:detail>
      <p> headings etc </p>
    </xd:detail>
  </xd:doc>
  <xsl:template match="head">
    <xsl:variable name="parent" select="local-name(..)"/>
    <xsl:if test="not(starts-with($parent,'div'))">
      <xsl:apply-templates/>
    </xsl:if>
  </xsl:template>
  <xd:doc>
    <xd:short>Process elements  head</xd:short>
    <xd:detail>&#160;</xd:detail>
  </xd:doc>
  <xsl:template match="head" mode="plain">
    <xsl:if test="preceding-sibling::head">
      <xsl:text> </xsl:text>
    </xsl:if>
    <xsl:apply-templates mode="plain"/>
  </xsl:template>
  <xd:doc>
    <xd:short>Process elements  hi</xd:short>
    <xd:detail>&#160;</xd:detail>
  </xd:doc>
  <xsl:template match="hi">
    <xsl:choose>
      <xsl:when test="@rend">
        <xsl:call-template name="rendering"/>
      </xsl:when>
      <xsl:otherwise>
        <strong>
          <xsl:apply-templates/>
        </strong>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xd:doc>
    <xd:short>Process elements  ident</xd:short>
    <xd:detail>&#160;</xd:detail>
  </xd:doc>
  <xsl:template match="ident">
    <xsl:choose>
      <xsl:when test="@type">
        <span class="ident-{@type}">
          <xsl:apply-templates/>
        </span>
      </xsl:when>
      <xsl:otherwise>
        <strong>
          <xsl:apply-templates/>
        </strong>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xd:doc>
    <xd:short>Process elements  imprint</xd:short>
    <xd:detail>&#160;</xd:detail>
  </xd:doc>
  <xsl:template match="imprint"><xsl:apply-templates select="biblScope"/><xsl:apply-templates select="pubPlace"/>, 
  <xsl:apply-templates select="date"/>. <xsl:apply-templates select="publisher"/></xsl:template>
  <xd:doc>
    <xd:short>Process elements  item</xd:short>
    <xd:detail>&#160;</xd:detail>
  </xd:doc>
  <xsl:template mode="bibl" match="item">
    <p>
      <xsl:call-template name="makeAnchor"/>
      <xsl:apply-templates/>
    </p>
  </xsl:template>
  <xd:doc>
    <xd:short>Process elements  item</xd:short>
    <xd:detail>&#160;</xd:detail>
  </xd:doc>
  <xsl:template mode="glosstable" match="item">
    <tr>
      <td valign="top">
        <strong>
          <xsl:apply-templates mode="print" select="preceding-sibling::*[1]"/>
        </strong>
      </td>
      <td>
        <xsl:call-template name="makeAnchor"/>
        <xsl:apply-templates/>
      </td>
    </tr>
  </xsl:template>
  <xd:doc>
    <xd:short>Process elements  item</xd:short>
    <xd:detail>&#160;</xd:detail>
  </xd:doc>
  <xsl:template mode="gloss" match="item">
    <dt>
      <xsl:call-template name="makeAnchor"/>
      <strong>
        <xsl:apply-templates mode="print" select="preceding-sibling::label[1]"/>
      </strong>
    </dt>
    <dd>
      <xsl:apply-templates/>
    </dd>
  </xsl:template>
  <xd:doc>
    <xd:short>Process elements  item</xd:short>
    <xd:detail>&#160;</xd:detail>
  </xd:doc>
  <xsl:template match="item">
    <li>
      <xsl:if test="@rend">
        <xsl:attribute name="class">
          <xsl:value-of select="@rend"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:if test="@n">
        <xsl:attribute name="value">
          <xsl:value-of select="@n"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:choose>
        <xsl:when test="@id">
          <a name="{@id}"/>
        </xsl:when>
        <xsl:when test="$generateParagraphIDs='true'">
          <a name="{generate-id()}"/>
        </xsl:when>
      </xsl:choose>
      <xsl:apply-templates/>
    </li>
  </xsl:template>
  <xd:doc>
    <xd:short>Process elements  item</xd:short>
    <xd:detail>&#160;</xd:detail>
  </xd:doc>
  <xsl:template match="item" mode="runin">
  • <xsl:apply-templates/> 
</xsl:template>
  <xd:doc>
    <xd:short>Process elements  item</xd:short>
    <xd:detail>&#160;</xd:detail>
  </xd:doc>
  <xsl:template match="item" mode="inline">
    <xsl:if test="preceding-sibling::item">,  </xsl:if>
    <xsl:if test="not(following-sibling::item) and preceding-sibling::item"> and  </xsl:if>
    <xsl:apply-templates/>
  </xsl:template>
  <xd:doc>
    <xd:short>Process elements  item/label</xd:short>
    <xd:detail>&#160;</xd:detail>
  </xd:doc>
  <xsl:template match="item/label">
    <xsl:choose>
      <xsl:when test="@rend">
        <xsl:call-template name="rendering"/>
      </xsl:when>
      <xsl:otherwise>
        <strong>
          <xsl:apply-templates/>
        </strong>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xd:doc>
    <xd:short>Process elements  kw</xd:short>
    <xd:detail>&#160;</xd:detail>
  </xd:doc>
  <xsl:template match="kw">
    <em>
      <xsl:apply-templates/>
    </em>
  </xsl:template>
  <xd:doc>
    <xd:short>Process elements  l</xd:short>
    <xd:detail>&#160;</xd:detail>
  </xd:doc>
  <xsl:template match="l" mode="Copying">
    <xsl:apply-templates/>
  </xsl:template>
  <xd:doc>
    <xd:short>Process elements  l[@copyOf]|lg[@copyOf]</xd:short>
    <xd:detail>
      <p> copyOf handling </p>
    </xd:detail>
  </xd:doc>
  <xsl:template match="l[@copyOf]|lg[@copyOf]">
    <xsl:variable name="W">
      <xsl:choose>
        <xsl:when test="starts-with(@copyof,'#')">
          <xsl:value-of select="substring-after(@copyof,'#')"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="@copyof"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:apply-templates select="key('IDS',$W)" mode="Copying"/>
  </xsl:template>
  <xd:doc>
    <xd:short>Process elements  label</xd:short>
    <xd:detail>&#160;</xd:detail>
  </xd:doc>
  <xsl:template match="label">
    <xsl:if test="@id">
      <a name="{@id}"/>
    </xsl:if>
    <xsl:apply-templates/>
  </xsl:template>
  <xd:doc>
    <xd:short>Process elements  label</xd:short>
    <xd:detail>&#160;</xd:detail>
  </xd:doc>
  <xsl:template match="label" mode="print">
    <xsl:if test="@id">
      <a name="{@id}"/>
    </xsl:if>
    <xsl:choose>
      <xsl:when test="@rend">
        <xsl:call-template name="rendering"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xd:doc>
    <xd:short>Process elements  lb</xd:short>
    <xd:detail>&#160;</xd:detail>
  </xd:doc>
  <xsl:template match="lb">
    <br/>
  </xsl:template>

  <xd:doc>
    <xd:short>Process elements  l</xd:short>
    <xd:detail>&#160;</xd:detail>
  </xd:doc>
  <xsl:template match="l">
    <div class="l"><xsl:apply-templates/></div>
  </xsl:template>

  <xd:doc>
    <xd:short>Process elements  lg</xd:short>
    <xd:detail>&#160;</xd:detail>
  </xd:doc>
  <xsl:template match="lg">
    <div class="lg">
      <xsl:apply-templates/>
    </div>
  </xsl:template>
  <xd:doc>
    <xd:short>Process elements  lg/l</xd:short>
    <xd:detail>&#160;</xd:detail>
  </xd:doc>

  <xsl:template match="lg/l">
    <div>
      <xsl:attribute name="class">
        <xsl:choose>
          <xsl:when test="@rend='Alignr'">
            <xsl:text>right</xsl:text>
          </xsl:when>
          <xsl:when test="@rend='Alignc'">
            <xsl:text>center</xsl:text>
          </xsl:when>
	  <xsl:when test="starts-with(@rend,'indent(')">
	    <xsl:text>indent</xsl:text>
	      <xsl:value-of
		  select="concat(substring-before(substring-after(@rend,'('),')'),'em')"/>
	  </xsl:when>
	  <xsl:when test="@rend='indent'">
	    <xsl:text>indent1</xsl:text>
	  </xsl:when>
	  <xsl:otherwise>
            <xsl:text>left</xsl:text>
	  </xsl:otherwise>
        </xsl:choose>
      </xsl:attribute> 
      <xsl:apply-templates/>
   </div>
  </xsl:template>

  <xd:doc>
    <xd:short>Process elements  lg</xd:short>
    <xd:detail>&#160;</xd:detail>
  </xd:doc>
  <xsl:template match="lg" mode="Copying">
    <xsl:apply-templates/>
  </xsl:template>

  <xd:doc>
    <xd:short>Process elements  list</xd:short>
    <xd:detail>
      <p>Lists. Depending on the value of the 'type' attribute,
      various HTML lists are generated:
      <dl>
	<dt>bibl</dt><dd>Items are processed in mode 'bibl'</dd>
	<dt>catalogue</dt><dd>A gloss list is created, inside a paragraph</dd>
	<dt>gloss</dt><dd>A gloss list is created, expecting alternate label
	and item elements</dd>
	<dt>glosstable</dt><dd>Label and item pairs are laid out in a
	two-column table</dd>
	<dt>inline</dt><dd>A comma-separate inline list</dd>
	<dt>runin</dt><dd>An inline list with bullets between items</dd>
	<dt>unordered</dt><dd>A simple unordered list</dd>
	<dt>ordered</dt><dd>A simple ordered list</dd>
	<dt>vallist</dt><dd>(Identical to glosstable)</dd>
      </dl> </p>
    </xd:detail>
  </xd:doc>
  <xsl:template match="list">
    <xsl:if test="head">
      <p>
        <em>
          <xsl:apply-templates select="head"/>
        </em>
      </p>
    </xsl:if>
    <xsl:choose>
      <xsl:when test="@type='catalogue'">
        <p>
          <dl>
            <xsl:for-each select="item">
              <p/>
              <xsl:apply-templates select="." mode="gloss"/>
            </xsl:for-each>
          </dl>
        </p>
      </xsl:when>
      <xsl:when test="@type='gloss' and @rend='multicol'">
        <xsl:variable name="nitems">
          <xsl:value-of select="count(item)div 2"/>
        </xsl:variable>
        <p>
          <table>
            <tr>
              <td valign="top">
                <dl>
                  <xsl:apply-templates mode="gloss" select="item[position()&lt;=$nitems ]"/>
                </dl>
              </td>
              <td valign="top">
                <dl>
                  <xsl:apply-templates mode="gloss" select="item[position() &gt;$nitems]"/>
                </dl>
              </td>
            </tr>
          </table>
        </p>
      </xsl:when>
      <xsl:when test="@type='gloss'">
          <dl>
            <xsl:apply-templates mode="gloss" select="item"/>
          </dl>
      </xsl:when>
      <xsl:when test="@type='glosstable' or @type='vallist'">
        <table>
          <xsl:apply-templates mode="glosstable" select="item"/>
        </table>
      </xsl:when>
      <xsl:when test="@type='inline'">
        <xsl:if test="not(item)">None</xsl:if>
        <xsl:apply-templates select="item" mode="inline"/>
      </xsl:when>
      <xsl:when test="@type='runin'">
        <p>
          <xsl:apply-templates select="item" mode="runin"/>
        </p>
      </xsl:when>
      <xsl:when test="@type='unordered' or @type='simple'">
        <ul>
          <xsl:choose>
            <xsl:when test="@rend and starts-with(@rend,'class:')">
              <xsl:attribute name="class">
                <xsl:value-of select="substring-after(@rend,'class:')"/>
              </xsl:attribute>
            </xsl:when>
            <xsl:when test="@rend">
              <xsl:attribute name="class">
                <xsl:value-of select="@rend"/>
              </xsl:attribute>
            </xsl:when>
          </xsl:choose>
          <xsl:apply-templates select="item"/>
        </ul>
      </xsl:when>
      <xsl:when test="@type='bibl'">
        <xsl:apply-templates select="item" mode="bibl"/>
      </xsl:when>
      <xsl:when test="starts-with(@type,'ordered')">
        <ol>
          <xsl:if test="starts-with(@type,'ordered:')">
            <xsl:attribute name="start">
              <xsl:value-of select="substring-after(@type,':')"/>
            </xsl:attribute>
          </xsl:if>
          <xsl:choose>
            <xsl:when test="@rend and starts-with(@rend,'class:')">
              <xsl:attribute name="class">
                <xsl:value-of select="substring-after(@rend,'class:')"/>
              </xsl:attribute>
            </xsl:when>
            <xsl:when test="@rend">
              <xsl:attribute name="class">
                <xsl:value-of select="@rend"/>
              </xsl:attribute>
            </xsl:when>
          </xsl:choose>
          <xsl:apply-templates select="item"/>
        </ol>
      </xsl:when>
      <xsl:otherwise>
        <ul>
          <xsl:choose>
            <xsl:when test="@rend and starts-with(@rend,'class:')">
              <xsl:attribute name="class">
                <xsl:value-of select="substring-after(@rend,'class:')"/>
              </xsl:attribute>
            </xsl:when>
            <xsl:when test="@rend">
              <xsl:attribute name="class">
                <xsl:value-of select="@rend"/>
              </xsl:attribute>
            </xsl:when>
          </xsl:choose>
          <xsl:apply-templates select="item"/>
        </ul>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xd:doc>
    <xd:short>Process elements  list</xd:short>
    <xd:detail>&#160;</xd:detail>
  </xd:doc>
  <xsl:template match="list" mode="inpara">
    <p>
      <xsl:apply-templates select="preceding-sibling::node()"/>
    </p>
    <xsl:apply-templates select="."/>
    <p>
      <xsl:apply-templates select="following-sibling::node()"/>
    </p>
  </xsl:template>
  <xd:doc>
    <xd:short>Process elements  list/label</xd:short>
    <xd:detail>&#160;</xd:detail>
  </xd:doc>
  <xsl:template match="list/label"/>
  <xd:doc>
    <xd:short>Process elements  listBibl</xd:short>
    <xd:detail>&#160;</xd:detail>
  </xd:doc>
  <xsl:template match="listBibl">
    <ol>
      <xsl:for-each select="bibl">
        <li>
          <xsl:apply-templates select="."/>
        </li>
      </xsl:for-each>
    </ol>
  </xsl:template>
  <xd:doc>
    <xd:short>Process elements  mentioned</xd:short>
    <xd:detail>&#160;</xd:detail>
  </xd:doc>
  <xsl:template match="mentioned">
    <xsl:choose>
      <xsl:when test="@rend">
        <xsl:call-template name="rendering"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xd:doc>
    <xd:short>Process elements  monogr</xd:short>
    <xd:detail>&#160;</xd:detail>
  </xd:doc>
  <xsl:template match="monogr" mode="monograll">
    <tr>
      <td>
        <xsl:choose>
          <xsl:when test="preceding-sibling::monogr">
	Also in:
      </xsl:when>
          <xsl:otherwise>
	In:
      </xsl:otherwise>
        </xsl:choose>
      </td>
    </tr>
    <tr>
      <td>
        <xsl:apply-templates select="author" mode="biblStruct"/>
        <i>
          <xsl:apply-templates select="title" mode="withbr"/>
        </i>
        <xsl:apply-templates select="respStmt"/>
        <xsl:apply-templates select="editor"/>
        <xsl:apply-templates select="edition"/>
        <xsl:apply-templates select="imprint"/>
      </td>
    </tr>
    <tr>
      <td>
        <xsl:apply-templates select="biblScope"/>
      </td>
    </tr>
    <xsl:apply-templates select="following-sibling::series"/>
  </xsl:template>
  <xd:doc>
    <xd:short>Process elements  monogr</xd:short>
    <xd:detail>&#160;</xd:detail>
  </xd:doc>
  <xsl:template match="monogr" mode="monogrfirst">
    <xsl:apply-templates select="author" mode="biblStruct"/>
    <i>
      <xsl:apply-templates select="title[not(@type='short')]" mode="withbr"/>
    </i>
  </xsl:template>
  <xd:doc>
    <xd:short>Process elements  monogr</xd:short>
    <xd:detail>&#160;</xd:detail>
  </xd:doc>
  <xsl:template match="monogr" mode="monogrrest">
    <tr>
      <td>
        <xsl:apply-templates select="respStmt"/>
        <xsl:apply-templates select="editor"/>
        <xsl:apply-templates select="edition"/>
        <xsl:apply-templates select="imprint"/>
        <xsl:if test="child::note">
      Zie noot: <xsl:apply-templates select="child::note"/>
    </xsl:if>
      </td>
    </tr>
    <tr>
      <td>
        <xsl:apply-templates select="biblScope"/>
      </td>
    </tr>
    <xsl:apply-templates select="following-sibling::series"/>
  </xsl:template>
  <xd:doc>
    <xd:short>Process elements  name</xd:short>
    <xd:detail>&#160;</xd:detail>
  </xd:doc>
  <xsl:template match="name" mode="plain">
    <xsl:variable name="ident">
      <xsl:apply-templates select="." mode="ident"/>
    </xsl:variable>
    <a name="{$ident}"/>
    <xsl:apply-templates/>
  </xsl:template>
  <xd:doc>
    <xd:short>Process elements  note</xd:short>
    <xd:detail>&#160;</xd:detail>
  </xd:doc>
  <xsl:template match="note">
    <xsl:variable name="identifier">
      <xsl:call-template name="noteID"/>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="ancestor::bibl">
	(<xsl:apply-templates/>)
      </xsl:when>
      <xsl:when test="@place='inline'">
	<a name="{$identifier}"/>
        <xsl:text> (</xsl:text>
        <xsl:apply-templates/>
        <xsl:text>)</xsl:text>
      </xsl:when>
      <xsl:when test="@place='display'">
	<a name="{$identifier}"/>
        <blockquote>
	<xsl:apply-templates/>
	</blockquote>
      </xsl:when>
      <xsl:when test="@place='foot' or @place='end'">
        <xsl:choose>
          <xsl:when test="$footnoteFile='true'">
            <a class="notelink" href="{$masterFile}-notes.html#{$identifier}">
              <sup>
		<xsl:call-template name="noteN"/>
              </sup>
            </a>
          </xsl:when>
          <xsl:otherwise>
            <a class="notelink" href="#{$identifier}">
              <sup>
		<xsl:call-template name="noteN"/>
              </sup>
            </a>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
	<a name="{$identifier}"/>
        <xsl:text> [Note: </xsl:text>
        <xsl:apply-templates/>
        <xsl:text>]</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xd:doc>
    <xd:short>Process elements  note</xd:short>
    <xd:detail>&#160;</xd:detail>
  </xd:doc>
  <xsl:template match="note" mode="printnotes">
    <xsl:if test="not(ancestor::bibl)">
      <xsl:variable name="identifier">
        <xsl:call-template name="noteID"/>
      </xsl:variable>
      <xsl:variable name="parent">
        <xsl:call-template name="locateParentdiv"/>
      </xsl:variable>
      <xsl:if test="$verbose='true'">
        <xsl:message>Note <xsl:value-of select="$identifier"/> with parent <xsl:value-of select="$parent"/></xsl:message>
      </xsl:if>
      <div class="note">
        <a name="{$identifier}"/>		
	   <xsl:call-template name="noteN"/>.
        <xsl:apply-templates/>
      </div>
    </xsl:if>
  </xsl:template>
  <xd:doc>
    <xd:short>Process elements  note[@type='action']</xd:short>
    <xd:detail>&#160;</xd:detail>
  </xd:doc>
  <xsl:template match="note[@type='action']">
    <div align="right"><b>Action <xsl:number level="any" count="note[@type='action']"/></b>:
      <i><xsl:apply-templates/></i></div>
  </xsl:template>

  <xd:doc>
    <xd:short>Process element  pb</xd:short>
    <xd:detail>Indication of a page break. For the purposes of HTML,
    we simply make it an anchor if it has an ID.</xd:detail>
  </xd:doc>
  <xsl:template match="pb">
    <xsl:if test="@id">
      <a name="{@id}"/>
    </xsl:if>
  </xsl:template>

  <xd:doc>
    <xd:short>Process elements  p</xd:short>
    <xd:detail>&#160;</xd:detail>
  </xd:doc>
  <xsl:template match="p">
    <xsl:choose>
      <xsl:when test="list">
        <xsl:apply-templates select="list[1]" mode="inpara"/>
      </xsl:when>
      <xsl:otherwise>
        <p>
          <xsl:choose>
            <xsl:when test="@rend and starts-with(@rend,'class:')">
              <xsl:attribute name="class">
                <xsl:value-of select="substring-after(@rend,'class:')"/>
              </xsl:attribute>
            </xsl:when>
            <xsl:when test="@rend">
              <xsl:attribute name="class">
                <xsl:value-of select="@rend"/>
              </xsl:attribute>
            </xsl:when>
          </xsl:choose>
          <xsl:choose>
            <xsl:when test="@id">
              <a name="{@id}"/>
            </xsl:when>
            <xsl:when test="$generateParagraphIDs='true'">
              <a name="{generate-id()}"/>
            </xsl:when>
          </xsl:choose>
          <xsl:if test="$numberParagraphs='true'">
            <xsl:number/>
            <xsl:text> </xsl:text>
          </xsl:if>
          <xsl:apply-templates/>
        </p>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xd:doc>
    <xd:short>Process elements  p[@rend='box']</xd:short>
    <xd:detail>&#160;</xd:detail>
  </xd:doc>
  <xsl:template match="p[@rend='box']">
    <p class="box">
      <xsl:apply-templates/>
    </p>
  </xsl:template>
  <xd:doc>
    <xd:short>Process elements  publisher</xd:short>
    <xd:detail>&#160;</xd:detail>
  </xd:doc>
  <xsl:template match="publisher">
  (<xsl:apply-templates/>).
</xsl:template>
  <xd:doc>
    <xd:short>Process elements  q</xd:short>
    <xd:detail>&#160;</xd:detail>
  </xd:doc>
  <xsl:template match="q">
    <xsl:choose>
      <xsl:when test="p">
	<blockquote>
	  <xsl:apply-templates/>
	</blockquote>
      </xsl:when>
      <xsl:when test="@rend='display'">
	<p class="blockquote">
	  <xsl:apply-templates/>
	</p>
      </xsl:when>
      <xsl:when test="text">
	<xsl:apply-templates/>
      </xsl:when>
      <xsl:when test="lg">
	<xsl:apply-templates/>
      </xsl:when>
      <xsl:otherwise>
	<xsl:variable name="pre">
	  <xsl:choose>
	    <xsl:when test="contains(@rend,'PRE')">
	      <xsl:choose>
		<xsl:when test="contains(@rend,'POST')">
		  <xsl:call-template name="getQuote">
		    <xsl:with-param name="quote" select="normalize-space(substring-before(substring-after(@rend,'PRE'),'POST'))"/>
		  </xsl:call-template>
		</xsl:when>
		<xsl:otherwise>
		  <xsl:call-template name="getQuote">
		    <xsl:with-param name="quote" select="normalize-space(substring-after(@rend,'PRE'))"/>
		  </xsl:call-template>
		</xsl:otherwise>
	      </xsl:choose>
	    </xsl:when>
	    <xsl:otherwise>
	      <xsl:value-of select="$preQuote"/>
	    </xsl:otherwise>
	  </xsl:choose>
	</xsl:variable>
	<xsl:variable name="post">
	  <xsl:choose>
	    <xsl:when test="contains(@rend,'POST')">
	      <xsl:call-template name="getQuote">
		<xsl:with-param name="quote" select="normalize-space(substring-after(@rend,'POST'))"/>
	      </xsl:call-template>
	    </xsl:when>
	    <xsl:otherwise>
	      <xsl:value-of select="$postQuote"/>
	    </xsl:otherwise>
	  </xsl:choose>
	</xsl:variable>
	<xsl:value-of select="$pre"/>
	<xsl:apply-templates/>
	<xsl:value-of select="$post"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xd:doc>
    <xd:short>Process elements  q[@rend='display']</xd:short>
    <xd:detail>&#160;</xd:detail>
  </xd:doc>
  <xsl:template match="q[@rend='display']">
    <blockquote>
      <xsl:apply-templates/>
    </blockquote>
  </xsl:template>
  <xd:doc>
    <xd:short>Process elements  q[@rend='eg']</xd:short>
    <xd:detail>&#160;</xd:detail>
  </xd:doc>
  <xsl:template match="q[@rend='eg']">
    <pre>
      <xsl:if test="$cssFile">
        <xsl:attribute name="class">eg</xsl:attribute>
      </xsl:if>
      <xsl:apply-templates/>
    </pre>
  </xsl:template>
  <xd:doc>
    <xd:short>Process elements  quote</xd:short>
    <xd:detail>&#160;</xd:detail>
  </xd:doc>
  <xsl:template match="quote">
    <blockquote>
      <xsl:apply-templates/>
      <xsl:if test="following-sibling::bibl">
        <div align="right">
          <font size="-1">(<xsl:apply-templates select="following-sibling::bibl"/>)</font>
        </div>
      </xsl:if>
    </blockquote>
  </xsl:template>
  <xd:doc>
    <xd:short>Process elements  quote[@rend='quoted']</xd:short>
    <xd:detail>&#160;</xd:detail>
  </xd:doc>
  <xsl:template match="quote[@rend='quoted']">
    <xsl:text>`</xsl:text>
    <xsl:apply-templates/>
    <xsl:text>' </xsl:text>
    <xsl:if test="following-sibling::bibl">
      <font size="-1">(<xsl:apply-templates select="following-sibling::bibl"/>)</font>
    </xsl:if>
  </xsl:template>
  <xd:doc>
    <xd:short>Process elements  resp</xd:short>
    <xd:detail>&#160;</xd:detail>
  </xd:doc>
  <xsl:template match="resp">
    <xsl:apply-templates/>
  </xsl:template>
  <xd:doc>
    <xd:short>Process elements  respStmt</xd:short>
    <xd:detail>&#160;</xd:detail>
  </xd:doc>
  <xsl:template match="respStmt"><xsl:apply-templates select="resp"/><xsl:for-each select="name[position()&lt;last()]"><xsl:apply-templates/>, </xsl:for-each><xsl:apply-templates select="child::name[position()=last()]"/>.
  <xsl:if test="ancestor::biblStruct"><br/></xsl:if></xsl:template>
  <xd:doc>
    <xd:short>Process elements  salute</xd:short>
    <xd:detail>&#160;</xd:detail>
  </xd:doc>
  <xsl:template match="salute">
    <p align="left">
      <xsl:apply-templates/>
    </p>
  </xsl:template>
  <xd:doc>
    <xd:short>Process elements  seg</xd:short>
    <xd:detail>&#160;</xd:detail>
  </xd:doc>
  <xsl:template match="seg">
    <span class="{@type}">
      <xsl:apply-templates/>
    </span>
  </xsl:template>
  <xd:doc>
    <xd:short>Process elements  series</xd:short>
    <xd:detail>&#160;</xd:detail>
  </xd:doc>
  <xsl:template match="series">
    <tr>
      <td>
        <xsl:apply-templates/>
      </td>
    </tr>
  </xsl:template>
  <xd:doc>
    <xd:short>Process elements  signed</xd:short>
    <xd:detail>&#160;</xd:detail>
  </xd:doc>
  <xsl:template match="signed">
    <p align="left">
      <xsl:apply-templates/>
    </p>
  </xsl:template>
  <xd:doc>
    <xd:short>Process elements  soCalled</xd:short>
    <xd:detail>&#160;</xd:detail>
  </xd:doc>
  <xsl:template match="soCalled">
    <xsl:choose>
      <xsl:when test="@rend">
        <xsl:call-template name="rendering"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>‘</xsl:text>
        <xsl:apply-templates/>
        <xsl:text>’</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xd:doc>
    <xd:short>Process elements  space</xd:short>
    <xd:detail>&#160;</xd:detail>
  </xd:doc>
  <xsl:template match="space">
    <xsl:choose>
      <xsl:when test="@extent">
        <xsl:call-template name="space_loop">
          <xsl:with-param name="extent" select="@extent"/>
        </xsl:call-template>
        <xsl:apply-templates/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text> </xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xd:doc>
    <xd:short>Process elements  term</xd:short>
    <xd:detail>&#160;</xd:detail>
  </xd:doc>
  <xsl:template match="term">
    <xsl:choose>
      <xsl:when test="@rend">
        <xsl:call-template name="rendering"/>
      </xsl:when>
      <xsl:otherwise>
        <em>
          <xsl:apply-templates/>
        </em>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xd:doc>
    <xd:short>Process elements  title</xd:short>
    <xd:detail>&#160;</xd:detail>
  </xd:doc>
  <xsl:template match="title">
    <i>
      <xsl:apply-templates/>
    </i>
  </xsl:template>
  <xd:doc>
    <xd:short>Process elements  title</xd:short>
    <xd:detail>&#160;</xd:detail>
  </xd:doc>
  <xsl:template match="title" mode="withbr">
    <xsl:value-of select="."/>
    <br/>
  </xsl:template>
  <xd:doc>
    <xd:short>Process elements  titleStmt/title</xd:short>
    <xd:detail>&#160;</xd:detail>
  </xd:doc>
  <xsl:template match="titleStmt/title">
    <xsl:if test="preceding-sibling::title">
      <br/>
    </xsl:if>
    <xsl:apply-templates/>
  </xsl:template>
  <xd:doc>
    <xd:short>Process elements  title[@level='a']</xd:short>
    <xd:detail>&#160;</xd:detail>
  </xd:doc>
  <xsl:template match="title[@level='a']">
    <xsl:text>‘</xsl:text>
    <xsl:apply-templates/>
    <xsl:text>’</xsl:text>
  </xsl:template>
  <xd:doc>
    <xd:short>Process elements  witList</xd:short>
    <xd:detail>&#160;</xd:detail>
  </xd:doc>
  <xsl:template match="witList">
    <xsl:apply-templates select="./witness"/>
  </xsl:template>
  <xd:doc>
    <xd:short>Process elements  witness</xd:short>
    <xd:detail>&#160;</xd:detail>
  </xd:doc>
  <xsl:template match="witness">
    <p>
      <a name="{@sigil}"/>
      <b>Sigle: <xsl:value-of select="@sigil"/></b>
      <br/>
      <xsl:value-of select="text()"/>
      <br/>
      <xsl:apply-templates select="biblStruct"/>
      <xsl:if test="child::note"><br/>Zie noot: <xsl:apply-templates select="child::note"/></xsl:if>
    </p>
  </xsl:template>
  <xd:doc>
    <xd:short>[html] </xd:short>
    <xd:param name="value">value</xd:param>
    <xd:detail>&#160;</xd:detail>
  </xd:doc>
  <xsl:template name="applyRend">
    <xsl:param name="value"/>
    <xsl:choose>
      <xsl:when test="not($value='')">
	<xsl:variable name="thisparm" select="substring-before($value,$rendSeparator)"/>
        <xsl:call-template name="renderingInner">
          <xsl:with-param name="value" select="$thisparm"/>
          <xsl:with-param name="rest" select="substring-after($value,$rendSeparator)"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xd:doc>
    <xd:short>[html] </xd:short>
    <xd:detail>&#160;</xd:detail>
  </xd:doc>
  <xsl:template name="continuedToc">
    <xsl:if test="div|div0|div1|div2|div3|div4|div5|div6">
      <ul class="toc">
        <xsl:apply-templates select="div|div0|div1|div2|div3|div4|div5|div6" mode="maketoc"/>
      </ul>
    </xsl:if>
  </xsl:template>

  <xd:doc>
    <xd:short>[html] How to identify a note</xd:short>
    <xd:detail>&#160;</xd:detail>
  </xd:doc>
  <xsl:template name="noteID">
    <xsl:choose>
      <xsl:when test="@id">
        <xsl:value-of select="@id"/>
      </xsl:when>
      <xsl:when test="@n">
	<xsl:text>Note</xsl:text>
        <xsl:value-of select="@n"/>
      </xsl:when>
      <xsl:when test="not(@place)">
	<xsl:choose>
	  <xsl:when test="ancestor::front">
	    <xsl:number level="any" count="note[not(@place)]" from="front"/>
	  </xsl:when>
	  <xsl:when test="ancestor::back">
	    <xsl:number level="any" count="note[not(@place)]" from="back"/>
	  </xsl:when>
	  <xsl:otherwise>
	    <xsl:number level="any" count="note[not(@place)]" from="body"/>
	  </xsl:otherwise>
	</xsl:choose>
      </xsl:when>
      <xsl:otherwise>
	<xsl:variable name="Place">
	  <xsl:value-of select="@place"/>
	</xsl:variable>
	<xsl:choose>
	  <xsl:when test="ancestor::front">
	    <xsl:number level="any" count="note[@place=$Place]" from="front"/>
	  </xsl:when>
	  <xsl:when test="ancestor::back">
	    <xsl:number level="any" count="note[@place=$Place]" from="back"/>
	  </xsl:when>
	  <xsl:otherwise>
	    <xsl:number level="any" count="note[@place=$Place]" from="body"/>
	  </xsl:otherwise>
	</xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xd:doc>
    <xd:short>[html] How to label a note</xd:short>
    <xd:detail>&#160;</xd:detail>
  </xd:doc>
  <xsl:template name="noteN">
    <xsl:choose>
      <xsl:when test="@n">
        <xsl:value-of select="@n"/>
      </xsl:when>
      <xsl:when test="not(@place)">
	<xsl:choose>
	  <xsl:when test="ancestor::front">
	    <xsl:number level="any" count="note[not(@place)]" from="front"/>
	  </xsl:when>
	  <xsl:when test="ancestor::back">
	    <xsl:number level="any" count="note[not(@place)]" from="back"/>
	  </xsl:when>
	  <xsl:otherwise>
	    <xsl:number level="any" count="note[not(@place)]" from="body"/>
	  </xsl:otherwise>
	</xsl:choose>
      </xsl:when>
      <xsl:otherwise>
	<xsl:variable name="Place">
	  <xsl:value-of select="@place"/>
	</xsl:variable>
	<xsl:choose>
	  <xsl:when test="ancestor::front">
	    <xsl:number level="any" count="note[@place=$Place]" from="front"/>
	  </xsl:when>
	  <xsl:when test="ancestor::back">
	    <xsl:number level="any" count="note[@place=$Place]" from="back"/>
	  </xsl:when>
	  <xsl:otherwise>
	    <xsl:number level="any" count="note[@place=$Place]" from="body"/>
	  </xsl:otherwise>
	</xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xd:doc>
    <xd:short>[html] Show relevant footnotes</xd:short>
    <xd:param name="currentID">currentID</xd:param>
    <xd:detail>&#160;</xd:detail>
  </xd:doc>
  <xsl:template name="partialFootNotes">
    <xsl:param name="currentID"/>
    <xsl:choose>
      <xsl:when test="$currentID='current'"/>
      <xsl:when test="$currentID='' and $splitLevel=-1">
        <xsl:call-template name="printNotes"/>
      </xsl:when>
      <xsl:when test="$currentID=''">
        <xsl:for-each select=" descendant::text">
          <xsl:call-template name="printNotes"/>
        </xsl:for-each>
      </xsl:when>
      <xsl:otherwise>
        <xsl:choose>
          <xsl:when test="count(key('IDS',$currentID))&gt;0">
            <xsl:for-each select="key('IDS',$currentID)">
              <xsl:call-template name="printNotes"/>
            </xsl:for-each>
          </xsl:when>
          <xsl:otherwise>
            <xsl:apply-templates select="ancestor-or-self::TEI.2/descendant::text" mode="xpath">
              <xsl:with-param name="xpath" select="$currentID"/>
              <xsl:with-param name="action">notes</xsl:with-param>
            </xsl:apply-templates>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xd:doc>
    <xd:short>[html] </xd:short>
    <xd:detail>&#160;</xd:detail>
  </xd:doc>
  <xsl:template name="printNotes">
    <xsl:if test="descendant::note[@place!='inline']">
      <xsl:choose>
        <xsl:when test="$footnoteFile='true'">
          <xsl:variable name="BaseFile">
            <xsl:value-of select="$masterFile"/>
            <xsl:call-template name="addCorpusID"/>
          </xsl:variable>
          <xsl:call-template name="outputChunk">
            <xsl:with-param name="ident">
              <xsl:value-of select="concat($BaseFile,'-notes')"/>
            </xsl:with-param>
            <xsl:with-param name="content">
              <xsl:call-template name="writeNotes"/>
            </xsl:with-param>
          </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
          <div class="notes">
            <div class="noteHeading">
              <xsl:value-of select="$noteHeading"/>
            </div>
            <xsl:apply-templates select="descendant::note[@place!='inline']" mode="printnotes"/>
          </div>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:if>
  </xsl:template>
  <xd:doc>
    <xd:short>[html] </xd:short>
    <xd:detail>
      <p> rendering. support for multiple rendition elements added
by Nick Nicholas </p>
    </xd:detail>
  </xd:doc>
  <xsl:template name="rendering">
    <xsl:call-template name="applyRend">
      <xsl:with-param name="value" select="concat(@rend,$rendSeparator)"/>
    </xsl:call-template>
  </xsl:template>

  <xd:doc>
    <xd:short>[html] </xd:short>
    <xd:param name="value">the current segment of the value of the
    rend attribute</xd:param>
    <xd:param name="rest">the remainder of the attribute</xd:param>
    <xd:detail>&#160;</xd:detail>
  </xd:doc>
  <xsl:template name="renderingInner">
    <xsl:param name="value"/>
    <xsl:param name="rest"/>
    <xsl:choose>
      <xsl:when test="$value='bold'">
        <b>
          <xsl:call-template name="applyRend">
            <xsl:with-param name="value" select="$rest"/>
          </xsl:call-template>
        </b>
      </xsl:when>
      <xsl:when test="$value='center'">
        <center>
          <xsl:call-template name="applyRend">
            <xsl:with-param name="value" select="$rest"/>
          </xsl:call-template>
        </center>
      </xsl:when>
      <xsl:when test="$value='code'">
        <b>
          <tt>
            <xsl:call-template name="applyRend">
              <xsl:with-param name="value" select="$rest"/>
            </xsl:call-template>
          </tt>
        </b>
      </xsl:when>
      <xsl:when test="$value='ital'">
        <i>
          <xsl:call-template name="applyRend">
            <xsl:with-param name="value" select="$rest"/>
          </xsl:call-template>
        </i>
      </xsl:when>
      <xsl:when test="$value='italic'">
        <i>
          <xsl:call-template name="applyRend">
            <xsl:with-param name="value" select="$rest"/>
          </xsl:call-template>
        </i>
      </xsl:when>
      <xsl:when test="$value='it'">
        <i>
          <xsl:call-template name="applyRend">
            <xsl:with-param name="value" select="$rest"/>
          </xsl:call-template>
        </i>
      </xsl:when>
      <xsl:when test="$value='italics'">
        <i>
          <xsl:call-template name="applyRend">
            <xsl:with-param name="value" select="$rest"/>
          </xsl:call-template>
        </i>
      </xsl:when>
      <xsl:when test="$value='i'">
        <i>
          <xsl:call-template name="applyRend">
            <xsl:with-param name="value" select="$rest"/>
          </xsl:call-template>
        </i>
      </xsl:when>
      <xsl:when test="$value='sc'">
<!--   <small>
	   <xsl:value-of
	   select="translate(.,'abcdefghijklmnopqrstuvwxyz','ABCDEFGHIJKLMNOPQRSTUVWXYZ')"/>
	   </small>
      -->
        <span style="font-variant: small-caps">
          <xsl:call-template name="applyRend">
            <xsl:with-param name="value" select="$rest"/>
          </xsl:call-template>
        </span>
      </xsl:when>
      <xsl:when test="$value='plain'">
        <xsl:call-template name="applyRend">
          <xsl:with-param name="value" select="$rest"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="$value='quoted'">
        <xsl:text>‘</xsl:text>
        <xsl:call-template name="applyRend">
          <xsl:with-param name="value" select="$rest"/>
        </xsl:call-template>
        <xsl:text>’</xsl:text>
      </xsl:when>
      <xsl:when test="$value='sub'">
        <sub>
          <xsl:call-template name="applyRend">
            <xsl:with-param name="value" select="$rest"/>
          </xsl:call-template>
        </sub>
      </xsl:when>
      <xsl:when test="$value='sup'">
        <sup>
          <xsl:call-template name="applyRend">
            <xsl:with-param name="value" select="$rest"/>
          </xsl:call-template>
        </sup>
      </xsl:when>
      <xsl:when test="$value='important'">
        <span class="important">
          <xsl:call-template name="applyRend">
            <xsl:with-param name="value" select="$rest"/>
          </xsl:call-template>
        </span>
      </xsl:when>
<!-- NN added -->
      <xsl:when test="$value='ul'">
        <u>
          <xsl:call-template name="applyRend">
            <xsl:with-param name="value" select="$rest"/>
          </xsl:call-template>
        </u>
      </xsl:when>
<!-- NN added -->
      <xsl:when test="$value='interlinMarks'">
        <xsl:text>`</xsl:text>
        <xsl:call-template name="applyRend">
          <xsl:with-param name="value" select="$rest"/>
        </xsl:call-template>
        <xsl:text>´</xsl:text>
      </xsl:when>
      <xsl:when test="$value='overbar'">
        <span style="text-decoration:overline">
          <xsl:call-template name="applyRend">
            <xsl:with-param name="value" select="$rest"/>
          </xsl:call-template>
        </span>
      </xsl:when>
      <xsl:when test="$value='expanded'">
        <span style="letter-spacing: 0.15em">
          <xsl:call-template name="applyRend">
            <xsl:with-param name="value" select="$rest"/>
          </xsl:call-template>
        </span>
      </xsl:when>
      <xsl:when test="$value='strike'">
        <span style="text-decoration: line-through">
          <xsl:call-template name="applyRend">
            <xsl:with-param name="value" select="$rest"/>
          </xsl:call-template>
        </span>
      </xsl:when>
      <xsl:when test="$value='small'">
        <span style="font-size: 75%">
          <xsl:call-template name="applyRend">
            <xsl:with-param name="value" select="$rest"/>
          </xsl:call-template>
        </span>
      </xsl:when>
      <xsl:when test="$value='large'">
        <span style="font-size: 150%">
          <xsl:call-template name="applyRend">
            <xsl:with-param name="value" select="$rest"/>
          </xsl:call-template>
        </span>
      </xsl:when>
      <xsl:when test="$value='smaller'">
        <span style="font-size: 50%">
          <xsl:call-template name="applyRend">
            <xsl:with-param name="value" select="$rest"/>
          </xsl:call-template>
        </span>
      </xsl:when>
      <xsl:when test="$value='larger'">
        <span style="font-size: 200%">
          <xsl:call-template name="applyRend">
            <xsl:with-param name="value" select="$rest"/>
          </xsl:call-template>
        </span>
      </xsl:when>
      <xsl:when test="$value='calligraphic'">
        <span style="font-family: cursive">
          <xsl:call-template name="applyRend">
            <xsl:with-param name="value" select="$rest"/>
          </xsl:call-template>
        </span>
      </xsl:when>
      <xsl:when test="$value='gothic'">
        <span style="font-family: fantasy">
          <xsl:call-template name="applyRend">
            <xsl:with-param name="value" select="$rest"/>
          </xsl:call-template>
        </span>
      </xsl:when>
      <xsl:when test="$value='noindex'">
        <xsl:call-template name="applyRend">
          <xsl:with-param name="value" select="$rest"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:choose>
          <xsl:when test="local-name(.)='p'">
            <xsl:call-template name="unknownRendBlock">
              <xsl:with-param name="rest" select="$rest"/>
              <xsl:with-param name="value" select="$value"/>
            </xsl:call-template>
          </xsl:when>
          <xsl:otherwise>
            <xsl:call-template name="unknownRendInline">
              <xsl:with-param name="rest" select="$rest"/>
              <xsl:with-param name="value" select="$value"/>
            </xsl:call-template>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xd:doc>
    <xd:short>[html] </xd:short>
    <xd:param name="extent">extent</xd:param>
    <xd:detail>&#160;</xd:detail>
  </xd:doc>
  <xsl:template name="space_loop">
    <xsl:param name="extent"/>
    <xsl:choose>
      <xsl:when test="$extent &lt; 1">
    </xsl:when>
      <xsl:otherwise>
        <xsl:text> </xsl:text>
        <xsl:variable name="newextent">
          <xsl:value-of select="$extent - 1"/>
        </xsl:variable>
        <xsl:call-template name="space_loop">
          <xsl:with-param name="extent" select="$newextent"/>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xd:doc>
    <xd:short>[html] </xd:short>
    <xd:param name="value">current value</xd:param>
    <xd:param name="rest">remaining values</xd:param>
    <xd:detail>&#160;</xd:detail>
  </xd:doc>
  <xsl:template name="unknownRendBlock">
    <xsl:param name="value"/>
    <xsl:param name="rest"/>
    <xsl:message>Unknown rend attribute <xsl:value-of select="$value"/></xsl:message>
    <code class="undone">[Unknown rendering: <xsl:value-of select="$value"/>]</code>
    <xsl:call-template name="applyRend">
      <xsl:with-param name="value" select="$rest"/>
    </xsl:call-template>
    <code class="undone">[End rendering]</code>
  </xsl:template>
  <xd:doc>
    <xd:short>[html] </xd:short>
    <xd:param name="value">value</xd:param>
    <xd:param name="rest">rest</xd:param>
    <xd:detail>&#160;</xd:detail>
  </xd:doc>
  <xsl:template name="unknownRendInline">
    <xsl:param name="value"/>
    <xsl:param name="rest"/>
    <xsl:message>Unknown rend attribute <xsl:value-of select="$value"/></xsl:message>
    <code class="undone">[Unknown rendering: <xsl:value-of select="$value"/>]</code>
    <xsl:call-template name="applyRend">
      <xsl:with-param name="value" select="$rest"/>
    </xsl:call-template>
    <code class="undone">[End rendering]</code>
  </xsl:template>
  <xd:doc>
    <xd:short>[html] </xd:short>
    <xd:detail>&#160;</xd:detail>
  </xd:doc>
  <xsl:template name="writeNotes">
    <html>
      <xsl:call-template name="addLangAtt"/>
      <head>
        <title>Notes for
	<xsl:apply-templates select="descendant-or-self::text/front//docTitle//text()"/>
	</title>
        <xsl:call-template name="includeCSS"/>
	<xsl:call-template name="cssHook"/>
      </head>
      <body>
        <xsl:call-template name="bodyHook"/>
        <xsl:call-template name="bodyJavaScriptHook"/>
        <xsl:call-template name="stdheader">
          <xsl:with-param name="title">
            <xsl:text>Notes for </xsl:text>
            <xsl:apply-templates select="descendant-or-self::text/front//docTitle//text()"/>
          </xsl:with-param>
        </xsl:call-template>
        <div class="notes">
          <div class="noteHeading">
            <xsl:value-of select="$noteHeading"/>
          </div>
          <xsl:apply-templates select="descendant::note[@place]" mode="printnotes"/>
        </div>
        <xsl:call-template name="stdfooter"/>
      </body>
    </html>
  </xsl:template>
</xsl:stylesheet>
