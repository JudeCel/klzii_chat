import React, {PropTypes}       from 'react';
import moment                   from 'moment'

const Message = ({ isReply = true, message, messageStar, deleteMessage, replyMessage, editMessage }) => {
  let activeStarClass = (message.star ? "active" : "");
  let formattedTime =  moment(new Date(message.time)).format("ddd h:mm D/YY");
  let avatarColor = message.session_member.colour.toString(16);
  let messageHeaderStyle = {
    backgroundColor: `#${avatarColor}`
  }

  let replyAction = (() => {
    if(isReply) {
    return (<div
      onClick={ replyMessage }
      data-replyid={ message.id }
      className="action glyphicon glyphicon-comment"
      />)
    }
  })();

  return (
    <div className="message-container">
      <div className="avatar-container col-md-2">
        <div className={"star " + activeStarClass + " glyphicon glyphicon-star " }
          onClick={ messageStar }
          data-id={ message.id }
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
          data-id={ message.id }
          data-body={ message.event.body }
          className="action glyphicon glyphicon-edit"
          />
        {replyAction}
        <div
          onClick={ deleteMessage }
          data-id={ message.id }
          className="action glyphicon glyphicon-remove"
        />
      </div>
      <div className= "replies col-md-10 pull-right">
        { message.replies.map( (reply) => {
          return (<Message
            message={ reply }
            deleteMessage={ deleteMessage }
            messageStar={ messageStar }
            editMessage={ editMessage }
            replyMessage={ replyMessage }
            isReply= { false }
            key={ reply.id }
          />)
        })
        }
      </div>
    </div>
  );
}
export default Message;
