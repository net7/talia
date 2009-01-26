<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output
	method="xml"
	indent="yes"
	encoding="UTF-8"
/>
    <xsl:template match="/">
        <xsl:param name="layer"/>
        <transcription>
            <text>
                <xsl:for-each select="/transcription/text">
                    <xsl:apply-templates select="node()" mode="layer">
                        <xsl:with-param name="layer">
                            <xsl:value-of select="$layer"/>
                        </xsl:with-param>
                    </xsl:apply-templates>
                </xsl:for-each>
            </text>
            <max_layer>
                <xsl:for-each select="/descendant-or-self::node()[@lay]">
                    <xsl:sort select="number(@lay)" data-type="number"/>
                    <xsl:if test="position() = last()">
                        <xsl:value-of select="number(@lay) + 0"/>
                    </xsl:if>
                </xsl:for-each>
            </max_layer>
        </transcription>
    </xsl:template>

<xsl:include href="transcription_diplomatic_core.xsl"/>
</xsl:stylesheet>
