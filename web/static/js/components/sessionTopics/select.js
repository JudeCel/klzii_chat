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
    dispatch({ type: Constants.SET_INPUT_REPLY, replyId: 0 });
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
  renderTopicSign() {
    let current = this.getCurrentSessionTopic();

    if(this.isFacilitator(this.props.currentUser)) return;

    return (
      <img src='/images/click-to-access-topics.png' alt='Click to access topics' />
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
  render() {
    const { sessionTopics, session, unread_messages } = this.props;
    let current = this.getCurrentSessionTopic();

    return (
      <div className='topic-select-section'>
        <div className='topic-select-box'>
          { this.renderSessionNameBlock() }

          <Dropdown id='topic-selector'>
            <Dropdown.Toggle className='no-border-radius' noCaret>
              <div className='no-border-radius btn btn-default name'>
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
                        <span className='pull-left'>{ sessionTopic.name }</span>
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
    channel: state.sessionTopic.channel,
    current: state.sessionTopic.current,
    sessionTopics: state.sessionTopic.all,
    whiteboardChannel: state.whiteboard.channel
  };
};

export default connect(mapStateToProps)(Select);
