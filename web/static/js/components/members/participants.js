import React, {PropTypes}       from 'react';
import Member               from './member.js'

const Participants =  React.createClass({
  render() {
    return (
      <div>
        {this.props.participants.map( (participant) =>
          <Member
            key={ participant.id }
            member={ participant }
          />
        )}
      </div>
    );
  }
})
export default Participants;
