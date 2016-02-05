import React, {PropTypes}       from 'react';

const Message =  React.createClass({
  render() {
    return (
      <div>
        Owner ID: {this.props.singleMessage.ownerId}
        <br />
        Message: {this.props.singleMessage.body}
      </div>
    );
  }
})
export default Message;
