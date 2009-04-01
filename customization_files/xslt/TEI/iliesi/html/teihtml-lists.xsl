<!-- 
Text Encoding Initiative Consortium XSLT stylesheet family
$Date: 2005/01/31 00:04:30 $, $Revision: 1.6 $, $Author: rahtz $

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


<!-- lists -->


<xsl:template match="list">
<xsl:if test="head">
  <p><em><xsl:apply-templates select="head"/></em></p>
</xsl:if>
<xsl:choose>
 <xsl:when test="@type='catalogue'">
  <p><dl>
    <xsl:for-each select="item">
       <p/>
       <xsl:apply-templates select="."  mode="gloss"/>
    </xsl:for-each>
  </dl></p>
 </xsl:when>
  <xsl:when test="@type='gloss' and @rend='multicol'">
    <xsl:variable name="nitems">
      <xsl:value-of select="count(item)div 2"/>
    </xsl:variable>
    <p><table>
    <tr>
      <td valign="top">
      <dl>
         <xsl:apply-templates mode="gloss" select="item[position()&lt;=$nitems ]"/>
      </dl>
      </td>
      <td  valign="top">
      <dl>
         <xsl:apply-templates mode="gloss" select="item[position() &gt;$nitems]"/>
      </dl>
      </td>
     </tr>
    </table>
    </p>
  </xsl:when>

 <xsl:when test="@type='gloss'">
  <p><dl><xsl:apply-templates mode="gloss" select="item"/></dl></p>
 </xsl:when>
 <xsl:when test="@type='glosstable'">
  <table><xsl:apply-templates mode="glosstable" select="item"/></table>
 </xsl:when>
 <xsl:when test="@type='vallist'">
  <table><xsl:apply-templates mode="glosstable" select="item"/></table>
 </xsl:when>
 <xsl:when test="@type='inline'">
   <xsl:if test="not(item)">None</xsl:if>
  <xsl:apply-templates select="item" mode="inline"/>
 </xsl:when>
 <xsl:when test="@type='runin'">
  <p><xsl:apply-templates select="item" mode="runin"/></p>
 </xsl:when>
 <xsl:when test="@type='unordered'">
  <ul>
  <xsl:choose>
  <xsl:when test="@rend and starts-with(@rend,'class:')">
    <xsl:attribute name="class">
      <xsl:value-of select="substring-after(@rend,'class:')"/>
    </xsl:attribute>
  </xsl:when>
  <xsl:when test="@rend">
    <xsl:attribute name="class"><xsl:value-of select="@rend"/></xsl:attribute>
  </xsl:when>
  </xsl:choose>
  <xsl:apply-templates select="item"/></ul>
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
    <xsl:attribute name="class"><xsl:value-of select="@rend"/></xsl:attribute>
  </xsl:when>
</xsl:choose>
  <xsl:apply-templates select="item"/></ol>
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
    <xsl:attribute name="class"><xsl:value-of select="@rend"/></xsl:attribute>
  </xsl:when>
</xsl:choose>
  <xsl:apply-templates select="item"/></ul>
 </xsl:otherwise>
</xsl:choose>
</xsl:template>

<xsl:template mode="bibl" match="item">
 <p>
   <xsl:call-template name="makeAnchor"/>
   <xsl:apply-templates/>
 </p>
</xsl:template>

<xsl:template mode="glosstable" match="item">
 <tr>
   <td valign="top"><strong>
     <xsl:apply-templates mode="print" select="preceding-sibling::*[1]"/></strong></td>
   <td><xsl:call-template name="makeAnchor"/><xsl:apply-templates/></td>
 </tr>
</xsl:template>

<xsl:template mode="gloss" match="item">
   <dt><xsl:call-template name="makeAnchor"/><strong>
     <xsl:apply-templates mode="print" select="preceding-sibling::label[1]"/>
   </strong>
   </dt>
   <dd>   <xsl:apply-templates/></dd>
</xsl:template>

<xsl:template match="item/label">
    <xsl:choose>
	<xsl:when test="@rend">
          <xsl:call-template name="rendering"/>
	</xsl:when>
        <xsl:otherwise>
          <strong><xsl:apply-templates/></strong>
        </xsl:otherwise>     
    </xsl:choose>
</xsl:template>

<xsl:template match="list/label"/>

<xsl:template match="item">
  <li>
    <xsl:if test="@rend">
      <xsl:attribute name="class"><xsl:value-of select="@rend"/></xsl:attribute>
    </xsl:if>
    <xsl:if test="@n">
      <xsl:attribute name="value"><xsl:value-of select="@n"/></xsl:attribute>
    </xsl:if>
    <xsl:choose>
      <xsl:when test="@id">
	<a name="{@id}"></a>
      </xsl:when>
      <xsl:when test="$generateParagraphIDs='true'">
	<a name="{generate-id()}"></a>
      </xsl:when>
    </xsl:choose>
    <xsl:apply-templates/>
  </li>
</xsl:template>

<xsl:template match="item" mode="runin">
  &#8226; <xsl:apply-templates/>&#160;
</xsl:template>

<xsl:template match="item" mode="inline">
  <xsl:if test="preceding-sibling::item">,  </xsl:if>
  <xsl:if test="not(following-sibling::item) and preceding-sibling::item"> and  </xsl:if>   
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="label" mode="print">
  <xsl:if test="@id"><a name="{@id}"></a></xsl:if>
  <xsl:choose>
    <xsl:when test="@rend">
      <xsl:call-template name="rendering"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:apply-templates/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="list" mode="inpara">
    <p><xsl:apply-templates select="preceding-sibling::node()"/></p>
    <xsl:apply-templates select="."/>
    <p><xsl:apply-templates select="following-sibling::node()"/></p>
  </xsl:template>
  
  
</xsl:stylesheet>
