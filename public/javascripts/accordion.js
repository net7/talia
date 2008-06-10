// Different kinds of Accordions:
// FIRSTOPENED: first accordion element will be automatically opened
// FIRSTBLIND: first accordion element will be opened with blind effect
// NONE: no special behaviours

var accBeh = {NONE: 0, FIRSTBLIND: 1, FIRSTOPENED: 2};


// Accordion class: it's a list of sensible elements (usually headers) and 
// a content for each one of them. The content is the .next() in DOM order and
// get shown/hidden with a blind effect by clicking on the header. Being an
// Accordion means that only one content can be open at a time. Thus we must
// check for any other open content and blind it up while blinding down the
// one the user selected.
var Accordion = Class.create({
    initialize: function(xpath) {
        // xpath given to the constructor, contains the css identifier
        // to gather accordion elements
        this.xpath = xpath;
        this.hideElements();

        // Used to track animations: we must deny 2 animations at the 
        // same time so we ignore clicks if one is going on
        this.isMoving = false;

        // Set which kind of accordion we are instantiating, default
        // to NONE
        if (arguments.length == 2)
            this.firstItemBehaviour = arguments[1];
        else
            this.firstItemBehaviour = accBeh.NONE;
    },

    hideElements: function() {

        // Observes the page loading and calls the anon function
        // at DOM loaded
        document.observe('dom:loaded', function() {
            // Takes the HTML elements with the css tag specified in the constructor:
            // they are the accordion elements. The content (to be shown/hidden)
            // for each one of them is the .next() in the DOM order
            this.elements = $$(this.xpath);
            this.elements.each(function(element) {
                // If necessary dont hide the content of the first element 
                if (this.firstItemBehaviour == accBeh.FIRSTOPENED && this.elements[0] == element)
                    element.addClassName('open');
                else  
                    element.next().hide();

                // Attach an observer on click event for the accordion elements: will call
                // handleClick() function. bindAsEventListener() and bind() forces 
                // 'this' identifier to reference this Accordion element
                element.observe('click', this.handleClick.bindAsEventListener(this));

            }.bind(this));

            // If necessary blind down the first element of this Accordion
            if (this.firstItemBehaviour == accBeh.FIRSTBLIND) {
                Accordion.isMoving = true;
                this.elements[0].addClassName('open');
                new Effect.BlindDown(this.elements[0].next(), {duration: 0.7, afterFinish: function (e) { Accordion.isMoving = false; }});
            }
        }.bind(this));
    }, // hideElements()
    
    handleClick: function(event){

      // If we already have an ongoing animation: ignore the click
      if (Accordion.isMoving == true)
          return;

      clickedElement = event.element();
      accordionContent = clickedElement.next();

      this.elements.each(function(itElement){
          // If the current element is the one the user clicked, and its not open
          // then we have to blind it down
          if (itElement == clickedElement && !itElement.hasClassName('open')){
              Accordion.isMoving = true;
              new Effect.BlindDown(accordionContent, {duration: 0.7, afterFinish: function (e) { Accordion.isMoving = false; }});
              clickedElement.addClassName('open');
          // in the other 2 cases: current el is open but it's not the one we
          // clicked on: close it; current el is open and it's the one we 
          // cliecked on: close it! :)
          } else if (itElement.hasClassName('open')) {
              Accordion.isMoving = true;
              new Effect.BlindUp(itElement.next(), {duration: 0.7, afterFinish: function (e) { Accordion.isMoving = false; }});
              itElement.removeClassName('open');
          }
      });
    } // handleClick()
}); // Accordion()

// Accordion.prototype.isMoving = false;


// Instantiate a new Accordion for the H1.accordion_toggle elements
new Accordion('h1.accordion_toggle', accBeh.FIRSTBLIND);


// LowPro's feature: we have to assign the addBehaviour() methods listening for click
// events after HTML code is loaded: this options does exactly this. :) 
Event.addBehavior.reassignAfterAjax = true;


// H3 elements gets managed this way: directly addBehaviour on the html
// element, since they are single element accordion, we dont need an Accordion
// class. The behaviour simply toggles the blind effect on dom's .next()
Event.addBehavior({
    'h3.source_more:click': function(event) {
        Effect.toggle(event.element().next(), 'blind', {duration: 0.7});
    }
});