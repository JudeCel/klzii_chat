import React, { PropTypes }       from 'react';
import moment                     from 'moment'
import MessageActions             from './actions'
import Avatar                     from '../members/avatar.js'

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
  render(){
    const { replyMessage, messageStar, message, deleteMessage, editMessage, thumbsUp } = this.props;
    const { can_edit, can_delete, can_star, can_vote, can_reply } = message.permissions;
    return (

      <div className="row message-container">
        <div className="col-md-12">
         <div className="media-body">
              {message.event.body}
         </div>
         <small className="text-muted">
           {message.session_member.username} | { this.formattedTime(message) }
         </small>
       </div>
         <div className="message-action-list col-md-12">
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
        <Star
          onClick={ messageStar }
          data={ { id: message.id, star: message.star} }
          can={ can_star}
          />
        </div>
        <div className="col-md-12">
          <hr/>
        </div>
        <div className= "col-md-12 pull-right row">
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
