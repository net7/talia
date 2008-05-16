//
//	With many thanks to Joe Cianflone, che no so chi è
//
/* FUNZIONE DI SETTAGGIO INIZIALE */
/* la variabile passata è la definizione css degli elementi titolo */
function loadAccordion (accordionGroup) {
    var accordionElements = $$(accordionGroup); /* chi sono gli accordion elements.... i titoli su cui clicco per aprire e chiudere gli oggetti */
    
    for (var i=0, len=accordionElements.length; i < len; ++i) { /* scorro tutti gli elementi */
        $$(accordionGroup)[i].next().setStyle('display: none;'); /* imnposto display none per le parti nascoste */
        // questo va hard coded nell'html Event.observe (accordionElements[i], 'click', accordion_event, false); /* aggiungo evento */
        // Event.observe (accordionElements[i], 'mouseover', accordion, false); /* aggiungo evento */
    }
    /* cancello gli href */
    deleteHrefAttributes($$('a.source_more_link'));
    /*apro il primo pezzo */
    if(accordionElements[0].hasClassName('first')) accordion(accordionElements[0]);   
}

function accordion_event(elemento) {
    /* elemento: elemento su cui ho cliccato */
    
    //var clicked_element = Event.element(e);
    var clicked_element = elemento;
    accordion(clicked_element);
}

function accordion(clicked_element) {
    var clicked_element = clicked_element; /* elemento su cui ho cliccato */
    /* array di tutti gli elementi che sono allo stesso livello */
    
    var array_elementi_allo_stesso_Livello = clicked_element.ancestors()[0].childElements();
    
    /* ciclo tutti gli elementi allo stesso livello e memorizzo quello attualemtne aperto */
    for (var j=0, len_elements=array_elementi_allo_stesso_Livello.length; j < len_elements; ++j) {
        if(array_elementi_allo_stesso_Livello[j].hasClassName('open')) var opened_element = array_elementi_allo_stesso_Livello[j];
    }
    
    var control_variable = false;
    for (var k=0, len_elements_2=array_elementi_allo_stesso_Livello.length; k < len_elements_2; ++k) {
        if(array_elementi_allo_stesso_Livello[k].hasClassName('in_movement')) control_variable = true;
    }    
    
    /* CONTROLLO SE C'è QUALCUNO IN MOVEMENT */
    if(control_variable == false)
    {
        if (!opened_element) { /* se non ci sono elementi aperti */
            switch_class(clicked_element ,"compress" ,"expand" );

            new Effect.BlindDown (clicked_element.next(), {duration:0.7,
                afterFinish: function (e)
                {
                    clicked_element.removeClassName('in_movement');
                    clicked_element.addClassName('open');
                }
            });
            clicked_element.addClassName('in_movement');
        }//if...
        else { /* ci sono elementi aperti,  e quello su cui ho cliccato non è opened */
            if (!clicked_element.hasClassName('open')) { /* cliccato su un elemento che non è quello aperto */
                switch_class(clicked_element ,"compress" ,"expand" );
                switch_class(opened_element ,"compress" ,"expand" );
                
                new Effect.Parallel(
                    [new Effect.BlindUp(opened_element.next(), {duration:0.7}), new Effect.BlindDown(clicked_element.next(), {duration:0.7})], 
                    {
                        afterFinish: function (e) {
                            clicked_element.removeClassName('in_movement');
                            opened_element.removeClassName('open');
                            clicked_element.addClassName('open');
                        }//afterFinish...
                    }

                );//Effect.Parallel...
                clicked_element.addClassName('in_movement');
            }else
            {
                switch_class(clicked_element ,"compress" ,"expand" );
                
                new Effect.BlindUp (clicked_element.next(), {duration:0.7,
                afterFinish: function (e)
                {
                    clicked_element.removeClassName('in_movement');
                    clicked_element.removeClassName('open');
                }
                });
                clicked_element.addClassName('in_movement'); 
            }
        }//else...
        
    }
}

/* funzione che imposta l'accordion per le liste principoali */
function configureSourcesListAccordion()
{
    if($$('h1.accordion_toggle').length > 0) /* controllo se cìè la struttura in questione */
    {
        
        var titoliH1CategorieSources = $$('h1.accordion_toggle');
        for(i=0; i <titoliH1CategorieSources.length; i++)
        {
            // titoliH1CategorieSources[i].setStyle('background: #e5e5e5 url(/images/sources_listing/source_expand_icon.gif) center left no-repeat;');
        }

        loadAccordion('h1.accordion_toggle');
        configureInternalSourcesAccordion();
    }
}

function configureInternalSourcesAccordion()
{
    var elementiPDaModificare = $$('p.source_data');
    for(p=0; p<elementiPDaModificare.length; p++)
    {
       // elementiPDaModificare[p].setStyle("display: none;");
      // elementiDaModificare[p].insert({ after: '<h3 class="source_more expand">More content</h3>' } )
    }
    
    var elementiH3DaModificare = $$('h3.source_more');
    for(p=0; p<elementiH3DaModificare.length; p++)
    {
      // elementiH3DaModificare[p].setStyle("display: block;").addClassName("expand");
        elementiH3DaModificare[p].addClassName("expand");
      // elementiDaModificare[p].insert({ after: '<h3 class="source_more expand">More content</h3>' } )
    }
    
    loadAccordion('h3.source_more');
}




