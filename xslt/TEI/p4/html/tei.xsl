<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns:xhtml="http://www.w3.org/1999/xhtml">
<!--
	<xsl:output method="xml" omit-xml-declaration="yes" indent="yes"/>
-->
	<xsl:output method="html" indent="yes"/>
	<!-- 
      
        AC = <div type="div1.aphorism"> |  <head /> | <p /> | <hi rend="bold" />  | <signed /> | <div type="div1-aphorismus" />
        
        BA = <div type="div2.aphorism" /> | <head /> | <p /> | <hi rend="bold" /> | <q rend="block" /> | <lg /> | <l /> | <div type="div1" /> | 
        
        CV = <div type="div1" /> | <head /> | <head type="sub" /> | <p /> | <hi rend="bold" /> | <dateline /> | 
        
        EH =  <div type="div2.aphorism" /> | <head /> | <p /> | <hi rend="bold" /> | <lg /> | <l /> | <signed /> | <div type="div1" /> |  <list /> |   <item />   | <head type="sub" /> | <q rend="block" /> | 
        
        GD = <div type="div1" /> | <head /> | <p /> | <hi rend="bold" /> | <closer /> | <dateline /> | <signed /> | <div type="div2.aphorism" /> | <head type="aphorism" /> | <head type="sub" /> | <item /> | <label /> | <emph /> | <list type="unordered" />
        
        GM = <div type="div2.aphorism" /> | <head /> | <p /> | <hi rend="bold" /> | <dateline /> | <q rend="block" /> | <lg /> | <l /> | 
        
        GT = <div type="div2.aphorism" /> | <head /> | <p /> | <hi rend="bold" /> |  <lg /> | <l /> | <q rend="block" /> | <div type="div1" /> |   <cit /> | <bibl /> | <title /> | <q rend="block" type="Zitate" /> |  <head type="aphorism" />  
       
        JGB =  <div type="div1" /> | <head /> | <p /> | <hi rend="bold" /> | <dateline /> | <div type="div2.aphorism" /> | <head type="aphorism" /> | <head type="sub" /> | <lg /> | <l /> | 
        
        M = <div type="div2.aphorism" /> | <head /> | <p /> | <hi rend="bold" /> | <dateline /> | <head type="aphorism" /> | 
        
        MA = <div type="div2" /> |  <head /> | <p /> | <hi rend="bold" /> | <dateline /> | <lg /> | <l /> | <emph /> <head type="Aphorismus" /> | <date />
        
        SGT = <div type="div1" /> | <head /> | <p /> | <hi rend="bold" /> | <q rend="block" /> | <lg /> | <l /> | 
        
        ST = <div type="div1" /> | <head /> | <p /> | <lg /> | <l /> | <hi rend="bold" /> | 
        
        WL = <div type="div1.aphorism" /> | <head /> | <p /> | <hi rend="bold" /> | 
        
        ZA = <div type="div3.aphorism" /> | <head /> | <p /> | <hi rend="bold" /> | <div type="div2" /> | <lg /> | <l /> | 
        
        DW = <div type="div1.aphorism" /> | <head /> | <p /> | <hi rend="bold" /> | 
        
        NW = <div type="div1" /> | <head /> | <p /> | <hi rend="bold" /> | <dateline /> | <l /> | <div type="div2.aphorism" /> | 
        
        WA = <div type="div1" /> | <head /> | <p /> | <hi rend="bold" /> | <div type="div2.aphorism" /> | <q rend="block" /> | <lg /> | <l /> | <signed /> | 
        
        PHG = <div type="div1" /> | <p /> | <hi rend="bold" /> | <div type="div1.aphorism" /> | <head /> | 
        
        GG = <div type="div1" /> | <p /> | <hi rend="bold" /> | <q rend="block" /> | <lg /> | <l /> | 
        
        GMT =<div type="div1" /> | <p /> | <hi rend="bold" /> | 
        
        MD = <div type="div1" /> | <p /> | <hi rend="bold" /> | 
        
        NJ = <div type="div1" /> | <p /> | <hi rend="bold" /> | 
        
        DS = <div type="div1.aphorism" /> | <head /> | <p /> | <hi rend="bold" /> | <q rend="block" /> | <lg /> | <l /> | 
        
        HL = <div type="div1.aphorism" /> | <head /> | <p /> | <hi rend="bold" /> | <q rend="block" /> | <l /> | 
        
        SE = <div type="div1.aphorism" /> | <head /> | <p /> | <hi rend="bold" /> | 
        
        WB = <div type="div1.aphorism" /> | <head /> | <p /> | <hi rend="bold" /> | <q rend="block" /> | <l /> | 
        
        
    -->

    <xsl:template match="/">
<!--     <html>
           <head>
-->
<!--                <link rel="stylesheet"  type="text/css" href="/stylesheets/TEI/p4/tei_style.css" /> -->
<!--            </head>
            <body>
-->
<!--
               <xsl:apply-templates select="tei:TEI" />
-->
               <xsl:apply-templates select="*" /> 
<!--            </body>
            </html>
-->
    </xsl:template>

	<xsl:template match="tei:TEI">
		<xsl:apply-templates select="tei:text"/>
	</xsl:template>

	<xsl:template match="tei:text">
		<div class="text">
			<xsl:apply-templates/>
		</div>
	</xsl:template>



	<!-- cut here -->

	<xsl:template match="tei:div">
		<div class="{@type}" id="{@xml:id}">
			<a name="{@xml:id}"/>
			<xsl:apply-templates/>
		</div>
		<div class="footnotes"><xsl:text> </xsl:text>
			<xsl:call-template name="printFootNote"/>
		</div>
	</xsl:template>

	<xsl:template match="tei:head">
		<div class="head{@type}">
			<h2>
				<xsl:apply-templates/>
			</h2>
		</div>
	</xsl:template>

	<xsl:template match="tei:head[@rend='Titel']">
		<h1>
			<xsl:apply-templates/>
		</h1>
	</xsl:template>

	<xsl:template match="tei:head[@rend='Titel_Kapitel']">
		<h2>
			<xsl:apply-templates/>
		</h2>
	</xsl:template>


	<xsl:template match="tei:head[@rend='Titel_aphorismus']">
		<h3>
			<xsl:apply-templates/>
		</h3>
	</xsl:template>


	<xsl:template match="tei:head[@type='Untertitel']">
		<p class="Untertitel">
			<xsl:apply-templates/>
		</p>
	</xsl:template>

	<xsl:template match="tei:foreign[@xml:lang='grc']">
		<span class="greek">
			<xsl:apply-templates/>
		</span>
	</xsl:template>



	<xsl:template match="tei:p">
		<div class="p">
			<p>
				<xsl:if test="@rend">
					<xsl:attribute name="class">
						<xsl:value-of select="@rend"/>
					</xsl:attribute>
				</xsl:if>
				<xsl:if test="parent::tei:note and not(name( preceding-sibling::tei:*[1])='p')">
					<span class="noteRef">
						<xsl:value-of select="parent::tei:note/@n"/>
					</span>
					<xsl:text> </xsl:text>
				</xsl:if>
				<xsl:apply-templates/>
			</p>
		</div>
	</xsl:template>

	<xsl:template match="tei:space[@dim='vertical']">
		<br/>
	</xsl:template>

	<xsl:template match="tei:choice">
		<span style="position:relative">
			<span class="tooltip_corrige">
				<xsl:apply-templates select="tei:corr"/>
			</span>
			<span class="popup">
                           <xsl:attribute name="id">hidden<xsl:value-of select="ancestor::tei:div/@xml:id"/><xsl:value-of select="generate-id()"/></xsl:attribute>
<!--<div class="tooltip_table">
 <div class="table-row">
  <div class="left-container"> 
    <xsl:apply-templates select="tei:sic"/><xsl:if test="string-length(tei:sic)=0">[editorial addition]</xsl:if>
  </div>
  <div class="right-container"> 
    <em>errata</em>
  </div>
 </div>
 <div class="table-row">
  <div class="left-container">
    <xsl:apply-templates select="tei:corr"/>
  </div>
  <div class="right-container"> 
    <em>corrige</em>
  </div>
 </div>
 <div class="table-row">   
    <a href="http://www.nietzschesource.org/documentation/corrections.html" target="_blank" style="font-style: italic">Nach KGW Nachberichte</a>
 </div>
</div> 
-->
<em>errata:</em><xsl:text> </xsl:text><xsl:apply-templates select="tei:sic"/><xsl:if test="string-length(tei:sic)=0">[editorial addition]</xsl:if><br/>
<em>corrige:</em><xsl:text> </xsl:text><xsl:apply-templates select="tei:corr"/><br/>
<a href="http://www.nietzschesource.org/documentation/corrections.html" target="_blank" style="font-style: italic">Nach KGW Nachberichte</a>

			</span>
		</span>
	</xsl:template>

	<xsl:template match="tei:hi[@rend='bold']">
		<xsl:choose>
			<xsl:when
				test="not(preceding-sibling::tei:hi[@rend='bold']) and
        (parent::tei:p/preceding-sibling::tei:head[@type='Aphorismus'] or
        parent::tei:p/preceding-sibling::tei:head[@type='aphorism'])">
				<span class="sp_bold">
					<xsl:apply-templates/>
				</span>
			</xsl:when>
			<xsl:otherwise>
				<span class="bold">
					<xsl:apply-templates/>
				</span>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="tei:hi[@rend='font-weight: bold']">
		<span class="bold">
			<xsl:apply-templates/>
		</span>
	</xsl:template>


	<xsl:template match="tei:hi">
		<span>
			<xsl:attribute name="style">
				<xsl:value-of select="@rend"/>
			</xsl:attribute>
			<xsl:apply-templates/>
		</span>
	</xsl:template>

	<xsl:template match="tei:hi[@rend='bold italic']">
		<span class="bolditalic">
			<xsl:apply-templates/>
		</span>
	</xsl:template>

	<xsl:template match="tei:dateline">
		<div class="dateline">
			<xsl:apply-templates/>
		</div>
	</xsl:template>

	<!--	
    <xsl:template match="tei:date">
    <div class="date">
    <xsl:apply-templates/>
    </div>
    </xsl:template>
  -->

	<xsl:template match="tei:emph">
		<span class="emph">
			<xsl:apply-templates/>
		</span>
	</xsl:template>

	<xsl:template match="tei:signed">
		<div class="signed">
			<xsl:apply-templates/>
		</div>
	</xsl:template>

	<xsl:template match="tei:closer">
		<div class="closer">
			<xsl:apply-templates/>
		</div>
	</xsl:template>


	<xsl:template match="tei:lg">
		<div class="lg">
			<xsl:apply-templates/>
		</div>
	</xsl:template>

	<xsl:template match="tei:l">
		<div class="l">
			<xsl:apply-templates/>
		</div>
	</xsl:template>

	<xsl:template match="tei:list">
		<ul>
			<xsl:apply-templates/>
		</ul>
	</xsl:template>

	<xsl:template match="tei:list[@type='unordered']">
		<ul>
			<xsl:apply-templates/>
		</ul>
	</xsl:template>

	<xsl:template match="tei:item">
		<li>
			<xsl:apply-templates/>
		</li>
	</xsl:template>

	<xsl:template match="tei:label">
		<div class="label">
			<xsl:apply-templates/>
		</div>
	</xsl:template>

	<xsl:template match="tei:q[@rend='block']">
		<blockquote>
			<xsl:apply-templates/>
		</blockquote>
	</xsl:template>


	<xsl:template match="tei:cit">
		<span class="cit">
			<xsl:apply-templates/>
		</span>
	</xsl:template>

	<xsl:template match="tei:bibl">
		<span class="bibl">
			<xsl:apply-templates/>
		</span>
	</xsl:template>

	<xsl:template match="tei:title">
		<span class="title">
			<xsl:apply-templates/>
		</span>
	</xsl:template>



	<xsl:template match="tei:table">
		<table border="0">
			<xsl:if test="@rend">
				<xsl:attribute name="style">
					<xsl:value-of select="@rend"/>
				</xsl:attribute>
			</xsl:if>

			<xsl:apply-templates/>
		</table>
	</xsl:template>


	<xsl:template match="tei:row">
		<tr>
			<xsl:apply-templates/>
		</tr>
	</xsl:template>

	<xsl:template match="tei:cell">
		<td valign="top">
			<xsl:if test="@rend">
				<xsl:attribute name="style">
					<xsl:value-of select="@rend"/>
				</xsl:attribute>
			</xsl:if>
			<xsl:if test="@cols">
				<xsl:attribute name="colspan">
					<xsl:value-of select="@cols"/>
				</xsl:attribute>
			</xsl:if>
			<xsl:if test="@rows">
				<xsl:attribute name="rowspan">
					<xsl:value-of select="@rows"/>
				</xsl:attribute>
			</xsl:if>
			<xsl:apply-templates/>
		</td>
	</xsl:template>
	<!-- <xsl:template match="*" /> -->


	<xsl:template name="printFootNote">
		<xsl:for-each select="//tei:note">
			<div class="note">
				<xsl:if test="not(tei:p)">
					<span class="noteRef">
						<xsl:value-of select="@n"/>
					</span>
					<xsl:text> </xsl:text>
				</xsl:if>
				<xsl:apply-templates/>
			</div>

		</xsl:for-each>
	</xsl:template>

	<xsl:template match="tei:note">
		<xsl:value-of select="@n"/>
	</xsl:template>

	<xsl:template match="tei:figure">
		<div class="image">
			<img>
				<xsl:attribute name="src">
					<xsl:value-of select="tei:graphic/@url"/>
				</xsl:attribute>

				<xsl:attribute name="height">
					<xsl:value-of select="tei:graphic/@height"/>
				</xsl:attribute>

				<xsl:attribute name="width">
					<xsl:value-of select="tei:graphic/@width"/>
				</xsl:attribute>
			</img>
		</div>
	</xsl:template>

	<xsl:template match="tei:figure[@rend='horizontal-line']">
		<hr class="hline-thin"/>
	</xsl:template>

	<xsl:template match="tei:g">
		<span>
			<xsl:attribute name="style">
				<xsl:value-of select="@rend"/>
			</xsl:attribute>
			<xsl:apply-templates/>
		</span>
	</xsl:template>

	<xsl:template match="xhtml:*">
		<xsl:copy-of select="."/>
	</xsl:template>
</xsl:stylesheet>

