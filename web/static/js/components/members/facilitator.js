import React, {PropTypes} from 'react';
import Member             from './member.js'
import { connect }        from 'react-redux';
import Console            from '../console/index';
import BoardModal         from './modals/facilitatorBoard';
import isOwner   from '../../mixins/isOwner';

const Facilitator = React.createClass({
  mixins: [isOwner],
  getInitialState() {
    return { boardModalOpen: false };
  },
  closeBoardModal() {
    this.setState({ boardModalOpen: false });
  },
  openBoardModal() {
    this.setState({ boardModalOpen: true });
  },
  selectClass(id) {
    const className = 'div-inline-block';
    return className + (this.isOwner(id) ? ' cursor-pointer' : '');
  },
  render() {
    const { boardModalOpen } = this.state;
    const { facilitator, openAvatarModal, boardContent } = this.props;
    return (
      <div className='facilitator-section'>
        <div className='div-inline-block'>
          <div className={ this.selectClass(facilitator.id) } onClick={ this.isOwner(facilitator.id) && openAvatarModal }>
            <Member key={ facilitator.id } member={ facilitator } />
          </div>

          <div className='say-section'>
            <div className='outerbox'>
              <div className='triangle'></div>
              <div className='innerbox' onClick={ this.openBoardModal }>
                <p className='text-break-all'>
                  { boardContent }
                </p>
              </div>
            </div>
          </div>

          <BoardModal show={ boardModalOpen } onHide={ this.closeBoardModal } boardContent={ boardContent } />
          <Console />
        </div>
      </div>
    )
  }
});

const mapStateToProps = (state) => {
  return {
    facilitator: state.members.facilitator,
    currentUser: state.members.currentUser,
    boardContent: state.members.facilitator.boardContent || 'Say something nice if you wish!'
  }
};

export default connect(mapStateToProps)(Facilitator);
