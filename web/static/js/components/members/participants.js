import React, {PropTypes}   from 'react';
import Member               from './member.js'
import { connect }          from 'react-redux';


const Participants = React.createClass({
  render() {
    const { participants, colours } = this.props;

    //helper for testing
    for(let i of Array(7).keys()) {
      if(participants[0]) {
        let last = participants.length-1;
        let object = Object.assign({}, participants[last]);
        object.id += 10;
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
            colour={ colours.participants[index+1] }
          />
        )}
      </div>
    );
  }
})

const mapStateToProps = (state) => {
  return {
    participants: state.members.participants,
    colours: state.chat.session.colours
  }
};
export default connect(mapStateToProps)(Participants);
