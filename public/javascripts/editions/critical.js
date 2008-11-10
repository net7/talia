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
    
    $('visore').style.height = windowHeight - $('visore').cumulativeOffset().top + "px";
    $('scroll').style.height = windowHeight - $('scroll').cumulativeOffset().top + "px";
}