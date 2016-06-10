import React, {PropTypes} from 'react';
import { connect }        from 'react-redux';
import { Modal }          from 'react-bootstrap';
import ReportsPages       from './pages';
import mixins             from '../../mixins';

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
  changePage(rendering, report) {
    this.setState({ rendering, report });
  },
  render() {
    const { rendering, report } = this.state;
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
            <div className='row'>
              <div className='col-md-12'>
                <ReportsPages rendering={ rendering } changePage={ this.changePage } report={ report } />
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
