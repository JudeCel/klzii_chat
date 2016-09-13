import React, {PropTypes} from 'react';
import { connect }        from 'react-redux';
import Badge              from '../sessionTopics/badge';
import Actions            from '../../actions/sessionTopic';

const MobileHeader = React.createClass({
  getInitialState() {
    return { mobileSideMenuVisibility: false, mobileSideMenuTopicsVisibility: false };
  },
  clickIfExists(className) {
    var el = document.getElementsByClassName(className)[0];
    if (el) {
      document.getElementsByClassName(className)[0].click();
      return true;
    } else {
      return false;
    }
  },
  whiteboardIconClick() {
    if (!this.clickIfExists("whiteboard-expand")) {
      this.clickIfExists("pinboard-expand")
    }
  },
  messagesClick() {
    this.toggleMenu();
    this.clickIfExists("icon-message");
  },
  helpClick() {
    this.toggleMenu();
    this.clickIfExists("icon-help");
  },
  logoutClick() {
    this.toggleMenu();
    this.clickIfExists("log-out");
  },
  getMenuItemStyle(originalClassName) {
    var el = document.getElementsByClassName(originalClassName)[0];
    return { 
      display: (el ? "block" : "none")
    };
  },
  toggleMenu() {
    this.setState({mobileSideMenuTopicsVisibility: false});
    this.setState({mobileSideMenuVisibility: !this.state.mobileSideMenuVisibility});
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
    const { dispatch, channel, whiteboardChannel } = this.props;
    dispatch(Actions.changeSessionTopic(channel, whiteboardChannel, id));
    this.toggleMenu();
  },
  directMessageBadge() {
    const { unreadDirectMessages } = this.props;
    let count = 0;
    for(var i in unreadDirectMessages) {
    count += unreadDirectMessages[i];
    }
    return (
    <span className={ 'badge badge-messages-' + count  }>{ count }</span>
    );
  },
  render() {
      const { sessionTopics, unread_messages } = this.props;

    return (
      <div className='header-innerbox header-innerbox-mobile'>
        <div className='navbar-header'>
          <button type='button' className='navbar-toggle' onClick={this.toggleMenu}>
            <span className='icon-bar'></span>
            <span className='icon-bar'></span>
            <span className='icon-bar'></span>
          </button>
          <span className='navbar-brand'><img src='/images/klzii_logo.png'/></span>
          <span className='navbar-whiteboard' onClick={this.whiteboardIconClick}><img src='/images/whiteboard-icon.png'/></span>
        </div>
        <div className='mobile-side-menu' style={ this.getMobileSideMenuStyle() }>
          <div className='mobile-side-menu-bg'></div>
          <div className='mobile-side-menu-content'>
            <ul>
              <li className='navbar-title'>Talk Radio</li>
              <li onClick={this.toggleTopics}><span className='fa fa-coffee'></span>Morning Story <span className='fa fa-angle-right'></span></li>
              <li onClick={this.messagesClick} style={ this.getMenuItemStyle("icon-message") }><span className='fa fa-comment'></span>Messages { this.directMessageBadge() }</li>
              <li onClick={this.helpClick} style={ this.getMenuItemStyle("icon-help") }><span className='fa fa-question'></span>Help</li>
              <li onClick={this.logoutClick} style={ this.getMenuItemStyle("log-out") }><span className='fa fa-sign-out'></span>Log out</li>
            </ul>
            <div className='powered-by'>
              Powered by <a href='http://www.klzii.com'>klsii</a>
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
                          <Badge type='reply' data={ unread_messages.session_topics[sessionTopic.id] } />
                          <Badge type='normal' data={ unread_messages.session_topics[sessionTopic.id] } />
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
  }
});

const mapStateToProps = (state) => {
  return {
    unread_messages: state.messages.unreadMessages,
    session: state.chat.session,
    channel: state.sessionTopic.channel,
    current: state.sessionTopic.current,
    sessionTopics: state.sessionTopic.all,
    whiteboardChannel: state.whiteboard.channel
  };
};

export default connect(mapStateToProps)(MobileHeader);