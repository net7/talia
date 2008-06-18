var InputSearch = Class.create({
	initialize: function(id, label){
		this.element = $(id);
		this._form = this.element.up('form');
		this.label = label || 'Cerca';
		this.element.value = this.label;
		this.registerHandlers();
	},
	registerHandlers: function(){
		if(Prototype.Browser.Safari){
	    this._form.addClassName('issafari');
			this.element.writeAttribute({
				type: 'search',
				autosave: 'at.ajaxian.search',
				results: '5',
				placeholder: this.label
			});
		} else {
			this.element.observe('focus', this.handleFocus.bindAsEventListener(this));
			this.element.observe('blur', this.handleBlur.bindAsEventListener(this));
		}
	},
	handleFocus: function(){
		this.element.value = '';
		this._form.setStyle('background: transparent url("/images/search_field/bg_search_focus.gif") no-repeat 10px 7px;');
		this.element.addClassName('focus');
	},
	handleBlur: function(){
		this.element.value = this.label;
		this._form.setStyle('background: transparent url("/images/search_field/bg_search.gif") no-repeat 10px 7px;');
		this.element.removeClassName('focus');
	}
});

document.observe('dom:loaded', function(){
  new InputSearch('s');	
});
