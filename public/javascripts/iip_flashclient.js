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
function load_iip_flashclient(server, image_path, width, height, element_id) { 
    var so = new SWFObject("/nietzsche/fliip.swf", "iip_flashview", width, height, "6.0.65", "#e0e0e0");
    so.addParam("quality", "high");
    so.addParam("scale", "noscale");
    so.addParam("salign", "tl");
	so.addVariable('iipimageserver', server)
    so.addVariable('FIF', '')
    so.addVariable('iipimagefif', "?fif=" + image_path)
    so.addVariable('iipimagetitle', 'prova')
    so.addVariable('iipimagepixels', '7')
    so.addVariable('iipimagepixelsmeasure', 'cm')
    so.write(element_id);		
}

