import React, { PropTypes } from 'react';
import { connect }          from 'react-redux';
import Constants            from './../constants';
import sessionActions       from '../actions/session';
import sessionTopicActions  from '../actions/sessionTopic';
import ChangeAvatarModal    from '../components/members/modals/changeAvatar/index.js';
import DirectMessageModal   from '../components/members/modals/directMessage/index.js';
import SessionTopicSelect   from '../components/sessionTopics/select.js';
import Resources            from '../components/resources/resources.js';
import HeaderLinks          from '../components/header/links.js';
import MobileHeader         from '../components/header/mobile.js';
import Forum                from '../components/chatRoom/forum';
import Focus                from '../components/chatRoom/focus';
import Loading              from '../components/util/loading.js';
import SessionExpire        from '../components/util/sessionExpire.js';
import Notifications        from '../actions/notifications';
import notificationMixin    from '../mixins/notification';
import ReportsModal         from '../components/reports/modal';
import ObserverListModal    from '../components/modals/observerList';
import ParticipantListModal    from '../components/modals/participantList';
import LeaveChatModal       from '../components/modals/leaveChat';
import ReactToastr, { ToastContainer, ToastMessage } from 'react-toastr';
var ToastMessageFactory     = React.createFactory(ToastMessage.animation);

const ChatView = React.createClass({
  mixins: [notificationMixin],
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
    if(nextProps.sessionReady && !nextProps.sessionTopicReady && nextProps.currentUser.currentTopic) {
      this.props.dispatch(sessionTopicActions.selectCurrent(nextProps.socket, nextProps.session_topics, nextProps.currentUser.currentTopic));
    }
  },
  getScreenWidthForAvatar(targetInnerWidth) {
    return targetInnerWidth >= 768 ? targetInnerWidth : 580;
  },
  componentDidMount() {
    window.addEventListener('resize', (e) => {
      let self = this;
      let windowUtility = { width: this.getScreenWidthForAvatar(e.target.innerWidth), height: document.body.clientHeight };
      if (JSON.stringify(this.props.utilityWindow) != JSON.stringify(windowUtility)) {
        this.props.dispatch({ type: Constants.SCREEN_SIZE_CHANGED, window: windowUtility });
      }
    });
    this.props.dispatch({ type: Constants.SCREEN_SIZE_CHANGED, window: { width: this.getScreenWidthForAvatar(window.innerWidth), height: document.body.clientHeight } });
    SessionExpire.init();
  },
  renderMainContent() {
    const { type } = this.props;
    switch(type) {
      case 'forum': return <Forum/>;
      case 'focus': return <Focus/>;
      case 'socialForum': return <Forum/>;
    }
  },
  getRelatedUIType() {
    const { type } = this.props;
    if (type == 'socialForum') return 'forum';
    return null;
  },
  getAppContainerClass() {
    const { role, type } = this.props;
    let relatedType = this.getRelatedUIType();
    let relatedTypeClass = relatedType ? "type-" + relatedType : "";
    return `role-${role} type-${type} ${relatedTypeClass}`;
  },
  render() {
    const { error, sessionReady, sessionTopicReady, brand_logo } = this.props;

    if(error) {
      return (<div>{error}</div>)
    }
    else if(sessionReady && sessionTopicReady) { 
      return (
        <div id='chat-app-container' className={ this.getAppContainerClass() }>
          <Loading />
          <ToastContainer ref='notification' className='toast-top-right' toastMessageFactory={ ToastMessageFactory } />

          <nav className='row header-section'>
            <div className='header-innerbox'>
              <SessionTopicSelect/>
              <Resources/>
              <HeaderLinks/>
              <div className='logo-section'>
                <img className='img-responsive' src={brand_logo.url.full} />
              </div>
            </div>
            <MobileHeader brand_logo={brand_logo}/>
          </nav>

          <div className='row room-outerbox'>
            <ChangeAvatarModal />
            <DirectMessageModal />
            <ReportsModal />
            <ObserverListModal />
            <ParticipantListModal />
            <LeaveChatModal />

            { this.renderMainContent() }

          </div>
          <div className="footer text-center">
            <span>Get Free <a href='//www.cliizii.com' target='_blank'><b>cliizii Chat</b></a></span>
          </div>
          <div id="small-screen">
            <div>This site is not compatible with small window sizes.</div>
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
    pinboardActive: state.sessionTopicConsole.data.pinboard,
    currentUser: state.members.currentUser,
    colours: state.chat.session.colours,
    brand_logo: state.chat.session.brand_logo,
    sessionReady: state.chat.ready,
    error: state.chat.error,
    session_topics: state.chat.session.session_topics,
    sessionTopicReady: state.sessionTopic.ready,
    socket: state.chat.socket,
    notifications: state.notifications,
    role: state.members.currentUser.role,
    type: state.chat.session.type,
    utilityWindow: state.utility.window
  };
};

export default connect(mapStateToProps)(ChatView);
