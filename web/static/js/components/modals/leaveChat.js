import React       from 'react';
import { connect } from 'react-redux';
import { Modal }   from 'react-bootstrap';
import mixins      from '../../mixins';

const LeaveChatModal = React.createClass({
  mixins: [mixins.modalWindows],
  leave() {
    history.go(-2);
  },
  getSadTeardropIcon() {
    return 'images/leave_chat_sad_teardrop.png'
  },
  render() {
    let show = this.showSpecificModal('leaveChat');

    if(show) {
      return (
        <Modal dialogClassName='modal-section modal-leave-chat' show={ show } onHide={ this.closeAllModals } onEnter={ this.onEnterModal }>

          <Modal.Body>
            <div className='text-center'>
              <label>Uh Oh!</label>
              <div>Do you really want to leave us? <img className='leave-chat-icon' src={ this.getSadTeardropIcon() } /></div>
            </div>
          </Modal.Body>

          <Modal.Footer>
            <center>
              <button onClick={ this.closeAllModals } className='btn btn-standart btn-green btn-padding-24'>Stay <i className="fa fa-smile-o"></i></button>
              <button onClick={ this.leave } className='btn btn-standart btn-red btn-padding-24'>Leave <i className="fa fa-frown-o"></i></button>
            </center>
          </Modal.Footer>
        </Modal>
      )
    }
    else {
      return (false)
    }
  }
});

const mapStateToProps = (state) => {
  return {
    modalWindows: state.modalWindows,
    observers: state.members.observers,
    colours: state.chat.session.colours,
    currentUser: state.members.currentUser,
  }
};

export default connect(mapStateToProps)(LeaveChatModal);
