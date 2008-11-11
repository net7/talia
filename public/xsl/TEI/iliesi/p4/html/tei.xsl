<!-- 
Text Encoding Initiative Consortium XSLT stylesheet family
$Date: 2005/01/31 00:04:31 $, $Revision: 1.5 $, $Author: rahtz $

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
   xmlns:a="http://relaxng.org/ns/compatibility/annotations/1.0"
   xmlns:edate="http://exslt.org/dates-and-times"
   xmlns:estr="http://exslt.org/strings"
   xmlns:exsl="http://exslt.org/common"
   xmlns:fo="http://www.w3.org/1999/XSL/Format"
   xmlns:local="http://www.pantor.com/ns/local"
   xmlns:rng="http://relaxng.org/ns/structure/1.0"
   xmlns:tei="http://www.tei-c.org/ns/1.0"
   xmlns:teix="http://www.tei-c.org/ns/Examples"
   extension-element-prefixes="exsl estr edate"
   exclude-result-prefixes="exsl estr edate a fo local rng tei teix"
   xmlns:html="http://www.w3.org/1999/xhtml"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
  version="1.0">
  
<xsl:import href="../common/teicommon.xsl"/>

<xsl:import href="teihtml-param.xsl"/>

<xsl:include href="teihtml-bibl.xsl"/>
<xsl:include href="teihtml-chunk.xsl"/>
<xsl:include href="teihtml-corpus.xsl"/>
<xsl:include href="teihtml-drama.xsl"/>
<xsl:include href="teihtml-figures.xsl"/>
<xsl:include href="teihtml-front.xsl"/>
<xsl:include href="teihtml-lists.xsl"/>
<xsl:include href="teihtml-layout.xsl"/>
<xsl:include href="teihtml-main.xsl"/>
<xsl:include href="teihtml-math.xsl"/>
<xsl:include href="teihtml-misc.xsl"/>
<xsl:include href="teihtml-notes.xsl"/>
<xsl:include href="teihtml-poetry.xsl"/>
<xsl:include href="teihtml-struct.xsl"/>
<xsl:include href="teihtml-tables.xsl"/>
<xsl:include href="teihtml-xref.xsl"/>

</xsl:stylesheet>
