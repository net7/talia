//
//	With many thanks to Joe Cianflone
//

/* FUNZIONE DI SETTAGGIO INIZIALE */
/* la variabile passata è la definizione css degli elementi titolo */
function loadAccordion (accordionGroup) { 
    var accordionElements = $$(accordionGroup); /* chi sono gli accordion elements.... i titoli su cui clicco per aprire e chiudere gli oggetti */
    for (var i=0, len=accordionElements.length; i < len; ++i) { /* scorro tutti gli elementi */
        $$(accordionGroup)[i].next().setStyle('display: none;'); /* imnposto display none per le parti nascoste */
        Event.observe (accordionElements[i], 'click', accordion, false); /* aggiungo evento */
        // Event.observe (accordionElements[i], 'mouseover', accordion, false); /* aggiungo evento */
    }
}

function accordion(e) {
    var clicked_element = Event.element(e); /* elemento su cui ho cliccato */
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
