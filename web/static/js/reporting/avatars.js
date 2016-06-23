function setAvatar(sessionMember, imgPath) {
  avatars = document.getElementsByClassName('svg' + sessionMember.id);

  for(var i = 0; i < avatars.length; i++){
    var svg = Snap(avatars[i]);
      var ad = sessionMember.avatarData;
      svg.image(imgPath + '/base_' + padToTwo(ad.base) + '.svg', 0, 0, 76, 70);
      svg.image(imgPath + '/face_' + padToTwo(ad.face) + '.svg', 0, 0, 76, 70);
      svg.image(imgPath + '/body_' + padToTwo(ad.body) + '.svg', 0, 0, 76, 70);
      svg.image(imgPath + '/hair_' + padToTwo(ad.hair) + '.svg', 0, 0, 76, 70);
      svg.image(imgPath + '/desk_' + padToTwo(ad.desk) + '.svg', 0, 0, 76, 70);
      svg.image(imgPath + '/head_' + padToTwo(ad.head) + '.svg', 0, 0, 76, 70);
  }
}

function padToTwo(number) {
  if (number <= 99) number = '0' + number;
  return number;
}
