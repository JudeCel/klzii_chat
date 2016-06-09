import React, {PropTypes} from 'react';
import { connect }        from 'react-redux';
import ReactDOM           from 'react-dom';
import moment             from 'moment';
import TextareaAutosize   from 'react-autosize-textarea';
import Message            from './message';
import mixins             from '../../../../mixins';

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
    console.error(this.state.text);
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
  componentDidMount() {
    // temp while no real messages
    this.shouldScrollBottom = true;
    this.componentDidUpdate();
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
    const { member, messages, currentUser } = this.props;

    return (
      <div className='col-md-12 messages-section' style={ this.borderColor() }>
        {
          messages.read.map((message) =>
            <Message key={ message.id } message={ message } member={ member } type='read' />
          )
        }

        { this.addSeperator(messages.unread) }

        {
          messages.unread.map((message) =>
            <Message key={ message.id } message={ message } member={ currentUser } type='unread' />
          )
        }

        <div className='form-group'>
          <div className='input-group input-group-lg'>
            <TextareaAutosize type='text' className='form-control no-border-radius' placeholder='Message' onChange={ this.onChange } onKeyDown={ this.onKeyDown } />
            <div className='input-group-addon no-border-radius cursor-pointer' onClick={ this.sendMessage }>POST</div>
          </div>
        </div>
      </div>
    )
  }
});

const mapStateToProps = (state) => {
  return {
    colours: state.chat.session.colours,
    currentUser: state.members.currentUser,
    messages: state.chat.session.directMessages || _fakeSeedData(10)
  }
};

export default connect(mapStateToProps, null, null, { pure: false })(Messages);

function _fakeSeedData(count) {
  let unreadCount = 2;
  let readCount = count - unreadCount;

  let read = [];
  for(var i = 0; i < readCount; i++) {
    read.push({
      id: i,
      senderId: 1,
      recieverId: 2,
      createdAt: new Date(),
      readAt: new Date(),
      text: "Random text " + i
    });
  }

  let unread = [];
  for(var i = 0; i < unreadCount; i++) {
    unread.push({
      id: i,
      senderId: 1,
      recieverId: 2,
      createdAt: new Date(),
      readAt: null,
      text: "Random text " + i
    });
  }

  return { read: read, unread: unread };
}
