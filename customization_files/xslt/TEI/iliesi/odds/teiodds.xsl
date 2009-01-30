<?xml version="1.0" encoding="utf-8"?>
<!-- $Date: 
Text Encoding Initiative Consortium XSLT stylesheet family
2001/10/01 $, $Revision: 1.48 $, $Author: rahtz $

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

    sebastian.rahtz@computing-services.oxford.ac.uk
-->
<xsl:stylesheet 
    xmlns:s="http://www.ascc.net/xml/schematron" 
    xmlns:a="http://relaxng.org/ns/compatibility/annotations/1.0"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" 
    xmlns:rng="http://relaxng.org/ns/structure/1.0"
    xmlns:teix="http://www.tei-c.org/ns/Examples"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:fo="http://www.w3.org/1999/XSL/Format"
    xmlns:edate="http://exslt.org/dates-and-times"
    xmlns:exsl="http://exslt.org/common"
    xmlns:estr="http://exslt.org/strings"
    exclude-result-prefixes="exsl estr edate teix fo a tei s xs" 
    extension-element-prefixes="edate exsl estr"
    version="1.0">
  <xsl:include href="RngToRnc.xsl"/>
  <xsl:param name="TEISERVER">http://localhost/TEI/Roma/xquery/</xsl:param>
  <xsl:param name="verbose"></xsl:param>
  <xsl:param name="schemaBaseURL">http://www.tei-c.org/P5/Schema/</xsl:param>
  
  <xsl:key  name="CLASSMEMBERS" match="elementSpec|classSpec" use="classes/memberOf/@key"/>
  <xsl:key name="TAGS" match="Tag|Pattern|Class" use="ident"/>
  <xsl:key name="IDENTS"   match="elementSpec|classSpec|macroSpec"   use="@ident"/>
  <xsl:key name="TAGIDS"     match="*[@id]"           use="@id"/>
  <xsl:key name="TAGIDENTS"     match="Table/*[ident]"           use="ident"/>
  <xsl:key name="IDS"     match="*[@id]"  use="@id"/>
  <xsl:key name="PATTERNS" match="macroSpec" use="@ident"/>
  <xsl:key name="MACRODOCS" match="macroSpec" use='1'/>
  <xsl:key name="CLASSDOCS" match="classSpec" use='1'/>
  <xsl:key name="TAGDOCS" match="elementSpec" use='1'/>
  <xsl:key name='NameToID' match="*" use="@ident"/>
  <xsl:key name="ElementModule" match="elementSpec" use="@module"/>
  <xsl:key name="ClassModule"   match="classSpec" use="@module"/>
  <xsl:key name="MacroModule"   match="macroSpec" use="@module"/>
  <xsl:key name="DeclModules"   match="moduleSpec[@type='decls']"	 use="@ident"/>
  <xsl:key name="AllModules"   match="moduleSpec[not(@type='decls')]" use="1"/>
  <xsl:key name="DefClasses"   match="classSpec[@predeclare='true']" use="1"/>
  
  <!-- lookup table of element contents, and templates to access the result -->
  <xsl:key name="ELEMENTPARENTS" match="Contains" use="."/>
  <xsl:key name="ELEMENTS" match="Element" use="@id"/>
  <xsl:param name="wrapLength">65</xsl:param>
  
  
  
  <xsl:template match="processing-instruction()">
    <xsl:if test="name(.) = 'odds'">
      <xsl:choose>
	<xsl:when test=".='date'">
	  This formatted version of the Guidelines was 
	  created on <xsl:value-of select="edate:date-time()"/>.
	</xsl:when>
      </xsl:choose>
    </xsl:if>
  </xsl:template>
  
  
  
  <xsl:template match="*" mode="literal">
    <xsl:text>
    </xsl:text>
    <xsl:for-each select="ancestor::rng:*">
      <xsl:text> </xsl:text>
    </xsl:for-each>
    <xsl:text>&lt;</xsl:text>
    <xsl:value-of select="local-name(.)"/>
    <xsl:for-each select="@*">
      <xsl:text> </xsl:text>
    <xsl:value-of select="local-name(.)"/>="<xsl:value-of select="."/>"</xsl:for-each>
    <xsl:choose>
      <xsl:when test="child::node()">
	<xsl:text>&gt;</xsl:text>
	<xsl:apply-templates mode="literal"/>
	<xsl:if test="node()[last()]/self::rng:*"> 
	  <xsl:text>
	  </xsl:text>
	</xsl:if>
	<xsl:for-each select="ancestor::rng:*">
	  <xsl:text> </xsl:text>
	</xsl:for-each>
	<xsl:text>&lt;/</xsl:text>
	<xsl:value-of select="local-name(.)"/>
	<xsl:text>&gt;</xsl:text>
      </xsl:when>    
      <xsl:otherwise>
	<xsl:text>/&gt;</xsl:text>
	<xsl:if test="node()[last()]/self::rng:*"> 
	  <xsl:text>
	  </xsl:text>
	</xsl:if>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  
  
  <xsl:template match="rng:*">
    <xsl:copy>
      <xsl:copy-of select="@*"/>
      <xsl:apply-templates select="rng:*|*|text()|comment()"/>
    </xsl:copy>
  </xsl:template>
  
  
  
  <xsl:template match="*" mode="tangle"/>
  
  
  <xsl:template match="att">
    <xsl:call-template name="italicize">
      <xsl:with-param name="text">
	<xsl:apply-templates/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>
  
  
  <xsl:template match="attDef[@mode='delete']" mode="tangle"/>
  
  <xsl:template match="attDef" mode="tangle">
    <xsl:variable name="I">
      <xsl:choose>
	<xsl:when test="starts-with(@ident,'xml:')">
	  <xsl:text>xml</xsl:text>
	  <xsl:value-of select="substring-after(@ident,'xml:')"/>
	</xsl:when>
	<xsl:otherwise>
	  <xsl:value-of select="@ident"/>
	</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:if test="not(@ident='xmlns')">
      <xsl:choose>
	<xsl:when test="@mode='add' and not (ancestor::elementSpec[@mode='add'])"/>
	<xsl:when test="@usage='req'">
	  <rng:ref name="{ancestor::attList/../@ident}.attributes.{$I}"/>
	</xsl:when>
	<xsl:when test="ancestor::classSpec">
	  <rng:ref name="{ancestor::attList/../@ident}.attributes.{$I}"/>
	</xsl:when>
	<xsl:otherwise>
	  <rng:ref
	      name="{ancestor::attList/../@ident}.attributes.{$I}"/>
	  <!-- when is this ever needed?	
	       <rng:optional>
	       </rng:optional>
	  -->
	</xsl:otherwise>
      </xsl:choose>
    </xsl:if>
  </xsl:template>
  
  <xsl:template match="attDef[@mode='change']" mode="tangle"/>
  
  <xsl:template match="attList" mode="tangle">
    <xsl:choose>
      <xsl:when test="@org='choice'">
	<rng:optional >
	  <rng:choice >
	    <xsl:apply-templates select="*" mode="tangle"/>
	  </rng:choice>
	</rng:optional>
      </xsl:when>
      <xsl:when test="parent::elementSpec[@mode='change']">
	<xsl:variable name="loc">
	  <xsl:value-of select="$TEISERVER"/>
	  <xsl:text>copytag.xq?name=</xsl:text>
	  <xsl:value-of select="parent::elementSpec/@ident"/>
	</xsl:variable>
	<xsl:if test="$verbose">
	  <xsl:message>Accessing TEISERVER: <xsl:value-of
	  select="$loc"/></xsl:message>
	</xsl:if>
	<xsl:for-each
	    select="document($loc)//attDef[not(@ident=current()//attDef/@ident)]">
	  <xsl:if test="not(@ident='xmlns')">
	    <xsl:variable name="I">
	      <xsl:choose>
		<xsl:when test="starts-with(@ident,'xml:')">
		  <xsl:text>xml</xsl:text>
		  <xsl:value-of select="substring-after(@ident,'xml:')"/>
		</xsl:when>
		<xsl:otherwise>
		  <xsl:value-of select="@ident"/>
		</xsl:otherwise>
	      </xsl:choose>
	    </xsl:variable>
	    <xsl:choose>
	      <xsl:when test="@usage='req'">
		<rng:ref name="{ancestor::elementSpec/@ident}.attributes.{$I}"/>
	      </xsl:when>
	      <xsl:otherwise>
		<rng:optional>
		  <rng:ref
		      name="{ancestor::elementSpec/@ident}.attributes.{$I}"/>
		</rng:optional>
	      </xsl:otherwise>
	    </xsl:choose>
	  </xsl:if>
	  </xsl:for-each>
	  <xsl:apply-templates select="*" mode="tangle"/>
      </xsl:when>
      <xsl:otherwise>
	<xsl:apply-templates select="*" mode="tangle"/>
      </xsl:otherwise>
    </xsl:choose>
    
  </xsl:template>
  
  
  
  <xsl:template match="author">
    <xsl:apply-templates/>,
  </xsl:template>
  
  
  
  <xsl:template match="classSpec" mode="processAtts">
    <xsl:if test="$verbose='true'">
      <xsl:message>    .... class attributes <xsl:value-of select="@ident"/></xsl:message>  
    </xsl:if>
    <xsl:variable name="thisClass">
      <xsl:value-of select="@ident"/>   
    </xsl:variable>
    <xsl:variable name="attclasscontent">
      <rng:x >
	<xsl:for-each select="classes/memberOf">
	  <xsl:for-each select="key('IDENTS',@key)[1]">
	    <xsl:if test="attList">
	      <xsl:if test="$verbose='true'">
		<xsl:message>          ..... add link to attributes from  class [<xsl:value-of 
		select="@ident"/>]</xsl:message>
	      </xsl:if>
	      <rng:ref name="{@ident}.attributes" />
	    </xsl:if>
	  </xsl:for-each>
	</xsl:for-each>
	<xsl:apply-templates select="attList" mode="tangle" />
      </rng:x>
    </xsl:variable>
    <xsl:call-template name="bitOut">
      <xsl:with-param name="grammar">true</xsl:with-param>
      <xsl:with-param name="content">
	<Wrapper>
	  <rng:define name="{$thisClass}.attributes" combine="choice" >
	    <xsl:for-each select="exsl:node-set($attclasscontent)/rng:x">
	      <xsl:choose>
		<xsl:when test="rng:*">
		  <xsl:copy-of select="rng:*"/>
		</xsl:when>
		<xsl:otherwise>
		  <rng:empty />
		</xsl:otherwise>
	      </xsl:choose>
	    </xsl:for-each>
	  </rng:define>
	  <xsl:call-template name="defineRelaxAttributes"/>
	</Wrapper>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>
  
  
  
  <xsl:template match="classSpec" mode="processDefaultAtts">
    <xsl:if test="$verbose='true'">
      <xsl:message>    .. default attribute settings for <xsl:value-of
      select="@ident"/></xsl:message>
    </xsl:if>
    <xsl:call-template name="bitOut">
      <xsl:with-param name="grammar">true</xsl:with-param>
      <xsl:with-param name="content">
	<Wrapper>
	  <rng:define name="{@ident}.attributes" combine="choice" >
	    <rng:empty />
	  </rng:define>
	</Wrapper>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>
  
  
  
  <xsl:template match="classSpec" mode="processModel">
    <xsl:if test="$verbose='true'">
      <xsl:message>    .... class model <xsl:value-of  select="@ident"/></xsl:message>
    </xsl:if>
    
    <xsl:variable name="thisClass">
      <xsl:value-of select="@ident"/>   
    </xsl:variable>
    <xsl:call-template name="bitOut">
      <xsl:with-param name="grammar">true</xsl:with-param>
      <xsl:with-param name="content">
	<Wrapper>
	  <rng:define name="{$thisClass}" combine="choice" >
	    <rng:notAllowed />
	  </rng:define>
	  <xsl:apply-templates select="classes/memberOf" mode="tangleModel"/>
	</Wrapper>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>
  
  
  
  <xsl:template match="classSpec" mode="tangle">
    <xsl:param name="type"/>
    <xsl:if test="$verbose='true'">
      <xsl:message>      .. process classSpec <xsl:value-of
      select="@ident"/> (type <xsl:value-of select="@type"/>)
      </xsl:message>
    </xsl:if>
    <xsl:apply-templates select="." mode="processModel"/>
    <xsl:apply-templates select="." mode="processAtts"/>
  </xsl:template>
  
  
  
  <xsl:template match="classSpec" mode="tangleadd">
    <xsl:apply-templates mode="tangleadd"/>
  </xsl:template>
  
  
  
  <xsl:template match="classSpec/@ident"/>
  
  
  <xsl:template match="classSpec/attList" mode="tangleadd">
    <xsl:for-each select="attDef[@mode='add']">
      <xsl:call-template name="defineAnAttribute">
	<xsl:with-param name="Name" select="../@ident"/>
      </xsl:call-template>
    </xsl:for-each>
  </xsl:template>
  
  
  <xsl:template match="classSpec[@mode='change']" mode="tangle">
    <xsl:if test="$verbose='true'">
      <xsl:message>      .. process (change mode) classSpec <xsl:value-of
      select="@ident"/> (type <xsl:value-of select="@type"/>)
      </xsl:message>
    </xsl:if>
    <xsl:if test="content">
      <rng:define name="{@ident}" combine="choice">
	<xsl:apply-templates select="content/*"/>
      </rng:define>
    </xsl:if>
    <xsl:if test="attList/attDef[@mode='add']">
      <rng:define name="{@ident}.attributes" combine="choice" >
	<xsl:for-each select="attList/attDef[@mode='add']">
	  <xsl:variable name="I">
	    <xsl:choose>
	      <xsl:when test="starts-with(@ident,'xml:')">
		<xsl:text>xml</xsl:text>
		<xsl:value-of select="substring-after(@ident,'xml:')"/>
	      </xsl:when>
	      <xsl:otherwise>
		<xsl:value-of select="@ident"/>
	      </xsl:otherwise>
	    </xsl:choose>
	  </xsl:variable>
	  <rng:ref name="{ancestor::classSpec/@ident}.attributes.{$I}"/>
	</xsl:for-each>
      </rng:define>
    </xsl:if>
    <xsl:call-template name="defineRelaxAttributes"/>
  </xsl:template>
  

  <xsl:template match="classSpec[@mode='replace']" mode="tangle">
    <xsl:if test="$verbose='true'">
      <xsl:message>      .. process (replace mode) classSpec <xsl:value-of
      select="@ident"/> (type <xsl:value-of select="@type"/>)
      </xsl:message>
    </xsl:if>
      <rng:define name="{@ident}.attributes">
	<xsl:for-each select="attList/attDef">
	  <xsl:variable name="I">
	    <xsl:choose>
	      <xsl:when test="starts-with(@ident,'xml:')">
		<xsl:text>xml</xsl:text>
		<xsl:value-of select="substring-after(@ident,'xml:')"/>
	      </xsl:when>
	      <xsl:otherwise>
		<xsl:value-of select="@ident"/>
	      </xsl:otherwise>
	    </xsl:choose>
	  </xsl:variable>
	  <rng:ref name="{ancestor::classSpec/@ident}.attributes.{$I}"/>
	</xsl:for-each>
      </rng:define>
    <xsl:call-template name="defineRelaxAttributes"/>
  </xsl:template>
  

  <xsl:template match="classSpec|elementSpec|macroSpec"
		mode="weave">     
    <xsl:call-template name="refdoc"/>
  </xsl:template>
  
  
  <xsl:template match="code">
    <xsl:call-template name="typewriter">
      <xsl:with-param name="text">
	<xsl:apply-templates/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>
  
  
  
  <xsl:template match="desc" mode="show">
    <xsl:apply-templates select="preceding-sibling::gloss"
			 mode="show"/>
    <xsl:apply-templates/>
  </xsl:template>
  
  
  
  <xsl:template match="desc"/>
  
 <xsl:template match="desc" mode="tangle"/>
  
  <xsl:template match="divGen[@type='classcat']">
    <xsl:apply-templates select="key('CLASSDOCS',1)" mode="weave">
      <xsl:sort select="@ident"/>
    </xsl:apply-templates>
  </xsl:template>
  
  
  
  <xsl:template match="divGen[@type='macrocat']">
    <xsl:apply-templates select="key('MACRODOCS',1)"  mode="weave">
      <xsl:sort select="@ident"/>
    </xsl:apply-templates>
  </xsl:template>
  
  
  
  <xsl:template match="divGen[@type='tagcat']">
    <xsl:apply-templates select="key('TAGDOCS',1)"  mode="weave">
      <xsl:sort select="@ident"/>
    </xsl:apply-templates>
  </xsl:template>
  
  
  
  <xsl:template match="editor">
    <xsl:apply-templates/>:
  </xsl:template>
  
  
  
  <xsl:template match="elementSpec[@mode='delete']" mode="tangle">
    <rng:define name="{@ident}">
      <rng:notAllowed />
    </rng:define>
  </xsl:template>
  
  <xsl:template match="elementSpec" mode="tangle">
    <xsl:if test="$verbose='true'">
      <xsl:message> elementSpec <xsl:value-of
      select="@ident"/>
      <xsl:if test="@id">: <xsl:value-of select="@id"/></xsl:if>
      <xsl:if test="@mode"> (mode <xsl:value-of select="@mode"/>)</xsl:if>
      </xsl:message>
    </xsl:if>
    <xsl:call-template name="bitOut">
      <xsl:with-param name="grammar"></xsl:with-param>
      <xsl:with-param name="content">
	<Wrapper>
	  <xsl:variable name="name">
	    <xsl:choose>
	      <xsl:when test="altIdent">
		<xsl:value-of select="normalize-space(altIdent)"/>
	      </xsl:when>
	      <xsl:otherwise>
		<xsl:value-of select="@ident"/>
	      </xsl:otherwise>
	    </xsl:choose>
	  </xsl:variable>
	  <xsl:choose>
	    <xsl:when test="content/rng:notAllowed">
	      <rng:define name="{@ident}" >
		<rng:notAllowed />
	      </rng:define>
	    </xsl:when>
	    <xsl:otherwise>
	      <rng:define  name="{@ident}" >
		<rng:element  name="{$name}" >
		  <xsl:if test="@ns">
		    <xsl:attribute name="ns"><xsl:value-of select="@ns"/></xsl:attribute>
		  </xsl:if>
		    <a:documentation>
		      <xsl:value-of select="desc"/>
		    </a:documentation>
		  <rng:ref name="{@ident}.content" />
		  <rng:ref name="{@ident}.attributes" />
		</rng:element>
	      </rng:define>
	      
	      <xsl:if test="content or not(@mode='change')">
		<xsl:call-template name="defineContent"/>
	      </xsl:if>
<!-- we do not make a defintion for the attributes pattern if we are
in change mode and there is no attList -->	      
	      <xsl:choose>
		<xsl:when test="@mode='change' and not(attList)">
		</xsl:when>
		<xsl:otherwise>
		  <xsl:call-template name="doDefineAttributePattern"/>
		</xsl:otherwise>
	      </xsl:choose>

	      <xsl:if test="not(@mode='change')">
		<xsl:call-template name="defineRelaxAttributes"/>
	      </xsl:if>
	      
	      <xsl:apply-templates select="classes/memberOf" mode="tangleModel"/>
	      
	    </xsl:otherwise>
	  </xsl:choose>      
	</Wrapper>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>
  
  <xsl:template name="doDefineAttributePattern">
    <rng:define name="{@ident}.attributes" >
      <xsl:choose>
	<xsl:when test="ancestor::schemaSpec and not(ancestor::schemaSpec/moduleRef/@key='tei')"/>
<!--
	<xsl:when test="@ident='egXML'">
	  <rng:ref name="tei.global.attributes" />
	</xsl:when>
-->
	<xsl:when test="@ns and
			not(contains(@ns,'http://www.tei-c.org/ns/1.0'))"/>
	<xsl:otherwise>
	  <rng:ref name="tei.global.attributes" />
	</xsl:otherwise>
      </xsl:choose>
      
      <xsl:if test="attList//attDef or not(@mode='change')">
	<xsl:choose>
	  <xsl:when test="classes or not(@mode='change')">
	    <xsl:apply-templates
		select="classes/memberOf"
		mode="processClassAtts">
	      <xsl:with-param name="homeIdent" select="@ident"/>
	    </xsl:apply-templates>
	  </xsl:when>
	  <xsl:otherwise>
	    <xsl:variable name="loc">
	      <xsl:value-of select="$TEISERVER"/>
	      <xsl:text>copytag.xq?name=</xsl:text>
	      <xsl:value-of select="@ident"/>
	    </xsl:variable>
	    <xsl:if test="$verbose">
	      <xsl:message>Accessing TEISERVER: <xsl:value-of
	      select="$loc"/></xsl:message>
	    </xsl:if>
	    
	    <xsl:variable name="homeIdent" select="@ident"/>
	    <xsl:for-each select="document($loc)/TEI.2/*">
	      <xsl:apply-templates
		  select=".//classes/memberOf"
		  mode="processClassAtts">
		<xsl:with-param name="homeIdent" select="$homeIdent"/>
	      </xsl:apply-templates>
	    </xsl:for-each>
	  </xsl:otherwise>
	</xsl:choose>
	<xsl:apply-templates select="attList" mode="tangle"/>
	<xsl:if test="not(@ns) or contains(@ns,'http://www.tei-c.org')">
	  <rng:optional >
	    <rng:attribute name="TEIform" a:defaultValue="{@ident}" >
	      <rng:text />
	    </rng:attribute>
	  </rng:optional>
	</xsl:if>
	<xsl:if test="@mode='change'">
	  <xsl:call-template name="makeRelaxAttributes"/>
	</xsl:if>
      </xsl:if>
      <!-- place holder to make sure something gets into the
	   pattern -->
      <rng:empty/>
      
    </rng:define>
  </xsl:template>

  <xsl:template name="defineContent">
    <rng:define name="{@ident}.content" >
      <xsl:choose>
	<xsl:when test="valList[@type='closed']">
	  <rng:choice >
	    <xsl:choose>
	      <!-- what to do when a new item is being added to a valList -->
	      <xsl:when test="ancestor::elementSpec/@mode='change'">
		<xsl:for-each select="valList/valItem">
		  <rng:value ><xsl:value-of select="@ident"/></rng:value>
		  <a:documentation><xsl:value-of select="gloss"/></a:documentation>
		</xsl:for-each>
	      </xsl:when>
	      <xsl:otherwise>
		<xsl:for-each select="valList/valItem">  
		  <rng:value ><xsl:value-of select="@ident"/></rng:value>
		  <a:documentation><xsl:value-of select="gloss"/></a:documentation>
		</xsl:for-each>
	      </xsl:otherwise>
	    </xsl:choose>
	  </rng:choice>
	</xsl:when>
	<xsl:when test="content">
	  <xsl:apply-templates select="content/*"/>
	</xsl:when>
	<xsl:otherwise>
	  <rng:empty />
	</xsl:otherwise>
      </xsl:choose>
    </rng:define>
  </xsl:template>
  
  <xsl:template match="memberOf" mode="processClassAtts">
    <xsl:param name="homeIdent"/>
    <xsl:choose>
      <xsl:when  test="key('IDENTS',@key)">
	<xsl:for-each select="key('IDENTS',@key)[1]">
	  <xsl:apply-templates  select="." mode="processClassAtts">
	    <xsl:with-param name="homeIdent"  select="$homeIdent"/>
	  </xsl:apply-templates>
	</xsl:for-each>
      </xsl:when>
      <xsl:otherwise>
	<xsl:if test="$verbose='true'">
	  <xsl:message>looking at class atts for <xsl:value-of
	  select="@key"/></xsl:message>
	</xsl:if>
	<xsl:variable name="loc">
	  <xsl:value-of select="$TEISERVER"/>
	  <xsl:text>copytag.xq?name=</xsl:text>
	  <xsl:value-of select="@key"/>
	</xsl:variable>
	<xsl:if test="$verbose">
	  <xsl:message>Accessing TEISERVER: <xsl:value-of
	  select="$loc"/></xsl:message>
	</xsl:if>
	
	<xsl:apply-templates select="document($loc)/TEI.2/classSpec" mode="processClassAtts">
	  <xsl:with-param name="homeIdent"  select="$homeIdent"/>
	</xsl:apply-templates>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template match="classSpec" mode="processClassAtts">
    <xsl:param name="homeIdent"/>
    <xsl:choose>
      <xsl:when test=".//attDef[@ident=$homeIdent]">
	<xsl:if test="$verbose='true'">
	  <xsl:message>copy of attributes from <xsl:value-of
	  select="@ident"/> because of <xsl:value-of
	  select="$homeIdent"/></xsl:message>
	</xsl:if>
	<xsl:for-each select=".//attList">
	  <xsl:choose>
	    <xsl:when test="@org='choice'">
	      <rng:optional >
		<rng:choice >
		  <xsl:for-each select="./attDef">
		    <xsl:if test="not(@ident='xmlns') and not(@ident=$homeIdent)">
		      <xsl:call-template name="makeAnAttribute"/>
		    </xsl:if>
		  </xsl:for-each>
		</rng:choice>
	      </rng:optional>
	    </xsl:when>
	    <xsl:otherwise>
	      <xsl:for-each select="./attDef">
		<xsl:if test="not(@ident='xmlns')  and not(@ident=$homeIdent)">
		  <xsl:call-template name="makeAnAttribute"/>
		</xsl:if>
	      </xsl:for-each>
	    </xsl:otherwise>
	  </xsl:choose>
	</xsl:for-each>
      </xsl:when>
      <xsl:otherwise>
	<xsl:if test=".//attList">
	  <rng:ref name="{@ident}.attributes" />
	</xsl:if>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  
  
  <xsl:template match="elementSpec" mode="tangleadd"/>
  
  
  <xsl:template match="elementSpec/@ident"/>
  
  <xsl:template match="gloss" mode="show">
    <xsl:if test="text()">
      (<xsl:apply-templates/>)
    </xsl:if>
  </xsl:template>
  
  
  
  
  <xsl:template match="gloss"/>
  
  
  
  <xsl:template match="index">
    <xsl:call-template name="makeAnchor">
      <xsl:with-param name="name">IDX-<xsl:number level="any"/></xsl:with-param>
    </xsl:call-template>
  </xsl:template>
  
  
  
  <xsl:template match="macroSpec" mode="tangle">
    <xsl:param name="msection"/>
    <xsl:param name="filename"/>
    <xsl:choose>
      <xsl:when test="generate-id()=generate-id(key('PATTERNS',@ident)[last()])">
	<xsl:variable name="entCont">
	  <BLAH>
	    <xsl:choose>
	      <xsl:when test="not($msection='') and content/rng:group">
		<rng:choice >
		  <xsl:apply-templates select="content/rng:group/rng:*"/>	     
		</rng:choice>
	      </xsl:when>
	      <xsl:otherwise>
		<xsl:apply-templates select="content/rng:*"/>
	      </xsl:otherwise>
	    </xsl:choose>
	  </BLAH>
	</xsl:variable>
	<xsl:variable name="entCount">
	  <xsl:for-each select="exsl:node-set($entCont)/BLAH">
	  <xsl:value-of select="count(rng:*)"/>
	</xsl:for-each>
      </xsl:variable>
      <xsl:choose>
	<xsl:when test='@ident="TEI.singleBase"'/>
	<xsl:when test='starts-with($entCont,"&#39;")'>
	  <xsl:if test="$verbose='true'">
	    <xsl:message>Omit <xsl:value-of select="$entCont"/> for
	    <xsl:value-of select="@ident"/></xsl:message>
	  </xsl:if>
	</xsl:when>
	<xsl:when test='starts-with($entCont,"-")'>
	  <xsl:if test="$verbose='true'">
	    <xsl:message>Omit <xsl:value-of select="$entCont"/> for
	    <xsl:value-of select="@ident"/></xsl:message>
	  </xsl:if>
	</xsl:when>
	<xsl:otherwise>
	  <xsl:if test="$verbose='true'">
	    <xsl:message>         ... so define ..<xsl:value-of
	    select="@ident"/></xsl:message>
	  </xsl:if>
	  <xsl:call-template name="bitOut">
	    <xsl:with-param name="grammar">true</xsl:with-param>
	    <xsl:with-param name="content">
	      <Wrapper>
		<rng:define name="{@ident}" >
		  <xsl:if test="starts-with(@ident,'macro.component')
				or @combine='true'">
		    <xsl:attribute name="combine">choice</xsl:attribute>
		  </xsl:if>
		  <xsl:choose>
		    <xsl:when test="starts-with(@ident,'type')">
		      <xsl:copy-of select="exsl:node-set($entCont)/BLAH/rng:*"/>
		    </xsl:when>
		    <xsl:when test="$entCount=0">
		      <rng:notAllowed />
		    </xsl:when>
		    <xsl:when test="$entCount=1">
		      <xsl:copy-of select="exsl:node-set($entCont)/BLAH/rng:*"/>
		    </xsl:when>
		    <xsl:when test="content/rng:text|content/rng:ref">
		      <rng:choice >
			<xsl:copy-of select="exsl:node-set($entCont)/BLAH/rng:*"/>
		      </rng:choice>
		    </xsl:when>
		    <xsl:otherwise>
		      <xsl:copy-of select="exsl:node-set($entCont)/BLAH/rng:*"/>
		    </xsl:otherwise>
		  </xsl:choose>
		</rng:define>
	      </Wrapper>
	    </xsl:with-param>
	  </xsl:call-template>
	</xsl:otherwise>
      </xsl:choose>
    </xsl:when>
    <xsl:otherwise>
      <xsl:if test="$verbose='true'">
	<xsl:message>ZAP pattern <xsl:value-of
	select="@ident"/></xsl:message>
      </xsl:if>
    </xsl:otherwise>
  </xsl:choose>
  
</xsl:template>




<xsl:template match="macroSpec/@ident"/>



<xsl:template match="macroSpec/content/rng:*"/>



<xsl:template match="memberOf" mode="tangleAtts">
  <xsl:variable name="ident">
    <xsl:value-of select="ancestor::elementSpec/@ident|ancestor::classSpec/@ident"/>
  </xsl:variable>
  <xsl:choose>
    <xsl:when  test="key('IDENTS',@key)">
      <xsl:for-each select="key('IDENTS',@key)[1]">
	<xsl:apply-templates  select="." mode="tagatts"/>
      </xsl:for-each>
    </xsl:when>
    <xsl:otherwise>
      <xsl:variable name="loc">
	<xsl:value-of select="$TEISERVER"/>
	<xsl:text>copytag.xq?name=</xsl:text>
	<xsl:value-of select="@key"/>
      </xsl:variable>
      <xsl:if test="$verbose">
	<xsl:message>Accessing TEISERVER: <xsl:value-of
	select="$loc"/></xsl:message>
      </xsl:if>
      
      <xsl:apply-templates select="document($loc)/TEI.2/*" mode="tagatts"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>


<xsl:template match="memberOf" mode="tangleModel">
  <xsl:variable name="ident">
    <xsl:value-of select="ancestor::elementSpec/@ident|ancestor::classSpec/@ident"/>
  </xsl:variable>
  <xsl:choose>
    <xsl:when  test="key('IDENTS',@key)">
      <xsl:for-each select="key('IDENTS',@key)[1]">
	<xsl:if test="$verbose='true'">
	  <xsl:message>      .... added [<xsl:value-of 
	  select="$ident"/>] to  class [<xsl:value-of select="@ident"/>]</xsl:message>
	</xsl:if>
	<rng:define name="{@ident}" combine="choice" >
	  <rng:ref name="{$ident}" />
	</rng:define>
      </xsl:for-each>
    </xsl:when>
    <xsl:otherwise>
      <xsl:if test="$verbose='true'">
	<xsl:message>      .... added (without lookup) [<xsl:value-of
	select="$ident"/>] to class [<xsl:value-of
	select="@key"/>]</xsl:message>
      </xsl:if>
      <rng:define name="{@key}" combine="choice" >
	<rng:ref name="{$ident}" />
      </rng:define>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>



<xsl:template match="mentioned">
  <xsl:text>&#8216;</xsl:text>
  <xsl:apply-templates/>
  <xsl:text>&#8217;</xsl:text>
</xsl:template>


<xsl:template match="moduleRef" mode="tangle" >
  <xsl:variable name="This" select="@key"/>
  <xsl:if test="$verbose='true'">
    <xsl:message>      .... import module [<xsl:value-of
    select="$This"/>] <xsl:value-of select="@url"/>] </xsl:message>
  </xsl:if>
  <xsl:call-template name="bitOut">
    <xsl:with-param name="grammar">true</xsl:with-param>
    <xsl:with-param name="content">
      <Wrapper>
	<xsl:choose>
	  <xsl:when test="@url">
	    <rng:include href="{@url}" />
	  </xsl:when>
	  <xsl:otherwise>
	    <rng:include href="{$schemaBaseURL}{$This}.rng" >
	      <xsl:attribute name="ns">
		<xsl:choose>
		  <xsl:when test="ancestor::schemaSpec/@namespace">
		    <xsl:value-of select="ancestor::schemaSpec/@namespace"/>
		  </xsl:when>
		  <xsl:otherwise>http://www.tei-c.org/ns/1.0</xsl:otherwise>
		</xsl:choose>
	      </xsl:attribute>
	      <xsl:for-each  select="../*[@module=$This and not(@mode='add')]">
		<xsl:apply-templates mode="tangle" select="."/>
	      </xsl:for-each>
	    </rng:include>
	    <xsl:for-each  select="../*[@module=$This and not(@mode='add')]//attDef[@mode='add']">
	      <xsl:call-template name="defineAnAttribute">
		<xsl:with-param name="Name" select="../../@ident"/>
	      </xsl:call-template>
	    </xsl:for-each>
	  </xsl:otherwise>
	</xsl:choose>
      </Wrapper>
    </xsl:with-param>
  </xsl:call-template>
</xsl:template>



<xsl:template match="moduleSpec[@mode='replace']" mode="tangle" >
  <xsl:call-template name="bitOut">
    <xsl:with-param name="grammar">true</xsl:with-param>
    <xsl:with-param name="content">
      <Wrapper>
	<xsl:apply-templates mode="tangle"/>
      </Wrapper>
    </xsl:with-param>
  </xsl:call-template>
</xsl:template>



<xsl:template match="p/@ident">
  <xsl:call-template name="makeAnchor">
    <xsl:with-param name="name">GDX-<xsl:number level="any"/></xsl:with-param>
  </xsl:call-template>
  <xsl:call-template name="ttembolden">
    <xsl:with-param name="text">
      <xsl:apply-templates/>
    </xsl:with-param>
  </xsl:call-template>
</xsl:template>

<xsl:template match="remarks" mode="tangle"/>

<xsl:template match="specGrp" mode="ok">
  <xsl:param name="filename"/>
  <xsl:call-template name="processSchemaFragment">
    <xsl:with-param name="filename" select="$filename"/>
  </xsl:call-template>
</xsl:template>



<xsl:template match="tag">
  <xsl:call-template name="typewriter">
    <xsl:with-param name="text">
      <xsl:text>&lt;</xsl:text>
      <xsl:apply-templates/>
      <xsl:text>&gt;</xsl:text>
    </xsl:with-param>
  </xsl:call-template>
</xsl:template>




<xsl:template match="title">
  <xsl:choose>
    <xsl:when test="parent::titleStmt">
      <xsl:if test="preceding-sibling::title"><br/></xsl:if>
      <xsl:apply-templates/>
    </xsl:when>
    <xsl:when test="@level='A'">
      &#8216;<xsl:apply-templates/>'
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="italicize">
	<xsl:with-param name="text">
	  <xsl:apply-templates/>
	</xsl:with-param>
      </xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>


<xsl:template match="comment()" mode="verbatim">
  <xsl:text>&#10;&lt;!--</xsl:text>
  <xsl:value-of select="."/>
  <xsl:text>--&gt;&#10;</xsl:text>
</xsl:template>

<xsl:template name="wraptext">
  <xsl:param name="indent"/>
  <xsl:param name="text"/>
  <xsl:choose>
    <xsl:when test="contains($text,'&#10;')">
      <xsl:value-of select="substring-before($text,'&#10;')"/>
      <xsl:text>&#10;</xsl:text>
      <xsl:value-of select="$indent"/>
      <xsl:call-template name="wraptext">
	<xsl:with-param name="indent">
	  <xsl:value-of select="$indent"/>
	</xsl:with-param>
	<xsl:with-param name="text">
	  <xsl:value-of select="substring-after($text,'&#10;')"/>
	</xsl:with-param>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$text"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="text()" mode="verbatim">
  <xsl:call-template name="wraptext">
    <xsl:with-param name="indent">
      <xsl:for-each select="ancestor::teix:*|ancestor::rng:*">
	<xsl:text> </xsl:text>
      </xsl:for-each>
    </xsl:with-param>
    <xsl:with-param name="text">
      <xsl:value-of select="."/>
    </xsl:with-param>
  </xsl:call-template>
</xsl:template>


<xsl:template match="teix:*|rng:*|*" mode="verbatim">
  <xsl:choose>
    <xsl:when test="preceding-sibling::node()[1]/self::*">
      <xsl:text>&#10;</xsl:text>
      <xsl:for-each select="ancestor::teix:*|ancestor::rng:*">
	<xsl:text> </xsl:text>
      </xsl:for-each>
    </xsl:when>
    <xsl:when test="not(preceding-sibling::node())">
      <xsl:text>&#10;</xsl:text>
      <xsl:for-each select="ancestor::teix:*|ancestor::rng:*">
	<xsl:text> </xsl:text>
      </xsl:for-each>
    </xsl:when>
  </xsl:choose>
  <xsl:text>&lt;</xsl:text>
  <xsl:value-of select="local-name(.)"/>
  <xsl:for-each select="@*">
    <xsl:text> </xsl:text>
  <xsl:value-of select="local-name(.)"/>="<xsl:value-of select="."/>"</xsl:for-each>
  <xsl:choose>
    <xsl:when test="child::node()">
      <xsl:text>&gt;</xsl:text>
      <xsl:apply-templates mode="verbatim"/>
      <xsl:choose>
	<xsl:when
	    test="child::node()[last()]/self::text()[normalize-space(.)='']"> 
	  <xsl:text>&#10;</xsl:text>
	  <xsl:for-each select="ancestor::teix:*|ancestor::rng:*">
	    <xsl:text> </xsl:text>
	  </xsl:for-each>
	</xsl:when>
	<xsl:when
	    test="child::node()[last()]/self::comment()"> 
	  <xsl:text>&#10;</xsl:text>
	  <xsl:for-each select="ancestor::teix:*|ancestor::rng:*">
	    <xsl:text> </xsl:text>
	  </xsl:for-each>
	</xsl:when>
	<xsl:when
	    test="child::node()[last()]/self::*"> 
	  <xsl:text>&#10;</xsl:text>
	  <xsl:for-each select="ancestor::teix:*|ancestor::rng:*">
	    <xsl:text> </xsl:text>
	  </xsl:for-each>
	</xsl:when>
      </xsl:choose>
      <xsl:text>&lt;/</xsl:text>
      <xsl:value-of select="local-name(.)"/>
      <xsl:text>&gt;</xsl:text>
    </xsl:when>    
    <xsl:otherwise>
      <xsl:text>/&gt;</xsl:text>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="token" mode="commentline">
  <xsl:call-template name="italicize">
    <xsl:with-param name="text">
      <xsl:value-of select="translate(.,'&#10;','')"/>
    </xsl:with-param>
  </xsl:call-template>
  <xsl:if test="following-sibling::token">
    <xsl:text>
    </xsl:text>
    <xsl:choose>
      <xsl:when test="contains(.,'--&gt;')">
	<xsl:apply-templates select="following-sibling::token[1]" 
			     mode="normalline"/>  
      </xsl:when>
      <xsl:otherwise>
	<xsl:apply-templates select="following-sibling::token[1]" mode="commentline"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:if>
</xsl:template>



<xsl:template match="token" mode="normalline">
  <xsl:choose>
    <xsl:when test="contains(.,'&lt;!--')">
      <xsl:call-template name="italicize">
	<xsl:with-param name="text">
	  <xsl:value-of select="translate(.,'&#10;','')"/>
	</xsl:with-param>
      </xsl:call-template>
      <xsl:if test="following-sibling::token">
	<xsl:text>
	</xsl:text>
	<xsl:choose>
	  <xsl:when test="contains(.,'--&gt;')">
	    <xsl:apply-templates select="following-sibling::token[1]" 
				 mode="normalline"/>  
	  </xsl:when>
	  <xsl:otherwise>
	    <xsl:apply-templates select="following-sibling::token[1]" mode="commentline"/>
	  </xsl:otherwise>
	</xsl:choose>
      </xsl:if>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="breakline"/>  
      <xsl:if test="following-sibling::token">
	<xsl:text>
	</xsl:text>
	<xsl:apply-templates select="following-sibling::token[1]" 
			     mode="normalline"/>
      </xsl:if>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>



<xsl:template match="token" mode="verbatimline">
  <xsl:call-template name="breakline"/>  
  <xsl:if test="following-sibling::token">
    <xsl:text>
    </xsl:text>
    <xsl:apply-templates select="following-sibling::token[1]" 
			 mode="verbatimline"/>
  </xsl:if>
</xsl:template>



<xsl:template match="token" mode="word">
  <xsl:param name="len"/>
  <xsl:choose>
    <xsl:when test="$len +string-length(.) &gt; $wrapLength">
      <xsl:text>
      </xsl:text>
      <xsl:value-of select="."/><xsl:text> </xsl:text>
      <xsl:if test="following-sibling::token">
	<xsl:apply-templates select="following-sibling::token[1]" mode="word">
	  <xsl:with-param name="len" select="8"/>
	</xsl:apply-templates>
      </xsl:if>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="."/><xsl:text> </xsl:text>
      <xsl:if test="following-sibling::token">
	<xsl:apply-templates select="following-sibling::token[1]" mode="word">
	  <xsl:with-param name="len" select="$len + string-length(.)"/>
	</xsl:apply-templates>
      </xsl:if>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>




<xsl:template name="attributeBody">		
  <xsl:variable name="name">
    <xsl:choose>
      <xsl:when test="altIdent">
	<xsl:value-of select="normalize-space(altIdent)"/>
      </xsl:when>
      <xsl:otherwise>
	    <xsl:value-of select="@ident"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <rng:attribute name="{$name}" >
    <xsl:if test="defaultVal">
      <xsl:attribute name="a:defaultValue">
	<xsl:value-of select="normalize-space(defaultVal)"/>
      </xsl:attribute>
    </xsl:if>
    <xsl:variable name="I">
      <xsl:choose>
	<xsl:when test="starts-with(@ident,'xml:')">
	  <xsl:text>xml</xsl:text>
	  <xsl:value-of select="substring-after(@ident,'xml:')"/>
	</xsl:when>
	<xsl:otherwise>
	  <xsl:value-of select="@ident"/>
	</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
      <a:documentation>
	<xsl:value-of select="desc"/>
      </a:documentation>
    <rng:ref
	name="{ancestor::attList/../@ident}.attributes.{$I}.content" />
  </rng:attribute>
</xsl:template>



<xsl:template name="breakline">
  <xsl:choose>
    <xsl:when test="string-length(.)&lt;$wrapLength">
      <xsl:value-of select="."/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:variable name="words" select="estr:tokenize(.)"/>
      <xsl:apply-templates select="$words[1]" mode="word">
	<xsl:with-param name="len" select="0"/>
      </xsl:apply-templates>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>



<xsl:template name="compositeNumber">
  <xsl:for-each select="ancestor::div1|ancestor::body/div">
    <xsl:number level="any"/>
    <xsl:text>.</xsl:text>
  </xsl:for-each>
  <xsl:number level="any" from="div1"/>
</xsl:template>

<xsl:template name="copyright">
  <xsl:apply-templates 
      select="/TEI.2/teiHeader/fileDesc/publicationStmt/availability"/>
</xsl:template>

<xsl:template name="defineAnAttribute">
  <xsl:param name="Name"/>
    <xsl:variable name="I">
      <xsl:choose>
	<xsl:when test="starts-with(@ident,'xml:')">
	  <xsl:text>xml</xsl:text>
	  <xsl:value-of select="substring-after(@ident,'xml:')"/>
	</xsl:when>
	<xsl:otherwise>
	  <xsl:value-of select="@ident"/>
	</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <rng:define name="{$Name}.attributes.{$I}" >
      <xsl:choose>
	<xsl:when test="@mode='delete'">
	  <rng:notAllowed />
	</xsl:when>
	<xsl:otherwise>
	  <xsl:choose>
	    <xsl:when test="@usage='req'">
	      <xsl:call-template name="attributeBody"/>
	    </xsl:when>
	    <xsl:when test="parent::attList[@org='choice']">
	      <xsl:call-template name="attributeBody"/>
	    </xsl:when>
	    <xsl:otherwise>
	      <rng:optional >
		<xsl:call-template name="attributeBody"/>
	      </rng:optional>
	    </xsl:otherwise>
	  </xsl:choose>
	</xsl:otherwise>
      </xsl:choose>	
    </rng:define>
    
    <xsl:choose>
      <xsl:when test="@mode='delete'"/>
      <xsl:when test="@mode='change' and not(datatype or valList)"/>
      <xsl:otherwise>
	<rng:define name="{$Name}.attributes.{$I}.content" >
	  <xsl:call-template name="attributeDatatype"/>
	</rng:define>
      </xsl:otherwise>
    </xsl:choose>
</xsl:template>

<xsl:template name="attributeDatatype">
  <xsl:variable name="this" select="@ident"/>
  <xsl:choose>
    <xsl:when test="datatype[rng:ref/@name='datatype.Code']">
      <xsl:choose>
	<xsl:when test="valList[@type='closed']">
	  <rng:choice >
	    <xsl:for-each select="valList/valItem">
	      <rng:value ><xsl:value-of select="@ident"/></rng:value>
              <a:documentation><xsl:value-of select="gloss"/></a:documentation>
	    </xsl:for-each>
	    <xsl:if test="@mode='add' and
			  ancestor::attList/../@mode='change'">
	      <xsl:variable name="loc">
		<xsl:value-of select="$TEISERVER"/>
		<xsl:text>copytag.xq?name=</xsl:text>
		<xsl:value-of select="ancestor::attList/../@ident"/>
	      </xsl:variable>
	      <xsl:if test="$verbose">
		<xsl:message>Accessing TEISERVER: <xsl:value-of
		select="$loc"/></xsl:message>
	      </xsl:if>
	      
	      <xsl:for-each select="document($loc)/TEI.2/*">
		<xsl:for-each
		    select=".//attList/attDef[@ident=$this]/valList/valItem">
		  <rng:value ><xsl:value-of  select="@ident"/></rng:value>
		  <a:documentation><xsl:value-of select="gloss"/></a:documentation>
		</xsl:for-each>
	      </xsl:for-each>
	    </xsl:if>
	  </rng:choice>
	</xsl:when>
	<xsl:otherwise>
	  <rng:text />
	</xsl:otherwise>
      </xsl:choose>
    </xsl:when>
    <xsl:when test="datatype/rng:*">
      <xsl:copy-of select="datatype/rng:*"/>
    </xsl:when>
    <xsl:when test="valList[@type='closed']">
      <rng:choice >
	<xsl:for-each select="valList/valItem">
	  <rng:value ><xsl:value-of select="@ident"/></rng:value>
	  <a:documentation><xsl:value-of select="gloss"/></a:documentation>
	</xsl:for-each>
      </rng:choice>
    </xsl:when>
    <xsl:otherwise>
      <rng:text />
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="makeSimpleAttribute">
  <xsl:variable name="name">
    <xsl:choose>
      <xsl:when test="altIdent">
	<xsl:value-of select="normalize-space(altIdent)"/>
      </xsl:when>
      <xsl:otherwise>
	<xsl:choose>
	  <xsl:when test="starts-with(@ident,'xml:')">
	    <xsl:text>xml</xsl:text>
	    <xsl:value-of select="substring-after(@ident,'xml:')"/>
	  </xsl:when>
	  <xsl:otherwise>
	    <xsl:value-of select="@ident"/>
	  </xsl:otherwise>
	</xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  
  <rng:attribute name="{$name}" >
    <xsl:if test="defaultVal">
      <xsl:attribute name="a:defaultValue">
	<xsl:value-of select="normalize-space(defaultVal)"/>
      </xsl:attribute>
    </xsl:if>
    <a:documentation>
	<xsl:value-of select="desc"/>
    </a:documentation>
    <xsl:call-template name="attributeDatatype"/>
  </rng:attribute>
</xsl:template>

<xsl:template name="makeAnAttribute">
  <xsl:choose>
    <xsl:when test="@usage='req'">
      <xsl:call-template name="makeSimpleAttribute"/>
    </xsl:when>
    <xsl:when test="parent::attList[@org='choice']">
      <xsl:call-template name="makeSimpleAttribute"/>
    </xsl:when>
    <xsl:otherwise>
      <rng:optional >
	<xsl:call-template name="makeSimpleAttribute"/>
      </rng:optional>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>


<xsl:template name="defineRelaxAttributes">
  <xsl:variable name="name" select="@ident"/>
  <xsl:for-each select="attList//attDef">
    <xsl:choose>
      <xsl:when test="@ident='xmlns'"/>
      <xsl:when test="@mode='add' and ../../@mode='replace'">
      </xsl:when>
      <xsl:when test="@mode='add' and ../../@mode='change'">
      </xsl:when>
      <xsl:otherwise>

	<xsl:call-template name="defineAnAttribute">
	  <xsl:with-param name="Name" select="$name"/>
	</xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:for-each>
</xsl:template>

<xsl:template name="makeRelaxAttributes">
  <xsl:variable name="name" select="@ident"/>
  <xsl:for-each select="attList//attDef[not(@mode='delete')]">
    <xsl:if test="not(@ident='xmlns')">
      <!--      
	   <xsl:call-template name="makeAnAttribute"/>
      -->
      <rng:ref name="{$name}.attributes.{@ident}"/>
    </xsl:if>
  </xsl:for-each>
</xsl:template>




<xsl:template name="generateClassParents">
  <xsl:choose>
    <xsl:when test="not(classes)"> (none)   </xsl:when>
    <xsl:otherwise>
      <xsl:for-each select="classes/memberOf">
	<xsl:choose>
	  <xsl:when test="key('IDENTS',@key)">
	    <xsl:for-each select="key('IDENTS',@key)">
	      <xsl:text>: </xsl:text>
	      <xsl:call-template name="makeLink">
		<xsl:with-param name="class">classlink</xsl:with-param>
		<xsl:with-param name="id"><xsl:value-of	select="@id"/></xsl:with-param>
		<xsl:with-param name="name"><xsl:value-of select="@ident"/></xsl:with-param>
		<xsl:with-param name="text">
		  <xsl:value-of select="@ident"/>
		</xsl:with-param>
	      </xsl:call-template>
	    </xsl:for-each>
	  </xsl:when>
	  <xsl:otherwise>
	    <xsl:text>: </xsl:text>
	    <xsl:value-of select="@key"/>
	  </xsl:otherwise>
	</xsl:choose>
      </xsl:for-each>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>



<xsl:template name="generateMembers">
  <xsl:variable name="this" select="@ident"/>
  <xsl:choose>
    <xsl:when test="key('CLASSMEMBERS',$this)">
      <xsl:for-each select="key('CLASSMEMBERS',$this)">
        <xsl:text>: </xsl:text>
	<xsl:call-template name="linkTogether">
	  <xsl:with-param name="name" select="@ident"/>
	  <xsl:with-param name="url" select="@id"/>
	</xsl:call-template>
	<xsl:if test="count(key('CLASSMEMBERS',@ident))&gt;0">
	  <xsl:text>  [</xsl:text>
	  <xsl:variable name="Key" select="@ident"/>
	  <xsl:for-each select="key('CLASSMEMBERS',@ident)">
	      <xsl:text>: </xsl:text>
	      <xsl:call-template name="showElement">
		<xsl:with-param name="name" select="@ident"/>
		<xsl:with-param name="id" select="@id"/>
	      </xsl:call-template>
	  </xsl:for-each>
	    <xsl:text>] </xsl:text>
	</xsl:if>
      </xsl:for-each>
    </xsl:when>
    <xsl:otherwise>
      <xsl:variable name="address">
	<xsl:value-of select="$TEISERVER"/>
	<xsl:text>classmembers.xq?class=</xsl:text>
	<xsl:value-of select="@ident"/>
      </xsl:variable>
      <xsl:if test="$verbose">
	<xsl:message>Accessing TEISERVER: <xsl:value-of
	select="$address"/></xsl:message>
      </xsl:if>
      <xsl:for-each
	  select="document($address)/list/item">
	<xsl:call-template name="showElement">
	  <xsl:with-param name="name" select="."/>
	  <xsl:with-param name="id"/>
	  </xsl:call-template>
	  <xsl:if test="following::item">
	    <xsl:text>: &#10;</xsl:text>
	  </xsl:if>
      </xsl:for-each>
    </xsl:otherwise>
  </xsl:choose>
  
</xsl:template>

<xsl:template name="showElement">
  <xsl:param name="id"/>
  <xsl:param name="name"/>
  <xsl:choose>
    <xsl:when test="$oddmode='tei'">
      <ref target="#{$name}"><xsl:value-of select="$name"/></ref>
    </xsl:when>
    <xsl:when test="$oddmode='html'">
      <xsl:choose>
	<xsl:when test="not($id='')">
	  <a class="link_element" href="ref-{$id}.html">
	    <xsl:value-of select="$name"/>
	  </a>
	</xsl:when>
	<xsl:otherwise>
	  <a href="{concat($TEISERVER,'tag.xq?name=',$name)}">
	    <xsl:value-of select="$name"/>
	  </a>
	</xsl:otherwise>
      </xsl:choose>
    </xsl:when>
    <xsl:when test="$oddmode='pdf'">
      <fo:inline font-style="italic"><xsl:value-of select="$name"/></fo:inline>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$name"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>



<xsl:template name="generateParents">
  <xsl:param name="what"/>
  <xsl:variable name="mums">
    <mums>
      <xsl:for-each select="document('dtdcat.xml')">
	<xsl:for-each select="key('ELEMENTPARENTS',$what)">
	  <mum><xsl:value-of select="../@id|../@xml:id"/></mum>
	</xsl:for-each>
      </xsl:for-each>
    </mums>
  </xsl:variable>
  <xsl:variable name="mums2">
    <mums>
      <xsl:for-each select="exsl:node-set($mums)/mums/mum">
	<xsl:sort select="."/>
	<mum><xsl:value-of select="."/></mum>
      </xsl:for-each>
    </mums>
  </xsl:variable>
  <xsl:for-each select="exsl:node-set($mums2)/mums/mum">
    <xsl:if test="not(. = preceding-sibling::mum)">        
      <xsl:value-of select="."/><xsl:text> </xsl:text>
    </xsl:if>
  </xsl:for-each>
</xsl:template>




<xsl:template name="linkStyle"/>



<xsl:template name="linkTogether">
  <xsl:param name="name"/>
  <xsl:param name="url"/>
  <xsl:choose>
    <xsl:when test="$oddmode='html' and starts-with($url,'http:')">
      <a href="{$url}"><xsl:value-of select="$name"/></a>
    </xsl:when>
    <xsl:when test="$oddmode='html'">
      <a class="link_odd" href="{concat('ref-',$url,'.html')}"><xsl:value-of select="$name"/></a>
    </xsl:when>
    <xsl:when test="$oddmode='pdf'">
      <fo:inline><xsl:value-of select="$name"/></fo:inline>
    </xsl:when>
    <xsl:when test="$oddmode='tei'">
      <ref target="#{$name}"><xsl:value-of select="$name"/></ref>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$name"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>



<xsl:template name="makeTagsetInfo">
  <xsl:value-of select="@module"/>
  <xsl:if test="$verbose='true'">
    <xsl:message>  tagset <xsl:value-of select="@id"/>: <xsl:value-of select="../@module"/></xsl:message>
  </xsl:if>
</xsl:template>



<xsl:template name="processSchemaFragment">
  <xsl:param name="filename"/>
  <xsl:variable name="secnum">
    <xsl:call-template name="sectionNumber"/>
  </xsl:variable>
  <xsl:if test="@id">
    <xsl:comment>[<xsl:value-of select="@id"/>] <xsl:value-of
    select="$secnum"/>
    <xsl:if test="@n">
      <xsl:text>: </xsl:text>
      <xsl:value-of select="@n"/>
    </xsl:if>
    </xsl:comment>
  </xsl:if>
  <xsl:apply-templates mode="tangle">
    <xsl:with-param name="filename" select="$filename"/>
  </xsl:apply-templates>
  <xsl:if test="@id">
    <xsl:comment> end of [<xsl:value-of select="@id"/>]  <xsl:value-of select="$secnum"/>    
    </xsl:comment>
  </xsl:if>
</xsl:template>




<xsl:template name="processSpecDesc">
  <xsl:variable name="name">
    <xsl:value-of select="@key"/>
  </xsl:variable>
  <xsl:variable name="atts">
    <xsl:value-of select="concat(' ',normalize-space(@atts),' ')"/>
  </xsl:variable>
  <xsl:choose>
    <xsl:when test="$name=''">
      <xsl:message>ERROR: no key attribute on specDesc</xsl:message>
    </xsl:when>
    <xsl:when test="key('IDENTS',$name)">
      <xsl:apply-templates select="key('IDENTS',$name)" mode="show">
	<xsl:with-param name="atts" select="$atts"/>
      </xsl:apply-templates>
    </xsl:when>
    <xsl:otherwise>
      <xsl:variable name="loc">
	<xsl:value-of select="$TEISERVER"/>
	<xsl:text>copytag.xq?name=</xsl:text>
	<xsl:value-of select="$name"/>
      </xsl:variable>
      <xsl:if test="$verbose">
	<xsl:message>Accessing TEISERVER: <xsl:value-of
	select="$loc"/></xsl:message>
      </xsl:if>
      
      <xsl:apply-templates select="document($loc)/*" mode="show">
	<xsl:with-param name="atts" select="$atts"/>
      </xsl:apply-templates>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>



<xsl:template name="processatts">
  <xsl:param name="values"/>
  <xsl:if test="not($values = '')">
    <xsl:apply-templates 
	select="key('IDS',substring-before($values,' '))"/>
    <xsl:call-template name="processatts">
      <xsl:with-param name="values" select="substring-after($values,' ')"/>
    </xsl:call-template>
  </xsl:if>
</xsl:template>




<xsl:template name="sectionNumber">
  <xsl:for-each select="(ancestor::div1|ancestor::div2|ancestor::div3|ancestor::div4)[last()]">
    <xsl:for-each select="ancestor-or-self::div1">
      <xsl:number from="body" level="any" /><xsl:text>.</xsl:text>
    </xsl:for-each>
    <xsl:number level="multiple" count="div2|div3|div4" from="div1"/>
  </xsl:for-each>
</xsl:template>

<xsl:template match="classSpec" mode="tagatts">
  <xsl:if test="$verbose='true'">
    <xsl:message>      .... link to attributes from class [<xsl:value-of select="@ident"/>]</xsl:message>
  </xsl:if>
  <rng:ref name="{@ident}.attributes" />
</xsl:template>


<xsl:template name="make-ns-declaration">
  <xsl:param name="is-default"/>
  <xsl:param name="prefix"/>
  <xsl:param name="uri"/>
</xsl:template>

<xsl:template name="inhnamespace"/>

<xsl:template match="s:*"/>

<xsl:template match="altIdent"/>

<xsl:template match="a:*">
  <xsl:copy-of select="."/>
</xsl:template>

</xsl:stylesheet>
