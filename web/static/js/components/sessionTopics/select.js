import React, {PropTypes}                           from 'react';
import { connect }                                  from 'react-redux';
import { Dropdown, Button, SplitButton, MenuItem }  from 'react-bootstrap'
import Badge                                        from './badge';
import mixins                                       from '../../mixins';
import Constants                                    from '../../constants';

const Select = React.createClass({
  mixins: [mixins.headerActions, mixins.validations, mixins.modalWindows],
  changeSessionTopic(id) {
    const { dispatch } = this.props;
    dispatch({ type: Constants.SET_INPUT_REPLY, replyId: null });
    this.setSessionTopic(id);
  },
  renderIconEye() {
    if(!this.isFacilitator(this.props.currentUser)) return;

    return (
      <span className='eye-section' onClick={ this.openSpecificModal.bind(this, 'observerList') }>
        <span className='icon-eye' />
        { this.props.observers.length }
      </span>
    )
  },
  renderIconUsers() {

    const { session } = this.props;
    if(!this.isFacilitator(this.props.currentUser) || session.type != 'forum') return;

    let onlineParticipantsCount = 0;
    for (let i=0; i<this.props.participants.length; i++) {
      if (this.props.participants[i].online) {
        onlineParticipantsCount++;
      }
    }

    return (
      <span className='users-section' onClick={ this.openSpecificModal.bind(this, 'participantList') }>
        <span className='fa fa-users' />
        { onlineParticipantsCount }
      </span>
    )
  },
  renderTopicSign() {
    let current = this.getCurrentSessionTopic();

    if(this.isFacilitator(this.props.currentUser)) return;

    return (
      <span className={ 'topic-sign text-break-all' + (current.landing ? ' topic-landing' : '') }>
        { current.sign }
      </span>
    )
  },
  renderSessionNameBlock() {
    const { session } = this.props;

    if (session.type == 'forum') {
    return (
      <div className='session-name'>
        { session.name }
      </div>
    )} else {
    return (
      <div className='div-inline-block session-name'>
        <strong>Welcome to:</strong><br />
        { session.name }
      </div>
    )}
  },
  getCurrentSessionTopic() {
    const { current, sessionTopics } = this.props;
    for(let i=0; i<sessionTopics.length; i++) {
      if (current.id == sessionTopics[i].id) {
        return sessionTopics[i];
      }
    }
    return current;
  },
  getHasMessagesClassName(topic) {
    const { currentUser } = this.props;
    return currentUser.role == "observer" || topic.members_has_messages.includes(currentUser.id) ? "" : " has-no-messages";
  },
  render() {
    const { sessionTopics, unread_messages } = this.props;
    let current = this.getCurrentSessionTopic();

    return (
      <div className='topic-select-section'>
        <div className='topic-select-box'>
          { this.renderSessionNameBlock() }

          <Dropdown id='topic-selector'>
            <Dropdown.Toggle className='no-border-radius' noCaret>
              <div className={ 'no-border-radius btn btn-default name' + this.getHasMessagesClassName(current)}>
                { current.name }
              </div>
              <div className='no-border-radius btn btn-default dropcaret'>
                <span className='caret'></span>
              </div>
            </Dropdown.Toggle>

            <Dropdown.Menu className='no-border-radius'>
              {
                sessionTopics.map((sessionTopic) => {
                  return (
                    <MenuItem onSelect={ this.changeSessionTopic.bind(this, sessionTopic.id) } key={ 'sessionTopic-' + sessionTopic.id } active={ current.id == sessionTopic.id }>
                      <div className='clearfix'>
                        <span className={'pull-left' + this.getHasMessagesClassName(sessionTopic)}>{ sessionTopic.name }</span>
                        <span className='pull-right'>
                          <Badge type='reply' data={ unread_messages.session_topics[sessionTopic.id] } />
                          <Badge type='normal' data={ unread_messages.session_topics[sessionTopic.id] } />
                        </span>
                      </div>
                    </MenuItem>
                  )
                })
              }
            </Dropdown.Menu>
          </Dropdown>

          <ul className='unread-messages-section'>
            <li>
              <Badge type='reply' data={ unread_messages.summary } />
            </li>
            <li>
              <Badge type='normal' data={ unread_messages.summary } />
            </li>
          </ul>
          { this.renderIconEye() }
          { this.renderIconUsers() }
          { this.renderTopicSign() }
        </div>
      </div>
    )
  }
});

const mapStateToProps = (state) => {
  return {
    modalWindows: state.modalWindows,
    currentUser: state.members.currentUser,
    unread_messages: state.messages.unreadMessages,
    session: state.chat.session,
    observers: state.members.observers,
    participants: state.members.participants,
    channel: state.sessionTopic.channel,
    current: state.sessionTopic.current,
    sessionTopics: state.sessionTopic.all,
    whiteboardChannel: state.whiteboard.channel,
    //need messages to rerender on new message
    messages: state.messages.all
  };
};

export default connect(mapStateToProps)(Select);
