// General utilities used in accordion and pod navigation


// Given an array of A elements strips the HREF attribute from 
// each one of them. This is to give priority to javascript onclick
// events when js is active. When it's not present in the browser, the
// page works normally with HREFs
function deleteHrefAttributes(elements) {
    for(i=0; i<elements.length; i++) {
        elements[i].writeAttribute('href', false);
    }
} // deleteHrefAttributes()

// Switches an element's class from class1 to class2 or vice-versa. 
// 'element' is the dom element (retrieved with $('id_element') for example)
function switch_class(element , class1, class2){
    if (element.hasClassName(class1)) {
        element.removeClassName(class1); 
        element.addClassName(class2);
    } else if (element.hasClassName(class2)) {
        element.removeClassName(class2); 
        element.addClassName(class1);
    }
} // switch_class()