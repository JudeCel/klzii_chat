import React, {PropTypes} from 'react';
import { connect }        from 'react-redux';
import mixins             from '../../../../mixins';
import moment             from 'moment';
import Avatar             from './../../avatar';

const Participants = React.createClass({
  mixins: [mixins.helpers],
  selectParticipant(participant) {
    this.props.selectParticipant(participant);
  },
  selectClassname(memberId) {
    const className = 'list-group-item no-border-radius';
    return memberId == this.props.memberId ? className + ' selected' : className;
  },
  render() {
    const { participants, colours, unreadDirectMessages, lastDirectMessages } = this.props;

    return (
      <div className='list-group no-border-radius' style={{ borderColor: colours.mainBorder }}>
        {
          participants.map((participant, index) =>
            <button type='button' key={ participant.id } className={ this.selectClassname(participant.id) } onClick={ this.selectParticipant.bind(this, participant) }>
              <div className='avatar'>
                <Avatar member={ participant } specificId='direct-message-left' />
              </div>

              <div className='info'>
                <div className='header'>
                  <div className='col-md-6'>
                    <strong>{ participant.username }</strong>
                  </div>

                  <div className='col-md-6 text-right'>
                    <span className='badge'>{ unreadDirectMessages[participant.id] }</span>
                    <span>{ this.formatDate(moment, new Date()) }</span>
                  </div>
                </div>

                <div className='body col-md-12'>
                  <p>{ lastDirectMessages[participant.id] }</p>
                </div>
              </div>
            </button>
          )
        }
      </div>
    )
  }
});

const mapStateToProps = (state) => {
  return {
    unreadDirectMessages: state.directMessages.unreadCount,
    lastDirectMessages: state.directMessages.last,
    colours: state.chat.session.colours,
    participants: state.members.participants
  }
};

export default connect(mapStateToProps)(Participants);