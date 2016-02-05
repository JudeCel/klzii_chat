import React, {PropTypes}       from 'react';

const Message =  React.createClass({
  render() {
    return (
      <div>
        User Name: {this.props.singleMessage.username}
        <br />
        Message: {this.props.singleMessage.body}
      </div>
    );
  }
})
export default Message;
