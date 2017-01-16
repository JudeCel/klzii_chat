import React, {PropTypes} from 'react';
import { Modal }          from 'react-bootstrap';
import { connect }        from 'react-redux';
import mixins             from '../../../../mixins';
import MessageBox         from './box';
import DirectMessageActions from '../../../../actions/directMessage';

const DirectMessage = React.createClass({
  mixins: [mixins.modalWindows],
  onClose() {
    const { dispatch, channel } = this.props;
    dispatch(DirectMessageActions.clearMessages());
    this.closeAllModals();
  },
  render() {
    const show = this.showSpecificModal('directMessage');

    if(show) {
      return (
        <Modal dialogClassName='modal-section direct-message-modal' show={ show } onHide={ this.onClose } onEnter={ this.onEnterModal }>
          <Modal.Header>
            <div className='col-md-2'>
              <span className='pull-left fa icon-reply' onClick={ this.onClose }></span>
            </div>

            <div className='col-md-8 modal-title'>
              <h4>Private Message</h4>
            </div>
          </Modal.Header>

          <Modal.Body>
            <MessageBox />
          </Modal.Body>
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
    channel: state.chat.channel,
    modalWindows: state.modalWindows,
    colours: state.chat.session.colours
  }
};

export default connect(mapStateToProps)(DirectMessage);
