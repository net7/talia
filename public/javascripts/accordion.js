var Accordion = Class.create({
	initialize: function(xpath){
		this.xpath = xpath;
		this.hideElements();
	},
	hideElements: function(){
		document.observe('dom:loaded', function(){
			this.elements = $$(this.xpath);
			this.elements.each(function(element){
				element.next().hide();
				element.observe('click', this.handleClick.bindAsEventListener(this));
			}.bind(this));			
		}.bind(this));
	},
	handleClick: function(event){
		accordionContent = event.element().next();
		this.elements.each(function(element){
			if(accordionContent == element.next() && !accordionContent.hasClassName('open')){
				new Effect.BlindDown(accordionContent, {duration: 0.7});
				accordionContent.addClassName('open');
			} else {
				new Effect.BlindUp(element.next(), {duration: 0.7});
				element.next().removeClassName('open');
			}
		});
	}
});

new Accordion('h1.accordion_toggle');

Event.addBehavior.reassignAfterAjax = true;
Event.addBehavior({
  'h3.source_more:click': function(event) {
    Effect.toggle(event.element().next(), 'blind', {duration: 0.7});
  }
});
