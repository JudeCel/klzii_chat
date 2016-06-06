import React, {PropTypes} from 'react';
import { connect }        from 'react-redux';
import Avatar             from './../../avatar.js';

const MessageBox = React.createClass({
  render() {
    const { member, messages, currentUser, colours } = this.props;

    return (
      <div className='messages-section' style={{ borderColor: colours.mainBorder }}>
        {
          messages.read.map((message, index) =>
            <div key={ index } className='media'>
              <div className='media-left media-top'>
                <Avatar member={ member } specificId={ 'direct-message-sender' + index } />
              </div>

              <div className='media-body'>
                {/*<h4 className='media-heading'>{ message.createdAt }</h4>*/}
                { message.text }
              </div>
            </div>
          )
        }
        {
          messages.unread.map((message, index) =>
            <div key={ index } className='media'>
              <div className='media-left media-top'>
                <Avatar member={ currentUser } specificId={ 'direct-message-reciever' + index } />
              </div>

              <div className='media-body'>
                {/*<h4 className='media-heading'>{ message.createdAt }</h4>*/}
                { message.text }
              </div>
            </div>
          )
        }
      </div>
    )
  }
});

const mapStateToProps = (state) => {
  return {
    colours: state.chat.session.colours,
    currentUser: state.members.currentUser,
    messages: state.chat.session.directMessages || _fakeSeedData(3)
  }
};

export default connect(mapStateToProps)(MessageBox);

function _fakeSeedData(count) {
  let unreadCount = 2;
  let readCount = count - unreadCount;

  let read = [];
  for(var i = 0; i < readCount; i++) {
    read.push({
      senderId: 1,
      recieverId: 2,
      read: true,
      createdAt: new Date(),
      text: "Random text " + i
    });
  }

  let unread = [];
  for(var i = 0; i < unreadCount; i++) {
    unread.push({
      senderId: 1,
      recieverId: 2,
      read: true,
      createdAt: new Date(),
      text: "Random text " + i
    });
  }

  return { read: read, unread: unread };
}
