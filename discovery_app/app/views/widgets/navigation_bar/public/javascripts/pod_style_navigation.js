/* Pod-style menu
 * 
 * All the functions to make it work are here. Movements, animations,
 * load and unload of menu lists.
 * The structures gets initialized in window_onload_event.js
 *  
 * Basically there's a mask (a box) which contains the visible part of the menu,
 * which scrolls under it and get hidden when outside its bounds. With buttons
 * and mouse wheel the user can scroll the menu elements up and down.
 * Clicking on a menu element will create a new AJAX request that downloads
 * the new menu's contents, and initialize a new menu structure. This new 
 * structure get positioned to the right of the old menu (we are going DOWN the 
 * navigation tree) or to the left (we are going UP, or back) initially hidden.
 * An animation will scroll bot old and new menus in the right direction.
 */


// Bool variable to stop animation if there's already one going on. If
// there's an animation it will be false
var movementEnabled = true; 

// This is the current level of the pod navigation. 1 is the first level, when
// you click on a subcategory you go on level 2, and so on
var navigationLevel = 1; 

// Extension of the pod navigation animation movement. Basically it's the
// pod menu width, pixels
var movementExtent = 200;

// Enum to know where are we going to:
// DOWN: we go right, down the tree, UP: we go left, up the tree
var movDirection = {UP: 0, DOWN: 1};

// Menu bottom margin from the bottom of the page, pixels
var menuBottomMargin = 50;

// When clicking on the menu vertical scroll buttons, the menu elements
// will get moved under the mask by an amount of pixel given 
// by mask.height * movPercentage
var movPercentage = 70/100;


// Minimum amount of pixel moved by a single wheel event inside the mask
var minMovement = 10;



// This function gets called when AJAX has already taken the content
// of the next level of navigation. The user clicked on an li element with
// id 'clickedLi'.
function navigationGoDown(clickedLi) {
   
    if (movementEnabled == true) {

        // Stop animations
        movementEnabled = false;
        
        // NOTE: this should be called outside this function, directly after
        // AJAX completed the request, maybe in ruby code?
        // configureSourcesListAccordion();

        // When we click on a pod element, the list of elements is partially
        // hidden by the pod mask. If the first element shown is not the real first
        // element of the list, we should calculate this offset and load the next
        // level of menu aligned with the mask and not with the parent list first
        // element (currently hidden, above the mask)
        var offset = $('ipod_nav_level_' + (navigationLevel + 1)).cumulativeOffset().top - 
            $('pod-list-wrap-mask').cumulativeOffset().top;

        // offset>0: means that the next level got loaded below the mask
        // top margin: we need to move it up, giving a negative margin-top.
        // offset<0: default case where the next level is loaded above
        // the top margin of the mask, use a positive margin-top
        // This is here since some browsers loads the next menu level at the same
        // y coord where we clicked, some others at the y coord of the
        // upper margin of the real list (usually out of the mask)
        if (offset > 0) {
            $('ipod_nav_level_' + (navigationLevel + 1)).setStyle('margin-top:-'+ offset +'px;');
            // This helps to avoid a problem with scrolling right after moving the
            // menu down by one level
            $('ipod_nav_level_' + (navigationLevel + 1)).setStyle('top: 0px;');
        } else { 
            $('ipod_nav_level_' + (navigationLevel + 1)).setStyle('margin-top:'+ (-offset) +'px;');
            $('ipod_nav_level_' + (navigationLevel + 1)).setStyle('top: 0px;');
        }

        // Strip href attribute from A tags
        deleteHrefAttributes($$('a.ipodStyle'));
        
        // Do the animation!
        horizontalScrollNavigation(movDirection.DOWN);

    } // if movementEnabled
} // navigationGoDown()


// NOTE: for now it just go back to the original previous menu elements. 
// If we want to change it trought an AJAX or something, maybe we'll need 
// to calculate some offset like in navigationGoDown()
function navigationGoUp() {

    // Strip href attribute from A tags
    deleteHrefAttributes($$('a.ipodStyle'));

    if (movementEnabled == true && navigationLevel > 1) {
        // Stop other animations and do the current one
        movementEnabled = false;
        horizontalScrollNavigation(movDirection.UP);
    }

} // navigationGoUp()


// This function do the animation in the given direction
function horizontalScrollNavigation(direction) {

    // If we're going down the menu has to move in left direction, so we need
    // a negative movementExtent
    var realMovementExtent = 0;

    // Function that will be called after the animation ends... we need
    // 2 functions since we cant pass a parameter
    var afterFunction;
    if (direction == movDirection.UP) {
        realMovementExtent = movementExtent;
        afterFunction = endOfMovementFunctionUp;
    } else if (direction == movDirection.DOWN) {
        realMovementExtent = -movementExtent;
        afterFunction = endOfMovementFunctionDown;
    }

    new Effect.Move ($('pod-list-wrap-ext'), { x: realMovementExtent, y: 0 , mode: 'relative', duration: 0.5, afterFinish: afterFunction});

} // horizontalScrollNavigation()

// This function get called by Scriptacolous at the end of the scrolling
// animations.
function endOfMovementFunctionUp() {
    // Remove the hidden menu elements
    $('ipod_nav_level_' + navigationLevel).remove();

    // Sets the nav elements and re-enables animations
    navigationLevel--;
    movementEnabled = true;

    // Check the menu to look right
    checkVerticalHeightOfPodNavigation();
} // endOfMovementFunctionDown()

function endOfMovementFunctionDown() {
    navigationLevel++;
    movementEnabled = true;
    checkVerticalHeightOfPodNavigation();
} // endOfMovementFunctionDown()

// Sets position and dimensions of mask and current menu in case
// of resize and movement. Various consistency checks for the menu 
// and its buttons
function checkVerticalHeightOfPodNavigation() {

    // Real height of the menu, pixels
    var menuHeight = document.viewport.getDimensions().height - 
        $('pod-list-wrap-mask').cumulativeOffset($('pod-list-wrap-mask')).top - 
        menuBottomMargin;

    $('pod-list-wrap-mask').setStyle('height: '+ menuHeight +'px');

    // Positioning of the bottom scroll button
    $('ipod_scroll_down_button').setStyle('position:absolute;');
    $('ipod_scroll_down_button').setStyle('margin-top: ' + menuHeight + 'px');

    // currentMenu is the container of the current UL menu element
    // mask is the outer mask of the pod navigation menu
    var currentMenu = $('ipod_nav_level_' + navigationLevel);
    var mask = $('pod-list-wrap-mask');

    // Bottom y coordinate of menu and mask
    var menuBottom = currentMenu.getHeight() + currentMenu.cumulativeOffset().top;
    var maskBottom = mask.cumulativeOffset().top + mask.getHeight();

    // If mask is bigger than menu, align the menu with the mask's top
    if(mask.getHeight() > currentMenu.getHeight()) 
        currentMenu.setStyle("top:0px;");
  
    // If menu is bigger than mask, and their bottom borders are not aligned,
    // force them to be aligned 
    if (maskBottom > menuBottom && currentMenu.getHeight() > mask.getHeight()) {
        var offset = maskBottom - menuBottom;
        currentMenu.setStyle("top:" + ((parseInt(currentMenu.style.top)) + offset) + "px")
    }

    upAndDownButtonsSetup();

} // checkVerticalHeightOfPodNavigation()


// Called by clicking the down button on the pod navigation menu
function scrollPodNavigationDown() {

    var maskBottom = $('pod-list-wrap-mask').cumulativeOffset().top + $('pod-list-wrap-mask').getHeight();
    var menuBottom = $('ipod_nav_level_' + navigationLevel).cumulativeOffset().top + $('ipod_nav_level_' + navigationLevel).getHeight();

    // Distance from bottom of the mask and bottom of the current menu. Is
    // zero if they are bottom aligned and we can return
    var bottomDifference = menuBottom - maskBottom;

    if (bottomDifference <= 0)
      return;
  
    // In a normal case we scroll down one page of the menu, actually not
    // an entire page but a fraction of it due to movPercentage
    var movementAmount = Math.round($('pod-list-wrap-mask').getHeight() * movPercentage);

    // We move the current menu by an amount that is the smallest
    // between the difference between coordinates of mask and menu and
    // the size of the mask*movPercentage
    var realMovement = Math.min(bottomDifference, movementAmount);

    // Do the animation
    new Effect.Move ($('ipod_nav_level_' + navigationLevel), { x: 0, y: -realMovement, mode: 'relative', duration: 0.3, afterFinish: upAndDownButtonsSetup});

} // scrollPodNavigationDown()

// Same as scrollPodNavigationDown()
function scrollPodNavigationUp() {

    var maskTop = $('pod-list-wrap-mask').cumulativeOffset().top;
    var menuTop = $('ipod_nav_level_' + navigationLevel).cumulativeOffset().top;

    var topDifference = maskTop - menuTop; 

    if (topDifference <= 0)
        return;
    
    var movementAmount = Math.round($('pod-list-wrap-mask').getHeight() * movPercentage);
    var realMovement = Math.min(topDifference, movementAmount);

    new Effect.Move ($('ipod_nav_level_' + navigationLevel), { x: 0, y: realMovement, mode: 'relative', duration: 0.3, afterFinish: upAndDownButtonsSetup});

} // scrollPodNavigationUp()

function upAndDownButtonsSetup() {

    // HTML objects to do the math
    var buttUp = $('ipod_scroll_up_button');
    var buttDown = $('ipod_scroll_down_button');
    var mask = $('pod-list-wrap-mask');
    var currentMenu = $('ipod_nav_level_' + navigationLevel);

    // y coords of menu and mask
    var maskTop = mask.cumulativeOffset().top;
    var maskBottom = maskTop + mask.getHeight(); 
    var menuTop = currentMenu.cumulativeOffset().top;
    var menuBottom = menuTop + currentMenu.getHeight(); 

    buttUp.setStyle("display:block;");
    buttDown.setStyle("display:block;");
       
    // If mask is bigger than menu, dont display navigation buttons
    if (mask.getHeight() > currentMenu.getHeight()) {
        buttUp.setStyle("background-image:none;");
        buttDown.setStyle("background-image:none;");
    } else {
        
        // We have some menu's elements hidden above the mask: show the UP button
        if (menuTop < maskTop)
            buttUp.setStyle("background-image:url(/images/pod_style_navigation/scroll_top_button.gif);");
        else
            buttUp.setStyle("background-image:url(/images/pod_style_navigation/scroll_top_button_deactivated.gif);");
        
        // We have some menu's elements hidden below mask: show the DOWN button
        if (menuBottom > maskBottom)
            buttDown.setStyle("background-image:url(/images/pod_style_navigation/scroll_bottom_button.gif);");
        else
            buttDown.setStyle("background-image:url(/images/pod_style_navigation/scroll_bottom_button_deactivated.gif);");

    } // if mask.getHeight > ..
} // upAndDownButtonsSetup()

    
    
// wheel event handler
function wheel(event) {
  
    if ($('pod-list-wrap-mask') == null)
        return true;

    var mask = $('pod-list-wrap-mask');

    // x,y coords where user cliked
    var x = Event.pointerX(event);
    var y = Event.pointerY(event);

    // Bounds of the mask
    var y1 = mask.cumulativeOffset().top;
    var x1 = mask.cumulativeOffset().left;
    var dim = mask.getDimensions();

    // If we are outside the mask bounds, dont process the wheel event
    if (x<x1 || x>dim.width + x1)
        return true;

    if (y<y1 || y>dim.height + y1)
        return true;
  
    // This will contain the wheel movement amount
    var delta = 0;

    // Every different browser process this event in a different way, we
    // need to get this value in every case
    if (!event)
        event = window.event;

    if (event.wheelDelta) {
        delta = event.wheelDelta/120;

        // Opera 9: sign is inverted
        if (window.opera)
            delta = -delta;

    } else if (event.detail) {

        // Mozilla
        delta = -event.detail/3;
    }

    // Do we have to process something?
    if (delta)
        handle(delta);

    // Prevent default browser behaviour: we dont want to scroll menu AND page
    if (event.preventDefault)
        event.preventDefault();

    return false;
} // wheel()

// Called by wheel() if we have to process the wheel event
function handle(delta) {
   
    // Usual bounds of mask and menu
    var maskTop = $('pod-list-wrap-mask').cumulativeOffset().top;
    var menuTop = $('ipod_nav_level_' + navigationLevel).cumulativeOffset().top;

    var maskBottom = maskTop + $('pod-list-wrap-mask').getHeight();
    var menuBottom = menuTop + $('ipod_nav_level_' + navigationLevel).getHeight();

    // New position of the menu under the mask
    var newPosition;
    
    // We are going up with the mousewheel
    if (delta < 0) {

        // If they are not aligned, calculate newPosition. Else just return: 
        // we dont need any movement
        if (menuBottom > maskBottom)
            newPosition = parseInt($('ipod_nav_level_' + navigationLevel).style.top) - Math.min(minMovement, menuBottom - maskBottom);
        else
            return;

    } else {
        // Same as above: if they are aligned just return
        if (menuTop < maskTop)
            newPosition = parseInt($('ipod_nav_level_' + navigationLevel).style.top) + Math.min(minMovement, maskTop - menuTop);
        else
            return;

    }
    
    // Update new menu position
    $('ipod_nav_level_' + navigationLevel).setStyle("top:"+ newPosition + "px");
    upAndDownButtonsSetup();

} // handle()

// Attach functions to browser's events
if (window.addEventListener)
    window.addEventListener('DOMMouseScroll', wheel, false);

// IE / OPERA
window.onmousewheel = document.onmousewheel = wheel;