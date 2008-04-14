Event.onReady(function() {
	$('data_form').hide();	
});

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