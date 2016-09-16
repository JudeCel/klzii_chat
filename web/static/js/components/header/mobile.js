import React, {PropTypes} from 'react';
import { connect }        from 'react-redux';
import mixins             from '../../mixins';
import Badge              from '../sessionTopics/badge';
import Avatar             from '../members/avatar.js';

const MobileHeader = React.createClass({
  mixins: [mixins.modalWindows, mixins.validations, mixins.headerActions],
  getInitialState() {
    return { mobileSideMenuVisibility: false, mobileSideMenuTopicsVisibility: false };
  },
  whiteboardIconClick() {
    const { sessionConsole } = this.props;
    document.getElementsByClassName(sessionConsole.pinboard ? "pinboard-expand" : "whiteboard-expand")[0].click();
  },
  messagesClick() {
    const { currentUser, firstParticipant, facilitator } = this.props;
    let member = this.isFacilitator(currentUser) ? firstParticipant : facilitator;
    this.toggleMenu();
    this.openSpecificModal('directMessage', { member: member });
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
  toggleMenu() {
    this.setState({mobileSideMenuVisibility: !this.state.mobileSideMenuVisibility, mobileSideMenuTopicsVisibility: false});
  },
  toggleTopics() {
    this.setState({mobileSideMenuTopicsVisibility: !this.state.mobileSideMenuTopicsVisibility});
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
    this.setSessionTopic(id);
    this.toggleMenu();
  },
  directMessageBadge() {
    const { unreadDirectMessages } = this.props;
    let count = 0;
    for(let i in unreadDirectMessages) {
      count += unreadDirectMessages[i];
    }
    return (
      <span className={ 'badge badge-messages-' + count  }>{ count }</span>
    );
  },
  changeAvatar() {
    const { currentUser } = this.props;
    this.toggleMenu();
    if (currentUser.role != "observer") {
      this.openSpecificModal('avatar');
    }
  },
  render() {
    const { sessionTopics, unread_messages, currentUser, brand_logo } = this.props;

    if (currentUser && currentUser.avatarData) {
      let avatarUser = { id: currentUser.id, username: currentUser.username, colour: currentUser.colour, avatarData: currentUser.avatarData, online: true, edit: false }

      return (
        <div className='header-innerbox header-innerbox-mobile'>
          <div className='navbar-header'>
            <button type='button' className='navbar-toggle' onClick={this.toggleMenu}>
              <span className='icon-bar'></span>
              <span className='icon-bar'></span>
              <span className='icon-bar'></span>
            </button>
            <span className='navbar-brand'><img src={brand_logo.url.full}/></span>
            <span className='navbar-whiteboard' onClick={this.whiteboardIconClick}><img src='/images/whiteboard-icon.png'/></span>
          </div>
          <div className='mobile-side-menu' style={ this.getMobileSideMenuStyle() }>
            <div className='mobile-side-menu-bg'></div>
            <div className='mobile-side-menu-content'>
              <ul>
                <li className='navbar-title'>Talk Radio</li>
                <li className={ "navbar-avatar " + currentUser.role } }>
                  <span onClick={this.changeAvatar}>
                    <Avatar member={ avatarUser } specificId={ 'mobile-menu-avatar' } />
                  </span>
                  <div>Click on Avatar to Customize Your Biizu</div>
                </li>
                <li onClick={this.toggleTopics}>
                    <span className='fa fa-coffee'></span>Morning Story
                    <span className='fa fa-angle-right'></span>
                    <Badge type='normal' data={ unread_messages.summary } />
                    <Badge type='reply' data={ unread_messages.summary } />
                </li>
                <li onClick={this.messagesClick} style={ this.getMenuItemStyle('messages', 'can_direct_message') }>
                  <span className='fa fa-comment'></span>Messages { this.directMessageBadge() }
                </li>
                <li onClick={this.toggleMenu}>
                  <span className='fa fa-question'></span>Help
                </li>
                <li onClick={this.logoutClick} style={ this.getMenuItemStyle('can_redirect', 'logout') }>
                  <span className='fa fa-sign-out'></span>Log out
                </li>
              </ul>
              <div className='powered-by'>
                Powered by <a href='http://www.klzii.com' target='_blank'>klzii</a>
              </div>
            </div>
            <div className='mobile-side-menu-topics' style={ this.getMobileSideMenuTopicsStyle() }>
              <ul>
                <li className='navbar-back'>
                  <span className='fa icon-reply' onClick={ this.toggleTopics }></span>
                </li>
                  {
                    sessionTopics.map((sessionTopic) => {
                      return (
                        <li key={ 'sessionTopic-' + sessionTopic.id } className='clearfix' onClick={ this.changeSessionTopic.bind(this, sessionTopic.id) }>
                          <span className='pull-left'>{ sessionTopic.name }</span>
                          <span className='pull-right'>
                            <Badge type='normal' data={ unread_messages.session_topics[sessionTopic.id] } />
                            <Badge type='reply' data={ unread_messages.session_topics[sessionTopic.id] } />
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
    sessionConsole: state.sessionTopic.console
  };
};
export default connect(mapStateToProps)(MobileHeader);