import React, { PropTypes } from 'react';
import { connect }          from 'react-redux';
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
    if(message.replies.length == 0) {
      return;
    } else {
      return (
        <div className='col-md-12 remove-side-margin pull-right'>
          {
            message.replies.map((reply) =>
              <Message key={ reply.id } message={ reply } />
            )
          }
        </div>
      )
    }
  },
  getMessageMember() {
    const { message, currentUser, participants, facilitator } = this.props;

    if (currentUser && message.session_member.id == currentUser.id) {
      return currentUser;
    } else if (facilitator && message.session_member.id == facilitator.id) {
      return facilitator;
    } else if (participants) {
      for (let i=0; i<participants.length; i++) {
        if (participants[i].id == message.session_member.id) {
          return participants[i];
        }
      }
    }
    return message.session_member;
  },
  getMessageSessionTopicContext() {
    const { message } = this.props;
    let sessionTopicContext = { };
    sessionTopicContext[message.session_member.currentTopic.id] = {
        avatarData: {
          face: message.emotion
        }
      };
    return sessionTopicContext;
  },
  render() {
    const { message, currentUser } = this.props;
    const { can_edit, can_delete, can_star, can_vote, can_reply } = message.permissions;

    let member = this.getMessageMember();
    let sessionTopicContext = this.getMessageSessionTopicContext();

    return (
      <div className='message-section media'>
        <div className={ this.mediaImagePosition(message) }>
          <div className={ 'emotion-chat-' + message.emotion } aria-hidden='true' style={{ backgroundColor: member.colour }}/>
          <div className='emotion-chat-avatar'>
            <Avatar member={ { id: member.id, username: member.username, colour: member.colour, avatarData: member.avatarData, sessionTopicContext: sessionTopicContext, online: true, edit: false } } specificId={ 'msgAvatar' + message.id } />
          </div>
        </div>

        <div className='media-body'>
          <div className='media-heading heading-section col-md-12'>
            <span className='pull-left' style={{ color: member.colour }}>
              { member.username }
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

const mapStateToProps = (state) => {
  return {
    currentUser: state.members.currentUser,
    participants: state.members.participants,
    facilitator: state.members.facilitator,
  }
};

export default connect(mapStateToProps)(Message);
