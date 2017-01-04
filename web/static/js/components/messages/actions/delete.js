import React, { PropTypes } from 'react';
import { connect }          from 'react-redux';
import Constants            from '../../../constants';
import MessagesActions      from '../../../actions/messages';
import ConfirmModal         from './../../modals/confirmModal'

const DeleteMessage = React.createClass({
  getInitialState() {
    return {showDeleteModal: false};
  },
  deleteCanceled() {
    this.setState({ showDeleteModal: false });
  },
  deleteAccepted() {
    const { message, dispatch, channel } = this.props;
    dispatch(MessagesActions.deleteMessage(channel, { id: message.id, replyId: message.replyId }));
    dispatch({ type: Constants.SET_INPUT_DEFAULT_STATE });
    this.setState({ showDeleteModal: false });
  },
  deleteMessage() {
    const { currentUser, message } = this.props;
    this.setState({ showDeleteModal: true });
  },
  render() {
    const { permission } = this.props;

    if (permission) {
      return(
        <span>
          <i className='icon-cancel-empty' onClick={ this.deleteMessage } />
          <ConfirmModal show={this.state.showDeleteModal} onAccept={this.deleteAccepted} onClose={this.deleteCanceled} description='Are you sure you want to delete this post?' title="Are you sure?"/>
        </span>
      )
    } else {
      return(false)
    }
  }
});

const mapStateToProps = (state) => {
  return {
    channel: state.sessionTopic.channel,
    currentUser: state.members.currentUser
  };
};

export default connect(mapStateToProps)(DeleteMessage);
