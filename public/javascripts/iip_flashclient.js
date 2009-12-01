/* 
 * The javascript code to insert the IIP Flash viewer into the page. This
 * depens on the Prototype library
 */

/*
 * Parameters:
 * server - URI for the IIP server
 * image_path - path to the image to show
 * with, height - dimension of the viewer window
 * element_id - the id of html element that will receive the viewer
 */
//function load_iip_flashclient(server, image_path, width, height, element_id) {
//    // TODO: Must be changed to work in subfolder URL
//    var so = new SWFObject("/fliipish.swf", "flashZoomer", width, height, "9", "#e0e0e0");
//    so.addParam("quality", "high");
//    so.addParam("scale", "noscale");
//    so.addParam("salign", "tl");
//    so.addVariable("imgSrc", image_path);
//    so.addVariable("zoomSteps", "3");
//    so.addVariable("imgSrv", server);
//    so.write(element_id);
//}

function load_iip_flashclient(server, image_path, width, height, element_id) {
    // TODO: Must be changed to work in subfolder URL
    var so = new SWFObject("/iipclient.swf", "flashZoomer", width, height, '9', "#e0e0e0");
    so.addParam("movie", "/iipclient.swf");
    so.addParam("zoom_anim_duration", "2");
    so.addParam("quality", "high");
    so.addParam("bgcolor", "#f3f3f3");
    so.addParam("allowScriptAccess", "sameDomain");
    so.addParam("salign", "tl");

    so.addVariable("image_path", image_path);
    so.addVariable("iipserver", server);
    so.addVariable("title", "");
    so.write(element_id);
}
