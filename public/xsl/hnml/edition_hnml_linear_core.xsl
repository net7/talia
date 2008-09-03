<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output
	method="xml"
	indent="yes"
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


<!--      HEAD     -->
    <xsl:template match="head">
        <span class="head">
            <xsl:apply-templates/>
        </span>
    </xsl:template> 

<!--      PB       -->
    <xsl:template match="pb">
    </xsl:template> 

<!--     P         -->
    <xsl:template match="p">
        <p>
            <xsl:apply-templates/>
        </p>
    </xsl:template>

<!--    HYPHEN     -->
    <xsl:template match="hyphen">
    </xsl:template>

<!--    NDASH      -->
    <xsl:template match="ndash">&#8211;
    </xsl:template>

<!--    LG         -->
    <xsl:template match="lg">
        <p>
            <xsl:apply-templates/>
        </p>
    </xsl:template>

<!--      L        -->
    <xsl:template match="l">
        <xsl:apply-templates/>
        <br/>
    </xsl:template>


<!--     SP        -->
    <xsl:template match="sp">
        <span class="sp">
            <xsl:apply-templates/>
        </span>
    </xsl:template>


<!--     U         -->
    <xsl:template match="u">
        <span class="u">
            <xsl:apply-templates/>
        </span>
    </xsl:template>


<!--     IT        -->
    <xsl:template match="it">
        <span class="it">
            <xsl:apply-templates/>
        </span>
    </xsl:template>

<!--     NOTE     -->
    <xsl:template match="note">
        <xsl:variable name="pos">
            <xsl:number level="any" count="note"/>
        </xsl:variable>
        <a name="note{$pos}a" href="#note{$pos}">
            <span class="mark">
                <xsl:apply-templates select="mark"/>
            </span>
        </a>
        <enote note="{$pos}" type="note">
            <mark>
                <xsl:apply-templates select="mark"/>
            </mark>
            <note>
                <xsl:apply-templates select="notetext"/>
            </note>
        </enote>
    </xsl:template>


<!--	EDITORS  -->
    <xsl:template match="editorS">
        <xsl:apply-templates select="corr"/>
    </xsl:template>

<!-- 	EDITOR	  -->
    <xsl:template match="editor">
        <xsl:variable name="pos">
            <xsl:number level="any" count="//*[(name() =  'editor') or ((name() = 'enote') and (name(parent::node()) != 'editor'))]"/>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="translate(corr, ' ', '') != ''">
                <span class="corr">
                    <xsl:apply-templates select="corr"/>
                </span>
            </xsl:when>
            <xsl:otherwise>
                <span class="sic">
                    <xsl:apply-templates select="sic"/>
                </span>
            </xsl:otherwise>
        </xsl:choose>
        <span class="fnumber">
            <a name="{$pos}a" href="#{$pos}">
                <xsl:value-of select="$pos"/>
            </a>
        </span>
        <enote type="withnote">
            <pos>
                <xsl:value-of select="$pos"/>
            </pos>
            <corr>
                <xsl:apply-templates select="corr"/>
            </corr>
            <sic>
                <xsl:apply-templates select="sic"/>
            </sic>
            <note>
                <xsl:apply-templates select="enote/child::*"/>
                <span class="remark">.
                    <xsl:apply-templates select="enote/text()"/>
                </span>
            </note>
        </enote>
    </xsl:template>


<!--   ENOTE      -->
    <xsl:template match="enote">
        <xsl:variable name="pos">
            <xsl:number level="any" count="enote"/>
        </xsl:variable>
        <span class="fnumber">
            <a name="{$pos}a" href="#{$pos}">
                <xsl:value-of select="$pos"/>
            </a>
        </span>
        <enote type="withoutnote">
            <pos>
                <xsl:value-of select="$pos"/>
            </pos>
            <note>
                <xsl:apply-templates select="node()"/>
            </note>
        </enote>
    </xsl:template>
      

<!--   rdg        -->
    <xsl:template match="rdg">
        <xsl:choose>
            <xsl:when test="translate(@type, ' ', '') != ''">;
                <span class="variant">
                    <xsl:apply-templates/>
                </span>
                <xsl:text> </xsl:text>
                <span class="type">
                    <xsl:value-of select="@type"/>
                    <xsl:text> </xsl:text>
                    <a href="/{@sig}" target="_blank">
                        <xsl:value-of select="@sig"/>
                    </a>
                    <xsl:if test="@hand != ''"> (Hand:
                        <xsl:value-of select="@hand"/>)
                    </xsl:if>
                </span>
            </xsl:when>
            <xsl:otherwise>
                <br/>
                <span class="variant">
                    <xsl:apply-templates/>
                </span>
                <xsl:text> </xsl:text>
                <span class="notype">
                    <a href="/{@sig}" target="_blank">
                        <xsl:value-of select="@sig"/>
                    </a>
                </span>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

<!--  a  -->
    <xsl:template match="a">
        <xsl:copy-of select="."/>
    </xsl:template>
</xsl:stylesheet>
