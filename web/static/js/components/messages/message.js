import React, {PropTypes}       from 'react';

const Message =  React.createClass({
  render() {
    return (
      <div>
        <div>
          User Name: {this.props.singleMessage.session_member.username}
        </div>
        <div>
          Message: {this.props.singleMessage.event.body}
        </div>
        <hr />
      </div>
    );
  }
})
export default Message;
