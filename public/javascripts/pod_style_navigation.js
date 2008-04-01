// JavaScript Document
// POD NAVIGATION DEVELOPEMENT - very simple!

/* **************************************** */
/* FUNZIONE CHE CANCELLA GLI ATTRIBUTI HREF NELLA NAVIGAZIONE */
/* **************************************** */
/* riceve un array di elementi */
function deleteHrefAttributes(elementi) {
        for(i=0; i<elementi.length; i++) // ciclo su tutti i link con classe ipod
	{
            elementi[i].writeAttribute('href',false);
	}
}
/* **************************************** */

/* **************************************** */
/* FUNZIONI CHE SCRIVONO I SOTTOLIVELLI */
/* **************************************** */
/* un po' di variabili */
var lastNavigationItemClicked;
var lastNavigationItemClickedHtmlContent;
var backLinkName;
var movementEnabled = true; // variabile boolena che controlla se si pu√≤ attivare il movimento o no: 
// quando il movimento √® in corso viene settata come false e non si pu√≤ riativare il movimento
var navigationLevel = 1; /* livello di navigazione attuale, inizialmente ugauale a 1 */

/* ************************************* */
/* NAVIGAZIONE VERSO LIVELLI INFERIORI */
/* ************************************* */
function navigationGoDown(idLiDaModificare)
{
	if(movementEnabled == true)
	{
		movementEnabled = false;
		/* qui ottengo il nome della cosa che deve diventare il back link */
		backLinkName = ($(idLiDaModificare).childElements())[0].innerHTML;
		/* sostituisci il testo del back link, andr√† modificato */ /* qui viene registrato il testo del link su cui sto cliccando, potrebbe servire per il back link */
		backLinkName = backLinkName.stripTags(); // tolgo  la roba html
		backLinkName = backLinkName.truncate(25,'...');
		/*$('backLink_a').innerHTML = backLinkName.truncate(25,'...');*/
		// attacco il pezzo di codice
		lastNavigationItemClicked = idLiDaModificare;
		lastNavigationItemClickedHtmlContent = $(idLiDaModificare).innerHTML;
		
                /* RETRIEVE FROM AJAX */
                // needs some ajax stuff here, AGIUNGO UN ID COSTRUITO CON IL LIVELLO DI NAVIGAZIONE
		// $(idLiDaModificare).insert("<ul id='ipod_nav_level_" + (navigationLevel + 1) + "'><li class=\"ipod_navigation_back_link\"><a class=\"ipodStyle\" href=\"http://www.google.it\" onclick=\"defaultNavigationGoUp();\" title=\"Test Link Number One\">Standard Back Link</a></li><li class=\"ipod_navigation_back_link\"><a class=\"ipodStyle\" href=\"http://www.google.it\" onclick=\"navigationGoUp();\" title=\"Test Link Number One\">Strange Back Link</a></li><li id='test1'><a class='ipodStyle' title='Test Link Number One' onclick='navigationGoDown(\"test1\");'>Link di livello inferiore 1</a></li><li id='test2'><a class='ipodStyle' title='Test Link Number One' onclick='navigationGoDown(\"test2\");'>Link di livello inferiore 2</a></li><li id='test3'><a class='ipodStyle' title='Test Link Number One' onclick='navigationGoDown(\"test3\");'>Link di livello inferiore 3</a></li><li id='test4'><a class='ipodStyle' title='Test Link Number One' onclick='navigationGoDown(\"test4\");'>Link di livello inferiore 4</a></li><li id='test5'><a class='ipodStyle' title='Test Link Number One' onclick='navigationGoDown(\"test5\");'>Link di livello inferiore 5</a></li><li id='test6'><a class='ipodStyle' title='Test Link Number One' onclick='navigationGoDown(\"test6\");'>Link di livello inferiore 6</a></li><li id='test7'><a class='ipodStyle' title='Test Link Number One' onclick='navigationGoDown(\"test7\");'>Link di livello inferiore 7</a></li><li id='test8'><a class='ipodStyle' title='Test Link Number One' onclick='navigationGoDown(\"test8\");'>Link di livello inferiore 8</a></li></ul>");
		// ********        $(idLiDaModificare).insert("<ul id=\"ipod_nav_level_" + (navigationLevel + 1) + "\"><span class=\"ipod_internal_backlinks\"><li class=\"ipod_navigation_back_link\"><a class=\"ipodStyle\" href=\"http://www.google.it\" onclick=\"defaultNavigationGoUp();\" title=\"Test Link Number One\">BACK LINK UNO</a></li><li class=\"ipod_navigation_back_link\"><a class=\"ipodStyle\" href=\"http://www.google.it\" onclick=\"defaultNavigationGoUp();\" title=\"Test Link Number One\">Back Link 2</a></li><li class=\"ipod_navigation_back_link\"><a class=\"ipodStyle\" href=\"http://www.google.it\" onclick=\"defaultNavigationGoUp();\" title=\"Test Link Number One\">Back Link 3</a></li></span><span class=\"ipod_internal_scroll\" ><li id=\"link_aggiunto_1\"><a class=\"ipodStyle\" href=\"http://www.google.it\" onclick=\"navigationGoDown('link_aggiunto_1');\">DOWN LINK 1</a></li><li id=\"link_aggiunto_2\"><a class=\"ipodStyle\" href=\"http://www.google.it\" onclick=\"navigationGoDown('link_aggiunto_2');\">link_aggiunto_2</a></li><li id=\"link_aggiunto_3\"><a class=\"ipodStyle\" href=\"http://www.google.it\" onclick=\"navigationGoDown('link_aggiunto_3');\">link_aggiunto_3</a></li><li id=\"link_aggiunto_4\"><a class=\"ipodStyle\" href=\"http://www.google.it\" onclick=\"navigationGoDown('link_aggiunto_4');\">link_aggiunto_4</a></li> <li id=\"link_aggiunto_5\"><a class=\"ipodStyle\" href=\"http://www.google.it\" onclick=\"navigationGoDown('link_aggiunto_5');\">link_aggiunto_5</a></li><li id=\"link_aggiunto_6\"><a class=\"ipodStyle\" href=\"http://www.google.it\" onclick=\"navigationGoDown('link_aggiunto_6');\">link_aggiunto_6</a></li><li id=\"link_aggiunto_7\"><a class=\"ipodStyle\" href=\"http://www.google.it\" onclick=\"navigationGoDown('link_aggiunto_7');\">link_aggiunto_7</a></li><li id=\"link_aggiunto_8\"><a class=\"ipodStyle\" href=\"http://www.google.it\" onclick=\"navigationGoDown('link_aggiunto_8');\">link_aggiunto_8</a></li></span></ul>");
                 
                /* ma non ci sar√† un problema di posizione ? */ 
                /*$('ipod_nav_level_' + (navigationLevel + 1))
                $('ipod_nav_level_' + (navigationLevel + 1)).select('span.ipod_internal_backlinks')[0]
                $('ipod_nav_level_' + (navigationLevel + 1)).select('span.ipod_internal_scroll ')[0]
                */
                var differenceInTopPosition = $('pod-list-wrap-mask').cumulativeOffset().top - $(idLiDaModificare).ancestors()[1].cumulativeOffset().top;
                
                var dimensioneVerticaleDelBackNavigation = $('ipod_nav_level_' + (navigationLevel + 1)).select('span.ipod_internal_scroll')[0].getHeight();

                $('ipod_nav_level_' + (navigationLevel + 1)).select('span.ipod_internal_scroll')[0].setStyle("margin-top:"+ dimensioneVerticaleDelBackNavigation +"px;");
                
                $('ipod_nav_level_' + (navigationLevel + 1)).setStyle('top:0px;');
                
                
                /* qui dobbbiamo calcolare la posizione top dell'elemento ul creato*/
                
                
                var topMaskMenu = $('pod-list-wrap-mask').cumulativeOffset().top;
                var topElement = $(idLiDaModificare).ancestors()[0].cumulativeOffset().top;
                    
                if(topElement > topMaskMenu)
                {
                    $('ipod_nav_level_' + (navigationLevel + 1)).setStyle('margin-top:-'+ (topElement - topMaskMenu)+'px;');
                }else{
                    $('ipod_nav_level_' + (navigationLevel + 1)).setStyle('margin-top:'+ (topMaskMenu - topElement) +'px;');
                }
                
                /* cancello i dati href dei tag a */
                deleteHrefAttributes($$('a.ipodStyle'));
                // scroll della navigazione verso la valle
		orizontalScrollNavigation('pod-list-wrap-ext',-200);
	}
}

/* ************************************* */
/* BACK NAVIGAZIONE VERSO LIVELLI SUPERIORI */
/* ************************************* */
/* ************************************* */
/* back navigation semplice, torno da dove provengo.
back link di default: si torna indietro esattamente da dove provengo, dall'ul di livello superiore
*/
function defaultNavigationGoUp()
{   
    deleteHrefAttributes($$('a.ipodStyle'));
	if(movementEnabled == true && navigationLevel > 1)
	{
		movementEnabled = false;
		// $(lastNavigationItemClicked).innerHTML = lastNavigationItemClickedHtmlContent;
                var differenza = ($('ipod_nav_level_' + navigationLevel).cumulativeOffset().top -  $('ipod_nav_level_' + (navigationLevel-1)).cumulativeOffset().top);
                // $('ipod_nav_level_' + (navigationLevel-1)).setStyle('margin-top:' + differenza + 'px;'); 
                orizontalScrollNavigation('pod-list-wrap-ext',200);
	}
}

/* complex back link: non torno da dove provendo ma da un nuovo link: devo andare a sostituire l'ul superiore */
function navigationGoUp()
{
    deleteHrefAttributes($$('a.ipodStyle'));
	/* 1. salvare la parte di codeice dell'ultimo livello che poi dovr√† riessere incollata */
	var codeToRemoveAndRepaste;
	codeToRemoveAndRepaste = $('ipod_nav_level_' + navigationLevel);
	
        /* RETRIEVE FROM AJAX */
	// upperLevelCode = "<ul id=\"ipod_nav_level_" + (navigationLevel - 1) + "\"><li id='test1'><a class='ipodStyle' title='Test Link Number One' onclick='navigationGoDown(\"test1\");'>Strange Back Link Numero 1</a></li><li id='test1'><a class='ipodStyle' title='Test Link Number One' onclick='navigationGoDown(\"test1\");'>Strange Back Link Numero 2</a></li></ul>";
	upperLevelCode = "<ul id=\"ipod_nav_level_" + (navigationLevel + 1) + "\"><span class=\"ipod_internal_backlinks\"><li class=\"ipod_navigation_back_link\"><a class=\"ipodStyle\" href=\"http://www.google.it\" onclick=\"defaultNavigationGoUp();\" title=\"Test Link Number One\">BACK LINK UNO</a></li><li class=\"ipod_navigation_back_link\"><a class=\"ipodStyle\" href=\"http://www.google.it\" onclick=\"defaultNavigationGoUp();\" title=\"Test Link Number One\">Back Link 2</a></li><li class=\"ipod_navigation_back_link\"><a class=\"ipodStyle\" href=\"http://www.google.it\" onclick=\"defaultNavigationGoUp();\" title=\"Test Link Number One\">Back Link 3</a></li></span><span class=\"ipod_internal_scroll\" ><li id=\"link_aggiunto_1\"><a class=\"ipodStyle\" href=\"http://www.google.it\" onclick=\"navigationGoDown('link_aggiunto_1');\">LINK NEW 1</a></li><li id=\"link_aggiunto_2\"><a class=\"ipodStyle\" href=\"http://www.google.it\" onclick=\"navigationGoDown('link_aggiunto_2');\">link_aggiunto_2</a></li><li id=\"link_aggiunto_3\"><a class=\"ipodStyle\" href=\"http://www.google.it\" onclick=\"navigationGoDown('link_aggiunto_3');\">link_aggiunto_3</a></li><li id=\"link_aggiunto_4\"><a class=\"ipodStyle\" href=\"http://www.google.it\" onclick=\"navigationGoDown('link_aggiunto_4');\">link_aggiunto_4</a></li> <li id=\"link_aggiunto_5\"><a class=\"ipodStyle\" href=\"http://www.google.it\" onclick=\"navigationGoDown('link_aggiunto_5');\">link_aggiunto_5</a></li><li id=\"link_aggiunto_6\"><a class=\"ipodStyle\" href=\"http://www.google.it\" onclick=\"navigationGoDown('link_aggiunto_6');\">link_aggiunto_6</a></li><li id=\"link_aggiunto_7\"><a class=\"ipodStyle\" href=\"http://www.google.it\" onclick=\"navigationGoDown('link_aggiunto_7');\">link_aggiunto_7</a></li><li id=\"link_aggiunto_8\"><a class=\"ipodStyle\" href=\"http://www.google.it\" onclick=\"navigationGoDown('link_aggiunto_8');\">link_aggiunto_8</a></li></span></ul>";
	/* 2. sostituire il livello superiopre (navigationLevel - 1) */
	$('ipod_nav_level_' + (navigationLevel-1)).replace(upperLevelCode);
	
	/* 3. incollare l'ultimo livello nel punto giusto */
	($('ipod_nav_level_' + (navigationLevel-1)).childElements())[0].insert(codeToRemoveAndRepaste);
	
        deleteHrefAttributes($$('a.ipodStyle'));
         
         /* 4. avvio del movimento */
	orizontalScrollNavigation('pod-list-wrap-ext',200);
}
/* **************************************** */

/* **************************************** */
/* SCROLL FUNCTIONS */
/* **************************************** */
/* variable settings for navigation scroll */
var condition; // condizione che server per il loop del movimento
var posizioneIniziale; // posizione iniziale dell√¨oggetto che si deve muovere
var posizioneFinale; // posizione finale dell'oggetto in movimento
var incremento; // incremento per raggiungere la destinazione del movimento, √® 0 oppure 1 negativo o positivo
var incrementoUnit = 5; // entit√† del movimento: il movimento √® dato da incremento * incrementoUnit
var totalIncrement; // appunto incremento * incrementoUnit
var elementoDaSpostare; // il div che si sposta
var correzioneSpostamento = 0;

function orizontalScrollNavigation(parteDaSpostare,diQuanto) {
        // $('pod-list-wrap-mask').setStyle('overflow: hidden');
        /* movimento, settaggio delle variabili */
   	condition = 1;
	diQuanto -= correzioneSpostamento;
	elementoDaSpostare = $(parteDaSpostare);
         
        /* una piccola ocrrezione di posizionamento */
        var positionDifference = $('pod-list-wrap-mask').cumulativeOffset($('pod-list-wrap-mask')).left;
        positionDifference = 47;
        
        posizioneIniziale = elementoDaSpostare.cumulativeOffset(elementoDaSpostare).left - positionDifference;
        // alert("posizioneIniziale: " + posizioneIniziale + ", diQuanto: " + diQuanto + ", positionDifference: " + positionDifference);
	posizioneFinale = posizioneIniziale + diQuanto;
	if(posizioneIniziale < posizioneFinale)
	{
		incremento = 1;
	}else if(posizioneIniziale > posizioneFinale){
		incremento = -1;
	}else if(posizioneIniziale = posizioneFinale)
	{
		incremento = 0;
	}
	totalIncrement = incremento * incrementoUnit;
        // if(incremento != 0) animateObject();
        if(incremento != 0) new Effect.Move (elementoDaSpostare,{ x: diQuanto, y: 0 , mode: 'relative', duration: 0.5, afterFinish: endOfMovementFunction}); 
}

/* FUNZIONE CHE VIENE CHIAMATA ALL FINE DEL MOVIMENTO DI SCROLL ORIZZONTALE */
function endOfMovementFunction()
{
	if(incremento == -1) /* scorre versa sinistra, va verso livelli pi√π bassi */
	{
		navigationLevel++; /*decremento del vlivello di vavigazione */
	}else if(incremento == 1) /* scorre verso destra, va verso livelli superiori */
	{
		$('ipod_nav_level_' + navigationLevel).remove();
		navigationLevel--; /*decremento del vlivello di vavigazione */
	}
	movementEnabled = true;
	incremento = 0;
	checkVerticalHeightOfPodNavigation();
}
/* **************************************** */

/* ************************************* */
/* GESTIONE DELLE DIMENSIONI VERTICALI E VERTICAL SCROLL */
/* ************************************* */
/* funzione di controllo dell'altezza in verticale del pod style menu al primo caricamento*/
function checkVerticalHeightOfPodNavigation()
{   /* altezza verticale disponibile per tutto il menu */
    var altezzaVerticale = document.viewport.getDimensions().height - $('pod-list-wrap-mask').cumulativeOffset($('pod-list-wrap-mask')).top - 50;
    /* attribuisco 'altezza verticale alla maschera del menu */
    $('pod-list-wrap-mask').setStyle('height: '+ altezzaVerticale +'px');
    /* posizionamento verticale del pulsante scroll */
    $('ipod_scroll_down_button').setStyle('margin-top: ' + altezzaVerticale + 'px');
    /* ri definizione dell'immagine di sfondo per il pulsante scroll */
    $('ipod_scroll_up_button').setStyle('background-image:url(/images/pod_style_navigation/scroll_top_button_deactivated.gif);');
    
    /* definizone dell'altezza verticale per la sottosezione del menu di navigazione */
    // altezzaFinaleDellaMask = altezzaVerticale - $('ipod_nav_level_' + navigationLevel).select('span.ipod_internal_backlinks')[0].getHeight();
    // $('ipod_nav_level_' + navigationLevel).select('span.ipod_internal_scroll')[0].setStyle('height:'+ (altezzaFinaleDellaMask) +'px;');
    /* - */
    
    if($('pod-list-wrap-mask').getHeight() > $('ipod_nav_level_' + navigationLevel).getHeight())
    {
        // $('ipod_scroll_up_button').setStyle('display:none;');
        // $('ipod_scroll_down_button').setStyle('display:none;');
    }else
    {
        $('ipod_scroll_up_button').setStyle('display:block;');
        $('ipod_scroll_down_button').setStyle('display:block;');
    }
}
function scroll_pod_navigation_down()
{   
    /* valore di incremento standard dello scroll, posso anche metterlo fuori tra le altre variabili */
    var incrementoMovimento = $('ipod_nav_level_' + navigationLevel).select('span.ipod_internal_scroll')[0].getHeight(); 
    var maskBottom = $('pod-list-wrap-mask').cumulativeOffset().top + $('pod-list-wrap-mask').getHeight();
    var itemBottom = $('ipod_nav_level_' + navigationLevel).select('span.ipod_internal_scroll')[0].cumulativeOffset().top + $('ipod_nav_level_' + navigationLevel).select('span.ipod_internal_scroll')[0].getHeight();
    var bottomDifference = itemBottom - maskBottom;
    
    if(bottomDifference > 0)
    {
        /* cofigurazione pulsante */
        $('ipod_scroll_up_button').setStyle('background-image:url(/images/pod_style_navigation/scroll_top_button.gif);');
        if(bottomDifference < incrementoMovimento)
        {
            new Effect.Move ($('ipod_nav_level_' + navigationLevel).select('span.ipod_internal_scroll')[0],{ x: 0, y: -bottomDifference, mode: 'relative', duration: 0.3});
            /* cofigurazione pulsante */
            $('ipod_scroll_down_button').setStyle('background-image:url(/images/pod_style_navigation/scroll_bottom_button_deactivated.gif);');
        }else
        {
            new Effect.Move ($('ipod_nav_level_' + navigationLevel).select('span.ipod_internal_scroll')[0],{ x: 0, y: -incrementoMovimento, mode: 'relative', duration: 0.3});
        }
    }
}

function scroll_pod_navigation_up()
{
    var incrementoMovimento = $('ipod_nav_level_' + navigationLevel).select('span.ipod_internal_scroll')[0].getHeight(); /* valore di incremento standare dello scroll, posso anche metterlo fuori tra le altre variabili */
    /* √® necessario fare alcuni controlli: controllare se √® permesso il movimento e di quanto √® permesso */
    /* valori da confrontare */
    var maskTop = $('pod-list-wrap-mask').cumulativeOffset().top + $('ipod_nav_level_' + navigationLevel).select('span.ipod_internal_backlinks')[0].getHeight();
    var itemTop = $('ipod_nav_level_' + navigationLevel).select('span.ipod_internal_scroll')[0].cumulativeOffset().top;
    var topDifference = maskTop - itemTop; /* differenza tra il top della maschera e lo scroll */
    
    if(topDifference > 0)
    {
        /* cofigurazione pulsante */
        $('ipod_scroll_down_button').setStyle('background-image:url(/images/pod_style_navigation/scroll_bottom_button.gif);');
        if(topDifference < incrementoMovimento)
        {
            new Effect.Move ($('ipod_nav_level_' + navigationLevel).select('span.ipod_internal_scroll')[0],{ x: 0, y: topDifference, mode: 'relative', duration: 0.3});
            /* cofigurazione pulsante */
            $('ipod_scroll_up_button').setStyle('background-image:url(/images/pod_style_navigation/scroll_top_button_deactivated.gif);');
        }else
        {
            new Effect.Move ($('ipod_nav_level_' + navigationLevel).select('span.ipod_internal_scroll')[0],{ x: 0, y: incrementoMovimento, mode: 'relative', duration: 0.3});
        }
    }
}


function distributeInternalSpanElements()
{
    var altezzaBackLinkStuff = $('ipod_nav_level_' + navigationLevel).select('span.ipod_internal_backlinks')[0].getHeight();
    /* setto il margin top uguale a quella roba */
    $('ipod_nav_level_' + navigationLevel).select('span.ipod_internal_scroll')[0].setStyle("margin-top: "+altezzaBackLinkStuff+"px");
}

/* **************************************** */
/* ON-LOAD - prototype-style */
/* **************************************** */
document.observe("dom:loaded", function() {
  // CHIAMATA ALLA FUNZIONE CHE ANNULA I LINK HREF TYRADIZIONALI
   deleteHrefAttributes($$('a.ipodStyle'));
   /* posizionamento verticale */
   distributeInternalSpanElements();
   checkVerticalHeightOfPodNavigation();
});
