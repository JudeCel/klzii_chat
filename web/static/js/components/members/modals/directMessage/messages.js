import React, {PropTypes} from 'react';
import { connect }        from 'react-redux';
import ReactDOM           from 'react-dom';
import moment             from 'moment';
import Message            from './message';
import mixins             from '../../../../mixins';
import DirectMessageActions from '../../../../actions/directMessage';

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
  addFetcher() {
    const { fetching, canFetch, messages } = this.props;

    if(fetching) {
      return (
        <i className='fa fa-spinner fa-pulse fa-3x fa-fw' />
      )
    }
    else if(canFetch && (messages.unread.length + messages.read.length) >= 10) {
      return (
        <div style={ this.borderColor() } onClick={ this.fetchNewData }>
          Fetch more messages
        </div>
      )
    }
  },
  fetchNewData() {
    const { dispatch, channel, reciever, currentPage } = this.props;
    dispatch(DirectMessageActions.nextPage(channel, reciever.id, currentPage));
  },
  componentWillUpdate(props) {
    let messages = ReactDOM.findDOMNode(this);
    let chatBoxHeight = messages.scrollTop + messages.offsetHeight;
    this.shouldScrollBottom = (chatBoxHeight >= messages.scrollHeight);
  },
  componentDidUpdate() {
    let messages = ReactDOM.findDOMNode(this);
    this.addOrRemoveScrollbarY(messages, this);
  },
  render() {
    const { read, unread } = this.props.messages;

    if(read.length || unread.length) {
      return (
        <div className='messages-section' style={ this.borderColor() }>
          <div className='fetcher-section text-center cursor-pointer'>
            { this.addFetcher() }
          </div>

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
    channel: state.chat.channel,
    facilitator: state.members.facilitator,
    participants: state.members.participants,
    colours: state.chat.session.colours,
    messages: state.directMessages,
    currentPage: state.directMessages.currentPage,
    canFetch: state.directMessages.canFetch,
    fetching: state.directMessages.fetching
  }
};

export default connect(mapStateToProps)(Messages);
