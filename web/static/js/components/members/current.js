import React, {PropTypes}       from 'react';
var createFragment = require('react-addons-create-fragment');

const CurrentMember =  React.createClass({
  render() {
    return (
      <div>
        Name: {this.props.member.username}
        Role: {this.props.member.role}
      </div>
    );
  }
})
export default CurrentMember;
