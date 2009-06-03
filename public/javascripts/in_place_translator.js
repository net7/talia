// InPlaceTranslator is a lightweight version of Click to Globalize
Ajax.InPlaceEditor.prototype = Object.extend(Ajax.InPlaceEditor.prototype,{
  createHiddenField: function(){
    var textField = document.createElement("input");
    textField.obj = this;
    textField.type = 'hidden';
    textField.name = 'key';
    textField.value = this.options.hiddenValue;
    var size = this.options.size || this.options.cols || 0;
    if (size != 0) textField.size = size;
    this._form.appendChild(textField);
  }
});

// Fix for: http://dev.rubyonrails.org/ticket/4579
Ajax.InPlaceEditor.prototype.initialize = Ajax.InPlaceEditor.prototype.initialize.wrap(
	function(proceed, element, url, options) {
		element = $(element);
    if($w('TD TH').include(element.tagName)){
			element.observe('click',     this.enterEditMode.bindAsEventListener(this));
			element.observe('mouseover', this.enterHover.bindAsEventListener(this));
			element.observe('mouseout',  this.leaveHover.bindAsEventListener(this));
      element.innerHTML = "<span>" + element.textContent + "</span>";
      element = element.down();
    }
		proceed(element, url, options);
	}
);

Ajax.InPlaceEditor.prototype.createForm = Ajax.InPlaceEditor.prototype.createForm.wrap(
  function(proceed) {
    proceed();
    this.createHiddenField();
  }
);

var InPlaceTranslator = Class.create({
  initialize: function(id){
    this.id = id;
    this.url = '/locale/translate';
    this.externalControl = this.id + '_activator', //.translate_element
    this.parentElement = $(this.id).up();
    this.parentElement.observe('click', function(event){
      if(event.element().tagName == 'A') {event.stop(); return;}
      // this.editor.createForm(); // force the form creation
      // this.editor.handleFormSubmission(event);
      $(this.externalControl).fire("click");
    }.bind(this));
    this.editor = this.createInPlaceEditor();
  },
  createInPlaceEditor: function(){
    return new Ajax.InPlaceEditor(this.id, this.url, {
      hiddenValue: this.id, // this.id should be the translation key too
      externalControl: this.externalControl,
      // externalControlOnly: true,
      callback: function(form, value) {
        return 'key='+escape(this.id)+'&value='+escape(value);
      }.bind(this)
    });
  }
});