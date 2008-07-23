function setHeight (){
    var newHeight = document.viewport.getDimensions().height - $('visore').cumulativeOffset ( $('visore')).top  ;
    $('visore').style.height = newHeight - 17 + "px";
    $('scroll').style.height = newHeight - 35 + "px";
}
    
function go_to_anchor(name){
    div_name = 'page_' + name;
    $('scroll').scrollTop = $(div_name).offsetTop;
}
    
