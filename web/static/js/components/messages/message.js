import React, {PropTypes}       from 'react';

const Message =  React.createClass({
  star(message){
    if(message.star) {
      return "active"
    }else {
      return ""
    }
  },
  render() {
    let message = this.props.message;
    return (
      <div className="message-container">
        <div className="avatar-container">

        </div>
        <div className="message">
          <header className="message-header">
            User Name: {message.session_member.username}
          </header>
          <div className="message-body">
              Message: {message.event.body}
          </div>
        </div>
        <div className="message-action-list">
          <div className={"star " + this.star(message) + " glyphicon glyphicon-star " }
            onClick={ this.props.messageStar }
            id={ message.id }
          />
          <div
            onClick={ this.props.deleteMessage }
            id={ message.id }
            className="remove glyphicon glyphicon-remove"
          />
        </div>
        <hr/>
      </div>
    );
  }
})
export default Message;
