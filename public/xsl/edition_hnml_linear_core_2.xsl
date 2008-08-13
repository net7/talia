<?xml version="1.0" encoding="UTF-8"?>
<!--
 | HyperNietzsche, an E-Research and E-Learning platform                  |

 | For the list of Authors and how to contact them, refer to              |
 | http://www.hndevelopers.org/team.php                                   |
 | or contact us at info@netseven.it                                      |

 | Copyright (C) 2000 - 2004 Net7 s.n.c. di Federico Ruberti and C.       |

 | This file is part of HyperNietzsche.                                   |
 |                                                                        |
 | HyperNietzsche is free software; you can redistribute it and/or modify |
 | it under the terms of the GNU General Public License as published by   |
 | the Free Software Foundation; either version 2 of the License, or      |
 | (at your option) any later version.                                    |
 |                                                                        |
 | HyperNietzsche is distributed in the hope that it will be useful,      |
 | but WITHOUT ANY WARRANTY; without even the implied warranty of         |
 | MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the          |
 | GNU General Public License for more details.                           |
 |                                                                        |
 | You should have received a copy of the GNU General Public License      |
 | along with HyperNietzsche; if not, write to the                        |
 | Free Software Foundation, Inc.,                                        |
 | 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA                |

 | A copy of the GNU General Public License is visible through the web at |
 | http://www.gnu.org/licenses/gpl.txt                                    |
-->

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
	    <xsl:when test="@type = 'withnote'"><div class="app"><span class="fnumber"><a name="{pos}" href="#{pos}a"><xsl:value-of select="pos"/></a></span><xsl:apply-templates mode="printall" select="corr"/><xsl:if test="corr != ''">] </xsl:if><xsl:apply-templates mode="printall" select="sic"/><xsl:text> Erstdruck</xsl:text><xsl:apply-templates mode="printall" select="note"/><br/></div>
	    </xsl:when>
	    <xsl:when test="@type = 'withoutnote'"><span class="fnumber"><a name="{pos}" href="#{pos}a"><xsl:value-of select="pos"/></a></span><span class="enote"><xsl:apply-templates mode="printall" select="note"/></span><br/>
	    </xsl:when>
	    <xsl:when test="@type = 'note'"><span class="mark"><a name="note{@note}" href="#note{@note}a"> <xsl:apply-templates mode="printall" select="mark"/></a></span><span class="note"><xsl:apply-templates mode="printall" select="note"/></span><br/>
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
