import React, { PropTypes } from 'react';
import { connect }          from 'react-redux';
import sessionActions       from '../actions/session';
import sessionTopicActions  from '../actions/sessionTopic';
import Messages             from '../components/messages/messages.js';
import Input                from '../components/messages/input.js';
import Facilitator          from '../components/members/facilitator.js';
import Participants         from '../components/members/participants.js';
import ChangeAvatarModal    from '../components/members/modals/changeAvatar/index.js';
import DirectMessageModal   from '../components/members/modals/directMessage/index.js';
import SessionTopicSelect   from '../components/sessionTopics/select.js';
import Resources            from '../components/resources/resources.js';
import HeaderLinks          from '../components/header/links.js';

import WhiteboardCanvas     from '../components/whiteboard/whiteboardCanvas';
import Notifications        from '../actions/notifications';
import notificationMixin    from '../mixins/notification';
import ReactToastr, { ToastContainer, ToastMessage } from 'react-toastr';
var ToastMessageFactory     = React.createFactory(ToastMessage.animation);

const ChatView = React.createClass({
  mixins: [notificationMixin],
  styles() {
    const { colours } = this.props;
    return {
      backgroundColor: colours.mainBackground,
      borderColor: colours.mainBorder
    };
  },
  componentDidUpdate() {
    const { notifications, dispatch, colours } = this.props;

    document.body.style.backgroundColor = colours.browserBackground;
    document.body.style.color = colours.font;

    if(this.refs.notification && notifications.type) {
      this.showNotification(this.refs.notification, notifications);
      Notifications.clearNotification(dispatch);
    }
  },
  componentWillMount() {
    this.props.dispatch(sessionActions.connectToChannel());
  },
  componentWillReceiveProps(nextProps){
    if(nextProps.sessionReady && !nextProps.sessionTopicReady) {
      this.props.dispatch(sessionTopicActions.selectCurrent(nextProps.socket, nextProps.session_topics));
    }
  },
  render() {
    const { error, sessionReady, sessionTopicReady } = this.props;

    if(error) {
      return (<div>{error}</div>)
    }
    else if(sessionReady && sessionTopicReady) {
      return (
        <div id='chat-app-container'>
          <ToastContainer ref='notification' className='toast-top-right' toastMessageFactory={ ToastMessageFactory } />

          <nav className='row header-section'>
            <div className='header-innerbox'>
              <SessionTopicSelect/>
              <Resources/>
              <HeaderLinks/>
            </div>
          </nav>

          <div className='row room-outerbox'>
            <div className='col-md-12 room-section' style={ this.styles() }>
              <ChangeAvatarModal />
              <DirectMessageModal />

              <div className='row'>
                <div className='col-md-8'>
                  <div className='row top-row'>
                    <Facilitator />
                    <WhiteboardCanvas member={ this.props }/>
                  </div>

                  <div className='row'>
                    <Participants />
                  </div>
                </div>

                <div className='col-md-4'>
                  <Messages/>
                </div>

                <div className='col-md-12'>
                  <Input/>
                </div>
              </div>
            </div>
          </div>
        </div>
      )
    }
    else {
      // Still loading
      return (false)
    }
  }
});

const mapStateToProps = (state) => {
  return {
    colours: state.chat.session.colours,
    sessionReady: state.chat.ready,
    error: state.chat.error,
    session_topics: state.chat.session.session_topics,
    sessionTopicReady: state.sessionTopic.ready,
    socket: state.chat.socket,
    notifications: state.notifications
  };
};

export default connect(mapStateToProps)(ChatView);
