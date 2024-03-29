import React, {PropTypes}                           from 'react';
import { connect }                                  from 'react-redux';
import { Dropdown, Button, SplitButton, MenuItem }  from 'react-bootstrap'
import Badge                                        from './badge';
import Toogle                                       from './toogle';
import mixins                                       from '../../mixins';
import Constants                                    from '../../constants';

const Select = React.createClass({
  mixins: [mixins.headerActions, mixins.validations, mixins.modalWindows],
  getInitialState() {
    return { open: false, canclose: true };
  },
  changeSessionTopic(id, _, e) {
    if (e._dispatchListeners.length == 1) {
      const { dispatch } = this.props;
      dispatch({ type: Constants.SET_INPUT_REPLY, replyId: null });
      this.setSessionTopic(id);
    } else {
      this.state.canclose = false;
    }
  },
  renderIconEye() {
    const { currentUser } = this.props;

    if(this.hasNoIconEye(currentUser)) return;

    let onlineObservers = this.props.observers.filter((item) => {
      if(item.online && item.id != currentUser.id) {
        return item;
      }
    });

    return (
      <span className='eye-section' onClick={ this.openSpecificModal.bind(this, 'observerList') }>
        <span className='icon-eye' />
        { onlineObservers.length }
      </span>
    )
  },
  renderIconUsers() {

    const { session, currentUser } = this.props;
    if(this.hasNoParticipantsIcon(currentUser)) return;

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

    if (["socialForum", "forum"].indexOf(session.type) > -1) {
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
    if (currentUser.role == "observer") {
      return "";
    } else {
      return currentUser.sessionTopicContext[topic.id] && currentUser.sessionTopicContext[topic.id].hasMessages ? "" : " has-no-messages";
    }
  },
  changeState() {
    const { open } = this.state;
    if (this.state.canclose) {
      this.setState({
        open: !open,
      });
    } else {
      this.state.canclose = true;
    }
  },
  render() {
    const { sessionTopics, unread_messages } = this.props;
    let current = this.getCurrentSessionTopic();

    return (
      <div className='topic-select-section'>
        <div className='topic-select-box'>
          { this.renderSessionNameBlock() }

          <Dropdown id='topic-selector' open={ this.state.open } onToggle={ this.changeState }>
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
                  if (sessionTopic.active || this.hasPermission(['topics', 'can_change_active'])){
                    return (
                      <MenuItem onSelect={ this.changeSessionTopic.bind(this, sessionTopic.id) } key={ 'sessionTopic-' + sessionTopic.id } active={ current.id == sessionTopic.id }>
                        <div className='clearfix'>
                          <span className={'pull-left' + this.getHasMessagesClassName(sessionTopic)}>{ sessionTopic.name }</span>
                          <span className='pull-right'>
                            <Badge type='reply' data={ unread_messages.session_topics[sessionTopic.id] } />
                            <Badge type='normal' data={ unread_messages.session_topics[sessionTopic.id] } />
                            <Toogle sessionTopic={ sessionTopic } />
                          </span>
                        </div>
                      </MenuItem>
                    )
                  }
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
    whiteboardChannel: state.whiteboard.channel
  };
};

export default connect(mapStateToProps)(Select);
