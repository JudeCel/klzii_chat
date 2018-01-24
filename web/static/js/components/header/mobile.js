import React, { PropTypes } from 'react';
import { connect } from 'react-redux';
import mixins from '../../mixins';
import Badge from '../sessionTopics/badge';
import Avatar from '../members/avatar.js';
import Constants from '../../constants';
import MobileConsole from '../../components/console/mobileConsole.js';

const MobileHeader = React.createClass({
  mixins: [mixins.modalWindows, mixins.validations, mixins.headerActions],
  componentDidMount() {
    // TA1906 - if you want to go back users are clicking the back arrow but it takes them out of the Session and back to the login
    
    history.pushState(Math.random(), null, null);
    window.onpopstate = function () {
      if (confirm('Do you really want to leave us?')) {
        history.back();
      } else {
        history.pushState(Math.random(), null, null);
      }
    };
  },
  getInitialState() {
    return { mobileSideMenuVisibility: false, mobileSideMenuTopicsVisibility: false };
  },
  whiteboardIconClick() {
    this.setState({ mobileSideMenuVisibility: false, mobileSideMenuTopicsVisibility: false });
    const { sessionConsole } = this.props;
    this.closeAllModals();
    if (document.getElementsByClassName(sessionConsole.pinboard ? "pinboard-expand" : "whiteboard-expand")[0].src.includes('expand')) {
      document.getElementsByClassName(sessionConsole.pinboard ? "pinboard-expand" : "whiteboard-expand")[0].click();
    }
  },
  messagesClick() {
    const { currentUser, firstParticipant, facilitator } = this.props;
    let member = this.isFacilitator(currentUser) ? firstParticipant : facilitator;
    this.toggleMenu();
    this.openSpecificModal('directMessage', { member: member });
  },
  spectatorsClick() {
    this.toggleMenu();
    this.openSpecificModal('observerList');
  },
  guestsClick() {
    this.toggleMenu();
    this.openSpecificModal('participantList');
  },
  logoutClick() {
    this.toggleMenu();
    this.logOut();
  },
  getMenuItemStyle(object, action) {
    let canShow = this.hasPermission([object, action]);
    return {
      display: (canShow ? "block" : "none")
    };
  },
  getSpectatorOrOGuestsMenuItemStyle() {
    let canShow = this.isObserver(this.props.currentUser) && this.isForum();
    return {
      display: (canShow ? "block" : "none")
    };
  },
  toggleMenu() {
    this.setState({ mobileSideMenuVisibility: !this.state.mobileSideMenuVisibility, mobileSideMenuTopicsVisibility: false });
  },
  toggleTopics() {
    this.setState({ mobileSideMenuVisibility: false, mobileSideMenuTopicsVisibility: !this.state.mobileSideMenuTopicsVisibility });
  },
  getMobileSideMenuStyle() {
    return {
      display: (this.state.mobileSideMenuVisibility ? "block" : "none")
    };
  },
  getMobileSideMenuTopicsStyle() {
    return {
      display: (this.state.mobileSideMenuTopicsVisibility ? "block" : "none")
    };
  },
  changeSessionTopic(id) {
    const { dispatch } = this.props;
    dispatch({ type: Constants.SET_INPUT_REPLY, replyId: null });
    this.setSessionTopic(id);
    this.toggleTopics();
  },
  directMessageBadge() {
    const { unreadDirectMessages } = this.props;
    let count = 0;
    for (let i in unreadDirectMessages) {
      count += unreadDirectMessages[i];
    }
    return (
      <span className={'badge badge-messages-' + count}>{count}</span>
    );
  },
  changeAvatar() {
    const { currentUser } = this.props;
    this.toggleMenu();
    if (currentUser.role != "observer") {
      this.openSpecificModal('avatar');
    }
  },
  getHasMessagesClassName(topic) {
    const { currentUser } = this.props;
    if (currentUser.role == "observer") {
      return "";
    } else {
      return currentUser.sessionTopicContext[topic.id] && currentUser.sessionTopicContext[topic.id].hasMessages ? "" : " has-no-messages";
    }
  },
  render() {
    const { sessionTopics, unread_messages, currentUser, brand_logo, colours, session } = this.props;

    if (currentUser && currentUser.avatarData) {

      return (
        <div className='header-innerbox header-innerbox-mobile'>
          <div className='navbar-header'>
            <div className="icon-coffee" onClick={this.toggleTopics}>
              <div className="access-topics-icon">
                <span className="fa fa-coffee"></span>
                <span className="text">Access<br />Topics</span>
              </div>
              <div className="badges">
                <Badge type='normal' data={unread_messages.summary} /><br />
                <Badge type='reply' data={unread_messages.summary} />
              </div>
            </div>
            <button type='button' className='navbar-toggle' onClick={this.toggleMenu}>
              <span className='icon-bar'></span>
              <span className='icon-bar'></span>
              <span className='icon-bar'></span>
            </button>
            <div onClick={this.state.mobileSideMenuVisibility ? this.toggleMenu : null}>
              <MobileConsole />
            </div>
            <span className='navbar-brand'><img src={brand_logo.url.full} /></span>
          </div>
          <div className='mobile-side-menu' style={this.getMobileSideMenuStyle()}>
            <div className='mobile-side-menu-bg'></div>
            <div className='mobile-side-menu-content'>
              <ul>
                <li className='navbar-title'>{session.name}</li>
                <li className={"navbar-avatar " + currentUser.role} >
                  <span onClick={this.changeAvatar}>
                    <Avatar member={{ id: currentUser.id, username: currentUser.username, colour: currentUser.colour, avatarData: currentUser.avatarData, online: true, edit: false }} specificId={'mobile-menu-avatar'} />
                  </span>
                  <div>Click on Avatar to Customize Your Biizu</div>
                </li>
                <li onClick={this.whiteboardIconClick}>
                  <span className='navbar-whiteboard' style={{ backgroundColor: colours.headerButton }}>
                    <img src='/images/whiteboard-icon.png' />
                  </span>
                  <span></span>Whiteboard
                    </li>
                <li onClick={this.messagesClick} style={this.getMenuItemStyle('messages', 'can_direct_message')}>
                  <span className='fa fa-comment'></span>Messages {this.directMessageBadge()}
                </li>
                <li onClick={this.spectatorsClick} style={this.getSpectatorOrOGuestsMenuItemStyle()}>
                  <span className='fa fa-eye'></span>Spectators
                    </li>
                <li onClick={this.guestsClick} style={this.getSpectatorOrOGuestsMenuItemStyle()}>
                  <span className='fa fa-users'></span>Guests
                    </li>
                    <a target="_blank" href="https://cliizii.com/help/" style={{ color: 'rgb(88, 89, 91)' }}>
                <li onClick={this.toggleMenu}>
                  <span className='fa fa-question'></span>Help
                    </li></a>
                <li onClick={this.logoutClick} style={this.getMenuItemStyle('can_redirect', 'logout')}>
                  <span className='fa fa-sign-out'></span>Log out
                    </li>
              </ul>
              <div className='powered-by'>
                Get <a href='//www.cliizii.com' target='_blank'>cliizii Chat</a>
              </div>
            </div>
          </div>
          <div className='mobile-side-menu' style={this.getMobileSideMenuTopicsStyle()}>
            <div className='mobile-side-menu-bg'></div>
            <div className='mobile-side-menu-topics'>
              <ul>
                <li className='navbar-back'>
                  <span className='fa icon-reply' onClick={this.toggleTopics}></span>
                </li>
                {
                  sessionTopics.map((sessionTopic) => {
                    return (
                      <li key={'sessionTopic-' + sessionTopic.id} className='clearfix' onClick={this.changeSessionTopic.bind(this, sessionTopic.id)}>
                        <span className={'pull-left' + this.getHasMessagesClassName(sessionTopic)}>{sessionTopic.name}</span>
                        <span className='pull-right'>
                          <Badge type='normal' data={unread_messages.session_topics[sessionTopic.id]} />
                          <Badge type='reply' data={unread_messages.session_topics[sessionTopic.id]} />
                        </span>
                      </li>
                    )
                  })
                }
              </ul>
            </div>
          </div>
        </div>
      )
    } else {
      return (false)
    }
  }
});

const mapStateToProps = (state) => {
  return {
    unread_messages: state.messages.unreadMessages,
    session: state.chat.session,
    channel: state.sessionTopic.channel,
    currentTopic: state.sessionTopic.current,
    sessionTopics: state.sessionTopic.all,
    currentUser: state.members.currentUser,
    whiteboardChannel: state.whiteboard.channel,
    modalWindows: state.modalWindows,
    unreadDirectMessages: state.directMessages.unreadCount,
    firstParticipant: state.members.participants[0],
    facilitator: state.members.facilitator,
    sessionConsole: state.sessionTopicConsole.data,
    colours: state.chat.session.colours
  };
};
export default connect(mapStateToProps)(MobileHeader);
