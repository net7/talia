// This gets called after both html and images are fully loaded
window.onload = function() {

    // If we have a toolbar, set its geometry (from: toolbar.js)
    if($('toolbar'))
        setToolbarGeometry();
    
    // sets up settings for the most important elements of the page
    // (from: mainElementsPositioning.js)
    loadFunctionSettings();

    // builds the accordion for sources list (from: accordion.js)
    // configureSourcesListAccordion();


    // If we're browsing a page with pod navigation :
    if($('pod-list-wrap-mask')) {

       // Strip href attributes from A tags (from: utilities.js)
       deleteHrefAttributes($$('a.ipodStyle'));
       
       // Check vertical alignments of masks, buttons and such
       // (both from: pod_style_navigation.js)
       checkVerticalHeightOfPodNavigation(); 
       upAndDownButtonsSetup();
       $('ipod_nav_level_' + navigationLevel).setStyle("top:0px");
       
       $('pod-list-wrap-mask').setStyle('overflow:hidden;');

    } // if pod-list-wrap-mask
    
} // window.onload = function()


// This gets called AFTER html is loaded but BEFORE all images
// are loaded, useful to call hiding functions 
document.observe("dom:loaded", function() {});
