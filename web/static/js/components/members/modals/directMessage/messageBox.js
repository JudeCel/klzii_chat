import React, {PropTypes} from 'react';
import { connect }        from 'react-redux';
import mixins             from '../../../../mixins';
import Avatar             from './../../avatar';
import Messages           from './messages';

const MessageBox = React.createClass({
  mixins: [mixins.validations],
  getInitialState() {
    return { member: this.props.modalData.member };
  },
  selectParticipant(member) {
    this.setState({ member: member });
  },
  render() {
    const { member } = this.state;
    const { colours, participants, currentUser } = this.props;

    if(this.isFacilitator(currentUser)) {
      return (
        <div className='row direct-message-section'>
          <div className='col-md-4'>
            <div className='list-group no-border-radius' style={{ borderColor: colours.mainBorder }}>
              {
                participants.map((participant, index) =>
                  <button type='button' key={ index } className='list-group-item no-border-radius' onClick={ this.selectParticipant.bind(this, participant) }>
                    <Avatar member={ participant } specificId='direct-message-left' />
                  </button>
                )
              }
            </div>
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
    colours: state.chat.session.colours,
    participants: state.members.participants,
    currentUser: state.members.currentUser
  }
};

export default connect(mapStateToProps)(MessageBox);
