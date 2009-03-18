//= require <prototype>
Element.addMethods({
	identify: function(element, force) {
    element = $(element);
    var id = element.readAttribute('id'), self = arguments.callee;
    if (id && !force) return id;
		id = id || 'anonymous_element';
    do { id += '_'+self.counter++ } while ($(id));
    element.writeAttribute('id', id);
    return id;
  }
});
Element.Methods.identify.counter = 1;