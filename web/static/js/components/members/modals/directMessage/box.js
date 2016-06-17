import React, {PropTypes} from 'react';
import { connect }        from 'react-redux';
import Messages           from './messages';
import Participants       from './participants';
import MessageInput       from './input';
import mixins             from '../../../../mixins';
import DirectMessageActions from '../../../../actions/directMessage';

const MessageBox = React.createClass({
  mixins: [mixins.validations, mixins.helpers],
  getInitialState() {
    const { member } = this.props.modalData;
    this.loadMemberMessages(member);
    return { reciever: member };
  },
  selectParticipant(reciever) {
    this.setState({ reciever: reciever });
    this.loadMemberMessages(reciever);
  },
  loadMemberMessages(reciever) {
    const { dispatch, channel } = this.props;
    dispatch(DirectMessageActions.index(channel, reciever.id));
    dispatch(DirectMessageActions.read(channel, reciever.id));
    dispatch(DirectMessageActions.last(channel));
  },
  render() {
    const { reciever } = this.state;
    const { colours, currentUser } = this.props;

    if(this.isFacilitator(currentUser)) {
      return (
        <div className='row direct-message-section'>
          <div className='col-md-4'>
            <Participants selectParticipant={ this.selectParticipant } memberId={ reciever.id } />
          </div>

          <div className='col-md-8'>
            <Messages reciever={ reciever } />
            <MessageInput />
          </div>
        </div>
      )
    }
    else {
      return (
        <div className='row direct-message-section'>
          <div className='col-md-12'>
            <Messages reciever={ reciever } />
            <MessageInput />
          </div>
        </div>
      )
    }
  }
});

const mapStateToProps = (state) => {
  return {
    channel: state.chat.channel,
    modalData: state.modalWindows.data,
    currentUser: state.members.currentUser
  }
};

export default connect(mapStateToProps)(MessageBox);
