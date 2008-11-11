<!-- 
TEI XSLT stylesheet family
$Date: 2004/11/22 21:44:57 $, $Revision: 1.2 $, $Author: rahtz $

XSL FO stylesheet to format TEI XML documents 

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
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

<xsl:import href="teilatex-lib.xsl"/>

<xsl:output method="text"/>

<xsl:template match="TEI.2">
\documentclass[a4paper]{article}
\usepackage{amsmath}
\usepackage[contnav]{pdfslide}
\pagestyle{title}
\usepackage{xmllatex}
\begin{document}
\orgurl{\protect\color{white}http://www.oucs.ox.ac.uk/}
\orgname{Oxford University Computing Services}
\author{<xsl:apply-templates select="/TEI.2//front//docAuthor"/>}
\title{<xsl:value-of select="/TEI.2//front//titlePart[@type='main']"/>}
\date{<xsl:value-of select="/TEI.2//front//docDate"/>}
\pagedissolve{Wipe /D 1 /Di /H /M /O}
\color{section0}
\overlay{d12.jpg}
\maketitle
\overlay{metablue.pdf}

<xsl:apply-templates select="text/body"/>
\end{document}
</xsl:template>


<xsl:template match="div/head">
\section{<xsl:apply-templates/>}
</xsl:template>

<xsl:template match="div/div/head">
\subsection{<xsl:apply-templates/>}
</xsl:template>

</xsl:stylesheet>
