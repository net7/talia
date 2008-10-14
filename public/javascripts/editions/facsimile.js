function set_height (){
    var newHeight = document.viewport.getDimensions().height - $('visore').cumulativeOffset ( $('visore')).top  ;
    $('visore').style.height = newHeight - 17 + "px";
    $('scroll').style.height = newHeight - 15 + "px";
}
    
function go_to_anchor(name){
    div_name = 'page_' + name;
    $('scroll').scrollTop = $(div_name).offsetTop;
}

// METHOD THAT PLACES THE TOOLBAR IN THE CENTER OF THE DIV ID 'visore'
function centerToolbar(){
  // Let's evaluate how much the left margin must be
  var margin_left_toolbar = ( $('visore').getDimensions().width - $('toolbar').getDimensions().width ) /2 + 'px';
  // Set the css attribute using prototype
  $('toolbar').setStyle({marginLeft: margin_left_toolbar});
}

/* LOAD PAGE EVENT */
Event.observe(window, 'load', function() {
  if ($('toolbar')) centerToolbar();
  setThumbsSize();
});

/* RESIZE PAGE EVENT */
window.onresize = function () {
    /* I CALL TRHE FUNCTION THAT SETS VERTICAL DIMENSION FOR DIV ELEMENTS INSIDE THE PAGE */  
    set_height (); 
    /* CALL TO THE FUNCTION THAT CENTERS THE TOOLBAR (IF EXISTS) */
    if ($('toolbar')) centerToolbar();
}
   
/* funzione momentanea che forza la dimensione delle thumbnails 120 x 80 px */
function setThumbsSize() {
  var array_thumbs = $$('div.block p a img');
  for(i=0; i<array_thumbs.length; i++) {
    array_thumbs[i].writeAttribute("width","80");
    array_thumbs[i].writeAttribute("height","120");
  }  
}
