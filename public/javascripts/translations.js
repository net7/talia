Element.addMethods({
	getText: function(element){
		element = $(element);
		return ((element.firstChild && element.firstChild.nodeValue) ? element.firstChild.nodeValue : '').strip();
	}
});

var TranslationFetcher = Class.create({
  initialize: function(selectId, tableId){
    this.url = "/admin/translations/search";
    this.selectElement = $(selectId);
    this.tableRows = $$('#'+tableId+' tr');
    this.tableRows.shift(); // remove the row contains th
    // I didn't used #observe because it was double firing #loadTranslations
    this.selectElement.onchange = this.loadTranslations.bindAsEventListener(this);
    if(autoloadReferenceTranslations) {this.loadTranslations()}; // if autoload enabled
  },

  loadTranslations: function(){
    keys = this.tableRows.map(function(row, i){
      key = row.select("td:nth-child(1) label").first().getText();
      return "key"+i+"="+encodeURIComponent(key);
    }).join('&');
    locale = encodeURIComponent(this.selectElement.value);
    new Ajax.Request(this.url + "?locale="+ locale +"&"+ keys, {
      method: 'get',
      onSuccess: function(transport){
        translations = $H(transport.responseText.evalJSON());
        this.updateTableWithTranslations($H(translations));
      }.bind(this)
    });
  },
  updateTableWithTranslations: function(translations){
    $$('.reference_translation').each(function(element){element.remove();});
    this.tableRows.each(function(row){
      key = row.select("td:nth-child(1) label").first().getText();
      translation = translations.get(key);
      tr = document.createElement('tr');
      tr.addClassName('reference_translation');
      td = document.createElement('td');
      translationTd = document.createElement('td');
      translationTd.update(translation);
      tr.insert(td, {position:'top'});
      tr.insert(translationTd, {position:'bottom'});

      row.insert(tr,{position:'after'});
    });
  }
});

document.observe('dom:loaded', function(e){
  new TranslationFetcher('reference_languages', 'translations');
});