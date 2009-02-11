<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output
	method="html"
	indent="yes"
	encoding="UTF-8"
/>
    <xsl:template match="/">
        <html>
            <head>
                <meta http-equiv="content-type" content="text/html;charset=UTF-8"/>
                <link rel="stylesheet" href="/stylesheets/hnml/transcr.css"/>
                <link rel="stylesheet" href="/stylesheets/hnml/linearized_transcription.css"/>
            </head>
            <body>
                <font>
                    <xsl:apply-templates select="/transcription/text" />
                    <xsl:if test="count(//enote) != 0">
                        <hr/>
                        <span class="footnote">
                            <xsl:for-each select="//enote">
                                <span class="fnumber">
                                    <a name="{pos}" href="#{pos}a">
                                        <xsl:value-of select="pos"/>
                                    </a>
                                </span>
                                <xsl:value-of select="corr"/>]
                                <xsl:value-of select="sic"/>
                                <span class="enote">
                                    <xsl:value-of select="note"/>
                                </span>
                                <br/>
                            </xsl:for-each>
                        </span>
                    </xsl:if>
                </font>
            </body>
        </html>
    </xsl:template>
    <xsl:include href="transcription_linear_core_2.xsl"/>
</xsl:stylesheet>
