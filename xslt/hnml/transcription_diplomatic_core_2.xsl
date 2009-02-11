<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output
	method="html"
	indent="yes"
	encoding="UTF-8"
/>



<!--           PAGEOUT          -->


	<xsl:template name="pageout">

	<xsl:for-each select="//pageout">

		<div id="boxadds">
		<a name="{@pos}" href="#{@pos}a"><span class="mark"> <xsl:value-of select="@pos"/>. </span></a>
		<div class="pnumber2"><xsl:value-of select="@page"/></div>
		<xsl:text> </xsl:text>
		<xsl:apply-templates select="node()"/>
		<br/>
		</div>
	</xsl:for-each>
	</xsl:template>




<!--		ADDOUT		-->

	<xsl:template name="addout2">

	<xsl:for-each select="//addout2">

		<div id="boxadds">
		<a name="{@pos}" href="#{@pos}a"><span class="mark"> <xsl:value-of select="@pos"/>. </span></a>
		<div class="pnumber2"><xsl:value-of select="@page"/></div>
		<xsl:text> </xsl:text>
		<xsl:apply-templates select="node()"/>
		<br/>
		</div>
	</xsl:for-each>
	</xsl:template>


<!--   ADDTOP  -->
	<xsl:template name="addtop">

	<xsl:for-each select="//addtop">


		<div id="boxAdds">
		<a name="{@pos}" href="#{@pos}a"><span class="mark"> <xsl:value-of select="@pos"/>. </span></a>
		<div class="pnumber2"><xsl:value-of select="@page"/></div>
		<xsl:text> </xsl:text>
		<xsl:apply-templates select="node()"/>
		<br/>
		</div>
	</xsl:for-each>
	</xsl:template>


<!--		INSMARK		-->

	<xsl:template match="insmark">

	
	<xsl:text> </xsl:text>
		<a name="{@ref}a" href="#{@ref}">
			
			<span class="insmark">
				<xsl:value-of select="@ref"/>
			</span>
	
		</a>

	</xsl:template>



<xsl:template match="* | @*">
<xsl:choose>
 <xsl:when test = "name() = 'addout2' or name() = 'addtop' or name() = 'table_width' or name() = 'pageout' or name() = 'notd'">
 </xsl:when>
 <xsl:otherwise>
  <xsl:copy>
	<xsl:apply-templates select="* | @* | text() "/>
 </xsl:copy>
 </xsl:otherwise>
</xsl:choose>
</xsl:template>



</xsl:stylesheet>





