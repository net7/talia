/* **************************************** */
/* SETTAGGI INIZIALI DEGLI ELEMENTI */
/* **************************************** */
function setToolbarGeometry()
{
    /* set css style of some elements */
    $('toolbar_mask').setStyle('overflow: hidden;');
    $('toolbar_mask').setStyle('margin:0 18px;');
    $('toolbar_mask').setStyle('width:' + ( document.viewport.getDimensions().width - $('toolbar_mask').cumulativeOffset().left - 45 ) + 'px;');
    $('toolbar').setStyle('border:0;');
    
    /* se ci sono pochi elementi devo controllare dove arriva l'ultimo e ridimensionare la toolbar' */
    var fullToolbarWidth = 5000;
    $('toolbar').setStyle('width:'+ fullToolbarWidth +'px;');
    
    /* modifico l'ultimo elemento della lista */
    $$('div#toolbar ul li')[$$('div#toolbar ul li').length - 1].setStyle('background-image: none;')
    
    $('scroll_back').setStyle('display:block;');
    $('scroll_forward').setStyle('display:block;');
    
    /* ci va messa una condizione if: se l'ultimo elemento toolbar esce dall maschera ' */
    /*var ultimoElementoArrayLi = $$('div#toolbar ul li').length - 1;
    var lastElementEnd = $$('div#toolbar ul li')[ultimoElementoArrayLi].cumulativeOffset().left + $$('div#toolbar ul li')[ultimoElementoArrayLi].getWidth();
    if(lastElementEnd > ( $('toolbar_mask').cumulativeOffset().left +  $('toolbar_mask').getWidth() ) )
    {
        $('scroll_back').setStyle('display:block;');
        $('scroll_forward').setStyle('display:block;');
    }else
    {
        $('scroll_back').setStyle('display:none;');
        $('scroll_forward').setStyle('display:none;');
    }
    */
    
    if($('toolbar_top')) /* se ho già creato gli oggetti ... */
    {
        graphicalElementsMove();
    }else{ /* ... altrimenti ... */
        graphicalToolbarSetUp();
    }
}

function graphicalToolbarSetUp()
{
    $('toolbar_mask').insert({after:"<div id=\"toolbar_top_left\"></div>"});
    $('toolbar_mask').insert({after:"<div id=\"toolbar_bottom_left\"></div>"});
    $('toolbar_mask').insert({after:"<div id=\"toolbar_bottom_right\"></div>"});
    $('toolbar_mask').insert({after:"<div id=\"toolbar_top_right\"></div>"});
    
    $('toolbar_mask').insert({after:"<div id=\"toolbar_top\"></div>"});
    $('toolbar_mask').insert({after:"<div id=\"toolbar_left\"></div>"});
    $('toolbar_mask').insert({after:"<div id=\"toolbar_bottom\"></div>"});
    $('toolbar_mask').insert({after:"<div id=\"toolbar_right\"></div>"});
    
    $('toolbar_mask').insert({after:"<div id=\"toppa_left\"></div>"});
    $('toolbar_mask').insert({after:"<div id=\"toppa_right\"></div>"});
    
    /* $('toolbar_mask').insert({before:"<div id=\"toolbar_bg\"></div>"}); */
    graphicalElementsMove();
}

function graphicalElementsMove()
{
    $('toolbar_mask').setStyle('width:' + ( document.viewport.getDimensions().width - $('toolbar_mask').cumulativeOffset().left - 45 ) + 'px;');
    $('toolbar').setStyle('height:auto;');
    if($('toolbar').getHeight() < 30) $('toolbar').setStyle('height:30px;');
    
    $('toolbar_top_left').setStyle("top:" +  $('toolbar_mask').cumulativeOffset().top + "px; left:" +  ( $('toolbar_mask').cumulativeOffset().left - 18 ) + "px;");
    $('toolbar_bottom_left').setStyle("top:" + ( $('toolbar_mask').cumulativeOffset().top + $('toolbar').getHeight() - 7 ) + "px; left:" + ( $('toolbar_mask').cumulativeOffset().left - 18 ) + "px;");
    $('toolbar_bottom_right').setStyle("top:" +  ( $('toolbar_mask').cumulativeOffset().top + $('toolbar').getHeight() - 7 ) + "px; left:" +  ( $('toolbar_mask').cumulativeOffset().left + $('toolbar_mask').getWidth() +11)  + "px;");
    $('toolbar_top_right').setStyle("top:" +  $('toolbar_mask').cumulativeOffset().top + "px; left:" +  ( $('toolbar_mask').cumulativeOffset().left + $('toolbar_mask').getWidth() + 11) + "px;");
    
    $('toolbar_top').setStyle("top:" + ( $('toolbar_mask').cumulativeOffset().top ) + "px; left:" + ( $('toolbar_mask').cumulativeOffset().left - 18 )+ "px;");
    $('toolbar_top').setStyle("width:" + ( $('toolbar_mask').getWidth() + 36 ) + "px;");
    
    $('toolbar_left').setStyle("top:" +  $('toolbar_mask').cumulativeOffset().top + "px; left:" + ( $('toolbar_mask').cumulativeOffset().left - 18 ) + "px;");
    $('toolbar_left').setStyle("height:" + $('toolbar').getHeight() + "px");
    
    $('toolbar_bottom').setStyle("top:" + ( $('toolbar_mask').cumulativeOffset().top + $('toolbar').getHeight() - 7 ) + "px; left:" + ( $('toolbar_mask').cumulativeOffset().left - 18 )+ "px;");
    $('toolbar_bottom').setStyle("width:" + ( $('toolbar_mask').getWidth() + 36 ) + "px;");
    
    $('toolbar_right').setStyle("top:" +  $('toolbar_mask').cumulativeOffset().top + "px; left:" +  ( $('toolbar_mask').cumulativeOffset().left + $('toolbar_mask').getWidth() + 11) + "px;");
    $('toolbar_right').setStyle("height:" + $('toolbar').getHeight() + "px");
    
    $('scroll_back').setStyle("top:" + ( $('toolbar').cumulativeOffset().top + ($('toolbar').getHeight() - $('scroll_back').getHeight())/2 ) + "px; left:" + ( $('toolbar_mask').cumulativeOffset().left - 11 ) + "px;");
    $('scroll_forward').setStyle("top:" + ( $('toolbar').cumulativeOffset().top + ($('toolbar').getHeight() - $('scroll_back').getHeight())/2 ) + "px; left:" + ( $('toolbar_mask').cumulativeOffset().left + $('toolbar_mask').getWidth() -7 ) + "px;");
    
    $('toppa_left').setStyle("top:" + $('toolbar_mask').cumulativeOffset().top + "px; left:" + ( $('toolbar_mask').cumulativeOffset().left - 18 ) + "px; height:" + $('toolbar').getHeight() + "px;")
    $('toppa_right').setStyle("top:" + $('toolbar_mask').cumulativeOffset().top + "px; left:" + ( $('toolbar_mask').cumulativeOffset().left + $('toolbar_mask').getWidth() - 12 ) + "px; height:" + $('toolbar').getHeight() + "px;")
    
    /* devo controllare la posizione del toolbar */
    /* controllo del margine destro.. */
    if( ( $$('div#toolbar ul li')[$$('div#toolbar ul li').length - 1].cumulativeOffset().left + $$('div#toolbar ul li')[$$('div#toolbar ul li').length - 1].getWidth() ) < ( $('toolbar_mask').cumulativeOffset().left + $('toolbar_mask').getWidth() ) )
    {
        var differenzaDestra = ( $('toolbar_mask').cumulativeOffset().left + $('toolbar_mask').getWidth() ) - ( $$('div#toolbar ul li')[$$('div#toolbar ul li').length - 1].cumulativeOffset().left + $$('div#toolbar ul li')[$$('div#toolbar ul li').length - 1].getWidth() );
        $('toolbar').setStyle('left:' + ( parseInt( $('toolbar').style.left ) + differenzaDestra)  + 'px;');
    }
    /*... controllo del margine sinistro */
    if( $$('div#toolbar ul li')[0].cumulativeOffset().left > $('toolbar_mask').cumulativeOffset().left )
    {
        var differenzaSinistra = ( $$('div#toolbar ul li')[0].cumulativeOffset().left - $('toolbar_mask').cumulativeOffset().left );
        $('toolbar').setStyle('left:' + ( parseInt( $('toolbar').style.left ) - differenzaSinistra + 15)  + 'px;');
    }
    
    configure_scroll_buttons();
}

function configure_scroll_buttons()
{
    /* BACK BUTTON */
    if( $$('div#toolbar ul li')[0].cumulativeOffset().left < ( $('toolbar_mask').cumulativeOffset().left + 10) )
    {
        $$('div#scroll_back a')[0].setStyle('background: transparent url(/images/toolbar/toolbar_back_button.gif) top left no-repeat;');
    }else
    {
        $$('div#scroll_back a')[0].setStyle('background: transparent url(/images/toolbar/toolbar_back_button_deactivated.gif) top left no-repeat;');
    }
    
    /* FORWARD BUTTON */
    if( ( $$('div#toolbar ul li')[$$('div#toolbar ul li').length-1].cumulativeOffset().left + $$('div#toolbar ul li')[$$('div#toolbar ul li').length-1].getWidth()) > ( $('toolbar_mask').cumulativeOffset().left + $('toolbar_mask').getWidth() + 10)  )
    {
        $$('div#scroll_forward a')[0].setStyle('background: transparent url(/images/toolbar/toolbar_forward_button.gif) top left no-repeat;');
    }else
    {   
        $$('div#scroll_forward a')[0].setStyle('background: transparent url(/images/toolbar/toolbar_forward_button_deactivated.gif) top left no-repeat;');
    }
}
/* **************************************** */
/* FUNZIONE PER LO SCROLL DELLA TOOLBAR */
/* **************************************** */
function toolbar_scroll_prev()
{
    var correzione = 15;
    /* 1.  bisogna scoprire di quanto deve essere lo spostamento */
    var estremoSxToolbarMask = $('toolbar_mask').cumulativeOffset().left + correzione;
    /* ciclo tutti gli elementi li e vedo qual'è il primo che esce a dx della mask */
    var itemToMove = -1;
    for(i=$$('div#toolbar ul li').length-1; i>=0; i--)
    {
        if( $$('div#toolbar ul li')[i].cumulativeOffset().left < estremoSxToolbarMask && itemToMove == -1)
        {
            itemToMove = i;
            var differenceInMovement =  estremoSxToolbarMask - $$('div#toolbar ul li')[i].cumulativeOffset().left;
        }
    }
    //* 2. chiamata alla funzione di scriptacuolous per il movimento */
    new Effect.Move ($('toolbar'),{ x: differenceInMovement, y: 0, mode: 'relative', duration: 0.3, afterFinish: configure_scroll_buttons});
}

function toolbar_scroll_next()
{
    var correzione = 15;
    /* 1.  bisogna scoprire di quanto deve essere lo spostamento */
    var estremoDxToolbarMask = $('toolbar_mask').cumulativeOffset().left + $('toolbar_mask').getWidth() + correzione;
    /* ciclo tutti gli elementi li e vedo qual'è il primo che esce a dx della mask */
    var itemToMove = -1;
    for(i=0; i<$$('div#toolbar ul li').length; i++)
    {
        if( ($$('div#toolbar ul li')[i].cumulativeOffset().left + $$('div#toolbar ul li')[i].getWidth()) > estremoDxToolbarMask && itemToMove == -1)
        {
            itemToMove = i;
            var differenceInMovement = ( $$('div#toolbar ul li')[i].cumulativeOffset().left + $$('div#toolbar ul li')[i].getWidth() ) - estremoDxToolbarMask;
        }
    }
    //* 2. chiamata alla funzione di scriptacuolous per il movimento */
    new Effect.Move ($('toolbar'),{ x: -(differenceInMovement + 10), y: 0, mode: 'relative', duration: 0.3, afterFinish: configure_scroll_buttons});
}