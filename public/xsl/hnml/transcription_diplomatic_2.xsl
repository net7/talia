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
                <link rel="stylesheet" href="/stylesheets/hnml/diplomatic_transcription.css"/>
            </head>
            <body>
                <xsl:if test="count(//addtop) != 0">
                    <span class="footnote">
                        <xsl:call-template name="addtop"/>
                    </span>
                </xsl:if>
                <xsl:apply-templates select="/transcription/text" />
                <xsl:if test="count(//addout2) != 0">
                    <span class="footnote">
                        <xsl:call-template name="addout2"/>
                    </span>
                </xsl:if>
            </body>
        </html>
    </xsl:template>
<xsl:include href="transcription_diplomatic_core_2.xsl"/>
</xsl:stylesheet>
