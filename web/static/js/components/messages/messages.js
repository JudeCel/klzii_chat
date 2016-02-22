import React, {PropTypes}   from 'react';
import Message              from './message.js'
import topicActions         from '../../actions/topic';

const Messages =  React.createClass({
  deleteMessage(e){
    this.props.dispatch(topicActions.deleteMessage(this.props.channal, e.target.id));
  },
  messageStar(e){
    this.props.dispatch(topicActions.messageStar(this.props.channal, e.target.id));
  },
  render() {
    return (
      <div>
        {this.props.messages.map( (message) =>
          <Message
            message={ message }
            deleteMessage={ this.deleteMessage }
            messageStar= { this.messageStar }
            key={ message.id }
          />
        )}
      </div>
    );
  }
})
export default Messages;
