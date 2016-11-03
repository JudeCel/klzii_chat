import React, {PropTypes} from 'react';
import { Modal }          from 'react-bootstrap';
import { connect }        from 'react-redux';

const ConfirmModal = React.createClass({
  onClose() {
    this.props.onClose();
  },
  render() {
    if(this.props.show) {
      return (
        <Modal dialogClassName='modal-section modal-section-confirm' show={ this.props.show } onHide={ this.onClose } onEnter={ this.onEnterModal }>
          <Modal.Header>
              <h1 className="modal-title">{this.props.title}</h1>
          </Modal.Header>

          <Modal.Footer>
            <h4 className="centered-body-text">{this.props.description}</h4>
            <span className='fa cancel-button pull-left' onClick={ this.props.onClose }>Cancel</span>
            <span className="fa confirm-button pull-right" onClick={ this.props.onAccept }>Continue</span>
          </Modal.Footer>
        </Modal>
      )
    }
    else {
      return (false)
    }
  }
});

export default ConfirmModal;
