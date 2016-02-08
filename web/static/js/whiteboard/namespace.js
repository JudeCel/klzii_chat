(function(){
  window.namespace = function(namespaceString) {
    let parts = namespaceString.split('.'),
        parent = window,
        currentPart = '';

    for (let i = 0, length = parts.length; i < length; i++) {
        currentPart = parts[i];
        parent[currentPart] = parent[currentPart] || {};
        parent = parent[currentPart];
    }

    return parent;
  };
  window.isEmpty = function(value) {
      if (typeof value == "undefined") return true;					//	undefined object?
      if (value === null) return true;								//	null object?
      if (value === '') return true;									//	is it an empty string?
      if (typeof value == "number" && isNaN(value)) return true;		//	valid Number?
      if (value instanceof Date && isNaN(Number(value))) return true;	//	valid Date?

      return false;
  }

  window.colourToHex =  function colourToHex(colour) {
    //	colour being passed could be a string
    colour = parseInt(colour);

    //if (isEmpty(colour)) return "#000";

    var hexColour = colour.toString(16);

    //	make sure our colour is padded
    while (hexColour.length < 6) hexColour = '0' + hexColour;

    return '#' + hexColour;
}
})()
