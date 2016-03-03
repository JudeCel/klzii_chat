import React, {PropTypes}       from 'react';

const Member = ({member}) => {
  function onlineStatus(online) {
    let color = (online ? "green": "");
    return { color: color };
  }
  
  const { id, username, role, online } = member;

  return(
    <div key={ id }>
      Name: { username }
      <br />
      Role: { role }
      <br />
      <div className=" glyphicon glyphicon-globe"style={onlineStatus(online)} />
    </div>
  )
}
export default Member;
