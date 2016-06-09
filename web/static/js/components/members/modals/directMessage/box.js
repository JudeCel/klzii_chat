import React, {PropTypes} from 'react';
import { connect }        from 'react-redux';
import mixins             from '../../../../mixins';
import Messages           from './messages';
import Participants       from './participants';

const MessageBox = React.createClass({
  mixins: [mixins.validations, mixins.helpers],
  getInitialState() {
    return { member: this.props.modalData.member };
  },
  selectParticipant(member) {
    this.setState({ member: member });
  },
  render() {
    const { member } = this.state;
    const { colours, currentUser } = this.props;

    if(this.isFacilitator(currentUser)) {
      return (
        <div className='row direct-message-section'>
          <div className='col-md-4'>
            <Participants selectParticipant={ this.selectParticipant } memberId={ member.id } />
          </div>

          <div className='col-md-8'>
            <Messages member={ member } />
          </div>
        </div>
      )
    }
    else {
      return (
        <div className='row direct-message-section'>
          <div className='col-md-12'>
            <Messages member={ member } />
          </div>
        </div>
      )
    }
  }
});

const mapStateToProps = (state) => {
  return {
    modalData: state.modalWindows.data,
    currentUser: state.members.currentUser
  }
};

export default connect(mapStateToProps)(MessageBox);
