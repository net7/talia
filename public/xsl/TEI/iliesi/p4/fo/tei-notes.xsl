<!-- 
TEI XSLT stylesheet family
$Date: 2004/11/23 10:05:32 $, $Revision: 1.3 $, $Author: rahtz $

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

<!-- out of line objects -->
<xsl:template match="note" mode="endnote">
 <fo:block id="{generate-id()}">
   <xsl:call-template name="calculateEndNoteNumber"/>
  <xsl:text>. </xsl:text><xsl:apply-templates/>
 </fo:block>
</xsl:template>

<xsl:template match="note">
  <xsl:choose>
   <xsl:when test="@place='foot'">
<!--
    <fo:simple-link>
      <xsl:attribute name="internal-destination">
      <xsl:value-of select="generate-id()"/>
      </xsl:attribute>
-->
    <xsl:variable name="FootID">
      <xsl:choose>
        <xsl:when test="@n">
         <xsl:value-of select="@n"/>
        </xsl:when>
        <xsl:otherwise>
         <xsl:call-template name="calculateFootnoteNumber"/>
        </xsl:otherwise>
       </xsl:choose>
    </xsl:variable>
    <fo:footnote>
      <fo:inline font-size="{$footnotenumSize}" vertical-align="super">
         <xsl:value-of select="$FootID"/>
      </fo:inline>
     <fo:footnote-body>
       <fo:block end-indent="0pt"
		 start-indent="0pt"
		 text-align="start" 
		 font-style="normal"
		 text-indent="{$parIndent}" 
		 font-size="{$footnoteSize}">
         <fo:inline font-size="{$footnotenumSize}"
               vertical-align="super">
          <xsl:value-of select="$FootID"/>
        </fo:inline><xsl:text> </xsl:text>
       <xsl:apply-templates/>
       </fo:block>
     </fo:footnote-body>
    </fo:footnote> 
   </xsl:when>
   <xsl:when test="@place='end'">
    <fo:simple-link>
      <xsl:attribute name="internal-destination">
      <xsl:value-of select="generate-id()"/>
      </xsl:attribute>
      <fo:inline font-size="{$footnotenumSize}" vertical-align="super">
      <xsl:choose>
        <xsl:when test="@n">
         <xsl:value-of select="@n"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="calculateEndNoteNumber"/>
        </xsl:otherwise>
       </xsl:choose>
    </fo:inline>
    </fo:simple-link>
   </xsl:when>
  <xsl:when test="@place='display'">
   <fo:block 	
	text-indent="0pt"
	end-indent="{$exampleMargin}"
	start-indent="{$exampleMargin}"
	font-size="{$exampleSize}"
	space-before.optimum="{$exampleBefore}"
	space-after.optimum="{$exampleAfter}"
	>
   <xsl:apply-templates/>
 </fo:block>
 </xsl:when>
  <xsl:when test="@place='divtop'">
   <fo:block 	
	text-indent="0pt"
	end-indent="{$exampleMargin}"
	start-indent="{$exampleMargin}"
        font-style="italic"
	font-size="{$exampleSize}"
	space-before.optimum="{$exampleBefore}"
	space-after.optimum="{$exampleAfter}"
	>
   <xsl:apply-templates/>
 </fo:block>
 </xsl:when>
   <xsl:when test="@place='margin'">
   </xsl:when>
   <xsl:when test="@place='right'">
   </xsl:when>
   <xsl:when test="@place='left'">
   </xsl:when>
   <xsl:otherwise>
   <xsl:text> (</xsl:text>
      <xsl:apply-templates/>
   <xsl:text>) </xsl:text>
   </xsl:otherwise>
  </xsl:choose>
</xsl:template>


<xsl:template name="calculateEndNoteNumber">
  <xsl:number  level="any" format="i" count="note[@place='end']"/>
</xsl:template>

<xsl:template name="calculateFootnoteNumber">
    <xsl:number  from="text" level="any" count="note[@place='foot']"/>
</xsl:template>

</xsl:stylesheet>
