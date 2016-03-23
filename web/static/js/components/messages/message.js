import React, { PropTypes }       from 'react';
import moment                     from 'moment';
import MessageActions             from './actions';
import Avatar                     from '../members/avatar.js';

const { Edit, Delete, Star, ThumbsUp, Reply } = MessageActions

const Message = React.createClass({
  formattedTime(message) {
    return moment(new Date(message.time)).format('ddd h:mm D/YY');
  },
  thumbsUpDate() {
    const { message } = this.props;

    return {
      id: message.id,
      votes_count: message.votes_count,
      has_voted: message.has_voted
    };
  },
  editData() {
    const { message } = this.props;

    return {
      id: message.id,
      body: message.event.body
    };
  },
  replyData() {
    const { message } = this.props;

    return {
      id: message.id
    };
  },
  deleteData() {
    const { message } = this.props;

    return {
      id: message.id
    };
  },
  starData() {
    const { message } = this.props;

    return {
      id: message.id,
      star: message.star
    };
  },
  mediaImagePosition() {
    const { message } = this.props;

    if(message.replies.length > 0) {
      return 'media-left media-top push-image-down';
    }
    else {
      return 'media-left media-bottom push-image-up';
    }
  },
  isRepliedMessage() {
    return this.props.message.replyId ? true : false;
  },
  actionListClass() {
    if(this.isRepliedMessage()) {
      return 'row col-md-12';
    }
    else {
      return 'col-md-12';
    }
  },
  render() {
    const { replyMessage, messageStar, message, deleteMessage, editMessage, thumbsUp } = this.props;
    const { can_edit, can_delete, can_star, can_vote, can_reply } = message.permissions;

    return (
      <div className='message-section media'>
        <div className={ this.mediaImagePosition() }>
          <span className='media-object glyphicon glyphicon-th' aria-hidden='true'></span>
        </div>

        <div className='media-body'>
          <div className='media-heading col-md-12' style={ { backgroundColor: 'red' } }>
            <span className='pull-left'>
              { message.session_member.username }
            </span>
            <span className='pull-right'>
              { this.formattedTime(message) }
            </span>
          </div>

          <div className='col-md-12' style={ { backgroundColor: "purple" } }>
            { message.event.body }
          </div>

          <div className={ this.actionListClass() }>
            <span className='pull-right'>
              <ThumbsUp data={ this.thumbsUpDate() } can={ can_vote } onClick={ thumbsUp } />
              <Edit data={ this.editData() } can={ can_edit } onClick={ editMessage } />
              <Reply data={ this.replyData() } can={ can_reply } onClick={ replyMessage } />
              <Delete data={ this.deleteData() } can={ can_delete } onClick={ deleteMessage } />
              <Star data={ this.starData() } can={ can_star} onClick={ messageStar } />
            </span>
          </div>

          {/* wrong - row and col*/}
          <div className='row col-md-12 pull-right'>
            {
              message.replies.map((reply) => {
                return (
                  <Message
                    message={ reply }
                    deleteMessage={ deleteMessage }
                    messageStar={ messageStar }
                    editMessage={ editMessage }
                    replyMessage={ replyMessage }
                    thumbsUp={ thumbsUp }
                    isReply= { false }
                    key={ reply.id }
                  />
                )
              })
            }
          </div>
        </div>
      </div>

    )
  }
});

export default Message;
