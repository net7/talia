<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output
	method="xml"
	indent="no"
	encoding="UTF-8"
/>


<!-- for fabrica:  preview_signature  -->
    <xsl:template match="preview_siglum">
        <p></p>
        <p>
            <br/>
            <font color="red">
                <b>
                    <xsl:value-of select="."/>
                </b>
            </font></p>
        <p></p>
    </xsl:template>



<!--	 	signature	-->
    <xsl:template match="siglum">
        <xsl:param name="layer"/>
        <h3>
            <b>
                <font color="red">
                    <xsl:apply-templates mode="layer">
                        <xsl:with-param name="layer">
                            <xsl:value-of select="$layer"/>
                        </xsl:with-param>
                    </xsl:apply-templates>
                </font>
            </b>
        </h3>
    </xsl:template>

<!--    LG         -->
    <xsl:template match="lg">
        <p>
            <xsl:apply-templates/>
        </p>
    </xsl:template>

<!--      L        -->
    <xsl:template match="l">
        <xsl:param name="layer"/>
        <span class="line">
            <xsl:apply-templates mode="layer">
                <xsl:with-param name="layer">
                    <xsl:value-of select="$layer"/>
                </xsl:with-param>
            </xsl:apply-templates>
        </span>
    </xsl:template>

<!--
<xsl:template match="l"><xsl:param name="layer"/><xsl:apply-templates mode="layer"><xsl:with-param name="layer"><xsl:value-of select="$layer"/></xsl:with-param></xsl:apply-templates><br/></xsl:template>
-->
<!--	       TS 		-->
    <xsl:template match="ts">
        <xsl:param name="layer"/>
        <span class="ts">
            <xsl:apply-templates mode="layer">
                <xsl:with-param name="layer">
                    <xsl:value-of select="$layer"/>
                </xsl:with-param>
            </xsl:apply-templates>
        </span>
    </xsl:template>

<!--            SUP             -->
    <xsl:template match="sup">
        <xsl:param name="layer"/>
        <span class="sup">
            <xsl:apply-templates mode="layer">
                <xsl:with-param name="layer">
                    <xsl:value-of select="$layer"/>
                </xsl:with-param>
            </xsl:apply-templates>
        </span>
    </xsl:template>


<!--		LB		-->
    <xsl:template match="lb">
        <xsl:text> </xsl:text>
    </xsl:template>

<!--		PB		-->

<!--
	<xsl:template match="pb"><hr class="pb"/></xsl:template>
-->
<!--		PB		-->
    <xsl:template match="pb">
        <p class="pb">
            <span class="pb_number">p.&#160;
                <xsl:value-of select="@p"/>
            </span>
        </p>
    </xsl:template>

<!--	       NB		-->
    <xsl:template match="nb">
    </xsl:template>


<!--		HYPHEN 		-->
    <xsl:template match="hyphen">
    </xsl:template>


<!--		LS     		-->
    <xsl:template match="ls">
        <xsl:param name="layer"/>
        <xsl:apply-templates mode="layer">
            <xsl:with-param name="layer">
                <xsl:value-of select="$layer"/>
            </xsl:with-param>
        </xsl:apply-templates>
    </xsl:template>

<!--		GS     		-->
    <xsl:template match="gs">
        <xsl:param name="layer"/>
        <xsl:apply-templates mode="layer">
            <xsl:with-param name="layer">
                <xsl:value-of select="$layer"/>
            </xsl:with-param>
        </xsl:apply-templates>
    </xsl:template>

<!--		GR     		-->
    <xsl:template match="gr">
        <xsl:param name="layer"/>
        <span class="gr">
            <xsl:apply-templates mode="layer">
                <xsl:with-param name="layer">
                    <xsl:value-of select="$layer"/>
                </xsl:with-param>
            </xsl:apply-templates>
        </span>
    </xsl:template>

<!--		BLACK    	       		-->
    <xsl:template match="black">
        <xsl:param name="layer"/>
        <xsl:apply-templates mode="layer">
            <xsl:with-param name="layer">
                <xsl:value-of select="$layer"/>
            </xsl:with-param>
        </xsl:apply-templates>
    </xsl:template>

<!--		blue    	       		-->
    <xsl:template match="blue">
        <xsl:param name="layer"/>
        <xsl:apply-templates mode="layer">
            <xsl:with-param name="layer">
                <xsl:value-of select="$layer"/>
            </xsl:with-param>
        </xsl:apply-templates>
    </xsl:template>

<!--		sepia    	       		-->
    <xsl:template match="sepia">
        <xsl:param name="layer"/>
        <xsl:apply-templates mode="layer">
            <xsl:with-param name="layer">
                <xsl:value-of select="$layer"/>
            </xsl:with-param>
        </xsl:apply-templates>
    </xsl:template>

<!--		purple    	       		-->
    <xsl:template match="purple">
        <xsl:param name="layer"/>
        <xsl:apply-templates mode="layer">
            <xsl:with-param name="layer">
                <xsl:value-of select="$layer"/>
            </xsl:with-param>
        </xsl:apply-templates>
    </xsl:template>

<!--		red    	       		-->
    <xsl:template match="red">
        <xsl:param name="layer"/>
        <xsl:apply-templates mode="layer">
            <xsl:with-param name="layer">
                <xsl:value-of select="$layer"/>
            </xsl:with-param>
        </xsl:apply-templates>
    </xsl:template>

<!--		pencil    	       		-->
    <xsl:template match="pencil">
        <xsl:param name="layer"/>
        <xsl:apply-templates mode="layer">
            <xsl:with-param name="layer">
                <xsl:value-of select="$layer"/>
            </xsl:with-param>
        </xsl:apply-templates>
    </xsl:template>


<!--		redpen    	       		-->
    <xsl:template match="redpen">
        <xsl:param name="layer"/>
        <xsl:apply-templates mode="layer">
            <xsl:with-param name="layer">
                <xsl:value-of select="$layer"/>
            </xsl:with-param>
        </xsl:apply-templates>
    </xsl:template>
		
<!--		bluepen  	       		-->
    <xsl:template match="bluepen">
        <xsl:param name="layer"/>
        <xsl:apply-templates mode="layer">
            <xsl:with-param name="layer">
                <xsl:value-of select="$layer"/>
            </xsl:with-param>
        </xsl:apply-templates>
    </xsl:template>



<!--		redpencil    	       		-->
    <xsl:template match="redpencil">
        <xsl:param name="layer"/>
        <xsl:apply-templates mode="layer">
            <xsl:with-param name="layer">
                <xsl:value-of select="$layer"/>
            </xsl:with-param>
        </xsl:apply-templates>
    </xsl:template>
		
<!--		bluepencil  	       		-->
    <xsl:template match="bluepencil">
        <xsl:param name="layer"/>
        <xsl:apply-templates mode="layer">
            <xsl:with-param name="layer">
                <xsl:value-of select="$layer"/>
            </xsl:with-param>
        </xsl:apply-templates>
    </xsl:template>


<!--		N     			-->
    <xsl:template match="N">
        <xsl:param name="layer"/>
        <xsl:apply-templates mode="layer">
            <xsl:with-param name="layer">
                <xsl:value-of select="$layer"/>
            </xsl:with-param>
        </xsl:apply-templates>
    </xsl:template>

<!-- 		G			-->
    <xsl:template match="G">
        <xsl:param name="layer"/>
        <xsl:apply-templates mode="layer">
            <xsl:with-param name="layer">
                <xsl:value-of select="$layer"/>
            </xsl:with-param>
        </xsl:apply-templates>
    </xsl:template>


<!--		X			-->
    <xsl:template match="X">
        <xsl:param name="layer"/>
        <xsl:apply-templates mode="layer">
            <xsl:with-param name="layer">
                <xsl:value-of select="$layer"/>
            </xsl:with-param>
        </xsl:apply-templates>
    </xsl:template>




<!-- 		U      	        -->
    <xsl:template match="u">
        <xsl:param name="layer"/>
        <span class="u">
            <xsl:apply-templates mode="layer">
                <xsl:with-param name="layer">
                    <xsl:value-of select="$layer"/>
                </xsl:with-param>
            </xsl:apply-templates>
        </span>
    </xsl:template>

<!--		U2     		-->
    <xsl:template match="u2">
        <xsl:param name="layer"/>
        <span class="u2">
            <xsl:apply-templates mode="layer">
                <xsl:with-param name="layer">
                    <xsl:value-of select="$layer"/>
                </xsl:with-param>
            </xsl:apply-templates>
        </span>
    </xsl:template>

<!--		U3     		-->
    <xsl:template match="u3">
        <xsl:param name="layer"/>
        <span class="u3">
            <xsl:apply-templates mode="layer">
                <xsl:with-param name="layer">
                    <xsl:value-of select="$layer"/>
                </xsl:with-param>
            </xsl:apply-templates>
        </span>
    </xsl:template>

<!--		U4     		-->
    <xsl:template match="u4">
        <xsl:param name="layer"/>
        <span class="u4">
            <xsl:apply-templates mode="layer">
                <xsl:with-param name="layer">
                    <xsl:value-of select="$layer"/>
                </xsl:with-param>
            </xsl:apply-templates>
        </span>
    </xsl:template>


<!--            SP              -->
    <xsl:template match="sp">
        <xsl:param name="layer"/>
        <span class="sp">
            <xsl:apply-templates mode="layer">
                <xsl:with-param name="layer">
                    <xsl:value-of select="$layer"/>
                </xsl:with-param>
            </xsl:apply-templates>
        </span>
    </xsl:template>


<!--            IT              -->
    <xsl:template match="it">
        <span class="it">
            <xsl:apply-templates/>
        </span>
    </xsl:template>


<!--	       PRINT 		-->
    <xsl:template match="print">
        <xsl:param name="layer"/>
        <xsl:apply-templates mode="layer">
            <xsl:with-param name="layer">
                <xsl:value-of select="$layer"/>
            </xsl:with-param>
        </xsl:apply-templates>
    </xsl:template>


<!--		ADD		-->
    <xsl:preserve-space elements="add"/>
    <xsl:template match="add">
        <xsl:param name="layer"/>
        <xsl:apply-templates mode="layer">
            <xsl:with-param name="layer">
                <xsl:value-of select="$layer"/>
            </xsl:with-param>
        </xsl:apply-templates>
    </xsl:template>



<!--		 STR   		-->
    <xsl:template match="str">
    </xsl:template>



<!--		ABBR		-->
    <xsl:template match="abbr">
        <span class="expan">
            <xsl:value-of select="@expan"/>
        </span>
    </xsl:template>



<!--		NDASH		-->
    <xsl:template match="ndash">&#8211;
    </xsl:template>

<!--		MDASH		-->
    <xsl:template match="mdash">&#8212;
    </xsl:template>

<!--		P		-->
    <xsl:template match="p">
        <xsl:param name="layer"/>
        <p class="heading">
            <xsl:apply-templates mode="layer">
                <xsl:with-param name="layer">
                    <xsl:value-of select="$layer"/>
                </xsl:with-param>
            </xsl:apply-templates>
        </p>
    </xsl:template>


<!--		DEL		-->
    <xsl:template match="del">
    </xsl:template>
	

<!--		ADDOUT		-->
    <xsl:template match="addout">
        <xsl:param name="layer"/>
        <span class="addout">
            <xsl:apply-templates mode="layer">
                <xsl:with-param name="layer">
                    <xsl:value-of select="$layer"/>
                </xsl:with-param>
            </xsl:apply-templates>
        </span>
    </xsl:template>


<!--            ANNOTATION      -->
    <xsl:template match="ann">
    </xsl:template>


<!--		OVERWRITE	-->
    <xsl:template match="overwrite">
        <xsl:param name="layer"/>
        <xsl:apply-templates mode="layer" select="new/node()">
            <xsl:with-param name="layer">
                <xsl:value-of select="$layer"/>
            </xsl:with-param>
        </xsl:apply-templates>
    </xsl:template>


<!--		JOINT		-->
    <xsl:template match="joint">
    </xsl:template>


<!--	      editorS		-->
    <xsl:template match="editorS">
        <xsl:param name="layer"/>
        <xsl:for-each select="corr">
            <xsl:apply-templates mode="layer" select=".">
                <xsl:with-param name="layer">
                    <xsl:value-of select="$layer"/>
                </xsl:with-param>
            </xsl:apply-templates>
        </xsl:for-each>
    </xsl:template>

<!-- 		EDITOR		-->
    <xsl:template match="editor">
        <xsl:param name="layer"/>
        <xsl:choose>
            <xsl:when test="count (corr) = 0">
                <xsl:apply-templates mode="layer" select="sic/node()">
                    <xsl:with-param name="layer">
                        <xsl:value-of select="$layer"/>
                    </xsl:with-param>
                </xsl:apply-templates>
            </xsl:when>
            <xsl:otherwise>
                <xsl:variable name="pos">
                    <xsl:number level="any" count="editor[(number(@lay) = number($layer)) or (translate(@lay, ' ' ,'') = '' and ( count(corr[number(@lay) = number($layer)]) > 0 or (translate(corr/@lay, ' ', '')='') ) )]"/>
                </xsl:variable>
                <span class="corr">
                    <xsl:for-each select="corr">
                        <xsl:apply-templates mode="layer" select=".">
                            <xsl:with-param name="layer">
                                <xsl:value-of select="$layer"/>
                            </xsl:with-param>
                        </xsl:apply-templates>
                    </xsl:for-each>
                </span>
                <xsl:if test="count(corr[number(@lay) = number($layer) or translate(@lay, ' ','') = '']) > 0">
                    <span class="fnumber">
                        <a name="{$pos}a" href="#{$pos}">
                            <xsl:value-of select="$pos"/>
                        </a>
                    </span>
                    <enote>
                        <pos>
                            <xsl:value-of select="$pos"/>
                        </pos>
                        <corr>
                            <xsl:for-each select="corr">
                                <xsl:apply-templates mode="layer" select=".">
                                    <xsl:with-param name="layer">
                                        <xsl:value-of select="$layer"/>
                                    </xsl:with-param>
                                </xsl:apply-templates>
                            </xsl:for-each>
                        </corr>
                        <sic>
                            <xsl:apply-templates mode="layer" select="sic/node()">
                                <xsl:with-param name="layer">
                                    <xsl:value-of select="$layer"/>
                                </xsl:with-param>
                            </xsl:apply-templates>
                        </sic>
                        <note>
                            <xsl:apply-templates mode="layer" select="enote/node()">
                                <xsl:with-param name="layer">
                                    <xsl:value-of select="$layer"/>
                                </xsl:with-param>
                            </xsl:apply-templates>
                        </note>
                    </enote>
                </xsl:if>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>


<!--		unresolved	-->
    <xsl:template match="unresolved">&#8224;
    </xsl:template>


<!--            PROXY           -->
    <xsl:template match="proxy">
        <xsl:value-of select="@let"/>
    </xsl:template>


<!--		 strBlock	-->
    <xsl:template match="strBlock">
        <xsl:param name="layer"/>
        <xsl:apply-templates mode="layer">
            <xsl:with-param name="layer">
                <xsl:value-of select="$layer"/>
            </xsl:with-param>
        </xsl:apply-templates>
    </xsl:template>


<!--            RESTORE         -->
    <xsl:template match="restore">
        <xsl:param name="layer"/>
        <xsl:apply-templates mode="layer" select="*/node()">
            <xsl:with-param name="layer">
                <xsl:value-of select="$layer"/>
            </xsl:with-param>
        </xsl:apply-templates>
    </xsl:template>


<!--  a  -->
    <xsl:template match="a">
        <xsl:copy-of select="."/>
    </xsl:template>


<!--	layer template   -->
    <xsl:template match="*" mode="layer">
        <xsl:param name="layer"/>
        <xsl:choose>
            <xsl:when test="(number($layer) >= number(@lay)) or (translate(@lay, ' ', '')='') ">
                <xsl:variable name="tmp_layer" select ="@lay"/>
                <xsl:if test="$tmp_layer != ''">
                    <xsl:call-template name="open_layer">
                        <xsl:with-param name="lay">
                            <xsl:value-of select="number(@lay)"/>
                        </xsl:with-param>
                    </xsl:call-template>
                </xsl:if>
                <xsl:choose>
                    <xsl:when test="name() = 'corr'">
                        <xsl:if test="number($layer) = number(@lay) or (translate(@lay ,' ' ,'') = '')">
                            <xsl:text> </xsl:text>
                            <xsl:apply-templates select=".">
                                <xsl:with-param name="layer">
                                    <xsl:value-of select="$layer"/>
                                </xsl:with-param>
                            </xsl:apply-templates>
                        </xsl:if>
                    </xsl:when>
                    <xsl:when test="(name() = 'editor' or name() = 'editorS')">
                        <xsl:if test="number($layer) >= number(@eq)">
                            <xsl:apply-templates mode="layer" select="sic/node()">
                                <xsl:with-param name="layer">
                                    <xsl:value-of select="$layer"/>
                                </xsl:with-param>
                            </xsl:apply-templates>
                        </xsl:if>
                        <xsl:if test="number($layer) &lt;= number(@lsic)">
                            <xsl:apply-templates mode="layer" select="sic/node()">
                                <xsl:with-param name="layer">
                                    <xsl:value-of select="$layer"/>
                                </xsl:with-param>
                            </xsl:apply-templates>
                        </xsl:if>
                        <xsl:if test="number($layer) = number(@lay) or (translate(@lay, ' ', '')='')" >
                            <xsl:apply-templates select=".">
                                <xsl:with-param name="layer">
                                    <xsl:value-of select="$layer"/>
                                </xsl:with-param>
                            </xsl:apply-templates>
                        </xsl:if>
                    </xsl:when>
                    <xsl:when test="name() = 'joint'">
                        <xsl:if test="number($layer) = number(@lay)">
                            <xsl:apply-templates select="node()">
                                <xsl:with-param name="layer">
                                    <xsl:value-of select="$layer"/>
                                </xsl:with-param>
                            </xsl:apply-templates>
                        </xsl:if>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:apply-templates select=".">
                            <xsl:with-param name="layer">
                                <xsl:value-of select="$layer"/>
                            </xsl:with-param>
                        </xsl:apply-templates>
                    </xsl:otherwise>
                </xsl:choose>
                <xsl:if test="$tmp_layer != ''">
                    <xsl:call-template name="close_layer"/>
                </xsl:if>
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
    <xsl:template name="open_layer">
        <xsl:param name="lay"/>
        <xsl:text disable-output-escaping = "yes">&lt;span class="level
        </xsl:text>
        <xsl:value-of select="$lay"/>
        <xsl:text disable-output-escaping="yes">">
        </xsl:text>
    </xsl:template>
    <xsl:template name="close_layer">
        <xsl:text disable-output-escaping = "yes">&lt;/span>
        </xsl:text>
    </xsl:template>
    <xsl:template match="//notd">
        <xsl:copy-of select="."/>
    </xsl:template>
</xsl:stylesheet>
