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
                <link rel="stylesheet" href="stylesheet/hnml/work.css"/>
                <link rel="stylesheet" href="stylesheet/hnml/transcr.css"/>
            </head>
            <body>
                <xsl:apply-templates select="/edition/text"/>
                <xsl:if test="count(//enote) != 0">
                    <hr/>
                    <span class="footnote">
                        <xsl:call-template name="enote"/>
                    </span>
                </xsl:if>
            </body>
        </html>
    </xsl:template>
    <xsl:include href="edition_linear_core_2.xsl"/>
</xsl:stylesheet>
