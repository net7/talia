// JavaScript Document
// POD NAVIGATION DEVELOPEMENT - very simple!

/* **************************************** */
/* FUNZIONI CHE SCRIVONO I SOTTOLIVELLI */
/* **************************************** */
/* un po' di variabili */
var movementEnabled = true; // variabile boolena che controlla se si pu√≤ attivare il movimento o no:
// quando il movimento √® in corso viene settata come false e non si pu√≤ riativare il movimento
var navigationLevel = 1; /* livello di navigazione attuale, inizialmente ugauale a 1 */

/* ************************************* */
/* NAVIGAZIONE VERSO LIVELLI INFERIORI */
/* ************************************* */
function navigationGoDown(idLiDaModificare)
{
    // idLiDaModificare: è l'elemento li su cui ho cliccato per navigare //'
    /* AJAX ha già provveduto a attaccare il nuovo pezzo di codice */
    if(movementEnabled == true)
    {
        movementEnabled = false;
        
        // configuro la vista a accordion se ce n'è bisogno'
        configureSourcesListAccordion();
        /* POSIZIONAMENTO DEL NUOVO UL CREATO */
        var differenzaPosizioneTopTraElementi = $('ipod_nav_level_' + (navigationLevel + 1)).cumulativeOffset().top - $('pod-list-wrap-mask').cumulativeOffset().top;
        if(differenzaPosizioneTopTraElementi > 0)
        {
            $('ipod_nav_level_' + (navigationLevel + 1)).setStyle('margin-top:-'+ differenzaPosizioneTopTraElementi +'px;');
        }else{
            $('ipod_nav_level_' + (navigationLevel + 1)).setStyle('margin-top:'+ (-differenzaPosizioneTopTraElementi) +'px;');
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
        var differenza = ($('ipod_nav_level_' + navigationLevel).cumulativeOffset().top -  $('ipod_nav_level_' + (navigationLevel-1)).cumulativeOffset().top);
        orizontalScrollNavigation('pod-list-wrap-ext',200);
    }
}

/* complex back link: non torno da dove provendo ma da un nuovo link: devo andare a sostituire l'ul superiore */
/* momentaneamente non utilizzato */
function navigationGoUp()
{
    deleteHrefAttributes($$('a.ipodStyle'));
    /* 1. salvare la parte di codeice dell'ultimo livello che poi dovr√† riessere incollata */
    var codeToRemoveAndRepaste;
    codeToRemoveAndRepaste = $('ipod_nav_level_' + navigationLevel);

    /* RETRIEVE FROM AJAX */
    // upperLevelCode = "<ul id=\"ipod_nav_level_" + (navigationLevel - 1) + "\"><li id='test1'><a class='ipodStyle' title='Test Link Number One' onclick='navigationGoDown(\"test1\");'>Strange Back Link Numero 1</a></li><li id='test1'><a class='ipodStyle' title='Test Link Number One' onclick='navigationGoDown(\"test1\");'>Strange Back Link Numero 2</a></li></ul>";
    upperLevelCode = "<ul id=\"ipod_nav_level_" + (navigationLevel + 1) + "\"><div class=\"ipod_internal_backlinks\"><li class=\"ipod_navigation_back_link\"><a class=\"ipodStyle\" href=\"http://www.google.it\" onclick=\"defaultNavigationGoUp();\" title=\"Test Link Number One\">BACK LINK UNO</a></li><li class=\"ipod_navigation_back_link\"><a class=\"ipodStyle\" href=\"http://www.google.it\" onclick=\"defaultNavigationGoUp();\" title=\"Test Link Number One\">Back Link 2</a></li><li class=\"ipod_navigation_back_link\"><a class=\"ipodStyle\" href=\"http://www.google.it\" onclick=\"defaultNavigationGoUp();\" title=\"Test Link Number One\">Back Link 3</a></li></div><div class=\"ipod_internal_scroll\" ><li id=\"link_aggiunto_1\"><a class=\"ipodStyle\" href=\"http://www.google.it\" onclick=\"navigationGoDown('link_aggiunto_1');\">LINK NEW 1</a></li><li id=\"link_aggiunto_2\"><a class=\"ipodStyle\" href=\"http://www.google.it\" onclick=\"navigationGoDown('link_aggiunto_2');\">link_aggiunto_2</a></li><li id=\"link_aggiunto_3\"><a class=\"ipodStyle\" href=\"http://www.google.it\" onclick=\"navigationGoDown('link_aggiunto_3');\">link_aggiunto_3</a></li><li id=\"link_aggiunto_4\"><a class=\"ipodStyle\" href=\"http://www.google.it\" onclick=\"navigationGoDown('link_aggiunto_4');\">link_aggiunto_4</a></li> <li id=\"link_aggiunto_5\"><a class=\"ipodStyle\" href=\"http://www.google.it\" onclick=\"navigationGoDown('link_aggiunto_5');\">link_aggiunto_5</a></li><li id=\"link_aggiunto_6\"><a class=\"ipodStyle\" href=\"http://www.google.it\" onclick=\"navigationGoDown('link_aggiunto_6');\">link_aggiunto_6</a></li><li id=\"link_aggiunto_7\"><a class=\"ipodStyle\" href=\"http://www.google.it\" onclick=\"navigationGoDown('link_aggiunto_7');\">link_aggiunto_7</a></li><li id=\"link_aggiunto_8\"><a class=\"ipodStyle\" href=\"http://www.google.it\" onclick=\"navigationGoDown('link_aggiunto_8');\">link_aggiunto_8</a></li></div></ul>";
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
    /* movimento, settaggio delle variabili */
    condition = 1;
    diQuanto -= correzioneSpostamento;
    elementoDaSpostare = $(parteDaSpostare);

    /* una piccola ocrrezione di posizionamento */
    var positionDifference = $('pod-list-wrap-mask').cumulativeOffset($('pod-list-wrap-mask')).left;
    positionDifference = 47;

    posizioneIniziale = elementoDaSpostare.cumulativeOffset(elementoDaSpostare).left - positionDifference;
    
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
/* funzione di controllo dell'altezza in verticale del pod style menu al primo caricamento
Viene chiamata all on load e anche sul resize
*/
function checkVerticalHeightOfPodNavigation()
{
    /* altezza verticale disponibile per tutto il menu */
    var margineDelMenuDalFondo = 50;
    var altezzaVerticale = document.viewport.getDimensions().height - $('pod-list-wrap-mask').cumulativeOffset($('pod-list-wrap-mask')).top - margineDelMenuDalFondo;
    /* attribuisco 'altezza verticale alla maschera del menu */
    $('pod-list-wrap-mask').setStyle('height: '+ altezzaVerticale +'px');
    /* posizionamento verticale del pulsante scroll */
    $('ipod_scroll_down_button').setStyle('position:absolute;');
    $('ipod_scroll_down_button').setStyle('margin-top: ' + altezzaVerticale + 'px');
    /* ri definizione dell'immagine di sfondo per il pulsante scroll */
    // $('ipod_scroll_up_button').setStyle('background-image:url(/images/pod_style_navigation/scroll_top_button_deactivated.gif);');

    if($('pod-list-wrap-mask').getHeight() > $('ipod_nav_level_' + navigationLevel).getHeight())
    {
        // $('ipod_scroll_up_button').setStyle('display:none;');
        // $('ipod_scroll_down_button').setStyle('display:none;');
    }else
    {
        // $('ipod_scroll_up_button').setStyle('display:block;');
        // $('ipod_scroll_down_button').setStyle('display:block;');
    }
    
    /* CONTROLLO: DOPO IL RESIZE */
    var fondoMask = $('pod-list-wrap-mask').cumulativeOffset().top + $('pod-list-wrap-mask').getHeight();
    var fondoNavigation = $('ipod_nav_level_' + navigationLevel).getHeight() + $('ipod_nav_level_' + navigationLevel).cumulativeOffset().top;
    if(fondoMask > fondoNavigation && $('ipod_nav_level_' + navigationLevel).getHeight() > $('pod-list-wrap-mask').getHeight())
    {
        var differenza = fondoMask - fondoNavigation;
        $('ipod_nav_level_' + navigationLevel).setStyle("top:" + ((parseInt($('ipod_nav_level_' + navigationLevel).style.top)) + differenza) + "px")
    }
    if($('pod-list-wrap-mask').getHeight() > $('ipod_nav_level_' + navigationLevel).getHeight())
    {
        $('ipod_nav_level_' + navigationLevel).setStyle("top:0px;");
    }
    
    upAndDownButtonsSetup();
}
function scroll_pod_navigation_down()
{
    /* valore di incremento standard dello scroll, posso anche metterlo fuori tra le altre variabili */
    var maskBottom = $('pod-list-wrap-mask').cumulativeOffset().top + $('pod-list-wrap-mask').getHeight();
    var itemBottom = $('ipod_nav_level_' + navigationLevel).cumulativeOffset().top + $('ipod_nav_level_' + navigationLevel).getHeight();
    var bottomDifference = itemBottom - maskBottom;
    var incrementoMovimento = $('pod-list-wrap-mask').getHeight();

    if(bottomDifference > 0)
    {
        /* cofigurazione pulsante */
        if(bottomDifference < incrementoMovimento)
        {
            new Effect.Move ($('ipod_nav_level_' + navigationLevel),{ x: 0, y: -bottomDifference, mode: 'relative', duration: 0.3, afterFinish: upAndDownButtonsSetup});
            /* cofigurazione pulsante */
            // $('ipod_scroll_down_button').setStyle('background-image:url(/images/pod_style_navigation/scroll_bottom_button_deactivated.gif);');
        }else
        {
            new Effect.Move ($('ipod_nav_level_' + navigationLevel),{ x: 0, y: -incrementoMovimento, mode: 'relative', duration: 0.3, afterFinish: upAndDownButtonsSetup});
        }
    }
}

function scroll_pod_navigation_up()
{
    var maskTop = $('pod-list-wrap-mask').cumulativeOffset().top;
    var itemTop = $('ipod_nav_level_' + navigationLevel).cumulativeOffset().top;
    var topDifference = maskTop - itemTop; /* differenza tra il top della maschera e lo scroll */

    var maskBottom = $('pod-list-wrap-mask').cumulativeOffset().top + $('pod-list-wrap-mask').getHeight();
    var incrementoMovimento = maskBottom - maskTop;

    if(topDifference > 0)
    {
        /* cofigurazione pulsante */
        // $('ipod_scroll_down_button').setStyle('background-image:url(/images/pod_style_navigation/scroll_bottom_button.gif);');
        if(topDifference < incrementoMovimento)
        {
            new Effect.Move ($('ipod_nav_level_' + navigationLevel),{ x: 0, y: topDifference, mode: 'relative', duration: 0.3, afterFinish: upAndDownButtonsSetup});
            /* cofigurazione pulsante */
            // $('ipod_scroll_up_button').setStyle('background-image:url(/images/pod_style_navigation/scroll_top_button_deactivated.gif);');
        }else
        {
            new Effect.Move ($('ipod_nav_level_' + navigationLevel),{ x: 0, y: incrementoMovimento, mode: 'relative', duration: 0.3, afterFinish: upAndDownButtonsSetup});
        }
    }
}

function upAndDownButtonsSetup()
{
    $('ipod_scroll_up_button').setStyle("display:block;");
    $('ipod_scroll_down_button').setStyle("display:block;");
        
    if( $('pod-list-wrap-mask').getHeight() > $('ipod_nav_level_' + navigationLevel).getHeight() )
    {
        $('ipod_scroll_up_button').setStyle("background-image:none;");
        $('ipod_scroll_down_button').setStyle("background-image:none;");
    }else
    {
         var fondoMask = $('pod-list-wrap-mask').cumulativeOffset().top + $('pod-list-wrap-mask').getHeight();
         var fondoNavigation = $('ipod_nav_level_' + navigationLevel).getHeight() + $('ipod_nav_level_' + navigationLevel).cumulativeOffset().top;
         
         var topMask = $('pod-list-wrap-mask').cumulativeOffset().top ;
         var topNavigation = $('ipod_nav_level_' + navigationLevel).cumulativeOffset().top;
         
        if( fondoNavigation > fondoMask && topNavigation < topMask )
        {
            $('ipod_scroll_down_button').setStyle("background-image:url(/images/pod_style_navigation/scroll_bottom_button.gif);");
            $('ipod_scroll_up_button').setStyle("background-image:url(/images/pod_style_navigation/scroll_top_button.gif);");
        }else if( fondoNavigation > fondoMask && topNavigation >= topMask )
        {
            $('ipod_scroll_down_button').setStyle("background-image:url(/images/pod_style_navigation/scroll_bottom_button.gif);");
            $('ipod_scroll_up_button').setStyle("background-image:url(/images/pod_style_navigation/scroll_top_button_deactivated.gif);");
        }else if( fondoNavigation <= fondoMask && topNavigation < topMask )
        {
            $('ipod_scroll_down_button').setStyle("background-image:url(/images/pod_style_navigation/scroll_bottom_button_deactivated.gif);");
            $('ipod_scroll_up_button').setStyle("background-image:url(/images/pod_style_navigation/scroll_top_button.gif);");
        }else if( fondoNavigation <= fondoMask && topNavigation >= topMask )
        {
            $('ipod_scroll_down_button').setStyle("background-image:url(/images/pod_style_navigation/scroll_bottom_button_deactivated.gif);");
            $('ipod_scroll_up_button').setStyle("background-image:url(/images/pod_style_navigation/scroll_top_button_deactivated.gif);");
        }
    }
}

/* **************************************** */
/* ON-LOAD - prototype-style */
/* **************************************** */
document.observe("dom:loaded", function() {
    /* SE ESISTE IL CONTENITORE DEL MENU */
    if($('pod-list-wrap-mask')) 
    {
        // CHIAMATA ALLA FUNZIONE CHE ANNULA I LINK HREF TYRADIZIONALI
       deleteHrefAttributes($$('a.ipodStyle'));
       /* posizionamento verticale */
       checkVerticalHeightOfPodNavigation();
       upAndDownButtonsSetup();
       $('ipod_nav_level_' + navigationLevel).setStyle("top:0px");

       /* impostazioni per il disable del javascript */
       $('pod-list-wrap-mask').setStyle('overflow:hidden;')

       /* controllo se esiste il pod navigation */
    }
});

/* **************************************** */
/* SCROLL WHEEL */
/* **************************************** */
// INIZIALIZZAZIONE
if (window.addEventListener)  // MOZILLA
    window.addEventListener('DOMMouseScroll', wheel, false);

// IE / OPERA
window.onmousewheel = document.onmousewheel = wheel;
    
// GESTORE EVENTO "MOVIMENTO ROTELLA"
function wheel(event)
{
    if($('pod-list-wrap-mask')) 
    {
        // Variabile che conterrà la variazione di movimento
        var delta = 0;

        // INTERNET EXPLORER
        if (!event)
            event = window.event;

        // INTERNET EXPLORER E OPERA
        if (event.wheelDelta)
        {
            delta = event.wheelDelta/120;
            // IN OPERA 9 IL SEGNO E' INVERTITO
            if (window.opera)
                delta = -delta;
        }

        // MOZILLA - LUNGA VITA A MOZILLA
        else if (event.detail)
            {
                // DELTA INVERTITO E MULTIPLO DI 3
                delta = -event.detail / 3;
            }

            // SE IL DELTA E' DIVERSO DA ZERO ESEGUE LA FUNZIONE HANDLE
            if (delta)
                handle(delta);

            // BLOCCA SCROLLING IN PAGINE LUNGHE...
            if (event.preventDefault)
                event.preventDefault();

            // RITORNA FALSO
            event.returnValue = false;
      }
}


// GESTIONE EVENTO (RIDIMENSIONAMENTO TESTO)
function handle(delta)
{
    // Dimensioni testo
    var dimensione;
    
    if (delta < 0)
    {
        // SSU
        if( ($('ipod_nav_level_' + navigationLevel).cumulativeOffset().top + $('ipod_nav_level_' + navigationLevel).getHeight()) > $('pod-list-wrap-mask').cumulativeOffset().top + $('pod-list-wrap-mask').getHeight() )
        {
            posizioneAttuale = parseInt($('ipod_nav_level_' + navigationLevel).style.top);
            $('ipod_nav_level_' + navigationLevel).setStyle("top:"+ (posizioneAttuale - 10) +"px");
            upAndDownButtonsSetup();
        }
    }
    else
    {
        // GIU'
        if( ($('ipod_nav_level_' + navigationLevel).cumulativeOffset().top) < $('pod-list-wrap-mask').cumulativeOffset().top )
        {
            posizioneAttuale = parseInt($('ipod_nav_level_' + navigationLevel).style.top);
            $('ipod_nav_level_' + navigationLevel).setStyle("top:"+ (posizioneAttuale + 10) +"px");
            upAndDownButtonsSetup();
        }
    }
}
/* **************************************** */




