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
import Notifications        from '../actions/notifications';
import notificationMixin    from '../mixins/notification';
import ReportsModal         from '../components/reports/modal';
import ObserverListModal    from '../components/modals/observerList';
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
    if(nextProps.sessionReady && !nextProps.sessionTopicReady) {
      this.props.dispatch(sessionTopicActions.selectCurrent(nextProps.socket, nextProps.session_topics));
    }
  },
  getScreenWidthForAvatar(targetInnerWidth) {
    return targetInnerWidth >= 768 ? targetInnerWidth : 580;
  },
  componentDidMount() {
    window.addEventListener('resize', (e) => {
      this.props.dispatch({ type: Constants.SCREEN_SIZE_CHANGED, window: { width: this.getScreenWidthForAvatar(e.target.innerWidth), height: e.target.innerHeight } });
    });
    this.props.dispatch({ type: Constants.SCREEN_SIZE_CHANGED, window: { width: this.getScreenWidthForAvatar(window.innerWidth), height: window.innerHeight } });
  },
  renderMainContent() {
    const { type } = this.props;
    switch(type) {
      case 'forum': return <Forum/>;
      case 'focus': return <Focus/>;
    }
  },
  render() {
    const { error, sessionReady, sessionTopicReady, brand_logo, role, type } = this.props;

    if(error) {
      return (<div>{error}</div>)
    }
    else if(sessionReady && sessionTopicReady) {
      return (
        <div id='chat-app-container' className={ 'role-' + role + ' type-' + type }>
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

            { this.renderMainContent() }

          </div>
          <div className="footer text-center">
            <span>Powered by <a href="//www.klzii.com" target="_blank"> <b>klzii.</b> </a> </span>
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
    colours: state.chat.session.colours,
    brand_logo: state.chat.session.brand_logo,
    sessionReady: state.chat.ready,
    error: state.chat.error,
    session_topics: state.chat.session.session_topics,
    sessionTopicReady: state.sessionTopic.ready,
    socket: state.chat.socket,
    notifications: state.notifications,
    role: state.members.currentUser.role,
    type: state.chat.session.type
  };
};

export default connect(mapStateToProps)(ChatView);
