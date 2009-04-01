//= require <prototype>
//= require <lowpro>

Event.addBehavior({
  '#show_transcription:click': function(e) {
    $('transcription').visualEffect('blind_down');
    $('hide_transcription').toggle();
    e.element().hide();
    set_height();
  },
  '#hide_transcription:click': function(e) {
    $('transcription').visualEffect('blind_up');
    $('show_transcription').toggle();
    e.element().hide();
    set_height();
  }
});
