// Function called on window resize event
window.onresize = function() {

    // if we're using the pod list navigation, check its vertical height
    if($('pod-list-wrap-mask')) 
        checkVerticalHeightOfPodNavigation();
    
    // if we have a toolbar, set its geometry (from toolbar.js)
    if($('toolbar')) 
        setToolbarGeometry();
    
    // Sets the height of interactive elements
    setElementsVerticalSettings();

} // window.onresize = function() 
 