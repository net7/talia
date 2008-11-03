function go_to_anchor(name){
    div_name_text = name + '_text';
    div_name_menu = name + '_menu';
    header_height = $('visore').cumulativeOffset ( $('visore')).top 
    // scrolls the text, on the right
    $('visore').scrollTop = $(div_name_text).offsetTop - header_height - 15; // adding 15 pixels helps in presenting it a bit nicer 
    // scrolls the menu, on the left
    $('scroll').scrollTop = $(div_name_menu).offsetTop - header_height;
}

function set_height(){
    var newHeight = document.viewport.getDimensions().height - $('visore').cumulativeOffset ( $('visore')).top  ;
    $('visore').style.height = newHeight - 2 + "px";
    $('scroll').style.height = newHeight - 2 - 10 + "px";
}