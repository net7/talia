function go_to_anchor(name){
    div_name_text = name + '_text';
    div_name_menu = name + '_menu';
    header_height = $('visore').cumulativeOffset ( $('visore')).top 
    // scrolls the text, on the right
    
    
    /* Generates error: Errore: $(div_name_text) is null */
    /* Just che if it exists */
    if($(div_name_text)) {
      $('visore').scrollTop = $(div_name_text).offsetTop - header_height - 15; // adding 15 pixels helps in presenting it a bit nicer 
    }
    // scrolls the menu, on the left
    if($(div_name_menu)) {
      $('scroll').scrollTop = $(div_name_menu).offsetTop - header_height;
    }     
}

function set_height(){
    /* Height of the whole window */
    var windowHeight = document.viewport.getDimensions().height;
    
    $('visore').style.height = windowHeight - $('visore').cumulativeOffset().top - 20 + "px";
    $('scroll').style.height = windowHeight - $('scroll').cumulativeOffset().top + "px";
}

// LOAD PAGE EVENT
Event.observe(window, 'load', function() {
    // Call to function  that handles collapsing of left side lists
    handleListCollapsing();
});

// Handles opening and closing of open elements in the left-bar list of pages
// The function looks for list items with class "opened"
function handleListCollapsing() {
 for(i=0; i < $$('li.opened').length; i++) {
      var currentElement = $$('li.opened')[i]; 
      // Remove of link href
      // currentElement.setAttribute("href", "javascript:;");  

     var aLinkToDisable = currentElement.firstDescendant();
     aLinkToDisable.writeAttribute({ href: 'javascript:;' });  
        
      Event.observe(currentElement, 'click', function(event) {
        if(this.next().getStyle('display') != 'none') {
          Effect.BlindUp(this.next(), { duration: 0.3 });
        } else {
            Effect.BlindDown(this.next(), { duration: 0.3 });
        }
      });
    }
}





