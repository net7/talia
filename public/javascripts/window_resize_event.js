/* javascript contenete tutte le funzioni chiamate
quando viene ridimensionata la finestra */


window.onresize = function(){
    /* refer to: pod_style_navigation.js */
    if($('pod-list-wrap-mask')) 
    {
        checkVerticalHeightOfPodNavigation();
    }
    
    /* se esiste la toolbar... refers to: toolbar.js */
    if($('toolbar')) 
    {
        setToolbarGeometry();
    }
    
    /* refer to: js.js */
    setElementsVerticalSettings();
}