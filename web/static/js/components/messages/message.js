import React, {PropTypes}       from 'react';

const Message = ({ message, messageStar, deleteMessage }) => {
  let activeStarClass = (message.star ? "active" : "");
  return (
    <div className="message-container">
      <div className="avatar-container">

      </div>
      <div className="message">
        <header className="message-header">
          User Name: {message.session_member.username}
        </header>
        <div className="message-body">
            Message: {message.event.body}
        </div>
      </div>
      <div className="message-action-list">
        <div className={"star " + activeStarClass + " glyphicon glyphicon-star " }
          onClick={ messageStar }
          id={ message.id }
        />
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
