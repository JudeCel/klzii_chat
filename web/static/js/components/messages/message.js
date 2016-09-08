import React, { PropTypes } from 'react';
import MessageActions       from './actions';
import mixins               from '../../mixins';
import Avatar               from '../members/avatar.js';

const { EditMessage, DeleteMessage, StarMessage, RateMessage, ReplyMessage } = MessageActions;

const Message = React.createClass({
  mixins: [mixins.helpers],
  mediaImagePosition(message) {
    const className = 'emotion-chat-section push-image ';
    return className + (message.replies.length > 0 ? 'media-top' : 'media-bottom');
  },
  bodyClassname(message) {
    const className = 'body-section col-md-12';
    return className + (message.session_member.role == 'facilitator' ? ' facilitator' : ' participant');
  },
  shouldShowRepliedMessages(message) {
    if(message.replyId) {
      return;
    }

    return (
      <div className='col-md-12 remove-side-margin pull-right'>
        {
          message.replies.map((reply) =>
            <Message key={ reply.id } message={ reply } />
          )
        }
      </div>
    )
  },
  render() {
    const { message } = this.props;
    const { can_edit, can_delete, can_star, can_vote, can_reply } = message.permissions;
    

    var member = message.session_member;
    member.sessionTopicContext[member.currentTopic.id].avatarData.face = message.emotion;
    member.online = true;

    return (
      <div className='message-section media'>
        <div className={ this.mediaImagePosition(message) }>
          <div className={ 'emotion-chat-' + message.emotion } aria-hidden='true' style={{ backgroundColor: message.session_member.colour }}/>
          <div className='emotion-chat-avatar'>
            <Avatar member={ member } specificId={ 'msgAvatar' + message.id } />
          </div>
        </div>

        <div className='media-body'>
          <div className='media-heading heading-section col-md-12'>
            <span className='pull-left' style={{ color: message.session_member.colour }}>
              { message.session_member.username }
            </span>

            <span className='pull-right'>
              <small>{ this.formatDate(message.time) }</small>
            </span>
          </div>

          <div className={ this.bodyClassname(message) }>
            <p className='text-break-all'>{ message.body }</p>
          </div>

          <div className='action-section col-md-12 text-right'>
            <StarMessage    permission={ can_star }   message={ message } />
            <ReplyMessage   permission={ can_reply }  message={ message } />
            <RateMessage    permission={ can_vote }   message={ message } />
            <EditMessage    permission={ can_edit }   message={ message } />
            <DeleteMessage  permission={ can_delete } message={ message } />
          </div>

          { this.shouldShowRepliedMessages(message) }
        </div>
      </div>
    )
  }
});

export default Message;
