function setAvatar(sessionMember, imgPath) {
  var avatar = Snap('.svg' + sessionMember.id);
  avatar.image(imgPath + '/base_00.svg', 0, 0, 152, 140);
  avatar.image(imgPath + '/face_00.svg', 0, 0, 152, 140);
  avatar.image(imgPath + '/body_00.svg', 0, 0, 152, 140);
  avatar.image(imgPath + '/hair_00.svg', 0, 0, 152, 140);
  avatar.image(imgPath + '/desk_00.svg', 0, 0, 152, 140);
  avatar.image(imgPath + '/head_00.svg', 0, 0, 152, 140);
}
