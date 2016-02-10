import React, {PropTypes}       from 'react';

const CurrentMember =  React.createClass({
  render() {
    return (
      <div>
        Name: {this.props.member.username}
        <br />
        Role: {this.props.member.role}
      </div>
    );
  }
})
export default CurrentMember;
