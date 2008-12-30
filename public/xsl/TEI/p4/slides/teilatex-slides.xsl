<!-- 
TEI XSLT stylesheet family
$Date: 2006/02/16 15:31:45 $, $Revision: 1.1 $, $Author: giacomi $

XSL FO stylesheet to format TEI XML documents 

##LICENSE
-->
<xsl:stylesheet 
    xmlns:rng="http://relaxng.org/ns/structure/1.0"
    xmlns:teix="http://www.tei-c.org/ns/Examples"
    xmlns:tei="http://www.tei-c.org/ns/1.0" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

<xsl:import href="../latex/tei.xsl"/>
<xsl:import href="slides-common.xsl"/>

<xsl:output method="text" encoding="utf-8"/>
<xsl:variable name="docClass">beamer</xsl:variable>
<xsl:param name="classParameters"></xsl:param>
<xsl:param name="beamerClass">PaloAlto</xsl:param>
<xsl:param name="startRed">\color{red}</xsl:param>
<xsl:param name="endRed"></xsl:param>
<xsl:param name="startBold">\textbf{</xsl:param>
<xsl:param name="startItalic">\textit{</xsl:param>
<xsl:param name="endBold">}</xsl:param>
<xsl:param name="endItalic">}</xsl:param>
<xsl:param name="spaceCharacter">&#160;</xsl:param>
<xsl:template name="lineBreak">
  <xsl:param name="id"/>
  <xsl:text>\\&#10;</xsl:text>
</xsl:template>

<xsl:template name="latexPackages">
\usepackage{colortbl}
\usetheme{<xsl:value-of select="$beamerClass"/>}
\usepackage{times}
\usepackage{fancyvrb}
\def\Gin@extensions{.pdf,.png,.jpg,.mps,.tif}
\setbeamercovered{transparent}
\let\mainmatter\relax
\let\frontmatter\relax
\let\backmatter\relax
\let\endfoot\relax
\let\endlastfoot\relax
</xsl:template>

<xsl:template name="latexLayout">
\date{<xsl:value-of
select="/TEI.2/teiHeader/fileDesc/editionStmt/edition/date"/>}
\institute{<xsl:value-of
select="/TEI.2/teiHeader/fileDesc/publicationStmt/authority"/>}
<xsl:if test="not($latexLogo='')">
\pgfdeclareimage[height=.5cm]{logo}{FIG0}
\logo{\pgfuseimage{logo}}
</xsl:if>
</xsl:template>

<xsl:template name="latexBegin">
\frame{\maketitle}

<xsl:if test=".//div0">
  \begin{frame} \frametitle{Outline} 
  \tableofcontents
  \end{frame}
</xsl:if>
</xsl:template>


<xsl:template match="div/head"/>
<xsl:template match="div0/head"/>
<xsl:template match="div1/head"/>

<xsl:template match="div0">
  \section{<xsl:for-each select="head"><xsl:apply-templates/></xsl:for-each>}
  \begin{frame} 
  \frametitle{<xsl:for-each
  select="head"><xsl:apply-templates/></xsl:for-each>}
  {\Huge…}
  \end{frame}
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="div|div1">
\begin{frame}<xsl:choose>
<xsl:when test="@rend='fragile'">[fragile]</xsl:when>
<xsl:when test=".//eg">[fragile]</xsl:when>
<xsl:when test=".//Output">[fragile]</xsl:when>
</xsl:choose>
<xsl:text>&#10;</xsl:text>
  \frametitle{<xsl:for-each select="head"><xsl:apply-templates/></xsl:for-each>}
  <xsl:apply-templates/>
\end{frame}
</xsl:template>

  <xsl:template name="makePic">
  <xsl:if test="@id">\hypertarget{<xsl:value-of select="@id"/>}{}</xsl:if>
  <xsl:text>\includegraphics[</xsl:text>
  <xsl:call-template name="graphicsAttributes">
    <xsl:with-param name="mode">latex</xsl:with-param>
  </xsl:call-template>
  <xsl:if test="not(@width) and not (@height) and not(@scale)">
    <xsl:text>width=\textwidth</xsl:text>
  </xsl:if>
  <xsl:text>]{</xsl:text>
      <xsl:choose>
	<xsl:when test="@url">
	  <xsl:value-of select="@url"/>
	</xsl:when>
	<xsl:when test="@entity">
	  <xsl:value-of select="unparsed-entity-uri(@entity)"/>
	</xsl:when>
      </xsl:choose>
  <xsl:text>}</xsl:text>
</xsl:template>

<xsl:template match="hi[not(@rend)]">
  <xsl:text>\alert{</xsl:text>
  <xsl:apply-templates/>
  <xsl:text>}</xsl:text>
</xsl:template>

<xsl:template match="item[@rend='pause']">
\item <xsl:apply-templates/>\pause
</xsl:template>

<xsl:template match="eg">
\begin{Verbatim}[fontsize=\scriptsize,frame=single,fillcolor=\color{yellow}]
<xsl:apply-templates mode="eg"/>
\end{Verbatim}
</xsl:template>

<xsl:template match="teix:egXML">
\begin{scriptsize}
\bgroup
\ttfamily\mbox{}
<xsl:apply-templates mode="verbatim"/>
\egroup
\end{scriptsize}
</xsl:template>
  

  <xsl:template match="table">
\par  
\begin{scriptsize}
\begin{tabular}
<xsl:call-template name="makeTable"/>
\end{tabular}
\end{scriptsize}
</xsl:template>

</xsl:stylesheet>
