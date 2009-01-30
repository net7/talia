<!-- 
TEI XSLT stylesheet family
$Date: 2004/05/10 21:58:08 $, $Revision: 1.2 $, $Author: rahtz $

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
<!-- paragraphs -->
 <xsl:template match="p">
  <fo:block font-size="{$bodySize}">
     <xsl:if test="preceding-sibling::p">
	<xsl:attribute name="text-indent">
              <xsl:value-of select="$parIndent"/>
        </xsl:attribute>
	<xsl:attribute name="space-before.optimum">
              <xsl:value-of select="$parSkip"/>
        </xsl:attribute>
	<xsl:attribute name="space-before.maximum">
              <xsl:value-of select="$parSkipmax"/>
        </xsl:attribute>
     </xsl:if>
 <xsl:if test="@xml:lang">
   <xsl:attribute name="country">
     <xsl:value-of select="substring-before(@xml:lang,'-')"/>
   </xsl:attribute>
   <xsl:attribute name="language">
     <xsl:value-of select="substring-after(@xml:lang,'-')"/>
   </xsl:attribute>
 </xsl:if>
    <xsl:apply-templates/>
  </fo:block>
</xsl:template>
</xsl:stylesheet>
