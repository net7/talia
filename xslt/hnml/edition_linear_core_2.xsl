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
            <xsl:choose>
                <xsl:when test="@type = 'withnote'">
                    <div class="app">
                        <span class="fnumber">
                            <a name="{pos}" href="#{pos}a">
                                <xsl:value-of select="pos"/>
                            </a>
                        </span>
                        <xsl:apply-templates mode="printall" select="corr"/>
                        <xsl:if test="corr != ''">]
                        </xsl:if>
                        <xsl:apply-templates mode="printall" select="sic"/>
                        <xsl:text> Erstdruck</xsl:text>
                        <xsl:apply-templates mode="printall" select="note"/>
                        <br/>
                    </div>
                </xsl:when>
                <xsl:when test="@type = 'withoutnote'">
                    <span class="fnumber">
                        <a name="{pos}" href="#{pos}a">
                            <xsl:value-of select="pos"/>
                        </a>
                    </span>
                    <span class="enote">
                        <xsl:apply-templates mode="printall" select="note"/>
                    </span>
                    <br/>
                </xsl:when>
                <xsl:when test="@type = 'note'">
                    <span class="mark">
                        <a name="note{@note}" href="#note{@note}a">
                            <xsl:apply-templates mode="printall" select="mark"/>
                        </a>
                    </span>
                    <span class="note">
                        <xsl:apply-templates mode="printall" select="note"/>
                    </span>
                    <br/>
                </xsl:when>
            </xsl:choose>
        </xsl:for-each>
    </xsl:template>
    <xsl:template mode="printall" match="*">
        <xsl:copy-of select="node()"/>
    </xsl:template>
    <xsl:template  match= "* | @*">
        <xsl:choose>
            <xsl:when test="name() = 'text'">
                <xsl:apply-templates select="node()"/>
            </xsl:when>
            <xsl:when test="name() = 'work'">
                <xsl:apply-templates select="node()"/>
            </xsl:when>
            <xsl:when test="name() = 'enote'">
            </xsl:when>
            <xsl:when test="name() = 'note'">
            </xsl:when>
            <xsl:when test="name() = 'notetext'">
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy>
                    <xsl:apply-templates select="* | @* | text() "/>
                </xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
</xsl:stylesheet>
