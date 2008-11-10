function set_height(){
    /* Height of the whole window */
    var windowHeight = document.viewport.getDimensions().height;
    
    $('visore').style.height = windowHeight - $('visore').cumulativeOffset().top + "px";
    $('scroll').style.height = windowHeight - $('scroll').cumulativeOffset().top + "px";
}