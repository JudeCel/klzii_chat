import React, { PropTypes }       from 'react';
import moment                     from 'moment'
import MessageActions             from './actions'

const { Edit, Delete, Star, ThumbsUp, Reply } = MessageActions

const Message =  React.createClass({
  formattedTime(message) {
    return  moment(new Date(message.time)).format("ddd h:mm D/YY")
  },
  avatarColor(message){
    return message.session_member.colour.toString(16)
  },
  messageHeaderStyle(message){
    return { backgroundColor: `#${this.avatarColor(message)}`}
  },
  filter(e){
    console.log(e);
  },
  render(){
    const { replyMessage, messageStar, message, deleteMessage, editMessage, thumbsUp } = this.props;
    const { can_edit, can_delete, can_star, can_vote, can_reply } = message.permissions;
    return (
      <div className="row message-container">
        <div className="avatar-container col-md-2">
          <div className="avatar glyphicon glyphicon-user">

          </div>
          <Star
            onClick={ messageStar }
            data={ { id: message.id, star: message.star} }
            can={ can_star}
            />
        </div>
        <div className="message">
          <div className="message-header col-md-10" style={ this.messageHeaderStyle(message)}>
            <div className="user">
              {message.session_member.username}
            </div>
            <div className="timestamp">
              { this.formattedTime(message) }
            </div>
          </div>
          <div className="message-body ">
              {message.event.body}
          </div>
        </div>
        <div className="message-action-list">
          <ThumbsUp
            data={ {
              id: message.id,
              votes_count: message.votes_count,
              has_voted: message.has_voted}
            }
            onClick={ thumbsUp }
            can={ can_vote }
            />
          <Edit
            data={ {id: message.id, body: message.event.body} }
            can={ can_edit }
            onClick={ editMessage}
          />
          <Reply
            data={ {id: message.id} }
            can={ can_reply }
            onClick={ replyMessage}
          />
          <Delete
            onClick={ deleteMessage }
            data={ {id: message.id} }
            can={ can_delete }
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
              thumbsUp={ thumbsUp }
              isReply= { false }
              key={ reply.id }
            />)
          })
          }
        </div>
      </div>
    )
  }
})
export default Message;
