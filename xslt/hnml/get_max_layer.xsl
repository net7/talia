<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output
	method="text"
	indent="no"
	encoding="UTF-8"
/>
	<xsl:template match="/">
          <xsl:for-each select="/descendant-or-self::node()[@lay]">
	     <xsl:sort select="number(@lay)" data-type="number"/>
               <xsl:if test="position() = last()"><xsl:value-of select="number(@lay) + 0"/></xsl:if>
	  </xsl:for-each>
        </xsl:template>
</xsl:stylesheet>
