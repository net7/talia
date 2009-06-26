// Load window
Event.observe(window, 'load', function() {
  configurePopUp();
});

// Resize , not implemented yet
window.onresize = function() {
};

// Look thru the whole code looking for the right stuff
function configurePopUp() {
	popUpElements = $$('span.popup');
	
	for(i=0; i < popUpElements.length; i++) {
		configureSinglePopUp(popUpElements[i]);
	}
}

// handle the single element
function configureSinglePopUp(element) {
    /*        var ballonText = element;
	var highlightedText = ballonText.previous();
    */
	/***	var highlightedText = element.cloneNode(true);
	highlightedText.innerHTML = '';
	ballonText.parentNode.insertBefore(highlightedText, ballonText);
	*/

	var highlightedText = element;
	var tmpText = element.innerHTML;
	element.innerHTML = '';
	element.removeAttribute('id');
	element.removeAttribute('class');


    //  highlightedText.setStyle({cursor: 'pointer', backgroundColor: '#e9dbb1', position: 'relative'});
	//   highlightedText.insert("<div class='tooltip' style='position:absolute;'>" + ballonText.innerHTML + "</div>");
    highlightedText.setStyle({cursor: 'pointer', backgroundColor: '#e9dbb1', position: 'relative'});
    highlightedText.insert("<div class='tooltip' style='position:absolute;'>" + tmpText + "</div>");

	//ballonText.innerHTML = '';

	var newElement = highlightedText.select('div.tooltip')[0];
	var newElementWidth = newElement.getWidth();
	
	newElement.insert("<div class='stem'></div>");
	newElement.insert("<div class='close'></div>");
	
	var newElementStem = newElement.select('div.stem')[0];
	var newElementClose = newElement.select('div.close')[0];
	
	// Gestione apri e chiudi
	//highlightedText.observe('click', function(event){
    element.previous().observe('click', function(event){
		var clickedToolTip = highlightedText.select('div.tooltip')[0];
		var clickedToolTipStatus;
		if(clickedToolTip.visible() == false) {
			clickedToolTipStatus = false;
		} else {
			clickedToolTipStatus = true;
		}
		hideAllPopUps();
		if(clickedToolTipStatus == true) {
			highlightedText.select('div.tooltip')[0].hide();
		} else {
			highlightedText.select('div.tooltip')[0].show();
		}
	});
	
	newElementClose.observe('click', function(event){
		// this.ancestors()[0].toggle();
		// hideAllPopUps();
	});
	 
	newElement.setStyle({
	  display: 'none',
	  position: 'absolute',
	  backgroundColor: '#e1e1e1',
	  fontSize: '12px',
	  zIndex: '100',
	  textAlign: 'justify',
	  padding: '22px 10px 10px 10px',
	  border: '5px solid #7d7d7d',
	  lineHeight: '16px',
	  top: '0',
	  left: '0',
	  color: '#363636',
	  textIndent: '0px'
	});
	
	newElementStem.setStyle({
	  position: 'absolute',
	  top: '0',
	  width: '15px',
	  height: '15px',
	  left: '0'
	});
	
	newElementClose.setStyle({
	  position: 'absolute',
	  top: '0',
	  background: 'url(images/tooltip/close.gif) center center no-repeat',
	  width: '15px',
	  height: '15px',
	  left: '0'
	});
	
	setPopUpWidth(newElement, newElementWidth, highlightedText);
	setPopUpPosition(newElement, highlightedText, newElementStem, newElementClose);
}


// Larghezza della popUp
function setPopUpWidth(popUp, width, father) {
	
	var popUpHeight = popUp.getHeight();
	var maxPopUpWidth;
	
	if(popUpHeight > 300) {
		// alert("WARNS");
		if(retrievePositionQuarter(father) == 1 || retrievePositionQuarter(father) == 4) {
			// alert("1 o 4");
			maxPopUpWidth = document.viewport.getDimensions().width - 100 - father.cumulativeOffset().left;
		} else if(retrievePositionQuarter(father) == 2 || retrievePositionQuarter(father) == 3) {
			// alert("2 o 3");
			maxPopUpWidth = document.viewport.getDimensions().width - 100 - ( document.viewport.getDimensions().width - father.cumulativeOffset().left);
		}
	} else {
		maxPopUpWidth = width;
	}
	
	// retrievePositionQuarter(father) == 1
	/*
	var popUpHeight = popUp.getHeight();
	if(popUpHeight > 200)
		maxPopUpWidth = document.viewport.getDimensions().width - 100;
	else
		var maxPopUpWidth = 200;
	var maxPopUpWidth = width;	
	*/
	
	popUp.setStyle({
		width: maxPopUpWidth + 'px'
	});
}

// Posizione della popUp
function setPopUpPosition(popUp, father, stem, close) {
	
	var fatherWidth = father.getWidth();
	var fatherHeight = father.getHeight();
	var fatherLeft = father.cumulativeOffset().left;
	var fatherTop = father.cumulativeOffset().top;
	var windowWidth = document.viewport.getDimensions().width;
	var windowHeight = document.viewport.getDimensions().height;
	var popUpWidth = popUp.getWidth();
	var popUpHeight = popUp.getHeight();
	var popUpLeft;
	var popUpTop;
	
	// Stem variables
	var stemTop;
	var stemLeft;
	
	// Close variables
	var closeTop;
	var closeLeft;
	
	var stemFile = "stem_";
	
	// alert(retrievePositionQuarter(father));
	
	if(retrievePositionQuarter(father) == 1) {
			popUpTop = fatherHeight + 20;
			stemTop = -20;
			closeTop = 5;
			stemFile += "bottom_";
			popUpLeft = fatherWidth/2;
			stemLeft = 15;
			closeLeft = popUpWidth - 20;
			stemFile += "right.gif";
	} else 	if(retrievePositionQuarter(father) == 2) {
			popUpTop = fatherHeight + 20;
			stemTop = -20;
			closeTop = 5;
			stemFile += "bottom_";
			popUpLeft = - popUpWidth + (fatherWidth/2);
			stemLeft = popUpWidth - 40;
			closeLeft = popUpWidth - 20;
			stemFile += "left.gif";
	} else 	if(retrievePositionQuarter(father) == 3) {
			popUpTop = - popUpHeight - 20;
			stemTop = popUpHeight+5;
			closeTop = 5;
			stemFile += "top_";
			popUpLeft = - popUpWidth + (fatherWidth/2);
			stemLeft = popUpWidth - 40;
			closeLeft = popUpWidth - 20;
			stemFile += "left.gif";
	} else	if(retrievePositionQuarter(father) == 4) {
			popUpTop = - popUpHeight - 20;
			stemTop = popUpHeight+5;
			closeTop = 5;
			stemFile += "top_";
			popUpLeft = fatherWidth/2;
			stemLeft = 15;
			closeLeft = popUpWidth - 20;
			stemFile += "right.gif";
	} 
	
	/*
	// Parte alta della finestra
	if(fatherTop < (windowHeight/2)) {
		popUpTop = fatherHeight + 20;
		stemTop = -20;
		closeTop = 5;
		stemFile += "bottom_";
	} else { // Parte bassa della finestra
		popUpTop = - popUpHeight - 20;
		stemTop = popUpHeight+5;
		closeTop = 5;
		stemFile += "top_";
	}
	
	// La parola è a sinistra nella finestra
	if(fatherLeft < (windowWidth/2)) {
		popUpLeft = fatherWidth/2;
		stemLeft = 15;
		closeLeft = popUpWidth - 20;
		stemFile += "right.gif";
	} else { // La parola è a destra nella finestra
		popUpLeft = - popUpWidth + (fatherWidth/2);
		stemLeft = popUpWidth - 40;
		closeLeft = popUpWidth - 20;
		stemFile += "left.gif";
	}
	*/
	
	popUp.setStyle({
		top: popUpTop + 'px',
		left: popUpLeft + 'px'
	});
	
	close.setStyle({
		top: closeTop + 'px',
		left: closeLeft + 'px'
	});
	
	stem.setStyle({
		top: stemTop + 'px',
		left: stemLeft + 'px',
		background: 'url(images/tooltip/'+ stemFile +') center center no-repeat'
	});


	// alert("Top: " + popUp.cumulativeOffset().top + ", bottom: " +  (document.viewport.getDimensions().height - popUp.cumulativeOffset().top + popUp.getHeight()) + ", left: " + popUp.cumulativeOffset().left + ", right: " + (document.viewport.getDimensions().width - popUp.cumulativeOffset().left + popUp.getWidth()));

}

function retrievePositionQuarter(elementFather) {

	var fatherLeft = elementFather.cumulativeOffset().left;
	var fatherTop = elementFather.cumulativeOffset().top;
	var windowWidth = document.viewport.getDimensions().width;
	var windowHeight = document.viewport.getDimensions().height;
	
	var returnString;
	
	// Parte alta della finestra
	if(fatherTop < (windowHeight/2)) {
		// La parola è a sinistra nella finestra
		if(fatherLeft < (windowWidth/2)) {
			// Alto a sinistra
			returnString = 1;
		} else { // La parola è a destra nella finestra
			// Alto a destra
			returnString = 2;
		}
	} else { // Parte bassa della finestra
		// La parola è a sinistra nella finestra
		if(fatherLeft < (windowWidth/2)) {
			// Basso a sinistra
			returnString = 4;
		} else { // La parola è a destra nella finestra
			// Basso a destra
			returnString = 3;
		}
	}
	return returnString;
}

// Nasconde tutte le pop up
function hideAllPopUps() {
	allToolTipsPopUp = $$('div.tooltip');
	
	for(i=0; i < allToolTipsPopUp.length; i++) {
		allToolTipsPopUp[i].setStyle({
			display: 'none'
		});
	}
}