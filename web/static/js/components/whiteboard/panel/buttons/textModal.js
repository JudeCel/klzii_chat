import React, {PropTypes} from 'react';
import { connect }        from 'react-redux';
import { Modal }          from 'react-bootstrap';
import mixins             from '../../../../mixins';

const TextButtonModal = React.createClass({
  mixins: [mixins.modalWindows],
  handleTextChange(e) {
    this.setState({ text: e.target.value });
  },
  onSave() {
    this.props.changeButton({ data: { text: this.state.text, mode: 'text' } });
    this.closeAllModals();
  },
  render() {
    const show = this.props.modalWindows.whiteboardText;

    if(show) {
      return (
        <Modal dialogClassName='modal-section whiteboard-text-modal' show={ show } onHide={ this.closeAllModals } onEnter={ this.onEnterModal }>
          <Modal.Header>
            <div className='col-md-2'>
              <span className='pull-left fa icon-reply' onClick={ this.closeAllModals }></span>
            </div>

            <div className='col-md-8 modal-title'>
              <h4>Enter Text</h4>
            </div>

            <div className='col-md-2' onClick={ this.onSave }>
              <span className='pull-right fa fa-check'></span>
            </div>
          </Modal.Header>

          <Modal.Body>
            <input type='text' className='form-control no-border-radius' id='text' placeholder='Text' onChange={ this.handleTextChange } />
          </Modal.Body>
        </Modal>
      )
    }
    else {
      return (false);
    }
  }
});

const mapStateToProps = (state) => {
  return {
    modalWindows: state.modalWindows,
    colours: state.chat.session.colours,
  }
};

export default connect(mapStateToProps)(TextButtonModal);
