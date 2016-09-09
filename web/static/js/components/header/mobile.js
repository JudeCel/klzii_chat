import React, {PropTypes} from 'react';
import { connect }        from 'react-redux';
import mixins             from '../../mixins';
import ReportsModal       from './../reports/modal';
import WhiteboardActions  from './../../actions/whiteboard';
import LogoutLink         from './logout';

const Links = React.createClass({
  whiteboardIconClick() {
      if (document.getElementsByClassName("whiteboard-expand")[0])
          document.getElementsByClassName("whiteboard-expand")[0].click()
      else if (document.getElementsByClassName("pinboard-expand")[0])
          document.getElementsByClassName("pinboard-expand")[0].click();
  },
  render() {

    return (
      <div className='header-innerbox header-innerbox-mobile'>
        <div className='navbar-header'>
          <button type='button' className='navbar-toggle'>
            <span className='icon-bar'></span>
            <span className='icon-bar'></span>
            <span className='icon-bar'></span>
          </button>
          <span className='navbar-brand'><img src='/images/klzii_logo.png'/></span>
          <span className='navbar-whiteboard' onClick={this.whiteboardIconClick}><img src='/images/whiteboard-icon.png'/></span>
        </div>
      </div>
    )
  }
});

const mapStateToProps = (state) => {
  return {
    whiteboardChannel: state.whiteboard.channel,
    modalWindows: state.modalWindows,
    unreadDirectMessages: state.directMessages.unreadCount,
    firstParticipant: state.members.participants[0],
    facilitator: state.members.facilitator,
    currentUser: state.members.currentUser,
    colours: state.chat.session.colours
  };
};

export default connect(mapStateToProps)(Links);
