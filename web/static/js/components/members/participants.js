import React, {PropTypes} from 'react';
import Member             from './member.js';
import { connect }        from 'react-redux';

const Participants = React.createClass({
  evenClasses(even) {
    const className = 'cursor-pointer ';
    return className + (even ? 'avatar-even' : 'avatar-odd');
  },
  render() {
    const { participants, openAvatarModal } = this.props;

    return (
      <div className='participants-section remove-side-margin'>
        {
          participants.map((participant, index) =>
            <div className='col-md-3' key={ participant.id }>
              <div className={ this.evenClasses(index % 2 == 0) } onClick={ openAvatarModal }>
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
    participants: state.members.participants
  }
};

export default connect(mapStateToProps)(Participants);
