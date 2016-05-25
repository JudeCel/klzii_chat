function setAvatar(sessionMember, imgPath) {
  var avatar = Snap('.svg' + sessionMember.id);
  ad = sessionMember.avatarData;
  avatar.image(imgPath + '/base_' + padToTwo(ad.base) + '.svg', 0, 0, 76, 70);
  avatar.image(imgPath + '/face_' + padToTwo(ad.face) + '.svg', 0, 0, 76, 70);
  avatar.image(imgPath + '/body_' + padToTwo(ad.body) + '.svg', 0, 0, 76, 70);
  avatar.image(imgPath + '/hair_' + padToTwo(ad.hair) + '.svg', 0, 0, 76, 70);
  avatar.image(imgPath + '/desk_' + padToTwo(ad.desk) + '.svg', 0, 0, 76, 70);
  avatar.image(imgPath + '/head_' + padToTwo(ad.head) + '.svg', 0, 0, 76, 70);
}

function padToTwo(number) {
  if (number <= 99) number = '0' + number;
  return number;
}
