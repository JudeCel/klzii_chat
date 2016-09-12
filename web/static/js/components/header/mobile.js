import React, {PropTypes} from 'react';
import { connect }        from 'react-redux';

const MobileHeader = React.createClass({
  getInitialState() {
    return { mobileSideMenuVisibility: false };
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
    this.setState({mobileSideMenuVisibility: !this.state.mobileSideMenuVisibility});
  },
  getMobileSideMenuStyle() {
    return { 
      display: (this.state.mobileSideMenuVisibility ? "block" : "none")
    };
  },
  render() {

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
              <li>Morning Story</li>
              <li onClick={this.messagesClick} style={ this.getMenuItemStyle("icon-message") }>Messages</li>
              <li onClick={this.helpClick} style={ this.getMenuItemStyle("icon-help") }>Help</li>
              <li onClick={this.logoutClick} style={ this.getMenuItemStyle("log-out") }>Log out</li>
            </ul>
            <div className='powered-by'>
              Powered by <a href='http://www.klzii.com'>klsii</a>
            </div>
          </div>
        </div>
      </div>
    )
  }
});

export default MobileHeader;
