import React, {PropTypes}   from 'react';
import Member               from './member.js'
import { connect }          from 'react-redux';


const Participants =  React.createClass({
  render() {
    const { participants } = this.props;

    return (
      <div className="row participants-section col-md-6">
        {participants.map( (participant) =>
          <Member
            key={ participant.id }
            member={ participant }
          />
        )}
      </div>
    );
  }
})

const mapStateToProps = (state) => {
  return {
    participants: state.members.participants
  }
};
export default connect(mapStateToProps)(Participants);
