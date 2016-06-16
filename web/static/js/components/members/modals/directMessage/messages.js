import React, {PropTypes} from 'react';
import { connect }        from 'react-redux';
import ReactDOM           from 'react-dom';
import moment             from 'moment';
import TextareaAutosize   from 'react-autosize-textarea';
import Message            from './message';
import mixins             from '../../../../mixins';
import DirectMessageActions from '../../../../actions/directMessage';

const Messages = React.createClass({
  mixins: [mixins.helpers],
  borderColor() {
    return { borderColor: this.props.colours.mainBorder };
  },
  onChange(e) {
    this.setState({ text: e.target.value });
  },
  onKeyDown(e) {
    if((e.keyCode == 10 || e.keyCode == 13) && (e.ctrlKey || e.metaKey)) {
      this.sendMessage();
    }
  },
  sendMessage() {
    const { dispatch, channel, reciever } = this.props;
    dispatch(DirectMessageActions.send(channel, { recieverId: reciever.id, text: this.state.text }));

    this.setState(this.getInitialState(), function() {
      let textarea = ReactDOM.findDOMNode(this).querySelector('#direct-message-textarea');
      textarea.value = this.state.text;
    });
  },
  addSeperator(messages) {
    if(messages.length > 0) {
      return (
        <div className='unread-separator text-center'>
          <hr className='pull-left' style={ this.borderColor() } />
          <span className='date'>{ this.formatDate(moment, messages[0].createdAt) }</span>
          <hr className='pull-right' style={ this.borderColor() } />
        </div>
      )
    }
  },
  getInitialState() {
    return { text: '' };
  },
  componentWillUpdate() {
    let messages = ReactDOM.findDOMNode(this);
    let chatBoxHeight = messages.scrollTop + messages.offsetHeight;
    this.shouldScrollBottom = (chatBoxHeight === messages.scrollHeight);
  },
  componentDidUpdate(props, state) {
    // Needs check when actually changed data
    let messages = ReactDOM.findDOMNode(this);
    this.addOrRemoveScrollbarY(messages, this);
  },
  shouldComponentUpdate(props, state) {
    return state.text == this.state.text;
  },
  render() {
    const { messages } = this.props;

    return (
      <div className='col-md-12 messages-section' style={ this.borderColor() }>
        {
          messages.read.map((message) =>
            <Message key={ message.id } message={ message } sender={ this.getSessionMemberById(message.senderId) } type='read' />
          )
        }

        { this.addSeperator(messages.unread) }

        {
          messages.unread.map((message) =>
            <Message key={ message.id } message={ message } sender={ this.getSessionMemberById(message.senderId) } type='unread' />
          )
        }

        <div className='form-group'>
          <div className='input-group input-group-lg'>
            <TextareaAutosize id='direct-message-textarea' type='text' className='form-control no-border-radius' placeholder='Message' onChange={ this.onChange } onKeyDown={ this.onKeyDown } />
            <div className='input-group-addon no-border-radius cursor-pointer' onClick={ this.sendMessage }>POST</div>
          </div>
        </div>
      </div>
    )
  }
});

const mapStateToProps = (state) => {
  return {
    facilitator: state.members.facilitator,
    participants: state.members.participants,
    colours: state.chat.session.colours,
    channel: state.chat.channel,
    messages: state.directMessages
  }
};

export default connect(mapStateToProps, null, null, { pure: false })(Messages);
