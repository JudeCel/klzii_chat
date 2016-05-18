import React, {PropTypes} from 'react';
import Member             from './member.js';
import { connect }        from 'react-redux';
import mixins             from '../../mixins';

const Participants = React.createClass({
  mixins: [mixins.validations, mixins.modalWindows],
  evenClasses(even, id) {
    let className = '';
    if(this.isOwner(id)) {
      className = 'cursor-pointer ';
    }

    return className + (even ? 'avatar-even' : 'avatar-odd');
  },
  render() {
    const { participants, openAvatarModal } = this.props;

    return (
      <div className='participants-section remove-side-margin'>
        {
          participants.map((participant, index) =>
            <div className='col-md-3' key={ participant.id }>
              <div className={ this.evenClasses(index % 2 == 0, participant.id) } onClick={ this.isOwner(participant.id) && this.openSpecificModal.bind(this, 'avatar') }>
                <Member member={ participant } />
              </div>
            </div>
          )
        }
      </div>
    )
  }
});

const mapStateToProps = (state) => {
  return {
    modalWindows: state.modalWindows,
    currentUser: state.members.currentUser,
    participants: state.members.participants
  }
};

export default connect(mapStateToProps)(Participants);
