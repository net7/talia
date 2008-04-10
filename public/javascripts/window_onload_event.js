/* javascript contenete tutte le funzioni chiamate
quando viene aperta la finestra */

/* **************************************** */
/* ON-LOAD - prototype-style */
/* **************************************** */
/* 1. questo viene chiamato all'inizio */
document.observe("dom:loaded", function() {
    
});


/* 2. questo viene chiamato alla fine */
window.onload = function() {
  /* refers to: toolbar.js */  
  if( $('toolbar')) setToolbarGeometry();
  
  /* refers to: js.js */
  loadFunctionSettings();
}

