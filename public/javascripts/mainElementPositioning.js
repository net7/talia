// Various functions to modify position and dimensione of the main
// elements of the page


// Sets the height of the interactive elements. Gets called
// on load and on resize
function setElementsVerticalSettings() {

    /* posizionamento dell'elemento bottom menu: menu presente nella sidebar
    che sta allineato in basso */

    // Moves the 'bottom_menu' element, always aligned at the bottom
    // of the left sidebar. Given the dimension of the page just substract 
    // 'bottom_menu_lower_space' (a margin in px from the bottom of the page),
    // and set the style of the element.
    var side_bar_top = Element.cumulativeOffset($('side_bar')).top;
    var bottom_menu_lower_space = 0;
    var bottom_menu_margin_top = (document.viewport.getDimensions().height) - 
          side_bar_top - bottom_menu_lower_space - ($('bottom_menu').getDimensions().height);

    $('bottom_menu').setStyle('margin-top: ' + bottom_menu_margin_top + 'px');
    
    // Sets the height of 'ext_page' div element. It contains all the
    // content in the page
    $('ext_page').setStyle('height: ' + document.viewport.getDimensions().height + 'px');

} // setElementsVerticalSettings()


// Called from onload event, sets up dimension and position for the most 
// importan elements of the page
function loadFunctionSettings() {

		// Make sure sidebar is in the page
		if (!$$('.sidebar_widget').any()) return;

    // GIULIO
    // $("bottom_menu").style.marginTop = 290 +"px";
    $("top_menu").style.marginTop = 60 +"px";
    setElementsVerticalSettings();

    // Attach the onclick function to the 'sidebar_button' element, the one
    // that opens and closes the sidebar
    $('side_bar_button').onclick = function() {

        switch_class($('side_bar') , "open", "closed");
        switch_class($('contents_ext'), "open", "closed");
        switch_class($('footer'), "open", "closed");
        switch_class($('page'), "open", "closed");

        
        // GIULIO
        // If the sidebar is open, close it
        if ($('side_bar').getWidth() > 200) {
            $('side_bar').setStyle('width:43px;');
            $('side_bar').setStyle('background:transparent url(/images/side_bar_icons/side_bar_top_closed.gif) top left no-repeat;');
            $('contents_ext').setStyle('margin-left:43px;');

        // If it's closed, open it
        } else {
            $('side_bar').setStyle('width:270px;');
            $('side_bar').setStyle('background:transparent url(/images/side_bar_icons/side_bar_top.gif) top left no-repeat;');
            $('contents_ext').setStyle('margin-left:270px;');
        }


       
        // If there is a toolbar, update its graphic configuration
        if ($('toolbar_top'))
            toolbarGraphicalUpdate();

    } // $('side_bar_button').onclick = function()

} // loadFunctionSettings()
