import React, {PropTypes}       from 'react';
import Message        from './message.js'

const Messages =  React.createClass({
  render() {
    return (
      <div>
        {this.props.messagesCollection.map( message =>
          <Message key={message.id} singleMessage={message}/>
        )}
      </div>
    );
  }
})
export default Messages;
