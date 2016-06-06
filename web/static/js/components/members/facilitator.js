import React, {PropTypes} from 'react';
import Member             from './member.js'
import { connect }        from 'react-redux';
import Console            from '../console/index';
import BoardModal         from './modals/facilitatorBoard';
import mixins             from '../../mixins';

const Facilitator = React.createClass({
  mixins: [mixins.validations, mixins.modalWindows],
  innerboxClassname(hasPermissions) {
    const className = 'innerbox';
    return hasPermissions ? className + ' cursor-pointer' : className;
  },
  selectClass(id) {
    const className = 'div-inline-block';
    return this.isOwner(id) ? className + ' cursor-pointer' : className;
  },
  render() {
    const { facilitator, boardContent, sessionTopicId } = this.props;
    const hasPermissions = this.hasPermissions('events', 'can_board_message');

    return (
      <div className='facilitator-section'>
        <div className='div-inline-block'>
          <div className={ this.selectClass(facilitator.id) } onClick={ this.isOwner(facilitator.id) && this.openSpecificModal.bind(this, 'avatar') }>
            <Member key={ facilitator.id } member={ facilitator } sessionTopicId={sessionTopicId} />
          </div>

          <div className='say-section'>
            <div className='outerbox'>
              <div className='triangle' />
              <div className={ this.innerboxClassname(hasPermissions) } onClick={ this.openSpecificModal.bind(this, 'facilitatorBoard') }>
                <p className='text-break-all' dangerouslySetInnerHTML={{ __html: boardContent }} />
              </div>
            </div>
          </div>

          <BoardModal { ...{ hasPermissions, boardContent } } />
          <Console />
        </div>
      </div>
    )
  }
});

const mapStateToProps = (state) => {
  return {
    modalWindows: state.modalWindows,
    sessionTopicId: state.sessionTopic.current.id,
    facilitator: state.members.facilitator,
    currentUser: state.members.currentUser,
    boardContent: state.sessionTopic.current.boardMessage
  }
};

export default connect(mapStateToProps)(Facilitator);
