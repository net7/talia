// JavaScript Document
/*
obsolete variables.
var ofsTop=290;
var prevOffset =0;
var margin_bottom_menu = 290;
*/

/* *************************** */
/* funzione che imposta le altezze verticali degli
elementi senibili 
Viene azionata in on load e on resize*/
/* *************************** */
function setElementsVerticalSettings()
{
    /* posizionamento dell'elemento bottom menu: menu presente nella sidebar
    che sta allineato in basso */
    var side_bar_top = Element.cumulativeOffset($('side_bar')).top;
    var bottom_menu_lower_space = 0;
    var bottom_menu_margin_top = (document.viewport.getDimensions().height) - side_bar_top - bottom_menu_lower_space - ($('bottom_menu').getDimensions().height);
    $('bottom_menu').setStyle('margin-top: ' + bottom_menu_margin_top + 'px');
    /* ma devo controllare che l'oggetto non vada sopa il menu sotto */
    
    /*
    if(Element.cumulativeOffset($('bottom_menu')).top < (Element.cumulativeOffset($('top_menu')).top + ($('top_menu').getDimensions().height)))
    {
        $('bottom_menu').setStyle('margin-top: ' + (Element.cumulativeOffset($('top_menu')).top + ($('top_menu').getDimensions().height) - Element.cumulativeOffset($('side_bar')).top) + 'px');
    }
    */
    
    /* settaggio in altezza del div ext_page */
    $('ext_page').setStyle('height: '+document.viewport.getDimensions().height+'px');
    
    /* settaggio in altezza del div side_bar */
    $('side_bar').setStyle('height: '+(document.viewport.getDimensions().height - Element.cumulativeOffset($('side_bar')).top)+'px');
}

/* funzione per aprire e chiudere la side_bar  element_id -> id dell'elemento da chiudere, classOpen -> il nome della classe css per l'elemento aperto,  classClosed-> il nome della classe css per l'elemento chiuso */
function open_close(elementId , classOpen, classClosed){
    if($(elementId).hasClassName(classOpen)){
        $(elementId).removeClassName(classOpen); 
        $(elementId).addClassName(classClosed);
    } else {
        $(elementId).removeClassName(classClosed); 
        $(elementId).addClassName(classOpen);
    }
}
    
window.onresize = function(){
    set_vertical_pod_like_menu_items(); /* settaggio degli elementi verticali interni al pod like menu */
    setElementsVerticalSettings();
}

window.onscroll= function(){
}

window.onload = function(){
    set_vertical_pod_like_menu_items(); /* settaggio degli elementi verticali interni al pod like menu */
    $("bottom_menu").style.marginTop = 290 +"px";
    $("top_menu").style.marginTop = 60 +"px";
    setElementsVerticalSettings();
    /* applico al pulsante con id 'sidebar_button' le funzioni per aprire e chiudere side_bar */
    $('side_bar_button').onclick=function(){
    open_close("side_bar" , "open", "closed");
    open_close("contents_ext", "open", "closed");
    open_close("footer", "open", "closed");
    open_close("page", "open", "closed");
    }
}



/* *************************** */
/* funzione che dato un elemento della pagina,
ne impone l'altezza fino al fondo della pagina */
/* *************************** */
/* PARAMETRI:
- elementToModify: elemento da essere modificato
- distance, eventuale distanza dal fondo della pagina */
function setHeightTillBottom(elementToModify, distance)
{
    var altezzaFinestra = document.viewport.getDimensions().height;
    if(distance){
    elementToModify.setStyle('height:' + (altezzaFinestra - Element.cumulativeOffset(elementToModify).top - distance) + 'px');
    }else{elementToModify.setStyle('height:' + (altezzaFinestra - Element.cumulativeOffset(elementToModify).top) + 'px');}
}




/* ******************************** */
/* COSTRUZIONE DELL'ALBERO */
/* ******************************** */
function buildTreeModel() { /* costruzione dell'albero */
    /* creo la root */
    root = new TreeNode("root");
    
    /* primi livelli */
    var java = new TreeNode("java");
    var javax = new TreeNode("javax");
    var org = new TreeNode("org");
    root.add(java);
    root.add(javax);
    root.add(org);
    
    /* secondi livelli */
    var awt = new TreeNode("awt");
    awt.add(new TreeNode("color"));
    awt.add(new TreeNode("datatransfer"));
    awt.add(new TreeNode("dnd"));
    awt.add(new TreeNode("event"));
    awt.add(new TreeNode("font"));
    awt.add(new TreeNode("geom"));
    awt.add(new TreeNode("im"));
    awt.add(new TreeNode("image"));
    awt.add(new TreeNode("print"));
    
    java.add(awt);
    
    var swing = new TreeNode("swing");
    swing.add(new TreeNode("border"));
    swing.add(new TreeNode("colorchooser"));
    swing.add(new TreeNode("event"));
    swing.add(new TreeNode("filechooser"));
    var plaf = new TreeNode("plaf");
    plaf.add(new TreeNode("basic"));
    plaf.add(new TreeNode("metal"));
    plaf.add(new TreeNode("multi"));
    plaf.add(new TreeNode("synth"));
    swing.add(plaf);
    var text = new TreeNode("text");
    text.add(new TreeNode("html"));
    text.add(new TreeNode("rtf"));
    swing.add(text);
    var tree = new TreeNode("tree");
    swing.add(tree);
    
    tree.add(new TreeNode("MutableTreeNode"));
    tree.add(new TreeNode("RowMapper"));
    tree.add(new TreeNode("TreeCellEditor"));
    tree.add(new TreeNode("TreeCellRenderer"));
    tree.add(new TreeNode("TreeModel"));
    tree.add(new TreeNode("TreeNode"));
    tree.add(new TreeNode("TreeSelectionModel"));
    tree.add(new TreeNode("Classes "));
    tree.add(new TreeNode("AbstractLayoutCache"));
    tree.add(new TreeNode("AbstractLayoutCache.NodeDimensions"));
    tree.add(new TreeNode("DefaultMutableTreeNode"));
    tree.add(new TreeNode("DefaultTreeCellEditor"));
    tree.add(new TreeNode("DefaultTreeCellRenderer"));
    tree.add(new TreeNode("DefaultTreeModel"));
    tree.add(new TreeNode("DefaultTreeSelectionModel"));
    tree.add(new TreeNode("FixedHeightLayoutCache"));
    tree.add(new TreeNode("TreePath"));
    tree.add(new TreeNode("VariableHeightLayoutCache"));
    tree.add(new TreeNode("Exceptions "));
    tree.add(new TreeNode("ExpandVetoException"));
    
    javax.add(new TreeNode("mail"));
    javax.add(new TreeNode("xml"));
    javax.add(swing);
    
    var xml = new TreeNode("xml");
    var sax = new TreeNode("sax");
    sax.add(new TreeNode("ext"));
    sax.add(new TreeNode("helpers"));
    xml.add(sax);
    org.add(xml);
    
    var w3c = new TreeNode("w3c");
    var dom = new TreeNode("dom");
    
    dom.add(new TreeNode("Attr"));
    dom.add(new TreeNode("CDATASection"));
    dom.add(new TreeNode("CharacterData"));
    dom.add(new TreeNode("Comment"));
    dom.add(new TreeNode("Document"));
    dom.add(new TreeNode("DocumentFragment"));
    dom.add(new TreeNode("DocumentType"));
    dom.add(new TreeNode("DOMConfiguration"));
    dom.add(new TreeNode("DOMError"));
    dom.add(new TreeNode("DOMErrorHandler"));
    dom.add(new TreeNode("DOMImplementation"));
    dom.add(new TreeNode("DOMImplementationList"));
    dom.add(new TreeNode("DOMImplementationSource"));
    dom.add(new TreeNode("DOMLocator"));
    dom.add(new TreeNode("DOMStringList"));
    dom.add(new TreeNode("Element"));
    dom.add(new TreeNode("Entity"));
    dom.add(new TreeNode("EntityReference"));
    dom.add(new TreeNode("NamedNodeMap"));
    dom.add(new TreeNode("NameList"));
    dom.add(new TreeNode("Node"));
    dom.add(new TreeNode("NodeList"));
    dom.add(new TreeNode("Notation"));
    dom.add(new TreeNode("ProcessingInstruction"));
    dom.add(new TreeNode("Text"));
    dom.add(new TreeNode("TypeInfo"));
    dom.add(new TreeNode("UserDataHandler"));
    dom.add(new TreeNode("Exceptions "));
    dom.add(new TreeNode("DOMException"));
    
    w3c.add(dom);
    org.add(w3c);
    
    currNode = root; /* indica il nodo corrente */
    navigationLevel = 0; /* inizializzazione del livello di navigazione. 0 = root */
}

var podListWrap;
var topButton;
var botButton;
var currNode;
var root;
var oldList;
var newList;
var isReverse;
var navigationLevel; /* livello del menu di navigazione */
var currentPodNavPositionX; /* posizione corrente del div del navigatore */
var finalPodNavPositionX; /* posizione da ottenere del dei del navigatore */
var singlePodColumnWidth = 195;

/* ******************************** */
/* FUNZIONE PRINCIPALE CHIAMATA DA ON LOAD */
/* ******************************** */
function main() {
    if($("pod-list-wrap")) $("pod-list-wrap").style.left = "0px";  /* la posizione iniziale del div che contiene il pod navigation */
    findElements(); /* punto elementi del codice html */
    buildTreeModel(); /* costruzione dell'albero */
    renderPod(); /* rendring della navigazione INIZIALE */
}
/* ******************************** */
/* PUNTO GLI ID CON $ */
/* ******************************** */
function findElements() { /* punto elementi del codice html */ /*sembra ok */
    topButton 	= $("top-but");
    /* botButton 	= $("bot-but"); */
    podListWrap = $("pod-list-wrap");
    /* topButton.style.backgroundColor="#00FF00";
    botButton.style.backgroundColor="#00FF00";
    podListWrap.style.backgroundColor="red"; */
}
/* ******************************** */
/* RENDERING INZIALE DELL'OGGETTO	 */
/* ******************************** */
function renderPod() { /*sembra ok */
    _renderButtons(); /* questa funzione è quella che scrive il link in basso e in alto */
    _renderList();
}
/* ******************************** */
/* RENDERING QUANDO PREMO PER ANDARE A UN LIVELLO INFERIORE	 */
/* ******************************** */
function renderPodAfterButtonForwardPress(){ /* funzione di rendering chiamata quando clicco su un pulsante */
    _renderButtons(); /* questa funzione è quella che scrive il link in basso e in alto */
    _renderListAfterButtonPress();
}
/* ******************************** */
/* RENDERING QUANDO PREMO PER TORNARE SU DI UN LIVELLO */
/* ******************************** */
function renderPodAfterButtonBackPress(){ /* funzione di rendering chiamata quando clicco su un pulsante */
    _renderButtons(); /* questa funzione è quella che scrive il link in basso e in alto */
    _controlAnimateLists("right");
}
/*
function _renderButtons() { 
    var uo;
    if (currNode == root) {
        uo = "TEST";
    } else {
        uo = "&laquo; " + currNode.userObject;
    }
    topButton.innerHTML = uo;
}
*/
function _renderList() {
    oldList = newList;
    newList = _createNewListNode(); /* creo il div dove poi vado a mettere i contenuti */
}
function _renderListAfterButtonPress() {
    oldList = newList;
    newList = _createNewListNode(); /* creo il div dove poi vado a mettere i contenuti */
    _controlAnimateLists("left");
}

function _createNewListNode() { /* MODIFICATO */
    var destination = $("pod-list-wrap"); /* div di destinazione dove creare i risultati */
    var newCode = "<div id='identificazione_" + navigationLevel + "' style='width: " +singlePodColumnWidth+ "px; position:absolute; top:0; border-right: 1px solid #FFF; background-color: #999;' ><div>"; /* nuovo codice che poi andrà dentro, inizo aprendo un tag div */
    var kid;
    var html = "";
    for (var i = 0; i < currNode.children.length; i++) { /* loop per tutti i figli presenti, costruisco il codice */
        kid = currNode.children[i];
        html += "<a href='#'";
        if (kid.isLeaf()) {
            html += " class='leaf'>";
        } else {
        html += " onclick='podNodeClicked(" + i + ");' class='branch' >" /* passo l'id */
    }
    html += kid.userObject;
    if (kid.isLeaf()) { /* aggginta dell efreccettine, dopo lo possiamo fare da css */
    } else {
    html += " >> "
}
html += "<\/a><br />";
}
newCode += html;
newCode += "</div></div>";
destination.innerHTML = destination.innerHTML + newCode; 
$("identificazione_" + navigationLevel).style.marginLeft = singlePodColumnWidth * navigationLevel + "px";
$("identificazione_" + navigationLevel).style.width = singlePodColumnWidth + "px";

}

function _controlAnimateLists()
{
    if(isReverse == false)
    {
        currentPodNavPositionX = parseInt($("pod-list-wrap").style.left);
        finalPodNavPositionX = currentPodNavPositionX - singlePodColumnWidth - 5; /* questo 170 va ridefinito */
    }else if(isReverse == true){
        currentPodNavPositionX = parseInt($("pod-list-wrap").style.left);
        finalPodNavPositionX = currentPodNavPositionX + singlePodColumnWidth + 5; /* questo 170 va ridefinito */
    }
    _animateLists();
}


function _animateLists() {
    /* movimento */
    var condition;
    condition = 1;
    
    /* condizione */
    if (isReverse) {
        currentPodNavPositionX = currentPodNavPositionX+10;
        if(currentPodNavPositionX >= finalPodNavPositionX){condition = 0;};
    } else {
    currentPodNavPositionX = currentPodNavPositionX-10;
    if(currentPodNavPositionX <= finalPodNavPositionX){condition = 0;};
}

if (condition == 1) {
    $("pod-list-wrap").style.left = currentPodNavPositionX + "px";
    setTimeout("_animateLists()",1);
} else {
set_vertical_pod_like_menu_items();
/* qui devo cancellare il livello precedente */
$('identificazione_' + (navigationLevel + 1)).remove();
return;
}
}


function _removeOldList() {
    if (oldList) {
        podListWrap.removeChild(oldList);
    }
}

/* ******************************** */
/* FUNZIONI CHIAMATE DAI PULSANTI - AVANTI E INDIETRO*/
/* ******************************** */
/* avanti */
function podNodeClicked(child_num) {
    navigationLevel++;
    currNode = currNode.children[child_num]; /* imposto il current node come il nodo su cui ho cliccato sopra */
    isReverse = false;
    renderPodAfterButtonForwardPress(); /* funzione che ridisegna il menu */
}

/* indietro */
function podButtonClicked() {
    if (currNode == root) {
        return;
    } else {
    navigationLevel--;
    currNode = currNode.parent;
}
isReverse = true;
renderPodAfterButtonBackPress(); /* funzione che ridisegna il menu */
}


/* ******************************** */
/* CREAZIONE DELLA CLASSE TREE NODE pER LA GESTIONE DELL'ALBERO DI NAVIGAZIONE */
/* ******************************** */

function TreeNode(userObject) { /*creo il metodo */
	this.userObject = userObject;
	this.children = [];
	this.parent;
}

TreeNode.prototype.toString = function () {
	var result = "treeNode [uo=" + this.userObject
			+ ", childCount=" + this.children.length;
	if (this.parent) {
		result += ", parent.uo=" + this.parent.userObject;
	}
	result += "]";
	return result;
};

TreeNode.prototype.add = function (newChild) {
	if (newChild.parent) {
		newChild.parent.remove(newChild);
	}
	newChild.parent = this;
	/* alert(this.children.length); */
	this.children.push(newChild);
};

TreeNode.prototype.remove = function (child) {
	this.children.remove(child);
	child.parent = null;
};

TreeNode.prototype.isLeaf = function (child) {
	return this.children.length == 0;
};


/* ******************************** */
/* GESTIONE DELLA POSIZIONE DEGLI OGGETTI E DELLA LAORO ALTEZZA IN VERTICALE */
/* ******************************** */
function set_vertical_pod_like_menu_items()
{
    if($("pod-wrap"))
    {
        setHeightTillBottom($("pod-wrap"));
        setHeightTillBottom($("pod-list-wrap-ext"));
       setHeightTillBottom($("pod-list-wrap"));
    }
    
   
    /* $("pod-wrap").setStyle('border:1px solid red');
    $("pod-list-wrap-ext").setStyle('border:1px solid green');
    $("pod-list-wrap").setStyle('border:1px solid blue'); */
}




/* ******************************** */
/* CHIMATA INIZIALE ON LOAD */
/* ******************************** */
var func = window.onload;
if (typeof window.onload != 'function')
{
    window.onload = main;
} else {
    window.onload = function ()
    {
        func(); main();
    };
}

    