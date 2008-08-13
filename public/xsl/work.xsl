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
	method="xml"
	indent="yes"
	encoding="UTF-8"
/>
	
	<xsl:template match="/">
  	  <transcription>
	    <text>

	      <xsl:apply-templates select="/edition/text"/>
	    </text>
	  </transcription>
	</xsl:template>



  <xsl:include href="xsl/hnml/work_core.xsl"/>


</xsl:stylesheet>
