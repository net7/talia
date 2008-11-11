<!-- 
Text Encoding Initiative Consortium XSLT stylesheet family
$Date: 2005/01/31 00:04:29 $, $Revision: 1.5 $, $Author: rahtz $

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

  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

<xsl:template match="teiCorpus.2">
 <xsl:for-each select="TEI.2">
 <xsl:if test="$verbose">
   <xsl:message>Process <xsl:value-of select="teiHeader/fileDesc/titleStmt/title"/></xsl:message>
 </xsl:if>
   <xsl:apply-templates select="." mode="split"/>
 </xsl:for-each>
 <html><xsl:call-template name="addLangAtt"/> 
 <head>
 <title><xsl:apply-templates select="teiHeader/fileDesc/titleStmt/title/text()"/></title>
 <xsl:call-template name="includeCSS"/>
 </head>
 <body class="simple">
 <xsl:call-template name="bodyHook"/>
 <xsl:call-template name="bodyJavaScriptHook"/>
 <xsl:call-template name="stdheader">
  <xsl:with-param name="title">
   <xsl:apply-templates select="teiHeader/fileDesc/titleStmt/title"/>
  </xsl:with-param>
 </xsl:call-template>

 <xsl:call-template name="corpusBody"/>

 <xsl:call-template name="stdfooter">
       <xsl:with-param name="date">
         <xsl:choose>
          <xsl:when test="teiHeader/revisionDesc//date[1]">
            <xsl:value-of select="teiHeader/revisionDesc//date[1]"/>
          </xsl:when>
          <xsl:otherwise>
    	   <xsl:text>(undated)</xsl:text>
          </xsl:otherwise>    
         </xsl:choose>
       </xsl:with-param>
       <xsl:with-param name="author"/>
   </xsl:call-template>
 </body>
 </html>
</xsl:template>


<xsl:template name="corpusBody">
<ul>
 <xsl:for-each select="TEI.2">
 <li>
    <a> <xsl:attribute name="href">
     <xsl:apply-templates mode="generateLink" select="."/>
     </xsl:attribute>
     <xsl:call-template name="header">
     <xsl:with-param name="minimal"/>
     </xsl:call-template>
     </a>  
 </li>
 </xsl:for-each>
</ul>
</xsl:template>

<xsl:template match="catRef">
  <xsl:variable name="W">
    <xsl:choose>
      <xsl:when test="starts-with(@target,'#')">
	<xsl:value-of select="substring-after(@target,'#')"/>
      </xsl:when>
      <xsl:otherwise>
	<xsl:value-of select="@target"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:if test="preceding-sibling::catRef"><xsl:text> </xsl:text></xsl:if>
  <em><xsl:value-of select="@scheme"/></em>:
  <xsl:apply-templates select="key('IDS',$W)/catDesc"/>
</xsl:template>

</xsl:stylesheet>
