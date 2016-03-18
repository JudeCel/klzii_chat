import React, {PropTypes}       from 'react';
import Avatar from './avatar.js'

const Member = ({member}) => {
  function onlineStatus(online) {
    let color = (online ? "green": "");
    return { color: color };
  }

  const { id, username, role, online, avatar_info } = member;
  return(
    <div key={ id }>
      Name: { username }
      <br />
      Role: { role }
      <br />
      <div className=" glyphicon glyphicon-globe" style={onlineStatus(online)} />
      <Avatar avatar_info={avatar_info} id={id} />
    </div>
  )
}
export default Member;
