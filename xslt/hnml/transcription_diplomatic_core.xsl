<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output
	method="xml"
	indent="yes"
	encoding="UTF-8"
/>


<!-- for fabrica:  preview_signature  -->

        <xsl:template match="preview_siglum"><p></p><p><br/><font color="red"><b><xsl:value-of select="."/></b></font></p><p></p></xsl:template>


<!--	 	signature	-->

	<xsl:template match="signature"><xsl:param name="layer"/><span class="signature"><xsl:apply-templates mode="layer"><xsl:with-param name="layer"><xsl:value-of select="$layer"/></xsl:with-param></xsl:apply-templates></span></xsl:template>


<!--		LB		-->

	<xsl:template match="lb"><br/><br/></xsl:template>


<!--      L        -->

<!--        <xsl:template match="l"><xsl:param name="layer"/><xsl:apply-templates mode="layer"><xsl:with-param name="layer"><xsl:value-of select="$layer"/></xsl:with-param></xsl:apply-templates><br/></xsl:template>
-->
        <xsl:template match="l"><xsl:param name="layer"/><span class="line"><xsl:apply-templates mode="layer"><xsl:with-param name="layer"><xsl:value-of select="$layer"/></xsl:with-param></xsl:apply-templates></span></xsl:template>

<!--		PB		-->

	<xsl:template match="pb"><p class="pb"><span class="pb_number">p.&#160;<xsl:value-of select="@p"/></span></p></xsl:template>


<!--		HYPHEN 		-->

	<xsl:template match="hyphen"><xsl:param name="layer"/><xsl:apply-templates mode="layer"><xsl:with-param name="layer"><xsl:value-of select="$layer"/></xsl:with-param></xsl:apply-templates></xsl:template>

<!--		LS     		-->

	<xsl:template match="ls"><xsl:param name="layer"/><span class="ls"><xsl:apply-templates mode="layer"><xsl:with-param name="layer"><xsl:value-of select="$layer"/></xsl:with-param></xsl:apply-templates></span></xsl:template>

<!--		GS     		-->

	<xsl:template match="gs"><xsl:param name="layer"/><span class="gs"><xsl:apply-templates mode="layer"><xsl:with-param name="layer"><xsl:value-of select="$layer"/></xsl:with-param></xsl:apply-templates></span></xsl:template>

<!--		GR     		-->
 
	<xsl:template match="gr"><xsl:param name="layer"/><span class="gr"><xsl:apply-templates mode="layer"><xsl:with-param name="layer"><xsl:value-of select="$layer"/></xsl:with-param></xsl:apply-templates></span></xsl:template>

<!--            PRINT                   -->

        <xsl:template match="print"><xsl:param name="layer"/><span class="print"><xsl:apply-templates mode="layer"><xsl:with-param name="layer"><xsl:value-of select="$layer"/></xsl:with-param></xsl:apply-templates></span></xsl:template>


<!--		BLACK    	       		-->

	<xsl:template match="black"><xsl:param name="layer"/><span class="black"><xsl:apply-templates mode="layer"><xsl:with-param name="layer"><xsl:value-of select="$layer"/></xsl:with-param></xsl:apply-templates></span></xsl:template>

<!--		blue    	       		-->

	<xsl:template match="blue"><xsl:param name="layer"/><span class="blue"><xsl:apply-templates mode="layer"><xsl:with-param name="layer"><xsl:value-of select="$layer"/></xsl:with-param></xsl:apply-templates></span></xsl:template>

<!--		sepia    	       		-->

	<xsl:template match="sepia"><xsl:param name="layer"/><span class="sepia"><xsl:apply-templates mode="layer"><xsl:with-param name="layer"><xsl:value-of select="$layer"/></xsl:with-param></xsl:apply-templates></span></xsl:template>

<!--		purple    	       		-->

	<xsl:template match="purple"><xsl:param name="layer"/><span class="purple"><xsl:apply-templates mode="layer"><xsl:with-param name="layer"><xsl:value-of select="$layer"/></xsl:with-param></xsl:apply-templates></span></xsl:template>

<!--		red    	       		-->

	<xsl:template match="red"><xsl:param name="layer"/><span class="red"><xsl:apply-templates mode="layer"><xsl:with-param name="layer"><xsl:value-of select="$layer"/></xsl:with-param></xsl:apply-templates></span></xsl:template>

<!--		pencil    	       		-->

	<xsl:template match="pencil"><xsl:param name="layer"/><span class="pencil"><xsl:apply-templates mode="layer"><xsl:with-param name="layer"><xsl:value-of select="$layer"/></xsl:with-param></xsl:apply-templates></span></xsl:template>


<!--		redpen    	       		-->

	<xsl:template match="redpen"><xsl:param name="layer"/><span class="redpen"><xsl:apply-templates mode="layer"><xsl:with-param name="layer"><xsl:value-of select="$layer"/></xsl:with-param></xsl:apply-templates></span></xsl:template>
		
<!--		bluepen  	       		-->

	<xsl:template match="bluepen"><xsl:param name="layer"/><span class="bluepen"><xsl:apply-templates mode="layer"><xsl:with-param name="layer"><xsl:value-of select="$layer"/></xsl:with-param></xsl:apply-templates></span></xsl:template>
	
<!--		redpencil    	       		-->

	<xsl:template match="redpencil"><xsl:param name="layer"/><span class="redpencil"><xsl:apply-templates mode="layer"><xsl:with-param name="layer"><xsl:value-of select="$layer"/></xsl:with-param></xsl:apply-templates></span></xsl:template>
		
<!--		bluepencil  	       		-->

	<xsl:template match="bluepencil"><xsl:param name="layer"/><span class="bluepencil"><xsl:apply-templates mode="layer"><xsl:with-param name="layer"><xsl:value-of select="$layer"/></xsl:with-param></xsl:apply-templates></span></xsl:template>
	

<!--		N     			-->

	<xsl:template match="N"><xsl:param name="layer"/><span class="N"><xsl:apply-templates mode="layer"><xsl:with-param name="layer"><xsl:value-of select="$layer"/></xsl:with-param></xsl:apply-templates></span></xsl:template>

<!-- 		G			-->

	<xsl:template match="G"><xsl:param name="layer"/><span class="G"><xsl:apply-templates mode="layer"><xsl:with-param name="layer"><xsl:value-of select="$layer"/></xsl:with-param></xsl:apply-templates></span></xsl:template>


<!--		X			-->


	<xsl:template match="X"><xsl:param name="layer"/><span class="X"><xsl:apply-templates mode="layer"><xsl:with-param name="layer"><xsl:value-of select="$layer"/></xsl:with-param></xsl:apply-templates></span></xsl:template>



<!-- 		U      	        -->

	<xsl:template match="u"><xsl:param name="layer"/><span class="u"><xsl:apply-templates mode="layer"><xsl:with-param name="layer"><xsl:value-of select="$layer"/></xsl:with-param></xsl:apply-templates></span></xsl:template>

<!--		U2     		-->

	<xsl:template match="u2"><xsl:param name="layer"/><span class="u2"><xsl:apply-templates mode="layer"><xsl:with-param name="layer"><xsl:value-of select="$layer"/></xsl:with-param></xsl:apply-templates></span></xsl:template>

<!--		U3     		-->

	<xsl:template match="u3"><xsl:param name="layer"/><span class="u3"><xsl:apply-templates mode="layer"><xsl:with-param name="layer"><xsl:value-of select="$layer"/></xsl:with-param></xsl:apply-templates></span></xsl:template>

<!--		U4     		-->

	<xsl:template match="u4"><xsl:param name="layer"/><span class="u4"><xsl:apply-templates mode="layer"><xsl:with-param name="layer"><xsl:value-of select="$layer"/></xsl:with-param></xsl:apply-templates></span></xsl:template>

<!--            SP              -->

        <xsl:template match="sp"><xsl:param name="layer"/><span class="sp"><xsl:apply-templates mode="layer"><xsl:with-param name="layer"><xsl:value-of select="$layer"/></xsl:with-param></xsl:apply-templates></span></xsl:template>

<!--		IT		-->

        <xsl:template match="it"><xsl:param name="layer"/><span class="it"><xsl:apply-templates mode="layer"><xsl:with-param name="layer"><xsl:value-of select="$layer"/></xsl:with-param></xsl:apply-templates></span></xsl:template>

<!--		 STR   		-->

	<xsl:template match="str"><xsl:param name="layer"/><span class="str"><xsl:apply-templates mode="layer"><xsl:with-param name="layer"><xsl:value-of select="$layer"/></xsl:with-param></xsl:apply-templates></span></xsl:template>


<!--		ABBR		-->

	<xsl:template match="abbr"><xsl:param name="layer"/><span class="abbr"><xsl:apply-templates mode="layer"><xsl:with-param name="layer"><xsl:value-of select="$layer"/></xsl:with-param></xsl:apply-templates></span></xsl:template>

<!--		NDASH		-->

	<xsl:template match="ndash">&#8211;</xsl:template>

<!--		MDASH		-->

	<xsl:template match="mdash">&#8212;</xsl:template>

<!--		P		-->



        <xsl:template match="p"><xsl:param name="layer"/><xsl:choose><xsl:when test="@indent"><p style="text-indent:{@indent}pt"><xsl:element name="span"><xsl:attribute name="class"><xsl:value-of select="name(parent::*)"/></xsl:attribute><xsl:apply-templates mode="layer"><xsl:with-param name="layer"><xsl:value-of select="$layer"/></xsl:with-param></xsl:apply-templates></xsl:element></p></xsl:when>
<xsl:otherwise><p class="{@align}"><xsl:element name="span"><xsl:attribute name="class"><xsl:value-of select="name(parent::*)"/></xsl:attribute><xsl:apply-templates mode="layer"><xsl:with-param name="layer"><xsl:value-of select="$layer"/></xsl:with-param></xsl:apply-templates></xsl:element></p></xsl:otherwise></xsl:choose></xsl:template>

<!--

	<xsl:template match="p"><xsl:param name="layer"/><p class="{@align}"><xsl:element name="span"><xsl:attribute name="class"><xsl:value-of select="name(parent::*)"/></xsl:attribute><xsl:apply-templates mode="layer"><xsl:with-param name="layer"><xsl:value-of select="$layer"/></xsl:with-param></xsl:apply-templates></xsl:element></p></xsl:template>
-->

<!--		DEL		-->

	<xsl:template match="del"><xsl:param name="layer"/><span class="del"><xsl:apply-templates mode="layer"><xsl:with-param name="layer"><xsl:value-of select="$layer"/></xsl:with-param></xsl:apply-templates></span></xsl:template>


<!-- ADD pl="inter" or pl="out" -->

<xsl:template match="add"><xsl:param name="layer"/>

<xsl:choose>

<!--  pageout -->

  <xsl:when test="@pl='pageOut'">
    <xsl:variable name="pos"><xsl:number level="any" count="add[(@pl='bottom' or @pl='out' or @pl='top' or @pl='right' or @pl='left' or @pl='pageleft' or @pl='pageright' or @pl='pageOut') and (($layer >= @lay) or not(@lay))]"/></xsl:variable><a name="{$pos}a" href="#{$pos}"><span class="mark"><xsl:value-of select="$pos"/></span></a><pageout pos="{$pos}" page="{@p}"><xsl:apply-templates mode="layer" select="node()"><xsl:with-param name="layer"><xsl:value-of select="$layer"/></xsl:with-param></xsl:apply-templates></pageout>
  </xsl:when>

<!-- bottom  case -->
  <xsl:when test="@pl='bottom'">
   <img src="/styles/add_bottom.gif"/><span class="boxline"><span class="boxadds"><img src="/styles/add_bottom.gif"/><xsl:apply-templates mode="layer" select="node()"><xsl:with-param name="layer"><xsl:value-of select="$layer"/></xsl:with-param></xsl:apply-templates></span></span>
  </xsl:when>

<!-- out case -->
  <xsl:when test="@pl='out'"><img src="/styles/add_out.gif"/>
  <xsl:choose>
    <xsl:when test="@p != ''">
      <span class="boxline"><span class="boxadds"><img src="/styles/add_out.gif"/><span class="pb_number">[p.&#160;<xsl:value-of select="@p"/>]</span>&#160;<xsl:apply-templates mode="layer" select="node()"><xsl:with-param name="layer"><xsl:value-of select="$layer"/></xsl:with-param></xsl:apply-templates></span></span>
    </xsl:when>
    <xsl:otherwise>
      <span class="boxline"><span class="boxadds"><img src="/styles/add_out.gif"/><xsl:apply-templates mode="layer" select="node()"><xsl:with-param name="layer"><xsl:value-of select="$layer"/></xsl:with-param></xsl:apply-templates></span></span>
    </xsl:otherwise>
  </xsl:choose>
  </xsl:when>
<!-- top case-->
  <xsl:when test="@pl='top'">
  <img src="/styles/add_top.gif"/><span class="boxline"><span class="boxadds"><img src="/styles/add_top.gif"/><xsl:apply-templates mode="layer" select="node()"><xsl:with-param name="layer"><xsl:value-of select="$layer"/></xsl:with-param></xsl:apply-templates></span></span>
  </xsl:when>

<!-- left case-->
  <xsl:when test="@pl='left'">
  <img src="/styles/add_left.gif"/><span class="boxline"><span class="boxadds"><img src="/styles/add_left.gif"/><xsl:apply-templates mode="layer" select="node()"><xsl:with-param name="layer"><xsl:value-of select="$layer"/></xsl:with-param></xsl:apply-templates></span></span>
  </xsl:when>
  
  <xsl:when test="@pl='right'">
   <img src="/styles/add_right.gif"/><span class="boxline"><span class="boxadds"><img src="/styles/add_right.gif"/><xsl:apply-templates mode="layer" select="node()"><xsl:with-param name="layer"><xsl:value-of select="$layer"/></xsl:with-param></xsl:apply-templates></span></span>
  </xsl:when>


  
  <xsl:when test="@pl='pageleft'">
    <xsl:variable name="pos"><xsl:number level="any" count="add[(@pl='bottom' or @pl='out' or @pl='top' or @pl='right' or @pl='left' or @pl='pageleft' or @pl='pageright' or @pl='pageOut') and (($layer >= @lay) or not(@lay))]"/></xsl:variable><a name="{$pos}a" href="#{$pos}"><span class="mark"><xsl:value-of select="$pos"/></span></a>


    <xsl:variable name="width_height">
      <xsl:choose>
	<xsl:when test="@w != '' and @h != ''">width:<xsl:value-of
	select="@w"/>; height:<xsl:value-of select="@h"/>; </xsl:when>
	<xsl:when test="@w != '' and @h = ''">width:<xsl:value-of select="@w"/>; </xsl:when>
	<xsl:when test="@w = '' and @h != ''">width:30; height:<xsl:value-of select="@h"/>; </xsl:when>
      </xsl:choose>
    </xsl:variable>

<xsl:variable name="margin">
   <xsl:choose>
   <xsl:when test="@w != ''">-<xsl:value-of select="@w + 30"/></xsl:when>
   <xsl:otherwise>-60</xsl:otherwise>
   </xsl:choose>
</xsl:variable>
    
    <xsl:variable name="attribs"><xsl:value-of select="$width_height"/>margin-left:<xsl:value-of select="$margin"/></xsl:variable> 


    <div id="boxLeft" style="{$attribs}"><a name="{$pos}" href="#{$pos}a"><span class="mark"><xsl:value-of select="$pos"/>. </span></a><xsl:text> </xsl:text><xsl:apply-templates mode="layer" select="node()"><xsl:with-param name="layer"><xsl:value-of select="$layer"/></xsl:with-param></xsl:apply-templates></div>
    <xsl:if test="@table != ''">
      <table_width><xsl:value-of select="@table"/></table_width>
    </xsl:if>

  </xsl:when>
  
  
  <xsl:when test="@pl='pageright'">
    <xsl:variable name="pos"><xsl:number level="any" count="add[(@pl='bottom' or @pl='out' or @pl='top' or @pl='right' or @pl='left' or @pl='pageleft' or @pl='pageright' or @pl='pageOut') and (($layer >= @lay) or not(@lay))]"/></xsl:variable><a name="{$pos}a" href="#{$pos}"><span class="mark"><xsl:value-of select="$pos"/></span></a>


    <xsl:variable name="width_height">
      <xsl:choose>
	<xsl:when test="@w != '' and @h != ''">width:<xsl:value-of select="@w"/>; height:<xsl:value-of select="@h"/>; </xsl:when>
	<xsl:when test="@w != '' and @h = ''">width:<xsl:value-of select="@w"/>; </xsl:when>
	<xsl:when test="@w = '' and @h != ''">width:30; height:<xsl:value-of select="@h"/>; </xsl:when>
      </xsl:choose>
    </xsl:variable>

<xsl:variable name="margin">
   <xsl:choose>
   <xsl:when test="@w != ''">-<xsl:value-of select="@w + 30"/></xsl:when>
   <xsl:otherwise>-60</xsl:otherwise>
   </xsl:choose>
</xsl:variable>
    
    <xsl:variable name="attribs"><xsl:value-of select="$width_height"/>margin-right:<xsl:value-of select="$margin"/></xsl:variable> 


    
    <div id="boxRight" style="{$attribs}"><a name="{$pos}" href="#{$pos}a"><span class="mark"><xsl:value-of select="$pos"/>. </span></a><xsl:text> </xsl:text><xsl:apply-templates mode="layer" select="node()"><xsl:with-param name="layer"><xsl:value-of select="$layer"/></xsl:with-param></xsl:apply-templates></div>
    <xsl:if test="@table != ''">
      <table_width><xsl:value-of select="@table"/></table_width>
    </xsl:if>

  </xsl:when>
  

 <xsl:when test="@pl='inter below'">                                                                                                                                 
     <xsl:choose>
       <xsl:when test="name(..) = 'add' and number(../@lay) > 0 and number(@lay) > 0">
         <xsl:variable name="tmp_layer"><xsl:value-of select="@lay - ../@lay"/></xsl:variable><span class="add_below"><xsl:apply-templates mode="layer"><xsl:with-param name="layer"><xsl:value-of select="$layer"/></xsl:with-param></xsl:apply-templates></span>
       </xsl:when>                                                                                                                                             
       <xsl:otherwise>
	 <xsl:variable name="tmp_layer"><xsl:value-of select="@lay"/></xsl:variable><span class="add_below"><xsl:apply-templates mode="layer"><xsl:with-param name="layer"><xsl:value-of select="$layer"/></xsl:with-param></xsl:apply-templates></span>
       </xsl:otherwise>
     </xsl:choose>
 </xsl:when> 
<!--

  <xsl:when test="@pl='inter' or @pl=''">
-->
  <xsl:otherwise>	
    <xsl:choose>
      <xsl:when test="name(..) = 'add' and number(../@lay) > 0 and number(@lay) > 0">
	<xsl:variable name="tmp_layer"><xsl:value-of select="@lay - ../@lay"/></xsl:variable><span class="add{$tmp_layer}"><xsl:apply-templates mode="layer"><xsl:with-param name="layer"><xsl:value-of select="$layer"/></xsl:with-param></xsl:apply-templates></span>
      </xsl:when>
      <xsl:otherwise>	    
	<xsl:variable name="tmp_layer"><xsl:value-of select="@lay"/></xsl:variable><span class="add{$tmp_layer}"><xsl:apply-templates mode="layer"><xsl:with-param name="layer"><xsl:value-of select="$layer"/></xsl:with-param></xsl:apply-templates></span>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:otherwise>
</xsl:choose>
</xsl:template>


<!--	ADDOUT 	-->



<xsl:template match="addout">
    <xsl:param name="layer"/>
    <xsl:choose>
    <xsl:when test="@p != ''">
      <span class="boxline"><span class="boxadds"><img src="/styles/add_out.gif"/><span class="pb_number">[p.&#160;<xsl:value-of select="@p"/>]</span>&#160;<xsl:apply-templates mode="layer" select="node()"><xsl:with-param name="layer"><xsl:value-of select="$layer"/></xsl:with-param></xsl:apply-templates></span></span>
    </xsl:when>
    <xsl:otherwise>
      <span class="boxline"><span class="boxadds"><img src="/styles/add_out.gif"/><xsl:apply-templates mode="layer" select="node()"><xsl:with-param name="layer"><xsl:value-of select="$layer"/></xsl:with-param></xsl:apply-templates></span></span>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>


<!-- 	annotation -->

<xsl:template match="ann"><xsl:param name="layer"/>
<xsl:choose>


  <xsl:when test="@pl='bottom'">
   <img src="/styles/ann_bottom.gif"/><span class="boxline"><span class="boxadds"><img src="/styles/ann_bottom.gif"/><xsl:apply-templates mode="layer" select="node()"><xsl:with-param name="layer"><xsl:value-of select="$layer"/></xsl:with-param></xsl:apply-templates></span></span>
  </xsl:when>

<!-- out case -->
  <xsl:when test="@pl='out'"><img src="/styles/ann_out.gif"/>
  <xsl:choose>
    <xsl:when test="@p != ''">
      <span class="boxline"><span class="boxadds"><img src="/styles/ann_out.gif"/><span class="pb_number">[p.&#160;<xsl:value-of select="@p"/>]</span>&#160;<xsl:apply-templates mode="layer" select="node()"><xsl:with-param name="layer"><xsl:value-of select="$layer"/></xsl:with-param></xsl:apply-templates></span></span>
    </xsl:when>
    <xsl:otherwise>
      <span class="boxline"><span class="boxadds"><img src="/styles/ann_out.gif"/><xsl:apply-templates mode="layer" select="node()"><xsl:with-param name="layer"><xsl:value-of select="$layer"/></xsl:with-param></xsl:apply-templates></span></span>
    </xsl:otherwise>
  </xsl:choose>
  </xsl:when>
<!-- top case-->
  <xsl:when test="@pl='top'">
  <img src="/styles/ann_top.gif"/><span class="boxline"><span class="boxadds"><img src="/styles/ann_top.gif"/><xsl:apply-templates mode="layer" select="node()"><xsl:with-param name="layer"><xsl:value-of select="$layer"/></xsl:with-param></xsl:apply-templates></span></span>
  </xsl:when>

<!-- left case-->
  <xsl:when test="@pl='left'">
  <img src="/styles/ann_left.gif"/><span class="boxline"><span class="boxadds"><img src="/styles/ann_left.gif"/><xsl:apply-templates mode="layer" select="node()"><xsl:with-param name="layer"><xsl:value-of select="$layer"/></xsl:with-param></xsl:apply-templates></span></span>
  </xsl:when>
  
  <xsl:when test="@pl='right'">
   <img src="/styles/ann_right.gif"/><span class="boxline"><span class="boxadds"><img src="/styles/ann_right.gif"/><xsl:apply-templates mode="layer" select="node()"><xsl:with-param name="layer"><xsl:value-of select="$layer"/></xsl:with-param></xsl:apply-templates></span></span>
  </xsl:when>

</xsl:choose>
</xsl:template>


<!--	OVERWRITE	-->

	<xsl:template match="overwrite"><xsl:param name="layer"/><xsl:apply-templates mode="layer" select="old/node()"><xsl:with-param name="layer"><xsl:value-of select="$layer"/></xsl:with-param></xsl:apply-templates><div style="display:inline; position:relative; bottom:7px; left:-{new/@l}pt; margin-right:-{new/@l}pt;"><xsl:apply-templates mode="layer" select="new/node()"><xsl:with-param name="layer"><xsl:value-of select="$layer"/></xsl:with-param></xsl:apply-templates></div></xsl:template>


<!--		JOINT		-->

	<xsl:template match="joint"><xsl:param name="layer"/><xsl:apply-templates mode="layer" select="node()"><xsl:with-param name="layer"><xsl:value-of select="$layer"/></xsl:with-param></xsl:apply-templates></xsl:template>
	
	
<!--		EDITOR		-->

	<xsl:template match="editor"><xsl:param name="layer"/><xsl:apply-templates mode="layer" select="sic/node()"><xsl:with-param name="layer"><xsl:value-of select="$layer"/></xsl:with-param></xsl:apply-templates></xsl:template>


<!--	      editorS		-->

	<xsl:template match="editorS"><xsl:param name="layer"/><xsl:apply-templates mode="layer" select="sic/node()"><xsl:with-param name="layer"><xsl:value-of select="$layer"/></xsl:with-param></xsl:apply-templates></xsl:template>

<!--		unresolved	-->

	<xsl:template match="unresolved">&#8224;</xsl:template>


<!--            PROXY           -->

        <xsl:template match="proxy"><img src="/stylesheets/hnml/proxy.jpg"/></xsl:template>


<!--		 strblock	-->

        <xsl:template match="strblock"><xsl:param name="layer"/><table cellpadding="0" cellspacing="0"><tr><td background="/styles/strikeblock_{@c}.jpeg"><xsl:apply-templates mode="layer"><xsl:with-param name="layer"><xsl:value-of select="$layer"/></xsl:with-param></xsl:apply-templates></td></tr></table></xsl:template>

<!--		RESTORE		-->

	<xsl:template match="restore"><xsl:param name="layer"/><xsl:apply-templates mode="layer" select="*/node()"><xsl:with-param name="layer"><xsl:value-of select="$layer"/></xsl:with-param></xsl:apply-templates></xsl:template>


<!--  a  -->

       <xsl:template match="a"><xsl:copy-of select="."/></xsl:template>


<!--	layer template    -->

 	<xsl:template match="*" mode="layer">
	  <xsl:param name="layer"/>	

            <xsl:choose>


	      <xsl:when test="(number($layer) >= number(@lay)) or (translate(@lay, ' ', '')='')">
<xsl:variable name="tmp_layer" select="@lay"/><xsl:if test="$tmp_layer!=''"><xsl:call-template name="open_layer"><xsl:with-param name="lay"><xsl:value-of select="number(@lay)"/></xsl:with-param></xsl:call-template></xsl:if>

     	            <xsl:apply-templates select=".">

		      <xsl:with-param name="layer">
		        <xsl:value-of select="$layer"/>
		      </xsl:with-param>
	  	    </xsl:apply-templates>
<xsl:if test="$tmp_layer!=''"><xsl:call-template name="close_layer"/></xsl:if>
	      </xsl:when>

	      <xsl:otherwise>
	        <xsl:choose>

 	          <xsl:when test="name()='u' or name()='u2' or name()='u3' or name()='u4' or name()='str' or name()='strblock' or name()='del' or name()='restore'">
	            <xsl:apply-templates select="child::node()" mode="layer">
		      <xsl:with-param name="layer">
		        <xsl:value-of select="$layer"/>
		      </xsl:with-param>
	  	    </xsl:apply-templates>
	          </xsl:when>
	          <xsl:when test="name()='overwrite'">
		    <xsl:apply-templates select="old/node()" mode="layer">
		      <xsl:with-param name="layer">
		        <xsl:value-of select="$layer"/>
		      </xsl:with-param>
	  	    </xsl:apply-templates>
		  </xsl:when>

		  <xsl:otherwise>
		  </xsl:otherwise>
		</xsl:choose> 
              </xsl:otherwise>

	    </xsl:choose>
	</xsl:template>
<xsl:template name="open_layer"><xsl:param name="lay"/><xsl:text disable-output-escaping = "yes">&lt;span class="level</xsl:text><xsl:value-of select="$lay"/><xsl:text disable-output-escaping="yes">"></xsl:text></xsl:template>

<xsl:template name="close_layer"><xsl:text disable-output-escaping = "yes">&lt;/span></xsl:text></xsl:template>

<xsl:template match="//notd">
 <xsl:copy-of select="."/>
</xsl:template>


</xsl:stylesheet>
