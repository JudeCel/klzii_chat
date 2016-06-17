import React, {PropTypes} from 'react';
import { connect }        from 'react-redux';
import mixins             from '../../mixins';

const Links = React.createClass({
  mixins: [mixins.modalWindows, mixins.validations],
  countAllUnread() {
    const { unreadDirectMessages } = this.props;

    let sum = 0;
    for(var i in unreadDirectMessages) {
      sum += unreadDirectMessages[i];
    }
    return sum || null;
  },
  showDirectMessages() {
    const { currentUser, firstParticipant, facilitator } = this.props;
    let member = this.isFacilitator(currentUser) ? firstParticipant : facilitator;

    this.openSpecificModal('directMessage', { member: member });
  },
  render() {
    const { colours } = this.props;
    const count = this.countAllUnread();
    const style = {
      backgroundColor: colours.headerButton
    };

    return (
      <div>
        <div className='col-md-4 links-section'>
          <ul className='icons'>
            <li style={ style }>
              <i className='icon-trash' />
            </li>
            <li style={ style }>
              <i className='icon-book-1' />
            </li>
            <li style={ style } onClick={ this.showDirectMessages }>
              <i className={ 'icon-message' + (count ? ' with-badge' : '') }/>
              <i className='badge'>{ count }</i>
            </li>
            <li style={ style }>
              <i className='icon-help' />
            </li>
            <li style={ style }>
              <i className='icon-reply' />
            </li>
          </ul>
        </div>
        <div className='col-md-1 logo-section'>
          <img width='150%' src='/images/logo.png' />
        </div>
      </div>
    )
  }
});

const mapStateToProps = (state) => {
  return {
    modalWindows: state.modalWindows,
    unreadDirectMessages: state.directMessages.unreadCount,
    firstParticipant: state.members.participants[0],
    facilitator: state.members.facilitator,
    currentUser: state.members.currentUser,
    colours: state.chat.session.colours
  };
};

export default connect(mapStateToProps)(Links);
