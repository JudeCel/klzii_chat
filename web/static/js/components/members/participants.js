import React, {PropTypes} from 'react';
import { connect }        from 'react-redux';
import Member             from './member.js';

const Participants = React.createClass({
  evenClasses(index) {
    let even = index % 2 == 0;
    return (even ? 'avatar-even' : 'avatar-odd');
  },
  render() {
    const { participants } = this.props;

    return (
      <div className='participants-section remove-side-margin'>
        {
          participants.map((participant, index) =>
            <div className='col-md-3' key={ participant.id }>
              <div className={ this.evenClasses(index) }>
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
