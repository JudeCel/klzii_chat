function setAvatar(id, avatarData, imgPath) {
  var svg = SVG(id);
  var array = ['base', 'face', 'body', 'hair', 'desk', 'head'];
  for(var u in array) {
    var key = array[u];
    var value = avatarData[key];
    if(value >= 0) svg.image(imgPath + '/' + key + '_0' + value + '.svg', 0, 0, 150, 70);
  }
}
