// hide open-id form by default
Event.onReady(function() {
  $('openid_login').hide();
});

Event.addBehavior({
  '#password_login a:click' : function(e) {
	  // TODO why doesn't works?
  	// new Effect.toggle('password_login','openid_login');
    new Effect.Fade('password_login', {duration: 0.001});
   	new Effect.Appear('openid_login', {duration: 0.4});
  },
  '#openid_login a:click' : function(e) {
	  // TODO why doesn't works?
  	// new Effect.toggle('openid_login', 'password_login');
    new Effect.Fade('openid_login', {duration: 0.001});
   	new Effect.Appear('password_login', {duration: 0.4});
  }
});