// Load window
Event.observe(window, 'load', function() {
  configurePopUp();
});

// Resize , not implemented yet
window.onresize = function() {
	// alert('resized');
};


// Look trhu the whole code looking for the right stuff
function configurePopUp() {
	popUpElements = $$('span.popup');
	// alert("length: " + popUpElements.length);
	
	for(i=0; i < popUpElements.length; i++) {
		configureSinglePopUp(popUpElements[i]);
	}
}

// handle the single element
function configureSinglePopUp(element) {
	var ballonText = element;
	var highlightedText = ballonText.previous();
	
	
	// highlightedText.wrap('span', {'class': 'highlightedTextWrapper'});
	highlightedText.insert("<div class='tooltip'>" + ballonText.innerHTML + "</div>");
	
	highlightedText.setStyle({cursor: 'pointer'});
	
	var newElement = highlightedText.select('div.tooltip')[0];
	
	newElement.insert("<div class='stem'></div>");
	newElement.insert("<div class='close'></div>");
	
	
	var newElementStem = newElement.select('div.stem')[0];
	var newElementClose = newElement.select('div.close')[0];
	
	highlightedText.observe('click', function(event){
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
		
		
		
		
		// highlightedText.select('div.tooltip')[0].show();
		// highlightedText.select('div.tooltip')[0].toggle();
		
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
	  textAlign: 'justify',
	  padding: '30px 10px 10px 10px',
	  border: '5px solid #7d7d7d',
	  lineHeight: '16px',
	  top: '0',
	  left: '0',
	  color: '#363636'
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
	  background: 'url(/images/tooltip/close.gif) center center no-repeat',
	  width: '15px',
	  height: '15px',
	  left: '0'
	});
	
	setPopUpWidth(newElement);
	setPopUpPosition(newElement, highlightedText, newElementStem, newElementClose);
	
	// var roundCorners = Rico.Corner.round.bind(Rico.Corner);
	// roundCorners(newElement,{corners:"top",color: "transparent"});
}


// Larghezza della popUp
function setPopUpWidth(popUp) {
	var maxPopUpWidth = 300;
	popUp.setStyle({
		width: '300px'
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
	
	// Parte alta della finestra
	if(fatherTop < (windowHeight/2)) {
		popUpTop = fatherHeight + 20;
		stemTop = -20;
		closeTop = 5;
		stemFile += "bottom_";
	} else {
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
		background: 'url(/images/tooltip/'+ stemFile +') center center no-repeat',
	});

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