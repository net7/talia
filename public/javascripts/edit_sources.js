Event.onReady(function() {
	$('data_form').hide();
	$$('.predicates').each(function(element){ element.hide(); });
	$$('.predicate').each(function(element){ attachAjaxAutocompleter(element); });
});

function attachAjaxAutocompleter(element) {
	auto_complete_id = element.down('.auto_complete').identify();
	// Force the element identification, since each input has the same id.
	input_text_id = element.down('input[id~titleized]').identify(true);
	new Ajax.Autocompleter(input_text_id, auto_complete_id, '/admin/sources/auto_complete_for_source', {parameters:'authenticity_token=' + encodeURIComponent(window.authenticityToken)});	
}

function attachAjaxAutocompleterOnNewElement(namespaceId) {
	attachAjaxAutocompleter($(namespaceId).select('.predicate').last());
}

Event.addBehavior({
  '.arrow_grouped:click': togglePredicates,
	'.arrow_collapsed:click': togglePredicates
});

function togglePredicates(e) {
	element = $(e.element());
  element.up('div').down('.predicates').toggle();
  className = image = element.getAttribute('src').match(/grouped/) ? 
    'collapsed' : 'grouped';
  element.writeAttribute({
	  'src': '/images/arrow_'+image+'.png',
		'class':'arrow_'+className
	});
	setTimeout(function() { Event.addBehavior.reload() }, 10);
}

function showPredicatesOfDiv(id) {
	element = $(id);
	element.down('.predicates').show();
  element.down('img').writeAttribute({
	  'src': '/images/arrow_collapsed.png',
		'class':'arrow_collapsed'
	});
	setTimeout(function() { Event.addBehavior.reload() }, 10);
}

function showUploadProgressBar() {
	new Effect.Appear('UploadProgressBar1');
}

function onFinishedUpload() {
	$('data_record_file').value = '';
	id = $('data_record[source_record_id]').value;
	new Ajax.Request('/admin/sources/data?id='+encodeURIComponent(id));
	// TODO DRYup this effect
	new Effect.Fade('data_form', {duration: 0.001});
 	new Effect.Appear('upload_link', {duration: 0.4});
  $('data_form').update('');
}