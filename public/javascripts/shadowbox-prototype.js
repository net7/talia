//= require <prototype>
if(typeof Prototype=="undefined"){throw"Unable to load Shadowbox, Prototype framework not found"}var Shadowbox={};Shadowbox.lib=function(){var C={};var B=/(-[a-z])/gi;var A=function(E,F){return F.charAt(1).toUpperCase()};var D=function(F){var E;if(!(E=C[F])){E=C[F]=F.replace(B,A)}return E};return{adapter:"prototype",getStyle:function(F,E){return Element.getStyle(F,E)},setStyle:function(G,F,H){if(typeof F=="string"){var E={};E[D(F)]=H;F=E}Element.setStyle(G,F)},get:function(E){return $(E)},remove:function(E){Element.remove(E)},getTarget:function(E){return Event.element(E)},preventDefault:function(E){Event.stop(E)},getPageXY:function(F){var E=Event.pointer(F);return[E.x,E.y]},keyCode:function(E){return E.keyCode},addEvent:function(G,E,F){Event.observe(G,E,F)},removeEvent:function(G,E,F){Event.stopObserving(G,E,F)},append:function(F,E){Element.insert(F,E)}}}();