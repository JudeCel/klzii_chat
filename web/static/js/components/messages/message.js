import React, { PropTypes } from 'react';
import { connect }          from 'react-redux';
import VisibilitySensor     from "react-visibility-sensor";
import MessageActions       from './actions';
import MessagesActions      from '../../actions/messages';
import mixins               from '../../mixins';
import Avatar               from '../members/avatar.js';

const { EditMessage, DeleteMessage, StarMessage, RateMessage, ReplyMessage } = MessageActions;

const Message = React.createClass({
  mixins: [mixins.validations, mixins.helpers, mixins.modalWindows],
  messageElemet: null,
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
      const { currentUser, participants, facilitator, modalWindows, channel } = this.props;
      return (
        <div className='reply-section'>
          {
            message.replies.map((reply) =>
              <Message key={ reply.id } message={ reply }
                currentUser={ currentUser } participants={ participants }
                facilitator={ facilitator }  modalWindows={ modalWindows }
                dispatch={ this.props.dispatch } channel={ channel }
                chatSectionElemet={ this.props.chatSectionElemet } />
            )
          }
        </div>
      )
    }
  },
  getSessionMember(session_member) {
    const { participants, facilitator } = this.props;
    switch (session_member.role) {
      case 'facilitator':
        return facilitator;
        break;
      case 'participant':
        for (let i=0; i<participants.length; i++) {
          if (participants[i].id == session_member.id) {
            return participants[i];
          }
        }
        break;
    }
  },
  reply_prefix(message){
    if (message.reply_session_member) {
      let member = this.getSessionMember(message.reply_session_member)
      return `@${member.username} `
    }
    return " "
  },
  getMessageSessionTopicContext(member) {
    const { message } = this.props;
    let sessionTopicContext = { };
    sessionTopicContext[member.currentTopic.id] = {
        avatarData: {
          face: message.emotion
        }
      };
    return sessionTopicContext;
  },
  canWritePrivateMessage(member) {
    const { currentUser } = this.props;
    return this.isFacilitator(currentUser) && currentUser.id != member.id;
  },
  privateMessage(member) {
    const { currentUser } = this.props;
    if (this.canWritePrivateMessage(member)) {
      this.openSpecificModal('directMessage', { member: member });
    }
  },
  onVisibilityChange(isVisible) {
    const { currentUser, message, dispatch, channel } = this.props;
    if (isVisible) {
      dispatch(MessagesActions.readMessage(channel, message));
    }
  },
  visibilitySensor() {
    const { message } = this.props;

    if (message.unread) {
      return (
        <VisibilitySensor
          onChange={ this.onVisibilityChange }
          delayedCall={ true }
          containment={ this.props.chatSectionElemet }
          delay={ 2000 }
          />
      )
    } else {
      return;
    }
  },
  render() {
    const { message } = this.props;
    const { can_edit, can_delete, can_star, can_vote, can_reply } = message.permissions;
    let member = this.getSessionMember(message.session_member);
    let sessionTopicContext = this.getMessageSessionTopicContext(member);
    let className = this.canWritePrivateMessage(member) ? 'cursor-pointer' : '';

    return (
      <div className='message-section media'>
        <div className={ (message.unread ? "unread" : "") } ref={(el) => this.messageElemet = el}>

          <div className={ this.mediaImagePosition(message) }>
            <div className={ 'emotion-chat-' + message.emotion } aria-hidden='true' style={{ backgroundColor: member.colour }}></div>
            <div className='emotion-chat-avatar'>
              <span onClick={ this.privateMessage.bind(this, member) } className={className}>
                <Avatar
                  member={ { id: member.id, username: member.username, colour: member.colour, avatarData: member.avatarData, sessionTopicContext: sessionTopicContext, online: true, edit: false } }
                  specificId={ 'msgAvatar' + message.id }  />
                </span>
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
              { this.visibilitySensor() }
              <p className='text-break-all'>{ this.reply_prefix(message) + " "+ message.body }</p>
            </div>

            <div className='action-section col-md-12 text-right'>
              <StarMessage    permission={ can_star }   message={ message } />
              <ReplyMessage   permission={ can_reply }  message={ message } />
              <RateMessage    permission={ can_vote }   message={ message } />
              <EditMessage    permission={ can_edit }   message={ message } />
              <DeleteMessage  permission={ can_delete } message={ message } />
            </div>
          </div>
        </div>

        { this.shouldShowRepliedMessages(message) }
      </div>
    )
  }
});

const mapStateToProps = (state) => {
  return {
    currentUser: state.members.currentUser,
    participants: state.members.participants,
    facilitator: state.members.facilitator,
    modalWindows: state.modalWindows,
    channel: state.sessionTopic.channel
  }
};

export default connect(mapStateToProps)(Message);
