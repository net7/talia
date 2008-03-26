// JavaScript Document
// POD NAVIGATION DEVELOPEMENT - very simple!

/* TO DO LIST */

/*
- vertical scroll
- gestione del navigation level
*/

/* **************************************** */
/* FUNZIONE CHE CANCELLA GLI ATTRIBUTI HREF NELLA NAVIGAZIONE */
/* **************************************** */
function deleteHrefAttributesInIpodNav() {
        // canecllazione degli attributi
        for(i=0; i<$$('a.ipodStyle').length; i++) // ciclo su tutti i link con classe ipod
	{
            $$('a.ipodStyle')[i].writeAttribute('href',false);
	}
// FIXME
//	defaultBackLinkString = ($('backLink').childElements())[0].innerHTML;
}
/* **************************************** */

/* **************************************** */
/* FUNZIONI CHE SCRIVONO I SOTTOLIVELLI */
/* **************************************** */
/* un po' di variabili */
var lastNavigationItemClicked;
var lastNavigationItemClickedHtmlContent;
var backLinkName;
var movementEnabled = true; // variabile boolena che controlla se si può attivare il movimento o no: 
// quando il movimento è in corso viene settata come false e non si può riativare il movimento
var navigationLevel = 1; /* livello di navigazione attuale, inizialmente ugauale a 1 */
var defaultBackLinkString;

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
		/* sostituisci il testo del back link, andrà modificato */ /* qui viene registrato il testo del link su cui sto cliccando, potrebbe servire per il back link */
		backLinkName = backLinkName.stripTags(); // tolgo  la roma html
		backLinkName = backLinkName.truncate(25,'...');
		/*$('backLink_a').innerHTML = backLinkName.truncate(25,'...');*/
		// attacco il pezzo di codice
		lastNavigationItemClicked = idLiDaModificare;
		lastNavigationItemClickedHtmlContent = $(idLiDaModificare).innerHTML;
		
                 /* FROM AJAX */
                // needs some ajax stuff here, AGIUNGO UN ID COSTRUITO CON IL LIVELLO DI NAVIGAZIONE
		$(idLiDaModificare).insert("<ul id='ipod_nav_level_" + (navigationLevel + 1) + "'><li id='test1'><a class='ipodStyle' title='Test Link Number One' onclick='navigationGoDown(\"test1\");'>Link di livello inferiore 1</a></li><li id='test2'><a class='ipodStyle' title='Test Link Number One' onclick='navigationGoDown(\"test2\");'>Link di livello inferiore 2</a></li></ul>");
		
                 // scroll della navigazione verso la valle
		scrollNavigation('pod-list-wrap-ext',-200);
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
	if(movementEnabled == true && navigationLevel > 1)
	{
		movementEnabled = false;
		// $(lastNavigationItemClicked).innerHTML = lastNavigationItemClickedHtmlContent;
		scrollNavigation('pod-list-wrap-ext',200);
	}
}

/* complex back link: non torno da dove provendo ma da un nuovo link: devo andare a sostituire l'ul superiore */
function navigationGoUp()
{
	/* 1. salvare la parte di codeice dell'ultimo livello che poi dovrà riessere incollata */
	var codeToRemoveAndRepaste;
	codeToRemoveAndRepaste = $('ipod_nav_level_' + navigationLevel);
	
        /* FROM AJAX */ 
	upperLevelCode = "<ul id=\"ipod_nav_level_" + (navigationLevel - 1) + "\"><li id='test1'><a class='ipodStyle' title='Test Link Number One' onclick='navigationGoDown(\"test1\");'>Strange Back Link Numero 1</a></li><li id='test1'><a class='ipodStyle' title='Test Link Number One' onclick='navigationGoDown(\"test1\");'>Strange Back Link Numero 2</a></li></ul>";
	
	/* 2. sostituire il livello superiopre (navigationLevel - 1) */
	$('ipod_nav_level_' + (navigationLevel-1)).replace(upperLevelCode);
	
	/* 3. incollare l'ultimo livello nel punto giusto */
	($('ipod_nav_level_' + (navigationLevel-1)).childElements())[0].insert(codeToRemoveAndRepaste);
	
         /* 4. avvio del movimento */
	scrollNavigation('pod-list-wrap-ext',200);
}
/* **************************************** */

/* **************************************** */
/* SCROLL FUNCTIONS */
/* **************************************** */
/* variable settings for navigation scroll */
var condition; // condizione che server per il loop del movimento
var posizioneIniziale; // posizione iniziale dellìoggetto che si deve muovere
var posizioneFinale; // posizione finale dell'oggetto in movimento
var incremento; // incremento per raggiungere la destinazione del movimento, è 0 oppure 1 negativo o positivo
var incrementoUnit = 5; // entità del movimento: il movimento è dato da incremento * incrementoUnit
var totalIncrement; // appunto incremento * incrementoUnit
var elementoDaSpostare; // il div che si sposta
var correzioneSpostamento = 8;

function scrollNavigation(parteDaSpostare,diQuanto) {
    
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
	posizioneFinale = posizioneIniziale +  diQuanto;
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
	if(incremento != 0) animateObject();
}

function animateObject() /* animazione vera e propria */
{
	posizioneIniziale = posizioneIniziale + totalIncrement;
	if (condition == 1) {
		elementoDaSpostare.style.left = posizioneIniziale + 'px';
		setTimeout('animateObject()',1);
	} else {
		elementoDaSpostare.style.left = posizioneFinale + 'px';
		endOfMovementFunction();
	}
	if(incremento == 1)
	{
		if(posizioneIniziale >= posizioneFinale) {condition = 0; } 
		
	}else if(incremento == -1)
	{
		if(posizioneIniziale <= posizioneFinale) {condition = 0;} 
	}
}

function endOfMovementFunction()
{
	if(incremento == -1) /* scorre versa sinistra, va verso livelli più bassi */
	{
		navigationLevel++; /*decremento del vlivello di vavigazione */
	}else if(incremento == 1) /* scorre verso destra, va verso livelli superiori */
	{
		$('ipod_nav_level_' + navigationLevel).remove();
		navigationLevel--; /*decremento del vlivello di vavigazione */
	}
	movementEnabled = true;
	incremento = 0;
	configureBackLink();
        checkVerticalHeightOfPodNavigation();
}
/* **************************************** */

/* **************************************** */
/* FUNZIONE CHE CONFIGURA IL BACK LINK */
/* **************************************** */
function configureBackLink()
{
	/* OPERAZIONE AGGIUNTIVA: quando siamo al livello 1 agigungo l'li NAVIGAZIONE, il default preso all'inizio dal codice */
	
	/* FROM AJAX */
	backLinksArray = new Array();
        backLinksArray[0]="<span>TITOLO</span>";
        backLinksArray[1]="<a onclick=\"defaultNavigationGoUp();\" href=\"#\">Go Back Where U Came From</a>"; /* stringa in arrivo per il go back where u came from */
	backLinksArray[2]="<a onclick=\"navigationGoUp();\" href=\"#\">Go Somewhere else</a>"; /* altre stringhe per altri back link */
	backLinksArray[3]="<span>Testo senza link</span>";
        backLinksArray[4]="<a onclick=\"navigationGoUp();\" href=\"#\">Go in another place</a>";
	
	var htmlToInsert = "";
	
        /* solo se voglio mettere la scritta 'Navigazione' o simili n testa al livello di navigazione 1 */ 
	// htmlToInsert += defaultBackLinkString;
	/* solo se voglio mettere la scritta 'Navigazione' o simili n testa al livello di navigazione 1 */ 
         
         for(j=0; j<backLinksArray.length; j++)
	{
             /* nel caso in cui il link contenga la chiamata all funzione di default go back */
		if(j != (backLinksArray.length-1)) /* ...se non è l'ultimo... */
                {
                    htmlToInsert += "<li class=\"backLinkItem\" id=\"ipod_backlink_" + (j+1) + "\">" + backLinksArray[j] + "</li>";
                }else{ /*... se è l'ultimo ... */
                    htmlToInsert += "<li id=\"ipod_backlink_" + (j+1) + "\">" + backLinksArray[j] + "</li>";
                }
	}
        /* inserimento del codice generato dentro il DIV */ 
	($('backLink').childElements())[0].innerHTML = htmlToInsert;
	
	/* se sono al livello di navigazione uno mostro il default li dove c'è scritto NAVIGAZIONe */
        /* solo se voglio mettere la scritta 'Navigazione' o simili n testa al livello di navigazione 1 */ 
	/*
         if(navigationLevel == 1)
	{
	}else
	{
		$('ipod_backlink_default').remove();
	}
        */ 
}
/* **************************************** */

/* ************************************* */
/* GESTIONE DELLE DIMENSIONI VERTICALI E VERTICAL SCROLL */
/* ************************************* */
/* funzione di controllo dell'altezza in verticale del pod style menu al primo caricamento*/
function checkVerticalHeightOfPodNavigation()
{
// FIXME
/*
    var altezzaVerticale = document.viewport.getDimensions().height - $('pod-list-wrap-mask').cumulativeOffset($('pod-list-wrap-mask')).top - 50;
    $('pod-list-wrap-mask').setStyle('height: '+ altezzaVerticale +'px');
    $('ipod_scroll_down_button').setStyle('margin-top: ' + altezzaVerticale + 'px');
    
    $('ipod_scroll_down_button').setStyle('background-image:url(/images/pod_style_navigation/scroll_bottom_button_deactivated.gif);');
    
    if($('pod-list-wrap-mask').getHeight() > $('ipod_nav_level_' + navigationLevel).getHeight())
    {
        $('ipod_scroll_up_button').setStyle('display:none;');
        $('ipod_scroll_down_button').setStyle('display:none;');
    }else
    {
        $('ipod_scroll_up_button').setStyle('display:block;');
        $('ipod_scroll_down_button').setStyle('display:block;');
    }
*/
}

function scroll_pod_navigation_up(item)
{
    var incrementoMovimento = $('pod-list-wrap-mask').getHeight(); /* valore di incremento standare dello scroll, posso anche metterlo fuori tra le altre variabili */
    var maskBottom = $('pod-list-wrap-mask').cumulativeOffset($('pod-list-wrap-mask')).top + $('pod-list-wrap-mask').getHeight();
    var itemBottom = $(item).cumulativeOffset($(item)).top + $(item).getHeight();
    var bottomDifference = itemBottom - maskBottom; /* differenza tra il top della maschera e lo scroll */
    if(bottomDifference > 0)
    {
        $('ipod_scroll_down_button').setStyle('background-image:url(/images/pod_style_navigation/scroll_bottom_button.gif);');
        if(bottomDifference < incrementoMovimento)
        {
            new Effect.Move ($(item),{ x: 0, y: -bottomDifference, mode: 'relative'});
            $('ipod_scroll_up_button').setStyle('background-image:url(/images/pod_style_navigation/scroll_top_button_deactivated.gif);');
        }else
        {
            new Effect.Move ($(item),{ x: 0, y: -incrementoMovimento, mode: 'relative'});
        }
    }
}
function scroll_pod_navigation_down(item)
{
    var incrementoMovimento = $('pod-list-wrap-mask').getHeight(); /* valore di incremento standare dello scroll, posso anche metterlo fuori tra le altre variabili */
    /* è necessario fare alcuni controlli: controllare se è permesso il movimento e di quanto è permesso */
    /* valori da confrontare */
    var maskTop = $('pod-list-wrap-mask').cumulativeOffset($('pod-list-wrap-mask')).top;
    var itemTop = $(item).cumulativeOffset($(item)).top;
    var topDifference = maskTop - itemTop; /* differenza tra il top della maschera e lo scroll */
    
    if(topDifference > 0)
    {
        $('ipod_scroll_up_button').setStyle('background-image:url(/images/pod_style_navigation/scroll_top_button.gif);');
        if(topDifference < incrementoMovimento)
        {
            new Effect.Move ($(item),{ x: 0, y: topDifference, mode: 'relative'});
             $('ipod_scroll_down_button').setStyle('background-image:url(/images/pod_style_navigation/scroll_bottom_button_deactivated.gif);');
        }else
        {
            new Effect.Move ($(item),{ x: 0, y: incrementoMovimento, mode: 'relative'});
        }
    }
    
}

/* **************************************** */
/* ON-LOAD - prototype-style */
/* **************************************** */
document.observe("dom:loaded", function() {
  // CHIAMATA ALLA FUNZIONE CHE ANNULA I LINK HREF TYRADIZIONALI
  deleteHrefAttributesInIpodNav();
  checkVerticalHeightOfPodNavigation();
});

