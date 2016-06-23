function setAvatar(sessionMember, imgPath) {
  avatars = document.getElementsByClassName('svg' + sessionMember.id);

  for(var i = 0; i < avatars.length; i++){
    var svg = Snap(avatars[i]);
      var ad = sessionMember.avatarData;
      if(ad.base >= 0) svg.image(imgPath + '/base_' + padToTwo(ad.base) + '.svg', 0, 0, 76, 70);
      if(ad.face >= 0) svg.image(imgPath + '/face_' + padToTwo(ad.face) + '.svg', 0, 0, 76, 70);
      if(ad.body >= 0) svg.image(imgPath + '/body_' + padToTwo(ad.body) + '.svg', 0, 0, 76, 70);
      if(ad.hair >= 0) svg.image(imgPath + '/hair_' + padToTwo(ad.hair) + '.svg', 0, 0, 76, 70);
      if(ad.desk >= 0) svg.image(imgPath + '/desk_' + padToTwo(ad.desk) + '.svg', 0, 0, 76, 70);
      if(ad.head >= 0) svg.image(imgPath + '/head_' + padToTwo(ad.head) + '.svg', 0, 0, 76, 70);
  }
}

function padToTwo(number) {
  if (number <= 99) number = '0' + number;
  return number;
}
