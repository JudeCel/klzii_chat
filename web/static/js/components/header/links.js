import React, {PropTypes} from 'react';
import { connect }        from 'react-redux';
import mixins             from '../../mixins';
import ReportsModal       from './../reports/modal';
import WhiteboardActions  from './../../actions/whiteboard';

const Links = React.createClass({
  mixins: [mixins.modalWindows, mixins.validations],
  clearWhiteboard() {
    if(confirm('Are you sure you want to clear whiteboard?')) {
      const { dispatch, whiteboardChannel } = this.props;
      dispatch(WhiteboardActions.deleteAll(whiteboardChannel));
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
    if(this.isFacilitator(this.props.currentUser)) {
      return (
        <li style={ style } onClick={ this.clearWhiteboard }>
          <i className='fa fa-paint-brush' />
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
  render() {
    const { colours } = this.props;
    const count = this.countAllUnread() || null;
    const style = {
      backgroundColor: colours.headerButton
    };

    return (
      <div>
        <div className='col-md-4 links-section'>
          <ul className='icons'>
            { this.clearWhiteboardFunction(style) }
            { this.reportsFunction(style) }

            <li style={ style } onClick={ this.showDirectMessages }>
              <i className={ 'icon-message' + (count ? ' with-badge' : '') }/>
              <i className='badge'>{ count }</i>
            </li>
            <li style={ style }>
              <i className='icon-help' />
            </li>
            <li style={ style }>
              <i className='icon-power' />
            </li>
          </ul>
        </div>
        <div className='col-md-1 logo-section'>
          <img src='/images/klzii_logo.png' />
        </div>

        <ReportsModal show={ this.showSpecificModal('reports') } />
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
