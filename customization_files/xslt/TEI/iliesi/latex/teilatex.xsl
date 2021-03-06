<?xml version="1.0" encoding="utf-8"?>
<!-- 
TEI XSLT stylesheet family
$Date: 2005/02/27 20:27:15 $, $Revision: 1.30 $, $Author: rahtz $

XSL stylesheet to format TEI XML documents to LaTeX

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
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"   
  xmlns:tei="http://www.tei-c.org/ns/1.0"
  xmlns:exsl="http://exslt.org/common"
  exclude-result-prefixes="exsl" 
  extension-element-prefixes="exsl"
  version="1.0">

<xsl:import href="../common/teicommon.xsl"/>
<xsl:param name="realFigures">false</xsl:param>
<xsl:param name="latexLogoFile"/>
<xsl:param name="latexLogoFile1"/>
<xsl:param name="latexLogoFile2"/>
<xsl:param name="latexLogoFile3"/>
<xsl:param name="useHeaderFrontMatter"/>
<xsl:param name="REQUEST"></xsl:param>
<xsl:param name="standardScale">1</xsl:param>
<xsl:output method="text" encoding="utf8"/>
<xsl:param name="pagesetup">twoside,a4paper,lmargin=1in,rmargin=1in,tmargin=0.25in,bmargin=0.75in</xsl:param>

<xsl:key name="IDS" match="*[@id]" use="@id"/>

<xsl:strip-space elements="*"/>

<xsl:template match="TEI.2">
  <xsl:variable name="docstyle">
  <xsl:choose>
   <xsl:when test="@rend">
   	<xsl:value-of select="@rend"/>
   </xsl:when>
   <xsl:otherwise>
    	<xsl:text>article</xsl:text>
   </xsl:otherwise>
  </xsl:choose>
  </xsl:variable>
<xsl:if test="not($realFigures='true')">
  <xsl:text>%BEGINFIGMAP
</xsl:text>
<xsl:if test="not($latexLogoFile='')">
  <xsl:text>%FIGMAP </xsl:text>
  <xsl:value-of select="$latexLogoFile"/><xsl:text> FIG0
</xsl:text>
</xsl:if>
<xsl:if test="not($latexLogoFile1='')">
  <xsl:text>%FIGMAP </xsl:text>
  <xsl:value-of select="$latexLogoFile1"/><xsl:text> FIG1
</xsl:text>
</xsl:if>
<xsl:if test="not($latexLogoFile2='')">
  <xsl:text>%FIGMAP </xsl:text>
  <xsl:value-of select="$latexLogoFile2"/><xsl:text> FIG2
</xsl:text>
</xsl:if>
<xsl:if test="not($latexLogoFile3='')">
  <xsl:text>%FIGMAP </xsl:text>
  <xsl:value-of select="$latexLogoFile3"/><xsl:text> FIG3
</xsl:text>
</xsl:if>
  <xsl:for-each select="//figure">
    <xsl:variable name="c"><xsl:number level="any"  count="figure[head]"/></xsl:variable>
    <xsl:text>%FIGMAP </xsl:text>
    <xsl:call-template name="findFileName"/>
    <xsl:text> FIG</xsl:text>
    <xsl:value-of select="$c + 1000"/>
    <xsl:text>&#10;</xsl:text>
  </xsl:for-each>
  <xsl:text>%ENDFIGMAP
</xsl:text>
</xsl:if>
\documentclass{<xsl:value-of select="$docstyle"/>}
\usepackage[<xsl:value-of select="$pagesetup"/>]{geometry}
\usepackage{times}
\usepackage{longtable}
\usepackage{colortbl}
\usepackage{ulem}
\usepackage{fancyvrb}
\usepackage{fancyhdr}
\usepackage{graphicx}
\IfFileExists{tipa.sty}{\usepackage{tipa}}{}
\DeclareTextSymbol{\textpi}{OML}{25}
\pagestyle{fancy} 
\usepackage[utf8]{inputenc}
\usepackage[T1]{fontenc}
\usepackage[]{ucs}
\RequirePackage{array}
\makeatletter
\gdef\arraybackslash{\let\\=\@arraycr}
<xsl:text disable-output-escaping="yes">
\newcolumntype{L}[1]{&gt;{\raggedright\arraybackslash}p{#1}}
\newcolumntype{C}[1]{&gt;{\centering\arraybackslash}p{#1}}
\newcolumntype{R}[1]{&gt;{\raggedleft\arraybackslash}p{#1}}
\newcolumntype{P}[1]{&gt;{\arraybackslash}p{#1}}
\definecolor{label}{gray}{0.75}
\def\Panel#1#2#3#4{\multicolumn{#3}{>{\columncolor{#2}}#4}{#1}}
</xsl:text>
\usepackage[pdftitle={<xsl:call-template name="generateSimpleTitle"/>},
pdfauthor={<xsl:call-template name="generateAuthor"/>},
pdfcreator={Oxford University Computing Services}
]{hyperref}
\DeclareRobustCommand*{\xref}{\hyper@normalise\xref@}
\def\xref@#1#2{\hyper@linkurl{#2}{#1}}
\makeatother
\def\TheFullDate{<xsl:call-template name="generateDate"/>}
\def\TheDate{<xsl:call-template name="generateDate">
<xsl:with-param name="showRev"/></xsl:call-template>}
\catcode`\_=12\relax
<xsl:text disable-output-escaping="yes">\let\tabcellsep&amp;
\catcode`\&amp;=12\relax
</xsl:text>
\title{<xsl:call-template name="generateTitle"/>}
\author{<xsl:call-template name="generateAuthor"/>}
\paperwidth211mm
\paperheight297mm
\hyperbaseurl{<xsl:value-of select="$baseURL"/>}
\makeatletter
\def\@pnumwidth{1.55em}
\def\@tocrmarg {2.55em}
\def\@dotsep{4.5}
\setcounter{tocdepth}{3}
\clubpenalty=8000
\emergencystretch 3em
\hbadness=4000
\hyphenpenalty=400
\pretolerance=750
\tolerance=2000
\vbadness=4000
\widowpenalty=10000
<xsl:if test="not($docstyle='letter')">
\renewcommand\section{\@startsection {section}{1}{\z@}%
                                   {-1.75ex \@plus -0.5ex \@minus -.2ex}%
                                   {0.5ex \@plus .2ex}%
                                   {\reset@font\large\bfseries\sffamily}}
\renewcommand\subsection{\@startsection{subsection}{2}{\z@}%
                                     {-1.75ex\@plus -0.5ex \@minus- .2ex}%
                                     {0.5ex \@plus .2ex}%
                                     {\reset@font\large\sffamily}}
\renewcommand\subsubsection{\@startsection{subsubsection}{3}{\z@}%
                                     {-1.5ex\@plus -0.35ex \@minus -.2ex}%
                                     {0.5ex \@plus .2ex}%
                                     {\reset@font\normalsize\sffamily}}
\renewcommand\paragraph{\@startsection{paragraph}{4}{\z@}%
                                    {1.5ex \@plus0.5ex \@minus.2ex}%
                                    {-1em}%
                                    {\reset@font\normalsize\bfseries}}
\renewcommand\subparagraph{\@startsection{subparagraph}{5}{\parindent}%
                                       {1.5ex \@plus1ex \@minus .2ex}%
                                       {-1em}%
                                      {\reset@font\normalsize\bfseries}}

</xsl:if>
\def\l@section#1#2{\addpenalty{\@secpenalty} \addvspace{1.0em plus 1pt}
\@tempdima 1.5em \begingroup
 \parindent \z@ \rightskip \@pnumwidth 
 \parfillskip -\@pnumwidth 
 \bfseries \leavevmode #1\hfil \hbox to\@pnumwidth{\hss #2}\par
 \endgroup}
\def\l@subsection{\@dottedtocline{2}{1.5em}{2.3em}}
\def\l@subsubsection{\@dottedtocline{3}{3.8em}{3.2em}}
\def\l@paragraph{\@dottedtocline{4}{7.0em}{4.1em}}
\def\l@subparagraph{\@dottedtocline{5}{10em}{5em}}
\fvset{frame=single,numberblanklines=false,xleftmargin=5mm,xrightmargin=5mm}
\@ifundefined{c@section}{\newcounter{section}}{}
<xsl:choose>
  <xsl:when test="/TEI.2/@rend='book'">
    \let\divI=\chapter
    \let\divII=\section
    \let\divIII=\subsection
    \let\divIV=\subsubsection
    \let\divV=\paragraph
  </xsl:when>
  <xsl:otherwise>
\newif\if@mainmatter 
\@mainmattertrue
\def\frontmatter{%
  \setcounter{secnumdepth}{-1}
  \@mainmatterfalse
  \pagenumbering{roman}}
\def\mainmatter{%
  \setcounter{section}{0}
  \setcounter{secnumdepth}{4}
  \@mainmattertrue
  \pagenumbering{arabic}}
\def\backmatter{%
  \clearpage
  \appendix
  \@mainmatterfalse}
\let\divI=\section
\let\divII=\subsection
\let\divIII=\subsubsection
\let\divIV=\paragraph
\let\divV=\subparagraph
  </xsl:otherwise>
</xsl:choose>
\makeatother

<xsl:call-template name="preambleHook"/>
\begin{document}
\thispagestyle{plain}
\parindent0em
\parskip3pt
\makeatletter
\def\tableofcontents{\section*{\contentsname}\@starttoc{toc}}
   <xsl:if test="not(text/front/titlePage)">
     <xsl:call-template name="printTitleAndLogo"/>
   </xsl:if>
\markright{\@title}%
\markboth{\@title}{\@author}%
\makeatother
<xsl:if test="not($docstyle='letter')">
\renewcommand{\sectionmark}[1]{\markright{\thesection\ #1}}
</xsl:if>
\fancyhf{} 
\fancyhead[LE]{\bfseries\leftmark} 
\fancyhead[RO]{\bfseries\rightmark} 
\fancyfoot[RO]{\TheFullDate}
\fancyfoot[CO]{\thepage}
\fancyfoot[LO]{<xsl:value-of select="$REQUEST"/>}
\fancyfoot[LE]{\TheFullDate}
\fancyfoot[CE]{\thepage}
\fancyfoot[RE]{<xsl:value-of select="$REQUEST"/>}
\fancypagestyle{plain}{\fancyhead{}\renewcommand{\headrulewidth}{0pt}}
<xsl:call-template name="begindocumentHook"/>
<xsl:apply-templates select="text"/>
\end{document}
</xsl:template>

<xsl:template match="/">
   <xsl:apply-templates select="TEI.2"/>
</xsl:template>

<xsl:template match="anchor">
 <xsl:text>\hypertarget{</xsl:text>
 <xsl:value-of select="@id"/>
  <xsl:text>}{}</xsl:text>
</xsl:template>

<xsl:template match="back">
\appendix
<xsl:apply-templates/>
</xsl:template>

<xsl:template match="back/div/div/head">
\subsection{<xsl:apply-templates />}
</xsl:template>

<xsl:template match="back/div/head">
\section{<xsl:apply-templates />}
</xsl:template>

<xsl:template match="bibl" mode="cite">
  <xsl:apply-templates select="text()[1]"/>
</xsl:template>

<xsl:template match="listBibl/bibl">
\bibitem {<xsl:choose><xsl:when test="@id">
<xsl:value-of select="@id"/></xsl:when>
<xsl:otherwise>bibitem-<xsl:number/></xsl:otherwise>
</xsl:choose>}
<xsl:apply-templates/>
<xsl:text>&#10;</xsl:text>
</xsl:template>


<xsl:template match="div0/head">
\divI<xsl:call-template name="sectionhead"/>
<xsl:call-template name="labelme"/>
</xsl:template>

<xsl:template match="div1/head">
\divII<xsl:call-template name="sectionhead"/>
<xsl:call-template name="labelme"/>
</xsl:template>

<xsl:template match="div2/head">
  \divIII<xsl:call-template name="sectionhead"/>
<xsl:call-template name="labelme"/>
</xsl:template>

<xsl:template match="div3/head">
\divIV<xsl:call-template name="sectionhead"/>
<xsl:call-template name="labelme"/>
</xsl:template>

<xsl:template match="div4/head">
\divV<xsl:call-template name="sectionhead"/>
<xsl:call-template name="labelme"/>
</xsl:template>

<xsl:template match="div/head">
<xsl:variable name="depth">
  <xsl:value-of select="count(ancestor::div)"/>
</xsl:variable>
<xsl:text>&#10;\div</xsl:text>
<xsl:choose>
  <xsl:when test="$depth=1">I</xsl:when>
  <xsl:when test="$depth=2">II</xsl:when>
  <xsl:when test="$depth=3">III</xsl:when>
  <xsl:when test="$depth=4">IV</xsl:when>
  <xsl:when test="$depth=5">V</xsl:when>
</xsl:choose>
<xsl:call-template name="sectionhead"/>
<xsl:call-template name="labelme"/>
</xsl:template>


<xsl:template match="cell">
  <xsl:if test="preceding-sibling::cell">\tabcellsep </xsl:if>
  <xsl:choose>
    <xsl:when test="@role='label'">
      <xsl:text>\Panel{</xsl:text>
        <xsl:if test="starts-with(normalize-space(.),'[')"><xsl:text>{}</xsl:text></xsl:if><xsl:apply-templates/>
      <xsl:text>}{label}{</xsl:text>
      <xsl:choose>
	<xsl:when test="@cols"><xsl:value-of select="@cols"/>
	</xsl:when>
	<xsl:otherwise>1</xsl:otherwise>
      </xsl:choose>
      <xsl:text>}{</xsl:text>
      <xsl:choose>
	<xsl:when test="@align='right'">r</xsl:when>
	<xsl:when test="@align='centre'">c</xsl:when>
	<xsl:when test="@align='center'">c</xsl:when>
	<xsl:when test="@align='left'">l</xsl:when>
	<xsl:otherwise>l</xsl:otherwise>
      </xsl:choose>
      <xsl:text>}</xsl:text>
    </xsl:when>
    <xsl:when test="@cols &gt; 1">
      <xsl:text>\multicolumn{</xsl:text>
      <xsl:value-of select="@cols"/>
      <xsl:text>}{c}{</xsl:text>
      <xsl:apply-templates/>
      <xsl:text>}</xsl:text>
    </xsl:when>
    <xsl:otherwise>
        <xsl:if test="starts-with(normalize-space(.),'[')"><xsl:text>{}</xsl:text></xsl:if>
	<xsl:apply-templates/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="code">\texttt{<xsl:apply-templates/>}</xsl:template>

<xsl:template match="divGen[@type='toc']">
\tableofcontents
</xsl:template>

<xsl:template match="div[@type='bibliography']">
\begin{thebibliography}{1}
  <xsl:call-template name="bibliography"/>
\end{thebibliography}  
</xsl:template>

<xsl:template match="listBibl">
\begin{thebibliography}{1}
  <xsl:apply-templates/>
\end{thebibliography}  
</xsl:template>

<xsl:template match="docAuthor">
\author{<xsl:apply-templates/>}
</xsl:template>

<xsl:template match="docDate">
\date{<xsl:apply-templates/>}
</xsl:template>


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

<xsl:template match="emph">\textit{<xsl:apply-templates/>}</xsl:template>


<xsl:template match="figDesc"/>

<xsl:template match="figure/head"/>

<xsl:template match="figure">
  <xsl:choose>
    <xsl:when test="@url">
      <xsl:call-template name="makePic"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:apply-templates/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="graphic">
      <xsl:call-template name="makePic"/>
</xsl:template>

<xsl:template name="makePic">
  <xsl:choose>
    <xsl:when test="@rend='display' or head or parent::figure/head">
      <xsl:text>\begin{figure}[htbp]
      </xsl:text>
    </xsl:when>
    <xsl:when test="@rend='centre'">
      <xsl:text>\par\centerline{</xsl:text>
    </xsl:when>
    <xsl:otherwise>
      \noindent
    </xsl:otherwise>
  </xsl:choose>
  <xsl:text>\includegraphics[</xsl:text>
  <xsl:if test="@width">
    <xsl:variable name="w">
      <xsl:choose>
	<xsl:when test="contains(@width,'pt')"><xsl:value-of select="@width"/></xsl:when>
	<xsl:when test="contains(@width,'in')"><xsl:value-of select="@width"/></xsl:when>
	<xsl:when test="contains(@width,'cm')"><xsl:value-of select="@width"/></xsl:when>
	<xsl:otherwise>
	  <xsl:value-of select="@width"/><xsl:text>pt</xsl:text>
	</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:text>width=</xsl:text><xsl:value-of select="$w"/><xsl:text>,</xsl:text>
  </xsl:if>
  <xsl:if test="@height">
    <xsl:variable name="h">
      <xsl:choose>
	<xsl:when test="contains(@height,'pt')"><xsl:value-of select="@height"/></xsl:when>
	<xsl:when test="contains(@height,'in')"><xsl:value-of select="@height"/></xsl:when>
	<xsl:when test="contains(@height,'cm')"><xsl:value-of select="@height"/></xsl:when>
	<xsl:otherwise>
	  <xsl:value-of select="@height"/><xsl:text>pt</xsl:text>
	</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:text>height=</xsl:text><xsl:value-of select="$h"/><xsl:text>,</xsl:text>
  </xsl:if>
  <xsl:choose>
    <xsl:when test="@scale and contains(@scale,'%')">
      <xsl:text>scale=</xsl:text>
      <xsl:value-of select="substring-before(@scale,'%') div 100"/>
      <xsl:text>,</xsl:text>
    </xsl:when>
    
    <xsl:when test="@scale">
      <xsl:text>scale=</xsl:text>
      <xsl:value-of select="@scale"/>
      <xsl:text>,</xsl:text>
    </xsl:when>
    <xsl:when test="not(@width) and not(@height) and not($standardScale=1)">
      <xsl:text>scale=</xsl:text>
      <xsl:value-of select="$standardScale"/>
      <xsl:text>,</xsl:text>
    </xsl:when>
  </xsl:choose>
  <xsl:text>]{</xsl:text>
  <xsl:choose>
    <xsl:when test="$realFigures='true'">
      <xsl:choose>
	<xsl:when test="@url">
	  <xsl:value-of select="@url"/>
	</xsl:when>
	<xsl:when test="parent::figure/@url">
	  <xsl:value-of select="parent::figure/@url"/>
	</xsl:when>
	<xsl:when test="parent::figure/@entity">
	  <xsl:value-of select="unparsed-entity-uri(parent::figure/@entity)"/>
	</xsl:when>
      </xsl:choose>
    </xsl:when>
    <xsl:otherwise>
      <xsl:variable name="c"><xsl:for-each select="ancestor-or-self::figure">
	<xsl:number level="any" count="figure[head]"/></xsl:for-each></xsl:variable>
      <xsl:text>FIG</xsl:text>
      <xsl:value-of select="$c+1000"/>
    </xsl:otherwise>
  </xsl:choose>
  <xsl:text>}</xsl:text>
  <xsl:choose>
    <xsl:when test="@rend='display' or head or parent::figure/head">
      <xsl:text>&#10;\caption{</xsl:text><xsl:value-of select="head|parent::figure/head"/>
      <xsl:text>}</xsl:text>
      <xsl:if test="parent::figure/@id|parent::figure/@xml:id">
	\label{<xsl:value-of select="parent::figure/@id|parent::figure/@xml:id"/>}
      </xsl:if>
      <xsl:text>\end{figure}
      </xsl:text>
    </xsl:when>
    <xsl:when test="@rend='centre'">
      <xsl:text>}\par</xsl:text>
    </xsl:when>
    <xsl:otherwise>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="foreign">
  <xsl:text>\textit{</xsl:text><xsl:apply-templates/><xsl:text>}</xsl:text>
</xsl:template>

<xsl:template match="front">
 \frontmatter
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="back">
 \backmatter
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="body">
 \mainmatter
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="gi">\texttt{&lt;<xsl:apply-templates/>&gt;}</xsl:template>

<xsl:template match="hi">
<xsl:text>\textbf{</xsl:text>
<xsl:apply-templates/>
<xsl:text>}</xsl:text>
</xsl:template>

<xsl:template match="hi[@rend='sub']">
<xsl:text>\textsubscript{</xsl:text>
<xsl:apply-templates/>
<xsl:text>}</xsl:text>
</xsl:template>

<xsl:template match="hi[@rend='sup']">
<xsl:text>\textsuperscript{</xsl:text>
<xsl:apply-templates/>
<xsl:text>}</xsl:text>
</xsl:template>

<xsl:template match="hr">
 \hline
</xsl:template>

<xsl:template match="ident">
  <xsl:text>\textsf{</xsl:text>
   <xsl:apply-templates/>
  <xsl:text>}</xsl:text>
</xsl:template>

<xsl:template match="item">
 \item <xsl:apply-templates/>
</xsl:template>

<xsl:template match="label"/>

<xsl:template match="lb">
<xsl:text>\newline </xsl:text>
</xsl:template>

<xsl:template match="list">
  <xsl:if test="head">
    \centerline{<xsl:value-of select="head"/>}
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

<xsl:template match="list/head"/>

<xsl:template match="mentioned">
  <xsl:text>\emph{</xsl:text><xsl:apply-templates/><xsl:text>}</xsl:text>
</xsl:template>

<xsl:template match="note[@place='foot']">
  <xsl:text>\footnote{</xsl:text>
  <xsl:apply-templates/>
  <xsl:text>}</xsl:text>
</xsl:template>

<xsl:template match="p">\par
<xsl:apply-templates/></xsl:template>

<xsl:template match="q">
  <xsl:text>`</xsl:text>
  <xsl:apply-templates/>
  <xsl:text>'</xsl:text>
</xsl:template>

<xsl:template match="q[@rend='eg']">
\begin{quote}\ttfamily\color{black}\obeylines <xsl:apply-templates/> \end{quote}
</xsl:template>

<xsl:template match="row">
  <xsl:if test="@role='label'">\rowcolor{label}</xsl:if>
  <xsl:apply-templates/>
  <xsl:if test="following-sibling::row">
    <xsl:text>\\
</xsl:text>
</xsl:if>
</xsl:template>

<xsl:template match="soCalled">
 <xsl:text>&#8216;</xsl:text><xsl:apply-templates/><xsl:text>&#8217;</xsl:text>
</xsl:template>

<xsl:template match="table" mode="xref">
<xsl:text>the table on p. \pageref{</xsl:text>
<xsl:value-of select="@id"/>
<xsl:text>}</xsl:text>
</xsl:template>

<xsl:template match="table">
\par  
<xsl:if test="@id">\label{<xsl:value-of select="@id"/>}</xsl:if>
<xsl:choose>
<xsl:when test="ancestor::table">
\begin{tabular}
<xsl:call-template name="makeTable"/>
\end{tabular}
</xsl:when>
<xsl:otherwise>
\begin{longtable}
<xsl:call-template name="makeTable"/>
\end{longtable}
\par
</xsl:otherwise>
</xsl:choose>
</xsl:template>

<xsl:template match="table/head"/>

<xsl:template match="table[@type='display']" mode="xref">
<xsl:text>Table </xsl:text>
<xsl:number level="any" count="table[@type='display']"/>
</xsl:template>

<xsl:template match="table[@type='display']">
  \begin{table*}
  \caption{<xsl:apply-templates select="head" mode="ok"/>}
  <xsl:if test="@id">\label{<xsl:value-of select="@id"/>}</xsl:if>
  \begin{small}
  \begin{center}
  \begin{tabular}
  <xsl:call-template name="makeTable"/>
  \end{tabular}
  \end{small}
  \end{center}
  \end{table*}
</xsl:template>

<xsl:template match="text">
  <xsl:call-template name="extradefHook"/>
 <xsl:text disable-output-escaping="yes">
\catcode`\$=12\relax
\catcode`\^=12\relax
\catcode`\~=12\relax
\catcode`\#=12\relax
\catcode`\%=12\relax
</xsl:text>
<xsl:apply-templates/>
</xsl:template>

<xsl:template match="titlePage">
  \begin{titlepage}
  <xsl:apply-templates/>
  \maketitle
  \end{titlepage}
  \cleardoublepage
</xsl:template>

<xsl:template match="titlePart">
\title{<xsl:apply-templates/>}
</xsl:template>

<xsl:template match="title[@level='a']">
  <xsl:text>``</xsl:text>
   <xsl:apply-templates/>
  <xsl:text>''</xsl:text>
</xsl:template>

<xsl:template match="title[@level='m']">
  <xsl:text>\textit{</xsl:text>
   <xsl:apply-templates/>
  <xsl:text>}</xsl:text>
</xsl:template>

<xsl:template match="title[@level='s']">
  <xsl:text>\textit{</xsl:text>
   <xsl:apply-templates/>
  <xsl:text>}</xsl:text>
</xsl:template>

<xsl:template match="xref[@type='cite']">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="text()">
  <xsl:choose>
    <xsl:when test="contains(.,'\')">
      <xsl:call-template name="slasher">
        <xsl:with-param name="s">
          <xsl:value-of select="."/>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="."/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template mode="gloss" match="item">
 \item[<xsl:apply-templates mode="print" select="preceding-sibling::*[1]"/>]
 <xsl:apply-templates/>
</xsl:template>

<xsl:template name="begindocumentHook"/>

<xsl:template name="bibliography">
  <xsl:apply-templates 
select="//xref[@type='cite'] | //xptr[@type='cite'] | //ref[@type='cite'] | //ptr[@type='cite']"
		       mode="biblio"/>
</xsl:template>

<xsl:template name="extradefHook"/>

<xsl:template name="findFileName">
  <xsl:variable name="f">
    <xsl:choose>
      <xsl:when test="@url">
	<xsl:value-of select="@url"/>
      </xsl:when>
      <xsl:when test="@file">
	<xsl:value-of select="@file"/>
      </xsl:when>
      <xsl:when test="@entity">
	<xsl:value-of select="unparsed-entity-uri(@entity)"/>
      </xsl:when>
      <xsl:when test="graphic">
	<xsl:value-of select="graphic/@url"/>
      </xsl:when>
    </xsl:choose>
  </xsl:variable>

  <xsl:choose>
    <xsl:when test="contains($f,'.')">
      <xsl:value-of select="$f"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="concat($f,'.png')"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="generateSimpleTitle">
 <xsl:choose>
    <xsl:when test="$useHeaderFrontMatter='true' and ancestor-or-self::TEI.2/text/front//docTitle">
         <xsl:value-of select="normalize-space(ancestor-or-self::TEI.2/text/front//docTitle)"/>
 </xsl:when>
<xsl:otherwise>
<xsl:value-of
 select="normalize-space(ancestor-or-self::TEI.2/teiHeader/fileDesc/titleStmt/title)"/>
</xsl:otherwise>
</xsl:choose>
</xsl:template>

<xsl:template name="labelme">
 <xsl:if test="../@id|../@xml:id">\hypertarget{<xsl:value-of select="../@id|../@xml:id"/>}{}</xsl:if>
</xsl:template>

<xsl:template name="makeExternalLink">
  <xsl:param name="ptr"/>
  <xsl:param name="dest"/>
  <xsl:choose>
    <xsl:when test="$ptr='true'">
      <xsl:text>\url{</xsl:text>
      <xsl:value-of select="$dest"/>
      <xsl:text>}</xsl:text>
    </xsl:when>
    <xsl:otherwise>
      <xsl:text>\xref{</xsl:text>
      <xsl:value-of select="$dest"/>
      <xsl:text>}{</xsl:text>
      <xsl:apply-templates/>
      <xsl:text>}</xsl:text>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="makeInternalLink">
  <xsl:param name="target"/>
  <xsl:param name="ptr"/>
  <xsl:param name="dest"/>
  <xsl:param name="body"/>
  <xsl:choose>
    <xsl:when test="key('IDS',$dest)">
      <xsl:text>\hyperlink{</xsl:text>
      <xsl:value-of select="$dest"/>
      <xsl:text>}{\textit{</xsl:text>
      <xsl:choose>
	<xsl:when test="not($body='')">
	  <xsl:value-of select="$body"/>
	</xsl:when>
	<xsl:when test="$ptr='true'">
	  <xsl:apply-templates mode="xref" select="key('IDS',$dest)">
	    <xsl:with-param name="minimal" select="$minimalCrossRef"/>
	  </xsl:apply-templates>
	</xsl:when>
	<xsl:otherwise>
	  <xsl:apply-templates/>
	</xsl:otherwise>
      </xsl:choose>
      <xsl:text>}}</xsl:text>
    </xsl:when>
    <xsl:otherwise>
      <xsl:text>&#x00AB;</xsl:text>
      <xsl:choose>
	<xsl:when test="not($body='')">
	  <xsl:value-of select="$body"/>
	</xsl:when>
	<xsl:when test="$ptr='true'">
	  <xsl:value-of select="$dest"/>
	</xsl:when>
	<xsl:otherwise>
	  <xsl:apply-templates/>
	</xsl:otherwise>
      </xsl:choose>
      <xsl:text>&#x00BB;</xsl:text>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>
<xsl:template name="makeTable">
  <xsl:variable name="r">
    <xsl:value-of select="@rend"/>
  </xsl:variable>
  <xsl:text>{</xsl:text>
  <xsl:if test="$r='rules'">|</xsl:if>
<xsl:variable name="tds">
 <xsl:for-each select=".//cell">
  <xsl:variable name="stuff">
     <xsl:apply-templates/>
  </xsl:variable>
   <cell>
    <xsl:attribute name="col"><xsl:number/></xsl:attribute>
    <xsl:value-of select="string-length($stuff)"/>
   </cell>
 </xsl:for-each>
</xsl:variable>
<xsl:variable name="total">
  <xsl:value-of select="sum(exsl:node-set($tds)/cell)"/>
</xsl:variable>
<xsl:for-each select="exsl:node-set($tds)/cell">
  <xsl:sort select="@col" data-type="number"/>
  <xsl:variable name="c" select="@col"/>
  <xsl:if test="not(preceding-sibling::cell[$c=@col])">
   <xsl:variable name="len">
    <xsl:value-of select="sum(following-sibling::cell[$c=@col]) + current()"/>
   </xsl:variable>
 <xsl:text>P{</xsl:text>
 <xsl:value-of select="($len div $total) * 0.95" />
   <xsl:text>\textwidth}</xsl:text>
  <xsl:if test="$r='rules'">|</xsl:if>
</xsl:if>
</xsl:for-each>
  <xsl:text>}
</xsl:text>
<xsl:if test="$r='rules'">\hline </xsl:if>
<xsl:if test="head and not(../@rend='display')">
  <xsl:text>\caption{</xsl:text>
  <xsl:apply-templates	select="head" mode="ok"/>
  <xsl:text>}\\ </xsl:text>
</xsl:if>
<xsl:apply-templates/>
  <xsl:if test="$r='rules'">
    <xsl:text>\\ \hline </xsl:text>
  </xsl:if>
</xsl:template>

<xsl:template name="preambleHook"/>

<xsl:template name="printTitleAndLogo">
\parbox[b]{.75\textwidth}{\fontsize{14pt}{16pt}\bfseries\sffamily\selectfont \@title}
\vskip20pt
\par{\fontsize{11pt}{13pt}\sffamily\itshape\selectfont\@author\hfill\TheDate}
\vspace{18pt}
</xsl:template>

<xsl:template name="sectionhead">
  <xsl:if test="note">
    <xsl:text>[</xsl:text>
    <xsl:apply-templates select="text()"/>
    <xsl:text>]</xsl:text>
  </xsl:if>
  <xsl:text>{</xsl:text>
  <xsl:apply-templates/>
  <xsl:text>}</xsl:text>
</xsl:template>

<xsl:template name="slasher">
  <xsl:param name="s"/>
  <xsl:choose>
  <xsl:when test="contains($s,'\')">
  <xsl:value-of select="substring-before($s,'\')"/>
  <xsl:text>\char92 </xsl:text>
      <xsl:call-template name="slasher">
        <xsl:with-param name="s">
          <xsl:value-of select="substring-after($s,'\')"/>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$s"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="generateEndLink">
  <xsl:param name="where"/>
  <xsl:value-of select="$where"/>
</xsl:template>


<xsl:template match="p[@rend='display']">
\begin{quote}
   <xsl:apply-templates/>
\end{quote}
</xsl:template>

<xsl:template match="q[@rend='display']">
\begin{quote}
   <xsl:apply-templates/>
\end{quote}
</xsl:template>

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

<xsl:template match="processing-instruction()[name(.)='tex']">
  <xsl:value-of select="."/>
</xsl:template>

</xsl:stylesheet>
