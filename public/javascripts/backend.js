//= require <prototype>

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
  // SPROCKETIZED
  if(contents = $('contenuti')) {
    // Height of the whole window
    var windowHeight = document.viewport.getDimensions().height;
     // Top position of div content
     var contentPosY = $('contenuti').cumulativeOffset().top;
    contents.style.height = ( windowHeight - contentPosY ) + "px";
  }
}

