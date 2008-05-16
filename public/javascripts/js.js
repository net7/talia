// JavaScript Document
/*
obsolete variables.
var ofsTop=290;
var prevOffset =0;
var margin_bottom_menu = 290;
*/

/* *************************** */
/* funzione che imposta le altezze verticali degli
elementi senibili 
Viene azionata in on load e on resize*/
/* *************************** */
function setElementsVerticalSettings()
{
    /* posizionamento dell'elemento bottom menu: menu presente nella sidebar
    che sta allineato in basso */
    var side_bar_top = Element.cumulativeOffset($('side_bar')).top;
    var bottom_menu_lower_space = 0;
    var bottom_menu_margin_top = (document.viewport.getDimensions().height) - side_bar_top - bottom_menu_lower_space - ($('bottom_menu').getDimensions().height);
    $('bottom_menu').setStyle('margin-top: ' + bottom_menu_margin_top + 'px');
    /* ma devo controllare che l'oggetto non vada sopa il menu sotto */
    
    /*
    if(Element.cumulativeOffset($('bottom_menu')).top < (Element.cumulativeOffset($('top_menu')).top + ($('top_menu').getDimensions().height)))
    {
        $('bottom_menu').setStyle('margin-top: ' + (Element.cumulativeOffset($('top_menu')).top + ($('top_menu').getDimensions().height) - Element.cumulativeOffset($('side_bar')).top) + 'px');
    }
    */
    /* settaggio in altezza del div ext_page */
    $('ext_page').setStyle('height: '+document.viewport.getDimensions().height+'px');
    
    /* settaggio in altezza del div side_bar */
    // $('side_bar').setStyle('height: '+(document.viewport.getDimensions().height - Element.cumulativeOffset($('side_bar')).top)+'px');
}

/* funzione per aprire e chiudere la side_bar  element_id -> id dell'elemento da chiudere, classOpen -> il nome della classe css per l'elemento aperto,  classClosed-> il nome della classe css per l'elemento chiuso */
function open_close(element , classOpen, classClosed){
    if(element.hasClassName(classOpen)){
        element.removeClassName(classOpen); 
        element.addClassName(classClosed);
    } else {
        element.removeClassName(classClosed); 
        element.addClassName(classOpen);
    }
}

function switch_class(element , class1, class2){
    if(element.hasClassName(class1)){
        element.removeClassName(class1); 
        element.addClassName(class2);
    } else if(element.hasClassName(class2)){
        element.removeClassName(class2); 
        element.addClassName(class1);
    }
}

window.onscroll= function(){
}

/* *************************** */
/* funzione che dato un elemento della pagina,
ne impone l'altezza fino al fondo della pagina */
/* *************************** */
/* PARAMETRI:
- elementToModify: elemento da essere modificato
- distance, eventuale distanza dal fondo della pagina */
function setHeightTillBottom(elementToModify, distance)
{
    var altezzaFinestra = document.viewport.getDimensions().height;
    if(distance){
    elementToModify.setStyle('height:' + (altezzaFinestra - Element.cumulativeOffset(elementToModify).top - distance) + 'px');
    }else{elementToModify.setStyle('height:' + (altezzaFinestra - Element.cumulativeOffset(elementToModify).top) + 'px');}
}

/* FUNZIONE CARICATA DALl'ON LOAD, IMPOSTA GLI ELEMENTI PRINCIPALI DELLA PAGINA */
function loadFunctionSettings()
{
    $("bottom_menu").style.marginTop = 290 +"px";
    $("top_menu").style.marginTop = 60 +"px";
    setElementsVerticalSettings();
    /* applico al pulsante con id 'sidebar_button' le funzioni per aprire e chiudere side_bar */
   
   $('side_bar_button').onclick=function(){
         // open_close( $$('body')[0], "open", "closed");
         open_close( $('side_bar') , "open", "closed");
         open_close( $('contents_ext'), "open", "closed");
         open_close($('footer'), "open", "closed");
         open_close($('page'), "open", "closed"); /* questo è il body */
        
        /* se la side bar +è aperta, la chiudo */
        if( $('side_bar').getWidth() > 200) /* LA CHIUDO */
        {
            $('side_bar').setStyle('width:43px;');
            $('side_bar').setStyle('background:transparent url(/images/side_bar_icons/side_bar_top_closed.gif) top left no-repeat;');
        
            $('contents_ext').setStyle('margin-left:43px;');
        }else if( $('side_bar').getWidth() < 200) /* LA APRO */
        {
            $('side_bar').setStyle('width:270px;');
            $('side_bar').setStyle('background:transparent url(/images/side_bar_icons/side_bar_top.gif) top left no-repeat;');
            
            $('contents_ext').setStyle('margin-left:270px;');
        }
        
        /* configurazione grafica della toolbar */
        if($('toolbar_top')) graphicalElementsMove();
    }
}

/* **************************************** */
/* FUNZIONE CHE CANCELLA GLI ATTRIBUTI HREF NELLA NAVIGAZIONE */
/* **************************************** */
/* riceve un array di elementi */
function deleteHrefAttributes(elementi)
{
    for(i=0; i<elementi.length; i++) // ciclo su tutti i link con classe ipod
        {
            elementi[i].writeAttribute('href',false);
        }
}
/* **************************************** */


