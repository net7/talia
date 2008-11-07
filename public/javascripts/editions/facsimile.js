// Function that sets the height of the side scroll panoramam view
// and the main content on the right
// depending on the size of the window
// This is called onload and on resize o the window
function set_height (){
    /* Height of the whole window */
    var windowHeight = document.viewport.getDimensions().height;
    /* height of the visore object - main pat of thepage where contents are displayed */
    var visoreHeight = windowHeight - $('visore').cumulativeOffset ( $('visore')).top  ;
    
    $('visore').style.height = visoreHeight - 0 + "px";
    $('scroll').style.height = visoreHeight - 15 + "px";

    /* setting other heights */
    /* image big div */
    var image_big_height = windowHeight - $('image_big').cumulativeOffset ( $('image_big')).top  ;
    $('image_big').style.height = image_big_height + "px";

    /* oggetti che contengono il visore flash */
    var array_iipfview = $$('div.iipfview');
    var iipfview_height;
    for(i=0; i < array_iipfview.length; i++) {
        iipfview_height = windowHeight - array_iipfview[i].cumulativeOffset ( array_iipfview[i]).top  ;
        array_iipfview[i].style.height = iipfview_height - 15 + "px";
    }
}
    
function go_to_anchor(name){
    div_name = 'page_' + name;
    $('scroll').scrollTop = $(div_name).offsetTop - 5;
}

// METHOD THAT PLACES THE TOOLBAR IN THE CENTER OF THE DIV ID 'visore'
function centerToolbar(){
  // Let's evaluate how much the left margin must be
  var margin_left_toolbar = ( $('visore').getDimensions().width - $('toolbar').getDimensions().width ) /2 + 'px';
  // Set the css attribute using prototype
  $('toolbar').setStyle({marginLeft: margin_left_toolbar});
}

// LOAD PAGE EVENT
Event.observe(window, 'load', function() {
  if ($('toolbar')) centerToolbar();
  // setThumbsSize($$('div.lonely p a img'));
  setThumbsSize();
});

// RESIZE PAGE EVENT 
window.onresize = function () {
    /* I CALL TRHE FUNCTION THAT SETS VERTICAL DIMENSION FOR DIV ELEMENTS INSIDE THE PAGE */  
    set_height (); 
    /* CALL TO THE FUNCTION THAT CENTERS THE TOOLBAR (IF EXISTS) */
    if ($('toolbar')) centerToolbar();
}
   
// funzione momentanea che forza la dimensione delle thumbnails 120 x 80 px */
function setThumbsSize() {
  var array_thumbs1 = $$('div.block p a img');
  var array_thumbs2 = $$('div.block p.lonely a img')
  var array_full = array_thumbs1.concat(array_thumbs2);
     
  // Scorro tutti gli elementi thumbnail
  // for(i=0; i<array_thumbs.length; i++) {
  for(i=0; i<array_full.length; i++) {
    
    var finalWidth = 80;
    var finalHeight = 120;    
    
    valori = resizeItem(array_full[i], finalWidth, finalHeight);
    array_full[i].writeAttribute("width","" + valori[0]);
    array_full[i].writeAttribute("height","" + valori[1]);
    array_full[i].setStyle({
      marginTop: valori[2] + 'px',
      marginBottom: valori[3] + 'px',
      marginRight: valori[4] + 'px',
      marginLeft: valori[5] + 'px'
    });
  }  
}

// Funzione utilizzata per ridimensionare un oggetto rispetto a due misure date
function resizeItem(itemToResize, maxWidth, maxHeight) {
  // Definition of variables
  var finalMarginLeft;
  var finalMarginRight;     
  var finalMarginTop;  
  var finalMarginBottom;
  var finalWidth;
  var finalHeight;
  var arrayMargins;
  
  // Rapporto iniziale tra i lati
  var ratio = itemToResize.getDimensions().width/itemToResize.getDimensions().height;
                        
  // ridimensionamento dell'oggetto in base alle proporzioni
  // 1. caso 1: si deve adattare il lato verticale. Il lato verticale dell'oggetto deve essere adattato al lato verticale della cornice.
  // L'altro lato va di conseguenza
  if ( ( maxWidth/ maxHeight) > ratio ) {
          // imponiamo il lato verticale dell'oggetto uguale al lato verticale della cornice
          finalHeight =  maxHeight;
          // il lato orizzontale lo correggiamo in base al rapporto tra i lati
          finalWidth = finalHeight * ratio;

          // Define the final margin dimensions
          finalMarginLeft = '' + ( maxWidth - finalWidth )/2;
          finalMarginRight = '' + finalMarginLeft;     
          finalMarginTop = '0';  
          finalMarginBottom = '0';
          
          arrayMargins = new Array(finalWidth, finalHeight, finalMarginTop,finalMarginRight,finalMarginBottom,finalMarginLeft);
  } else {
          // 2. caso 2: si deve adattare il lato orizzontale. Il lato orizzontale dell'oggetto deve essere adattato al lato orizzontale della cornice.
          // L'altro lato va di conseguenza
          // imponiamo il lato verticale dell'oggetto uguale al lato verticale della cornice
          finalWidth =  maxWidth;
          // il lato orizzontale lo correggiamo in base al rapporto tra i lati
          finalHeight = finalWidth / ratio;
          
          // Define the final margin dimensions
          finalMarginLeft = '0';
          finalMarginRight = '0';     
          finalMarginTop = '' + ( maxHeight - finalHeight )/2;
          finalMarginBottom = '' + finalMarginTop;
  }
  arrayMargins = new Array(finalWidth, finalHeight, finalMarginTop,finalMarginRight,finalMarginBottom,finalMarginLeft);
  return arrayMargins;
}// resizeAndCenterItem


