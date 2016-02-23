import React, {PropTypes}       from 'react';
import moment                   from 'moment'

const Message = ({ message, messageStar, deleteMessage }) => {
  let activeStarClass = (message.star ? "active" : "");
  let formattedTime =  moment(new Date(message.time)).format("ddd h:mm D/YY");
  let avatarColor = message.session_member.colour.toString(16);
  let messageHeaderStyle = {
    backgroundColor: `#${avatarColor}`
  }

  return (
    <div className="message-container">
      <div className="avatar-container col-md-2">
        <div className={"star " + activeStarClass + " glyphicon glyphicon-star " }
          onClick={ messageStar }
          id={ message.id }
          />
      </div>
      <div className="message">
        <div className="message-header col-md-10" style={messageHeaderStyle}>
          <div className="user">
            {message.session_member.username}
          </div>
          <div className="timestamp">
            { formattedTime }
          </div>
        </div>
        <div className="message-body ">
            {message.event.body}
        </div>
      </div>
      <div className="message-action-list">
        <div
          onClick={ deleteMessage }
          id={ message.id }
          className="remove glyphicon glyphicon-remove"
        />
      </div>
      <hr/>
    </div>
  );
}
export default Message;
