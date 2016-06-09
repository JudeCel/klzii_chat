import React, {PropTypes} from 'react';
import { connect }        from 'react-redux';
import Member             from './member.js';
import BoardModal         from './modals/facilitatorBoard';
import Console            from '../console/index';
import mixins             from '../../mixins';

const Facilitator = React.createClass({
  mixins: [mixins.validations, mixins.modalWindows],
  innerboxClassname(hasPermissions) {
    const className = 'innerbox';
    return hasPermissions ? className + ' cursor-pointer' : className;
  },
  render() {
    const { facilitator, boardContent } = this.props;
    const hasPermissions = this.hasPermissions('events', 'can_board_message');

    return (
      <div className='facilitator-section'>
        <div className='div-inline-block'>
          <div className='div-inline-block'>
            <Member key={ facilitator.id } member={ facilitator } />
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
    facilitator: state.members.facilitator,
    currentUser: state.members.currentUser,
    boardContent: state.sessionTopic.current.boardMessage
  }
};

export default connect(mapStateToProps)(Facilitator);
