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
    <link rel="stylesheet" href="styles/work.css"/>
    <link rel="stylesheet" href="styles/transcr.css"/>
    <link rel="stylesheet" href="styles/linearized_edition.css"/>
  </head>

  <style type="text/css">
  &lt;!-- 

   #brdBottom {
	border-top-width: thin;
	border-right-width: thin;
	border-bottom-width: thin;
	border-left-width: thin;
	border-bottom-style: dotted;
	border-top-color: #003366;
	border-right-color: #003366;
	border-bottom-color: #003366;
	border-left-color: #003366;
   }

   #LayerNo {
	background-image: url(images/iconeLayers/LNo.gif);
	background-repeat: no-repeat;
	background-position: center center;
   }
   #LayerSi {
	background-image: url(images/iconeLayers/L123.gif);
	background-repeat: no-repeat;
	background-position: center center;
   }
   #linguetta {
	background-image:  url(images/linguette/biancaTr.gif);
	background-repeat: no-repeat;
	background-position: center top;
   }
   #linguetta2 {
	background-image:  url(images/linguette/bluTr.gif);
	background-repeat: no-repeat;
	background-position: center top;
   }

   -->
   </style>



  <body  leftmargin="0" marginheight="0" marginwidth="0" topmargin="0" background="images/sfondo_contributi.gif">
<!--
  <body background="images/sfondo_contributi.gif" leftmargin="0" marginheight="0" marginwidth="0" topmargin="0">

-->


 <table width="95%"  border="0" cellspacing="0" cellpadding="0" align="center" >
        <tr>
          <td>
            <table width="100%"  border="0" align="center" cellpadding="0" cellspacing="0">
              <tr>
                <td background="images/linguette/lineablu.gif">
	          &#160;
                </td>
                <td valign="top" background="images/linguette/lineablu.gif">
	          <table width="300" height="30" border="0" align="center" cellpadding="0" cellspacing="0">
                    <tr class="Verdana10">
                      <td width="60" height="30" id="linguetta2">
		        <center> 
                          <b>
			    <a href="navigate.php?special=edition_hnml&amp;file={//xml_file}&amp;mode=image&amp;material_sigle={//material_sigle}" target="_self">
			      _#_image_#_
			    </a>
			  </b>
                        </center>
                      </td>
                      <td width="60" height="30" id="linguetta2">
	   	        <center>
                          <b>
			    <a href="navigate.php?special=edition_hnml&amp;file={//xml_file}&amp;mode=hnml&amp;material_sigle={//material_sigle}" target="_self">
			      HNML
			    </a>
			  </b>
                        </center>
                      </td>
                      <td width="60" height="30" id="linguetta">
	                <center>
                          <b>
			    <font color="#990000">
			      _#_linear_#_
			    </font>
			  </b>
                        </center>
                      </td>
                      <td width="60" height="30" background="images/linguette/lineablu.gif" id="linguetta2">
	   	        <center>
                          <b>
			    <a href="admin/transcriptions/print_edition.php?mode=linear&amp;file={//xml_file}&amp;sigla={//material_sigle}&amp;layer={//layer}" target="_blank"> 
			      _#_print_#_
			    </a>
			  </b>
                        </center>
                     </td>
                   </tr>
                </table>
	      </td>
              <td background="images/linguette/finaleblu.gif">
	        &#160;
	      </td>
            </tr>



<xsl:if test="//max_layer > 0 and normalize-space(//max_layer) != ''">

            <tr>
              <td background="images/contribution/transcription/latoSX.gif" bgcolor="#FFFFFF">
	        &#160;
	      </td>
              <td valign="top" bgcolor="#FFFFFF">
	        <table width="300" height="30"  border="0" align="center" cellpadding="0" cellspacing="0" id="brdDotBottom">
                <tr class="Verdana10" >
                  <td height="20" width="70">
                    <center>
                      <img src="images/iconeLayers/generica.gif" width="19" height="25" align="absmiddle"/>
		      _#_layers_#_:
                    </center>
                  </td>
                  <td width="55" height="20" id="LayerNo">
		    <div align="CENTER"> 
<xsl:choose>
  <xsl:when test="//layer = 0">
	              <b>
		        <font color="#990000">
 	  	           No
			</font>
	              </b>
  </xsl:when>
  <xsl:otherwise>
	              <a href="navigate.php?special=edition_hnml&amp;file={//xml_file}&amp;mode=linear&amp;material_sigle={//material_sigle}&amp;layer=0" target="_self">
		        No
		      </a>
  </xsl:otherwise>
</xsl:choose>
	            </div>
                  </td>
		  
   <xsl:call-template name="layers">
     <xsl:with-param name="layer">
       1
     </xsl:with-param>
   </xsl:call-template>
    
              </tr>
	    </table>
          </td>
          <td background="images/contribution/transcription/latoDX.gif">
            &#160;
	  </td>

	</tr>
</xsl:if>

        <tr> 
          <td width="20" background="images/contribution/transcription/latoSX.gif" >
            &#160;
          </td>
          <td bgcolor="#FFFFFF">
<br/>


<xsl:apply-templates select="/edition/text"/>


<xsl:if test="count(//enote) != 0">

		<hr/>
		<span class="footnote">
		  <xsl:call-template name="enote"/>
		</span>
</xsl:if>




          </td>
          <td valign="top" bgcolor="#FFFFFF" background="images/contribution/transcription/latoDX.gif">
            &#160; &#160; 
          </td>
        </tr>
        <tr>
          <td width="20" background="images/contribution/transcription/bassoSX.gif" bgcolor="#FFFFFF">
            &#160;
          </td>
          <td height="30"  background="images/contribution/transcription/basso.gif" bgcolor="#FFFFFF">
            &#160;
          </td>
          <td width="25" height="30" background="images/contribution/transcription/bassoDX.gif">
           &#160;
          </td>
        </tr>
      </table>			    
    </td>
  </tr>
  <tr>
    <td>
      <a href="/doc/criteria/index.html" target="_blank">
         _#_criteria_#_
      </a>
    </td>
  </tr>
</table>
		     
 
  </body>

</html>

</xsl:template>



  <xsl:include href="work_core_2.xsl"/>

</xsl:stylesheet>
