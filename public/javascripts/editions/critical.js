//= require <prototype>
//= require <effects>


//set height and goto_anchor are called on Dom Load in the views/critical_editions/_script.html/erb partial

// All Page Contents Loaded
Event.observe(window, 'load', function() {
    // Call to function that handles collapsing of left side lists
    handleListCollapsing();
});

// Resize
Event.observe(window, 'resize', function () {
    // Set height of elements
    set_height ();
})

document.addEventListener('DOMSubtreeModified', function(){
    set_height ();
}, true)


// Functions
function go_to_anchor(name){
    div_name_text = name + '_text';
    div_name_menu = name + '_menu';
    // scrolls the text, in the right pane
    if($(div_name_text)) {
        $('visore').scrollTop = $(div_name_text).offsetTop - 15; // adding 15 pixels helps in presenting it a bit nicer
    }
    // scrolls the menu on the left
    if($(div_name_menu)) {
        $('scroll').scrollTop = $(div_name_menu).offsetTop - 120; // adding 120 pixels will show the menu entry at the 5th or 6th place
    }     
}

/* Functions to set the height ans width of some elements */
/* Called on Load and Resize */
function set_height(){
    /* Height of the whole window */
    var windowHeight = document.viewport.getDimensions().height;
    
    $('visore').style.height = windowHeight - $('visore').cumulativeOffset().top - 20 + "px";
    $('scroll').style.height = windowHeight - $('scroll').cumulativeOffset().top + "px";

/*
    // Set the width of the Text Blocks (blocks showing text on the right of the page)
    $$('div.txt_block').each(
        function(element)
        {
            element.style.width = ( element.getDimensions().width - 70 ) + "px";
        }
    );
    */
}

// Handles opening and closing of open elements in the left-bar list of pages
// The function looks for list items with class "opened"
function handleListCollapsing() {
    $$('li.opened').each(
        function(element) {
            // Tag A element
            var aLink = element.firstDescendant();
            aLink.writeAttribute({ 
                href: 'javascript:;'
            });

            // Evento click
            Event.observe(aLink, 'click', function(event) {
                if(this.next('ul').getStyle('display') != 'none') {
                    Effect.BlindUp(this.next('ul'), { 
                        duration: 0.5
                    });
                } else {
                    Effect.BlindDown(this.next('ul'), { 
                        duration: 0.5
                    });
                }
            });
        }
        )
}


