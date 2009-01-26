<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet 
  xmlns:xd="http://www.pnp-software.com/XSLTdoc"
  xmlns:a="http://relaxng.org/ns/compatibility/annotations/1.0"
  xmlns:edate="http://exslt.org/dates-and-times"
  xmlns:estr="http://exslt.org/strings"
  xmlns:exsl="http://exslt.org/common"
  xmlns:rng="http://relaxng.org/ns/structure/1.0"
  xmlns:tei="http://www.tei-c.org/ns/1.0"
  xmlns:teix="http://www.tei-c.org/ns/Examples"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
  extension-element-prefixes="exsl estr edate" 
  exclude-result-prefixes="xd exsl estr edate a rng tei teix" 
  version="1.0">
  
<xd:doc type="stylesheet">
    <xd:short>
    TEI stylesheet
    dealing  with elements from the
      core module, making LaTeX output.
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
    <xd:short>Process elements  ab</xd:short>
    <xd:detail>&#160;</xd:detail>
  </xd:doc>
  <xsl:template match="ab">
  <xsl:apply-templates/>
  <xsl:if test="following-sibling::ab">\\&#10;</xsl:if>
</xsl:template>
  
<xd:doc>
    <xd:short>Process elements  bibl</xd:short>
    <xd:detail>&#160;</xd:detail>
  </xd:doc>
  <xsl:template match="bibl" mode="cite">
  <xsl:apply-templates select="text()[1]"/>
</xsl:template>
  
<xd:doc>
    <xd:short>Process elements  bibl/title</xd:short>
    <xd:detail>&#160;</xd:detail>
  </xd:doc>
  <xsl:template match="bibl/title">
  <xsl:if test="preceding-sibling::title"> </xsl:if>
  <xsl:choose>
    <xsl:when test="@level='a'">
      <xsl:text>`</xsl:text>
      <xsl:apply-templates/>
      <xsl:text>'</xsl:text>
    </xsl:when>
    <xsl:otherwise>
      <xsl:text>\textit{</xsl:text>
      <xsl:apply-templates/>
      <xsl:text>}</xsl:text>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>
  
<xd:doc>
    <xd:short>Process elements  code</xd:short>
    <xd:detail>&#160;</xd:detail>
  </xd:doc>
  <xsl:template match="code">\texttt{<xsl:apply-templates/>}</xsl:template>
  
<xd:doc>
    <xd:short>Process elements  eg|q[@rend='eg']</xd:short>
    <xd:detail>&#160;</xd:detail>
  </xd:doc>
  <xsl:template match="eg|q[@rend='eg']">
<xsl:choose>
<xsl:when test="@n">
\begin{Verbatim}[numbers=left,label={<xsl:value-of select="@n"/>}]
<xsl:apply-templates mode="eg"/>
\end{Verbatim}
</xsl:when>
<xsl:otherwise>
\begin{Verbatim}[frame=single,fillcolor=\color{yellow}]
<xsl:apply-templates mode="eg"/>
\end{Verbatim}
</xsl:otherwise>
</xsl:choose>
</xsl:template>
  
<xd:doc>
    <xd:short>Process elements  emph</xd:short>
    <xd:detail>&#160;</xd:detail>
  </xd:doc>
  <xsl:template match="emph">\textit{<xsl:apply-templates/>}</xsl:template>
  
<xd:doc>
    <xd:short>Process elements  foreign</xd:short>
    <xd:detail>&#160;</xd:detail>
  </xd:doc>
  <xsl:template match="foreign">
  <xsl:text>\textit{</xsl:text><xsl:apply-templates/><xsl:text>}</xsl:text>
</xsl:template>
  
<xd:doc>
    <xd:short>Process elements  gi</xd:short>
    <xd:detail>&#160;</xd:detail>
  </xd:doc>
  <xsl:template match="gi">\texttt{&lt;<xsl:apply-templates/>&gt;}</xsl:template>
  
<xd:doc>
    <xd:short>Process elements  head</xd:short>
    <xd:detail>&#160;</xd:detail>
</xd:doc>
<xsl:template match="head">
  <xsl:choose>
    <xsl:when test="parent::castList"/>
    <xsl:when test="parent::figure"/>
    <xsl:when test="parent::list"/>
    <xsl:when test="parent::lg">
      \subsection*{<xsl:apply-templates/>}
    </xsl:when>
    <xsl:when test="parent::table"/>
    <xsl:when test="parent::div1[@type='letter']"/>
    <xsl:when test="parent::div[@type='letter']"/>
    <xsl:when test="parent::div[@type='bibliography']"/>
    <xsl:otherwise>
      <xsl:variable name="depth">
	<xsl:apply-templates select=".." mode="depth"/>
      </xsl:variable>
      <xsl:text>&#10;\Div</xsl:text>
      <xsl:choose>
	<xsl:when test="$depth=0">I</xsl:when>
	<xsl:when test="$depth=1">II</xsl:when>
	<xsl:when test="$depth=2">III</xsl:when>
	<xsl:when test="$depth=3">IV</xsl:when>
	<xsl:when test="$depth=4">V</xsl:when>
      </xsl:choose>
      <xsl:choose>
      <xsl:when test="ancestor::q">Star</xsl:when>
      <xsl:when test="ancestor::back and
		      $numberBackHeadings='false'">Star</xsl:when>
      <xsl:when test="ancestor::front and 
		      $numberFrontHeadings='false'">Star</xsl:when>
      </xsl:choose>
      <xsl:call-template name="sectionhead"/>
      <xsl:call-template name="labelme"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xd:doc>
    <xd:short>Process elements  hi</xd:short>
    <xd:detail>&#160;</xd:detail>
  </xd:doc>
  <xsl:template match="hi">
    <xsl:call-template name="rendering"/>
  </xsl:template>

<xd:doc>
    <xd:short>Rendering rules, turning @rend into LaTeX commands</xd:short>
    <xd:detail>&#160;</xd:detail>
  </xd:doc>
<xsl:template name="rendering">
  <xsl:variable name="cmd">
    <xsl:choose>
      <xsl:when test="@rend='bold'">textbf</xsl:when>
      <xsl:when test="@rend='center'">centerline</xsl:when>
      <xsl:when test="@rend='code'">texttt</xsl:when>
      <xsl:when test="@rend='ital'">textit</xsl:when>
      <xsl:when test="@rend='italic'">textit</xsl:when>
      <xsl:when test="@rend='it'">textit</xsl:when>
      <xsl:when test="@rend='italics'">textit</xsl:when>
      <xsl:when test="@rend='i'">textit</xsl:when>
      <xsl:when test="@rend='sc'">textsc</xsl:when>
      <xsl:when test="@rend='plain'">textrm</xsl:when>
      <xsl:when test="@rend='quoted'">textquoted</xsl:when>
      <xsl:when test="@rend='sub'">textsuperscript</xsl:when>
      <xsl:when test="@rend='sup'">textsubscript</xsl:when>
      <xsl:when test="@rend='important'">textbf</xsl:when>
      <xsl:when test="@rend='ul'">uline</xsl:when>
      <xsl:when test="@rend='overbar'">textoverbar</xsl:when>
      <xsl:when test="@rend='expanded'">textsc</xsl:when>
      <xsl:when test="@rend='strike'">sout</xsl:when>
      <xsl:when test="@rend='small'">textsmall</xsl:when>
      <xsl:when test="@rend='large'">textlarge</xsl:when>
      <xsl:when test="@rend='smaller'">textsmaller</xsl:when>
      <xsl:when test="@rend='larger'">textlarger</xsl:when>
      <xsl:when test="@rend='calligraphic'">textcal</xsl:when>
      <xsl:when test="@rend='gothic'">textgothic</xsl:when>
      <xsl:when test="@rend='noindex'">textrm</xsl:when>
      <xsl:otherwise>textbf</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:text>\</xsl:text>
  <xsl:value-of select="$cmd"/>
  <xsl:text>{</xsl:text>
  <xsl:apply-templates/>
  <xsl:text>}</xsl:text>
</xsl:template>
  
<xd:doc>
    <xd:short>Process elements  hr</xd:short>
    <xd:detail>&#160;</xd:detail>
  </xd:doc>
  <xsl:template match="hr">
 \hline
</xsl:template>
  
<xd:doc>
    <xd:short>Process elements  ident</xd:short>
    <xd:detail>&#160;</xd:detail>
  </xd:doc>
  <xsl:template match="ident">
  <xsl:text>\textsf{</xsl:text>
   <xsl:apply-templates/>
  <xsl:text>}</xsl:text>
</xsl:template>
  
<xd:doc>
    <xd:short>Process elements  item</xd:short>
    <xd:detail>&#160;</xd:detail>
  </xd:doc>
  <xsl:template match="item">
    \item<xsl:if test="@n">[<xsl:value-of select="@n"/>]</xsl:if>
    <xsl:text> </xsl:text>
    <xsl:apply-templates/>
</xsl:template>
  
<xd:doc>
    <xd:short>Process elements  item</xd:short>
    <xd:detail>&#160;</xd:detail>
  </xd:doc>
  <xsl:template mode="gloss" match="item">
 \item[<xsl:apply-templates mode="print" select="preceding-sibling::*[1]"/>]
 <xsl:apply-templates/>
</xsl:template>
  
<xd:doc>
    <xd:short>Process elements  label</xd:short>
    <xd:detail>&#160;</xd:detail>
  </xd:doc>
  <xsl:template match="label"/>
  
<xd:doc>
    <xd:short>Process elements  lb</xd:short>
    <xd:detail>&#160;</xd:detail>
  </xd:doc>
  <xsl:template match="lb">
<xsl:text>\newline </xsl:text>
</xsl:template>
  
<xd:doc>
    <xd:short>Process elements  list</xd:short>
    <xd:detail>&#160;</xd:detail>
  </xd:doc>
  <xsl:template match="list">
  <xsl:if test="head">
    \centerline{<xsl:for-each select="head"><xsl:apply-templates/></xsl:for-each>}
  </xsl:if>
<xsl:choose>
  <xsl:when test="@type='gloss'">
    \begin{description}<xsl:apply-templates mode="gloss" select="item"/>
    \end{description}
  </xsl:when>
  <xsl:when test="@type='unordered'">
    \begin{itemize}<xsl:apply-templates/>
    \end{itemize}
  </xsl:when>
  <xsl:when test="@type='ordered'">
    \begin{enumerate}<xsl:apply-templates/>
    \end{enumerate}
  </xsl:when>
  <xsl:otherwise>
    \begin{itemize}<xsl:apply-templates/>
    \end{itemize}
  </xsl:otherwise>
</xsl:choose>
  </xsl:template>
  
<xd:doc>
    <xd:short>Process elements  listBibl</xd:short>
    <xd:detail>&#160;</xd:detail>
  </xd:doc>
  <xsl:template match="listBibl">
\begin{bibitemlist}{1}
  <xsl:apply-templates/>
\end{bibitemlist}  
</xsl:template>
  
<xd:doc>
    <xd:short>Process elements  listBibl/bibl</xd:short>
    <xd:detail>&#160;</xd:detail>
  </xd:doc>
  <xsl:template match="listBibl/bibl">
\bibitem {<xsl:choose><xsl:when test="@id">
<xsl:value-of select="@id"/></xsl:when>
<xsl:otherwise>bibitem-<xsl:number/></xsl:otherwise>
</xsl:choose>}
<xsl:apply-templates/>
<xsl:text>
</xsl:text>
</xsl:template>
  
<xd:doc>
    <xd:short>Process elements  mentioned</xd:short>
    <xd:detail>&#160;</xd:detail>
  </xd:doc>
  <xsl:template match="mentioned">
  <xsl:text>\emph{</xsl:text><xsl:apply-templates/><xsl:text>}</xsl:text>
</xsl:template>
  
<xd:doc>
    <xd:short>Process elements  note</xd:short>
    <xd:detail>&#160;</xd:detail>
  </xd:doc>
  <xsl:template match="note">
    <xsl:if test="@id">\hypertarget{<xsl:value-of select="@id"/>}{}</xsl:if>
    <xsl:choose>
      <xsl:when test="@place='end'">
	<xsl:text>\endnote{</xsl:text>
	<xsl:apply-templates/>
	<xsl:text>}</xsl:text>
      </xsl:when>
      <xsl:when test="@target">
	<xsl:text>\footnotetext{</xsl:text>
	<xsl:apply-templates/>
	<xsl:text>}</xsl:text>
      </xsl:when>
      <xsl:otherwise>
	<xsl:text>\footnote{</xsl:text>
	<xsl:apply-templates/>
	<xsl:text>}</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
</xsl:template>
  
<xd:doc>
    <xd:short>Process elements  p</xd:short>
    <xd:detail>&#160;</xd:detail>
  </xd:doc>
  <xsl:template match="p">\par
<xsl:apply-templates/></xsl:template>
  
<xd:doc>
  <xd:short>Process element  pb</xd:short>
  <xd:detail>Indication of a page break. We make it an anchor if it has an ID.</xd:detail>
</xd:doc>
<xsl:template match="pb">
    <xsl:choose>
      <xsl:when test="$pagebreakStyle='active'">
	<xsl:text>\clearpage </xsl:text>
      </xsl:when>
      <xsl:when test="$pagebreakStyle='visible'">
	  <xsl:text>✁[</xsl:text>
	  <xsl:value-of select="@unit"/>
	  <xsl:text> Page </xsl:text>
	  <xsl:value-of select="@n"/>
	  <xsl:text>]✁</xsl:text>
      </xsl:when>
      <xsl:otherwise>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:if test="@id">
      <xsl:text>\hypertarget{</xsl:text>
      <xsl:value-of select="@id"/>
      <xsl:text>}{}</xsl:text>
    </xsl:if>

</xsl:template>


<xd:doc>
    <xd:short>Process elements  q</xd:short>
    <xd:detail>&#160;</xd:detail>
  </xd:doc>
  <xsl:template match="q">
    <xsl:choose>
      <xsl:when test="p">
	\begin{quote}<xsl:apply-templates/> \end{quote}
      </xsl:when>
      <xsl:when test="text">
	<xsl:apply-templates/>
      </xsl:when>
      <xsl:when test="lg">
	\begin{quote}<xsl:apply-templates/> \end{quote}
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
    <xd:short>Process elements  p[@rend='display']</xd:short>
    <xd:detail>&#160;</xd:detail>
  </xd:doc>
  <xsl:template match="p[@rend='display']">
\begin{quote}
   <xsl:apply-templates/>
\end{quote}
</xsl:template>
  
<xd:doc>
    <xd:short>Process elements  q[@rend='display']</xd:short>
    <xd:detail>&#160;</xd:detail>
  </xd:doc>
  <xsl:template match="q[@rend='display']">
\begin{quote}
   <xsl:apply-templates/>
\end{quote}
</xsl:template>
  
 
<xd:doc>
    <xd:short>Process elements  soCalled</xd:short>
    <xd:detail>&#160;</xd:detail>
  </xd:doc>
  <xsl:template match="soCalled">
 <xsl:text>‘</xsl:text><xsl:apply-templates/><xsl:text>’</xsl:text>
</xsl:template>
  
<xd:doc>
    <xd:short>Process elements  titlePart</xd:short>
    <xd:detail>&#160;</xd:detail>
  </xd:doc>
  <xsl:template match="titlePart">
    <xsl:if test="ancestor::group">
    \part{<xsl:apply-templates/>}
    </xsl:if>
</xsl:template>
  
<xd:doc>
    <xd:short>Process elements  title[@level='a']</xd:short>
    <xd:detail>&#160;</xd:detail>
  </xd:doc>
  <xsl:template match="title[@level='a']">
  <xsl:text>``</xsl:text>
   <xsl:apply-templates/>
  <xsl:text>''</xsl:text>
</xsl:template>
  
<xd:doc>
    <xd:short>Process elements  title[@level='m']</xd:short>
    <xd:detail>&#160;</xd:detail>
  </xd:doc>
  <xsl:template match="title[@level='m']">
  <xsl:text>\textit{</xsl:text>
   <xsl:apply-templates/>
  <xsl:text>}</xsl:text>
</xsl:template>
  
<xd:doc>
    <xd:short>Process elements  title[@level='s']</xd:short>
    <xd:detail>&#160;</xd:detail>
  </xd:doc>
  <xsl:template match="title[@level='s']">
  <xsl:text>\textit{</xsl:text>
   <xsl:apply-templates/>
  <xsl:text>}</xsl:text>
</xsl:template>
  
<xd:doc>
    <xd:short>Process elements  xref[@type='cite']</xd:short>
    <xd:detail>&#160;</xd:detail>
  </xd:doc>
  <xsl:template match="xref[@type='cite']">
    <xsl:apply-templates/>
</xsl:template>
  
<xd:doc>
    <xd:short>Process text(), escaping the LaTeX command characters.</xd:short>
    <xd:detail>We need the backslash and two curly braces to insert
    LaTeX commands into the output, so these characters need to
    replaced when they are found in running text. They are translated
    to Unicode COMBINING REVERSE SOLIDUS OVERLAY, MEDIUM LEFT CURLY BRACKET
    ORNAMENT and MEDIUM RIGHT CURLY BRACKET ORNAMENT; if these are
    used in real text, the escape will have to be changed. They are
    translated back to the correct characters by appropriate
    definitions in the preamble (see the template for TEI in textstructure.xsl).</xd:detail>
  </xd:doc>
  <xsl:template match="text()">
    <xsl:value-of select="translate(.,'\{}','&#8421;&#10100;&#10101;')"/>
</xsl:template>
  
<xd:doc>
    <xd:short>Process elements  text()</xd:short>
    <xd:detail>&#160;</xd:detail>
  </xd:doc>
  <xsl:template match="text()" mode="eg">
  <xsl:choose>
    <xsl:when test="starts-with(.,'&#10;')">
      <xsl:value-of select="substring-after(.,'&#10;')"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="."/>
</xsl:otherwise>
</xsl:choose>
</xsl:template>
  
<xd:doc>
    <xd:short>[latex] </xd:short>
    <xd:detail>&#160;</xd:detail>
  </xd:doc>
  <xsl:template name="bibliography">
  <xsl:apply-templates select="//xref[@type='cite'] | //xptr[@type='cite'] | //ref[@type='cite'] | //ptr[@type='cite']" mode="biblio"/>
</xsl:template>
  
</xsl:stylesheet>
