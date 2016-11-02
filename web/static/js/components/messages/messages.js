import React, { PropTypes } from 'react';
import ReactDOM             from 'react-dom';
import { connect }          from 'react-redux';
import Message              from './message.js';
import mixins               from '../../mixins';

const Messages = React.createClass({
  mixins: [mixins.helpers],
  componentWillUpdate() {
    let chatMessages = ReactDOM.findDOMNode(this);
    let chatBoxHeight = chatMessages.scrollTop + chatMessages.offsetHeight;
    this.shouldScrollBottom = (chatBoxHeight === chatMessages.scrollHeight);
  },
  componentDidUpdate() {
    let chatMessages = ReactDOM.findDOMNode(this);
    this.addOrRemoveScrollbarY(chatMessages, this);
  },
  render() {
    const { messages } = this.props;
      console.log(this.props);

    return (
      <div className='chat-section'>
        {
          messages.map((message) =>
            <Message key={ message.id } message={ message } />
          )
        }
      </div>
    )
  }
});

const mapStateToProps = (state) => {
  return {
    messages: state.messages.all
  };
};

export default connect(mapStateToProps)(Messages);
