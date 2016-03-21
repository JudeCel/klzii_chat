import React, {PropTypes}   from 'react';
import Member               from './member.js'
import { connect }          from 'react-redux';


const Participants =  React.createClass({
  render() {
    const { participants } = this.props;

    //helper for testing
    for(let i of Array(7).keys()) {
      if(participants[0]) {
        let last = participants.length-1;
        let object = Object.assign({}, participants[last]);
        object.id++;
        participants.push(object);
      }
    }

    return (
      <div className="row participants-section col-md-6 col-md-pull-2">
        {participants.map( (participant, index) =>
          <Member
            key={ participant.id }
            member={ participant }
            isEven={ index % 2 == 0 }
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
