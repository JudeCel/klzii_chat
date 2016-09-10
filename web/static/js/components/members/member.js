import React, {PropTypes} from 'react';
import { connect }        from 'react-redux';
import Avatar             from './avatar.js';
import mixins             from '../../mixins';

const Member = React.createClass({
  mixins: [mixins.validations, mixins.modalWindows],
  canDoEvent(member) {
    const { currentUser } = this.props;

    let clickParticipantAsFacilitator = this.isFacilitator(currentUser) && this.isParticipant(member);
    let clickFacilitatorAsParticipant = this.isParticipant(currentUser) && this.isFacilitator(member);
    return clickParticipantAsFacilitator || clickFacilitatorAsParticipant;
  },
  onClickEvent(member) {
    if(this.isOwner(member.id)) {
      this.openSpecificModal('avatar');
    }
    else if(this.canDoEvent(member)) {
      this.openSpecificModal('directMessage', { member: member });
    }
  },
  eventClass(member) {
    const can = this.isOwner(member.id) || this.canDoEvent(member);
    return can ? 'cursor-pointer' : '';
  },
  render() {
    const { member } = this.props;
    
    return (
      <div className={ this.eventClass(member) } onClick={ this.onClickEvent.bind(this, member) }>
        <Avatar member={ member } />
      </div>
    )
  }
});

const mapStateToProps = (state) => {
  return {
    // participants needed for automatic update when online state changes, do not remove.
    participants: state.members.participants,
    currentUser: state.members.currentUser,
    modalWindows: state.modalWindows
  }
};

export default connect(mapStateToProps)(Member);
