import React, {PropTypes} from 'react';
import { connect }        from 'react-redux';
import mixins             from '../../../../mixins';
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
  getLastUnread(participantId) {
    return this.props.lastDirectMessages[participantId] || {};
  },
  render() {
    const { participants, observers, colours, unreadDirectMessages, lastDirectMessages, lastSentDirectMessages } = this.props;

    let users = [];
    observers.map((observer) => {
      if (lastDirectMessages[observer.id] || lastSentDirectMessages[observer.id]) {
        users.push(observer);
      }
    });
    users = users.concat(participants);

    if (users.length > 0) {
      return (
        <div className='list-group no-border-radius' style={{ borderColor: colours.mainBorder }}>
          {
            users.map((participant, index) =>
              <button type='button' key={ participant.id } className={ this.selectClassname(participant.id) } onClick={ this.selectParticipant.bind(this, participant) }>
                <div className='avatar'>
                  <Avatar member={ participant } specificId='direct-message-left' isDirectMessage={ true }/>
                </div>

                <div className='info'>
                  <div className='header'>
                    <div className='col-md-6'>
                      <strong>{ participant.role == 'observer' ? participant.firstName + ' ' + participant.lastName : participant.username }</strong>
                    </div>

                    <div className='col-md-6 text-right'>
                      <span className='badge'>{ unreadDirectMessages[participant.id] }</span>
                      <span>{ this.formatDate(this.getLastUnread(participant.id).createdAt) }</span>
                    </div>
                  </div>

                  <div className='body col-md-12'>
                    <p>{ this.getLastUnread(participant.id).text }</p>
                  </div>
                </div>
              </button>
            )
          }
        </div>
      )
    } else {
      return (
        <div className='list-group no-border-radius' style={{ borderColor: colours.mainBorder }}>
          <div style={{padding: "10px"}}>There are no users</div>
        </div>
      )
    }
  }
});

const mapStateToProps = (state) => {
  return {
    unreadDirectMessages: state.directMessages.unreadCount,
    lastDirectMessages: state.directMessages.last,
    lastSentDirectMessages: state.directMessages.lastSent,
    colours: state.chat.session.colours,
    participants: state.members.participants,
    observers: state.members.observers
  }
};

export default connect(mapStateToProps)(Participants);
