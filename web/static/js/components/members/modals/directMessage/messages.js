import React, {PropTypes} from 'react';
import { connect }        from 'react-redux';
import ReactDOM           from 'react-dom';
import moment             from 'moment';
import Message            from './message';
import mixins             from '../../../../mixins';

const Messages = React.createClass({
  mixins: [mixins.helpers],
  borderColor() {
    return { borderColor: this.props.colours.mainBorder };
  },
  addSeperator(read, unread) {
    if(read.length && unread.length) {
      return (
        <div className='unread-separator text-center'>
          <hr className='pull-left' style={ this.borderColor() } />
          <span className='date'>{ this.formatDate(moment, unread[0].createdAt) }</span>
          <hr className='pull-right' style={ this.borderColor() } />
        </div>
      )
    }
  },
  componentWillUpdate() {
    let messages = ReactDOM.findDOMNode(this);
    let chatBoxHeight = messages.scrollTop + messages.offsetHeight;
    this.shouldScrollBottom = (chatBoxHeight >= messages.scrollHeight);
  },
  componentDidUpdate(props, state) {
    let messages = ReactDOM.findDOMNode(this);
    this.addOrRemoveScrollbarY(messages, this);
  },
  render() {
    const { read, unread } = this.props.messages;

    if(read.length || unread.length) {
      return (
        <div className='messages-section' style={ this.borderColor() }>
          {
            read.map((message) =>
              <Message key={ message.id } message={ message } sender={ this.getSessionMemberById(message.senderId) } type='read' />
            )
          }

          { this.addSeperator(read, unread) }

          {
            unread.map((message) =>
              <Message key={ message.id } message={ message } sender={ this.getSessionMemberById(message.senderId) } type='unread' />
            )
          }
        </div>
      )
    }
    else {
      return (<div></div>)
    }
  }
});

const mapStateToProps = (state) => {
  return {
    facilitator: state.members.facilitator,
    participants: state.members.participants,
    colours: state.chat.session.colours,
    messages: state.directMessages
  }
};

export default connect(mapStateToProps)(Messages);
