// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
function remove_from_collection(element, selector) {
  hiding_visual_effect(element, selector);
  window.clearTimeout(Element.remove.delay(0.00001, $(element).up(selector)));
}

function mark_for_destroy(element, selector) {
  $(element).next('.should_destroy').value = 1;
  hiding_visual_effect(element, selector);
}

function hiding_visual_effect(element, selector) {
	new Effect.SwitchOff($(element).up(selector));
}
