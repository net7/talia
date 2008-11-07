/* 
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

// LOAD PAGE EVENT
Event.observe(window, 'load', function() {
  setContentHeight();
});

// RESIZE PAGE EVENT 
window.onresize = function () {
     setContentHeight();
}

// Set the height of div content from back end
function setContentHeight() {
    // Height of the whole window
    var windowHeight = document.viewport.getDimensions().height;
     // Top position of div content
     var contentPosY = $('contenuti').cumulativeOffset().top;
    $('contenuti').style.height = ( windowHeight - contentPosY ) + "px";
}

