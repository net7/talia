/* Toolbar management
 * 
 * The toolbar is that path thingie above the content part. It shows where the 
 * user is navigating and a list of uplinks to broader categories of content.
 * It has a mask of visible content and the real menu which scrolls under it.
 * When the list is longer than the mask, the navigation button are active and
 * it's possible to scroll it to the left and to the right. The page resize
 * is managed here.
 */


// Sets dimension and position of the toolbar
function setToolbarGeometry() {

    // Overwrite css attributes in case the browsers is js-capable
    $('toolbar_mask').setStyle('overflow: hidden;');
    $('toolbar_mask').setStyle('margin:0 18px;');
    $('toolbar_mask').setStyle('width:' + ( document.viewport.getDimensions().width - $('toolbar_mask').cumulativeOffset().left - 45 ) + 'px;');
    $('toolbar').setStyle('border:0;');
    $('scroll_back').setStyle('display:block;');
    $('scroll_forward').setStyle('display:block;');

    // Sets an arbitrary width to the toolbar
    var fullToolbarWidth = 5000;
    $('toolbar').setStyle('width:'+ fullToolbarWidth +'px;');
    
    // modify the last element on the list in order to avoid to show the
    // last separator
    $$('div#toolbar ul li')[$$('div#toolbar ul li').length - 1].setStyle('background-image: none;')
  
    // If the toolbar already exist, just update. Otherwise set it up.
    if ($('toolbar_top')) 
        toolbarGraphicalUpdate(); 
    else
        graphicalToolbarSetUp();
    
} // setToolbarGeometry;

function graphicalToolbarSetUp() {

    // Creation of toolbar's graphical frame through a set of divs
    var s = "<div id=\"toppa_right\"></div>";
    s += "<div id=\"toppa_left\"></div>";
    s += "<div id=\"toolbar_right\"></div>";
    s += "<div id=\"toolbar_bottom\"></div>";
    s += "<div id=\"toolbar_left\"></div>";
    s += "<div id=\"toolbar_top\"></div>";
    s += "<div id=\"toolbar_top_right\"></div>";
    s += "<div id=\"toolbar_bottom_right\"></div>";
    s += "<div id=\"toolbar_bottom_left\"></div>";
    s += "<div id=\"toolbar_top_left\"></div>";

    $('toolbar_mask').insert({after:s});

    // Set up position and dimension of those divs
    toolbarGraphicalUpdate();

} // graphicalToolbarSetUp()

function toolbarGraphicalUpdate() {

    var toolbarRightMargin = 45;

    // graphical corrections for div positioning
    var leftCorr = 18;
    var rightCorr = 11;
    var bottomCorr = 7;
    var scrollBackCorr = 11;
    var scrollFwdCorr = 7;
    var widthCorr = 36;
    
    // Sets toolbar width
    $('toolbar_mask').setStyle('width:' + (document.viewport.getDimensions().width - 
          $('toolbar_mask').cumulativeOffset().left - toolbarRightMargin) + 'px;');
    $('toolbar').setStyle('height:auto;');

    // Doesnt allow the toolbar to reduce its height under 30px
    if ($('toolbar').getHeight() < 30)
        $('toolbar').setStyle('height:30px;');
    
    // Sets position of toolbar's corners
    $('toolbar_top_left').setStyle("top:" +  $('toolbar_mask').cumulativeOffset().top + 
        "px; left:" +  ( $('toolbar_mask').cumulativeOffset().left - leftCorr) + "px;");
    $('toolbar_bottom_left').setStyle("top:" + ( $('toolbar_mask').cumulativeOffset().top + 
        $('toolbar').getHeight() - bottomCorr) + "px; left:" + ( $('toolbar_mask').cumulativeOffset().left - leftCorr) + "px;");
    $('toolbar_bottom_right').setStyle("top:" +  ( $('toolbar_mask').cumulativeOffset().top + 
        $('toolbar').getHeight() - bottomCorr) + "px; left:" +  ( $('toolbar_mask').cumulativeOffset().left + 
        $('toolbar_mask').getWidth() + rightCorr)  + "px;");
    $('toolbar_top_right').setStyle("top:" +  $('toolbar_mask').cumulativeOffset().top + 
        "px; left:" +  ( $('toolbar_mask').cumulativeOffset().left + $('toolbar_mask').getWidth() + rightCorr) + "px;");

    // Sets position and dimensions of toolbar's borders
    $('toolbar_top').setStyle("top:" + ($('toolbar_mask').cumulativeOffset().top) + "px; left:" +
        ($('toolbar_mask').cumulativeOffset().left - leftCorr)+ "px;");
    $('toolbar_top').setStyle("width:" + ($('toolbar_mask').getWidth() + widthCorr) + "px;");
    
    $('toolbar_left').setStyle("top:" +  $('toolbar_mask').cumulativeOffset().top + "px; left:" +
        ($('toolbar_mask').cumulativeOffset().left - leftCorr) + "px;");
    $('toolbar_left').setStyle("height:" + $('toolbar').getHeight() + "px");
    
    $('toolbar_bottom').setStyle("top:" + ( $('toolbar_mask').cumulativeOffset().top + 
        $('toolbar').getHeight() - bottomCorr) + "px; left:" + 
        ($('toolbar_mask').cumulativeOffset().left - leftCorr) + "px;");
    $('toolbar_bottom').setStyle("width:" + ( $('toolbar_mask').getWidth() + widthCorr) + "px;");
    
    $('toolbar_right').setStyle("top:" + $('toolbar_mask').cumulativeOffset().top + 
        "px; left:" +  ( $('toolbar_mask').cumulativeOffset().left + 
        $('toolbar_mask').getWidth() + rightCorr) + "px;");
    $('toolbar_right').setStyle("height:" + $('toolbar').getHeight() + "px");
    
    
    // Sets position of back and forward toolbar's buttons
    $('scroll_back').setStyle("top:" + ( $('toolbar').cumulativeOffset().top + 
        ($('toolbar').getHeight() - $('scroll_back').getHeight())/2 ) + 
        "px; left:" + ( $('toolbar_mask').cumulativeOffset().left - scrollBackCorr) + "px;");
    $('scroll_forward').setStyle("top:" + ( $('toolbar').cumulativeOffset().top + 
        ($('toolbar').getHeight() - $('scroll_back').getHeight())/2 ) + "px; left:" + 
        ($('toolbar_mask').cumulativeOffset().left + $('toolbar_mask').getWidth() - scrollFwdCorr) + "px;");
    

    // Sets position of back and forward toolbar's buttons background
    $('toppa_left').setStyle("top:" + $('toolbar_mask').cumulativeOffset().top + 
        "px; left:" + ( $('toolbar_mask').cumulativeOffset().left - leftCorr) + 
        "px; height:" + $('toolbar').getHeight() + "px;")
    $('toppa_right').setStyle("top:" + $('toolbar_mask').cumulativeOffset().top + 
        "px; left:" + ( $('toolbar_mask').cumulativeOffset().left + 
        $('toolbar_mask').getWidth() - 12) + "px; height:" + $('toolbar').getHeight() + "px;")

    
    // Get the right position of the last li element inside the toolbar, get 
    // the right mask border position, if the diff is > 0, set toolbar left
    // style accordingly
    var lastLi = $$('div#toolbar ul li').last();
    var lastLiRightMargin = lastLi.cumulativeOffset().left + lastLi.getWidth();        
    var toolbarRightMargin = $('toolbar_mask').cumulativeOffset().left + $('toolbar_mask').getWidth();
    var rightDiff = toolbarRightMargin - lastLiRightMargin;
    
    // GIULIO
    if (rightDiff > 0) 
        $('toolbar').setStyle('left:' + (parseInt($('toolbar').style.left) + rightDiff) + 'px;');

    
    // same for left margin
    var firstLi = $$('div#toolbar ul li').first();
    var firstLiLeftMargin = firstLi.cumulativeOffset().left;
    var toolbarLeftMargin = $('toolbar_mask').cumulativeOffset().left;
    var leftDiff = firstLiLeftMargin - toolbarLeftMargin;

    if (leftDiff > 0) 
        $('toolbar').setStyle('left:' + (parseInt($('toolbar').style.left) - leftDiff + 15) + 'px;');
    
    activateToolbarScrollButtons();

} // toolbarGraphicalUpdate()


// Activate or deactivate back and forward toolbar's buttons, depending on the
// toolbar position relative to the toolbar mask. In other words, if for example
// the last element of the toolbar is hidden by the fwd button, activate it. 
function activateToolbarScrollButtons() {

    // Back button
    if ($$('div#toolbar ul li').first().cumulativeOffset().left < ($('toolbar_mask').cumulativeOffset().left + 10)) 
        $$('div#scroll_back a').first().setStyle('background: transparent url(/images/toolbar/toolbar_back_button.gif) top left no-repeat;');
    else
        $$('div#scroll_back a').first().setStyle('background: transparent url(/images/toolbar/toolbar_back_button_deactivated.gif) top left no-repeat;');
    
    // Forward button
    if (($$('div#toolbar ul li').last().cumulativeOffset().left + $$('div#toolbar ul li').last().getWidth()) > ($('toolbar_mask').cumulativeOffset().left + $('toolbar_mask').getWidth() + 10)) 
        $$('div#scroll_forward a')[0].setStyle('background: transparent url(/images/toolbar/toolbar_forward_button.gif) top left no-repeat;');
    else
        $$('div#scroll_forward a')[0].setStyle('background: transparent url(/images/toolbar/toolbar_forward_button_deactivated.gif) top left no-repeat;');

} // activateToolbarScrollButtons()


// These 2 functions get called by toolbar's scroll buttons
function toolbarScrollPrev() {

    // This is used to move right the first shown element, in order to
    // distance it from the toolbar mask margin
    var correction = 15;
    var toolbarMaskLeftMargin = $('toolbar_mask').cumulativeOffset().left + correction;

    /* ciclo tutti gli elementi li e vedo qual'è il primo che esce a dx della mask */
    // Look for the first element (starting from right most one) that is out 
    // of the toolbar mask. Calculate by how many pixels move the toolbar to
    // show it
    var movement = 0;
    for(i=$$('div#toolbar ul li').length-1; i>=0; i--) 
        if($$('div#toolbar ul li')[i].cumulativeOffset().left < toolbarMaskLeftMargin) {
            movement = toolbarMaskLeftMargin - $$('div#toolbar ul li')[i].cumulativeOffset().left;
            break;
        }
    
    // Let's move the toolbar (scriptacolous)
    new Effect.Move ($('toolbar'),{ x: movement, y: 0, mode: 'relative', duration: 0.3, afterFinish: activateToolbarScrollButtons});

} // toolbarScrollPrev()

// Identical to the previous one
function toolbarScrollNext() {
    var correction = 0;

    var toolbarMaskRightMargin = $('toolbar_mask').cumulativeOffset().left + $('toolbar_mask').getWidth() + correction;
    var movement = 0;
    for(i=0; i<$$('div#toolbar ul li').length; i++) 
        if (($$('div#toolbar ul li')[i].cumulativeOffset().left + $$('div#toolbar ul li')[i].getWidth()) > toolbarMaskRightMargin) {
            movement = ( $$('div#toolbar ul li')[i].cumulativeOffset().left + $$('div#toolbar ul li')[i].getWidth() ) - toolbarMaskRightMargin;
            break;
        }
    
    new Effect.Move ($('toolbar'),{ x: -movement, y: 0, mode: 'relative', duration: 0.3, afterFinish: activateToolbarScrollButtons});
} // toolbarScrollNext()