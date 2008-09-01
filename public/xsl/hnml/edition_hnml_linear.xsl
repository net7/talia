<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:output
	method="xml"
	indent="no"
	encoding="UTF-8"
/>


	<xsl:template match="/">
	<edition>
	 <text>
	 <xsl:apply-templates select="/edition/text"/>
	</text>
	 </edition>
	</xsl:template>



  <xsl:include href="edition_hnml_linear_core.xsl"/>


</xsl:stylesheet>
