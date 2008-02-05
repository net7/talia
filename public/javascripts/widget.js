var Widget = Class.create();
Widget.prototype = {
	initialize: function(identifier, widget_name) {
		this.identifier  = identifier;
		this.widget_name = widget_name;
	},
	
	request: function(handler, options) {
		options = options || $H({});
		parameters = $H({ 'widget_name': this.widget_name,
    		              'identifier' : this.identifier,
									    'handler'    : handler });
		options['parameters'] = $H(options['parameters'] || {}).merge(parameters);
		new Ajax.Request('/widget_proxy', options);
	}
}