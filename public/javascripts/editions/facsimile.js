//= require <prototype>
//= require <effects>

// Dom Loaded
document.observe("dom:loaded", function() {
    // Set height of elements
    set_height();
});

// All Page Contents Loaded
Event.observe(window, 'load', function() {
    if ($('toolbar')) centerToolbar();

    // Set height of elements
    // ALREADY se in document.observe("dom:loaded"... 
    //    set_height();
    
    // setThumbsSize($$('div.lonely p a img'));
    // setThumbsSize();
    // Functions that set the position of the single or double IIP viewer, only if they exist
    if($$('div.image_big').length > 0 || $$('div.image_half').length > 0) setIipViewerSize();
});

// Resize
window.onresize = function () {
    // Set height of elements
    set_height (); 
    // Functions that center the toolbar (check if exists)
    if ($('toolbar')) centerToolbar();
    // Functions that set the position of the single or double IIP viewer, only if they exist
    if($$('div.image_big').length > 0 || $$('div.image_half').length > 0) setIipViewerSize();
}



// Functions
// Function that sets the height of the side scroll panoramam view
// and the main content on the right
// depending on the size of the window
// This is called onload and on resize o the window
function set_height (){
    if($('visore')) {
        // Height of the whole window
        var windowHeight = document.viewport.getDimensions().height;
        // Height of the visore object - main pat of the page where contents are displayed
        var visoreHeight = windowHeight - $('visore').cumulativeOffset ( $('visore')).top;

        $('visore').style.height = visoreHeight - 0 + "px";
        $('scroll').style.height = windowHeight - $('scroll').cumulativeOffset().top + "px";
    }
    
    // setting other heights
    // image big div
    // var image_big_height = windowHeight - $('image_big').cumulativeOffset ( $('image_big')).top  ;
    // $('image_big').style.height = image_big_height + "px";

    // Oggetti che contengono il visore flash
    var array_iipfview = $$('div.iipfview');
    var iipfview_height;
    for(i=0; i < array_iipfview.length; i++) {
        iipfview_height = windowHeight - array_iipfview[i].cumulativeOffset ( array_iipfview[i]).top  ;
        array_iipfview[i].style.height = iipfview_height - 35 + "px";
    }
}
    
function go_to_anchor(name){
    div_name = 'page_' + name;
    $('scroll').scrollTop = $(div_name).offsetTop - 5;
}

// METHOD THAT PLACES THE TOOLBAR IN THE CENTER OF THE DIV ID 'visore'
function centerToolbar(){
    // Let's evaluate how much the left margin must be
    var margin_left_toolbar = ( $('visore').getDimensions().width - $('toolbar').getDimensions().width ) /2 + 'px';
    // Set the css attribute using prototype
    $('toolbar').setStyle({
        marginLeft: margin_left_toolbar
    });
}

// funzione momentanea che forza la dimensione delle thumbnails 120 x 80 px */
function setThumbsSize() {
    var array_thumbs1 = $$('div.block p a img');
    var array_thumbs2 = $$('div.block p.lonely a img')
    var array_full = array_thumbs1.concat(array_thumbs2);
     
    // Scorro tutti gli elementi thumbnail
    // for(i=0; i<array_thumbs.length; i++) {
    for(i=0; i<array_full.length; i++) {

        var finalWidth = 80;
        var finalHeight = 120;
    
        valori = resizeItem(array_full[i], finalWidth, finalHeight);
        array_full[i].writeAttribute("width","" + valori[0]);
        array_full[i].writeAttribute("height","" + valori[1]);
        array_full[i].setStyle({
            paddingTop: valori[2] + 'px',
            paddingRight: valori[3] + 'px',
            paddingBottom: valori[4] + 'px',
            paddingLeft: valori[5] + 'px',
            backgroundColor: '#FFFFFF'
        });
    }
}

// Funzione utilizzata per ridimensionare un oggetto rispetto a due misure date
function resizeItem(itemToResize, maxWidth, maxHeight) {
    // Definition of variables
    var finalMarginLeft;
    var finalMarginRight;
    var finalMarginTop;
    var finalMarginBottom;
    var finalWidth;
    var finalHeight;
    var arrayMargins;
  
    // Rapporto iniziale tra i lati
    var ratio = itemToResize.getDimensions().width/itemToResize.getDimensions().height;
                        
    // ridimensionamento dell'oggetto in base alle proporzioni
    // 1. caso 1: si deve adattare il lato verticale. Il lato verticale dell'oggetto deve essere adattato al lato verticale della cornice.
    // L'altro lato va di conseguenza
    if ( ( maxWidth/ maxHeight) > ratio ) {
        // imponiamo il lato verticale dell'oggetto uguale al lato verticale della cornice
        finalHeight =  maxHeight;
        // il lato orizzontale lo correggiamo in base al rapporto tra i lati
        finalWidth = finalHeight * ratio;

        // Define the final margin dimensions
        finalMarginLeft = '' + ( maxWidth - finalWidth )/2;
        finalMarginRight = '' + finalMarginLeft;
        finalMarginTop = '0';
        finalMarginBottom = '0';
          
        arrayMargins = new Array(finalWidth, finalHeight, finalMarginTop,finalMarginRight,finalMarginBottom,finalMarginLeft);
    } else {
        // 2. caso 2: si deve adattare il lato orizzontale. Il lato orizzontale dell'oggetto deve essere adattato al lato orizzontale della cornice.
        // L'altro lato va di conseguenza
        // imponiamo il lato verticale dell'oggetto uguale al lato verticale della cornice
        finalWidth =  maxWidth;
        // il lato orizzontale lo correggiamo in base al rapporto tra i lati
        finalHeight = finalWidth / ratio;
          
        // Define the final margin dimensions
        finalMarginLeft = '0';
        finalMarginRight = '0';
        finalMarginTop = '' + ( maxHeight - finalHeight )/2;
        finalMarginBottom = '' + finalMarginTop;
    }
    arrayMargins = new Array(finalWidth, finalHeight, finalMarginTop,finalMarginRight,finalMarginBottom,finalMarginLeft);
    return arrayMargins;
}// resizeAndCenterItem


// Function that sets the correct widths of the twins iip flash viewer
function setIipViewerSize() {
    // Right arrow to view the next image
    $$('p.next')[0].setStyle({
        right: '0'
    });

    // Copyright
    var copyright_paragraph = $$('p.facsimile_copyright')[0]

    // Reset of the width
    copyright_paragraph.setStyle({
        width: '1500px'
    });
    
    // Setting width:
    // Retrieve the width of the paragraph
    var copyright_width = copyright_paragraph.getDimensions().width;
    // If the paragraph is too wide, i've to make it smaller
    if(copyright_width > ( $('visore').getDimensions().width - (2 * 40) ) ) {
        copyright_paragraph.setStyle({
            width: ($('visore').getDimensions().width - (2 * 40) ) + 'px'
        });
    }

    // Read the height of the copyright paragraph
    var copyright_height = copyright_paragraph.getDimensions().height;
    
    // I evaluate the left position of the copyright paragraph
    var left_position_copyright = ( $('visore').getDimensions().width - copyright_paragraph.getDimensions().width) / 2;
    // Arssign the value
    copyright_paragraph.setStyle({
        left: left_position_copyright + 'px'
    });

    // Single viewer
    if( $$('div.image_big').length > 0 ) {
        var singleImageHolder = $$('div.image_big')[0];
        var singleImageViewer = $$('div.iipfview')[0];

        var availableWidth = $('visore').getDimensions().width;
        var availableHeight = $('visore').getDimensions().height - $$('p.sigla')[0].getDimensions().height - 17;

        singleImageHolder.setStyle({
            position: 'absolute',
            left: '24px',
            right: '24px',
            height: ( availableHeight - copyright_height ) + 'px'
        });

        singleImageViewer.setStyle({
            height: ( availableHeight - copyright_height ) + 'px'
        });
    }

    // Double Viewer
    if( $$('div.image_half').length > 0 ) {
        var leftImageViewer = $$('div.image_half')[0];
        var rightImageViewer = $$('div.image_half')[1];

        var availableWidth = $('visore').getDimensions().width;
        var availableHeight = $('visore').getDimensions().height - $$('p.sigla')[0].getDimensions().height - 17;

        leftImageViewer.setStyle({
            position: 'absolute',
            left: '24px',
            width: ((availableWidth-50)/2) + 'px',
            height: ( availableHeight - copyright_height ) + 'px'
        });

        rightImageViewer.setStyle({
            position: 'absolute',
            width: ((availableWidth-50)/2) + 'px',
            right: '24px',
            height: ( availableHeight - copyright_height ) + 'px'
        });
    }
}
