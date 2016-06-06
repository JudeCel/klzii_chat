import React, {PropTypes} from 'react';
import { connect }        from 'react-redux';
import { Modal }          from 'react-bootstrap';
import mixins             from '../../mixins';
import ReportView         from './view';

const ReportsModal = React.createClass({
  mixins: [mixins.modalWindows],
  getInitialState() {
    return { rendering: 'index' };
  },
  onClose() {
    this.setState(this.getInitialState());
    this.closeAllModals();
  },
  onBack() {
    if(this.state.rendering != 'index') {
      this.setState(this.getInitialState());
    }
    else {
      this.onClose();
    }
  },
  onShow(e) {
    this.setState(this.getInitialState());
    this.onEnterModal(e);
  },
  render() {
    const { rendering } = this.state;
    const { show } = this.props;

    if(show) {
      return (
        <Modal dialogClassName='reports-modal modal-section' show={ show } onHide={ this.onClose } onEnter={ this.onShow }>
          <Modal.Header>
            <div className='col-md-2'>
              <span className='pull-left fa icon-reply' onClick={ this.onBack }></span>
            </div>

            <div className='col-md-8 modal-title'>
              <h4>Reports</h4>
            </div>
          </Modal.Header>

          <Modal.Body>
            <div className='row reports-section'>
              <div className='col-md-12'>
                <ReportView rendering={ rendering } />
              </div>
            </div>
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
    modalWindows: state.modalWindows,
    colours: state.chat.session.colours,
  }
};

export default connect(mapStateToProps)(ReportsModal);
