<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"  xmlns:tei="http://www.tei-c.org/ns/1.0" version="1.0">
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
     <!--
     <html>
            <head>
            -->
                <link  rel="stylesheet"  type="text/css" href="/stylesheets/TEI/tei_style.css" />
     <!--
            </head>
            <body>
             -->
                <xsl:apply-templates select="tei:TEI" />
<!--
            </body>
            </html>
            -->
    </xsl:template>
    
    <xsl:template match="tei:TEI">
       <xsl:apply-templates select="tei:text" />
       </xsl:template>
    
    <xsl:template match="tei:text">
        <div class="text">
            <xsl:apply-templates />
        </div>
    </xsl:template>
    
    <xsl:template match="tei:div">
        <div class="{@type}" id="{@xml:id}">
            <a name="{@xml:id}" />
            <xsl:apply-templates />
         </div>
    </xsl:template>
    
    <xsl:template match="tei:head">
       <div class="head{@type}">
            <h2>
                <xsl:apply-templates />
            </h2>
        </div>
    </xsl:template>
    
    <xsl:template match="tei:head[@type='Aphorismus']" />
    
    <xsl:template match="tei:head[@type='aphorism']" />
        
        
    <xsl:template match="tei:p">
        <div class="p">
        <p>
            <xsl:if test="@rend">
                <xsl:attribute name="style"><xsl:value-of select="@rend"/></xsl:attribute>
            </xsl:if>
            <xsl:apply-templates />
        </p>
        </div>
    </xsl:template>
    
    <xsl:template match="tei:hi[@rend='bold']">
        <xsl:choose>
            <xsl:when test="not(preceding-sibling::tei:hi[@rend='bold']) and (parent::tei:p/preceding-sibling::tei:head[@type='Aphorismus'] or parent::tei:p/preceding-sibling::tei:head[@type='aphorism'])">
                <span class="sp_bold">
                    <xsl:apply-templates />
                </span>
            </xsl:when>
            <xsl:otherwise>
                <span class="bold">
                    <xsl:apply-templates />
                </span>
                </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="tei:hi[@rend='font-weight: bold']">
        <span class="bold">
        <xsl:apply-templates/> 
        </span>
        
    </xsl:template>
    
    <xsl:template match="tei:dateline">
        <div class="dateline">
            <xsl:apply-templates />
        </div>
    </xsl:template>
    
    <xsl:template match="tei:date">
        <div class="date">
           <xsl:apply-templates /> 
       </div>
       </xsl:template>
    
    
    <xsl:template match="tei:emph">
        <span class="emph">
            <xsl:apply-templates />
        </span>
    </xsl:template>
    
    <xsl:template match="tei:signed">
        <div class="signed">
            <xsl:apply-templates />
       </div>
    </xsl:template>
    
    <xsl:template match="tei:closer">
        <div class="closer">
            <xsl:apply-templates />
        </div>
    </xsl:template>
    
        
    <xsl:template match="tei:lg">
        <div class="lg">
            <xsl:apply-templates />
         </div>
      </xsl:template>
    
    <xsl:template match="tei:l">
        <div class="l">
            <xsl:apply-templates />
        </div>
    </xsl:template>
    
    <xsl:template match="tei:list">
        <ul>
            <xsl:apply-templates />
        </ul>
    </xsl:template>
    
<xsl:template match="tei:list[@type='unordered']">
        <ul>
            <xsl:apply-templates />
        </ul>
</xsl:template>
    
    <xsl:template match="tei:item">
        <li><xsl:apply-templates /></li>
    </xsl:template>
    
    <xsl:template match="tei:label">
        <div class="label">
            <xsl:apply-templates />
            </div>
    </xsl:template>
    
    <xsl:template match="tei:q[@rend='block']">
        <blockquote>
            <xsl:apply-templates />
        </blockquote>
    </xsl:template>

    
    <xsl:template match="tei:cit">
       <span class="cit">
            <xsl:apply-templates />
       </span>
    </xsl:template>
    
    <xsl:template match="tei:bibl">
        <span class="bibl">
            <xsl:apply-templates />
        </span>
    </xsl:template>
    
    <xsl:template match="tei:title">
        <span class="title">
            <xsl:apply-templates />
        </span>
    </xsl:template>
    
    <xsl:template match="tei:table">
        <table style="margin: 0px">
            <xsl:apply-templates/>
        </table>
    </xsl:template>
    
    <xsl:template match="tei:row">
        <tr>
            <xsl:apply-templates/>
        </tr>
    </xsl:template>
    
    <xsl:template match="tei:cell">
        <td style="vertical-align:top">
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
    
    
</xsl:stylesheet>
