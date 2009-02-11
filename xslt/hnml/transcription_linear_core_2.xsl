<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output
	method="html"
	indent="yes"
	encoding="UTF-8"
/>



<!--		ENOTE		-->
    <xsl:template name="enote">
        <xsl:for-each select="//enote">
            <span class="fnumber">
                <a name="{pos}" href="#{pos}a">
                    <xsl:number level="any" count="enote"/>
                </a>
            </span>
            <xsl:apply-templates mode="printall" select="corr"/>]
            <xsl:apply-templates mode="printall" select="sic"/>
            <xsl:text> </xsl:text>
            <xsl:if test="note != ''">
                <span class="enote">
                    <xsl:value-of select="note"/>
                </span>
            </xsl:if>
            <br/>
        </xsl:for-each>
    </xsl:template>
    <xsl:template mode="printall" match="*">
        <xsl:copy-of select="node()"/>
    </xsl:template>
    <xsl:template match="* | @*">
        <xsl:choose>
            <xsl:when test="name() = 'enote' or name() = 'pageout' or name() = 'addout' or name() = 'addtop' or name() = 'table_width' or name() = 'addout2' or name() = 'notd' ">
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy>
                    <xsl:apply-templates select="* | @* | text() "/>
                </xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
</xsl:stylesheet>
