var Document = {
	cookies: function(document){
		var result = $A(document.cookie.split("; ")).inject($H({}), function(memo, pair){
			pair = pair.split('=');
			memo.set(pair[0], pair[1]);
			return memo;
		});
		return result;
	}
};
Object.extend(document, {	cookies: Document.cookies.methodize() });
