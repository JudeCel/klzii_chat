import React, {PropTypes} from 'react';
import { connect }        from 'react-redux';
import mixins             from '../../mixins';
import WhiteboardActions  from './../../actions/whiteboard';
import PinboardActions    from './../../actions/pinboard';
import ConfirmModal       from './../modals/confirmModal';
import LeaveOrDetails     from './leaveOrDetails';

const Links = React.createClass({
  mixins: [mixins.modalWindows, mixins.validations],
  clearWhiteboardAccepted() {
    const { sessionTopicConsole, channel, dispatch, whiteboardChannel } = this.props;

    this.closeAllModals();
    dispatch(WhiteboardActions.deleteAll(whiteboardChannel));
    if(sessionTopicConsole.data.pinboard && this.hasPermission(['pinboard', 'can_enable'])) {
      dispatch(PinboardActions.enable(channel, false));
    }
  },
  reportsFunction(style) {
    if(this.hasPermission(['reports', 'can_report'])) {
      return (
        <li style={ style } onClick={ this.openSpecificModal.bind(this, 'reports') }>
          <i className='icon-book-1' />
        </li>
      )
    }
  },
  clearWhiteboardFunction(style) {
    if(this.isFacilitator(this.props.currentUser) && this.hasPermission(['whiteboard', 'can_display_whiteboard'])) {
      return (
        <li style={ style } onClick={ this.openSpecificModal.bind(this, 'clearWhiteboard') }>
          <i className='fa fa-paint-brush' />
        </li>
      )
    }
  },
  directMessageFunction(style, count) {
    if(this.hasPermission(['messages', 'can_direct_message'])) {
      return (
        <li style={ style } onClick={ this.showDirectMessages }>
          <i className={ 'icon-message' + (count ? ' with-badge' : '') }/>
          <i className='badge'>{ count }</i>
        </li>
      )
    }
  },
  countAllUnread() {
    const { unreadDirectMessages } = this.props;

    let sum = 0;
    for(var i in unreadDirectMessages) {
      sum += unreadDirectMessages[i];
    }

    return sum;
  },
  showDirectMessages() {
    const { currentUser, firstParticipant, facilitator } = this.props;
    let member = this.isFacilitator(currentUser) ? firstParticipant : facilitator;

    this.openSpecificModal('directMessage', { member: member });
  },
  helpButtonRedirect(){
    window.open(this.props.currentUser.helpPage, '_blank');
  },
  render() {
    const { colours } = this.props;
    const count = this.countAllUnread() || null;
    const show = this.showSpecificModal('clearWhiteboard');
    const style = {
      backgroundColor: colours.headerButton
    };

    return (
      <div className='links-section'>
        <ul className='icons'>
          { this.clearWhiteboardFunction(style) }
          { this.reportsFunction(style) }
          { this.directMessageFunction(style, count) }
          <li style={ style } onClick={ this.helpButtonRedirect }>
            <i className='icon-help' />
          </li>

          <LeaveOrDetails />
        </ul>

        <ConfirmModal show={ show } onAccept={this.clearWhiteboardAccepted} onClose={this.closeAllModals} description='Are you sure you want to clean the Whiteboard?' title="Are you sure?"/>
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
    colours: state.chat.session.colours,
    sessionTopicConsole: state.sessionTopicConsole,
    channel: state.sessionTopic.channel,
  };
};

export default connect(mapStateToProps)(Links);
