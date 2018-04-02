import React, {PropTypes} from 'react';
import { connect }        from 'react-redux';
import Member             from './member.js';
import BoardModal         from './modals/facilitatorBoard';
import mixins             from '../../mixins';

const Facilitator = React.createClass({
  mixins: [mixins.validations, mixins.modalWindows],
  innerboxClassname(permission) {
    const className = 'innerbox text-break-all';
    return permission ? className + ' cursor-pointer' : className;
  },
  getCurrentSessionTopic() {
    const { current, sessionTopics } = this.props;
    for(let i=0; i<sessionTopics.length; i++) {
      if (current.id == sessionTopics[i].id) {
        return sessionTopics[i];
      }
    }
    return current;
  },
  render() {
    const { facilitator } = this.props;
    let boardContent = this.getCurrentSessionTopic().boardMessage;
    const permission = this.hasPermission(['messages', 'can_board_message']);

    let facilitatorMember = this.isForum() ? Object.assign(facilitator, { online: true }) : facilitator;
    
    return (
      <div className='facilitator-section'>
        <div className='div-inline-block'>
          <Member key={ facilitator.id } member={ facilitatorMember } />
        </div>

        <div className='say-section'>
          <div className='outerbox'>
            <div className='triangle'></div>
            <div className={ this.innerboxClassname(permission) } onClick={ this.openSpecificModal.bind(this, 'facilitatorBoard') }>
              <p className='facilitator-name-mobile'>Host: { facilitator.username }</p>
              <p style={{wordWrap: 'breakWord'}} dangerouslySetInnerHTML={{ __html: boardContent }} />
            </div>
          </div>
        </div>

        <BoardModal { ...{ permission, boardContent } } />
      </div>
    )
  }
});

const mapStateToProps = (state) => {
  return {
    modalWindows: state.modalWindows,
    facilitator: state.members.facilitator,
    currentUser: state.members.currentUser,
    current: state.sessionTopic.current,
    sessionTopics: state.sessionTopic.all,
    session: state.chat.session,
  }
};

export default connect(mapStateToProps)(Facilitator);
