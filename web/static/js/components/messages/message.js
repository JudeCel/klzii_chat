import React, {PropTypes}       from 'react';
import moment                   from 'moment'

const Message = ({ message, messageStar, deleteMessage, replayMessage, editMessage }) => {
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
          onClick={ editMessage }
          id={ message.id }
          className="action glyphicon glyphicon-edit"
          />
        <div
          onClick={ replayMessage }
          id={ message.id }
          className="action glyphicon glyphicon-comment"
        />
        <div
          onClick={ deleteMessage }
          id={ message.id }
          className="action glyphicon glyphicon-remove"
        />
      </div>
      <hr/>
      <div className= "replies col-md-10 pull-right">
        { message.replies.map( (replay) => {
          return (<Message
            message={ replay }
            deleteMessage={ deleteMessage }
            messageStar={ messageStar }
            editMessage={ editMessage }
            replayMessage={ replayMessage }
            key={ replay.id }
          />)
        })
        }
      </div>
    </div>
  );
}
export default Message;
