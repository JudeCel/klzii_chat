import React, {PropTypes} from 'react';
import { connect }        from 'react-redux';
import { Modal }          from 'react-bootstrap';
import UploadsView        from '../../resources/modals/uploads/types/index';
import mixins             from '../../../mixins';

const UploadsConsole = React.createClass({
  mixins: [mixins.modalWindows],
  render() {
    const show = this.showSpecificModal('console');
    const { consoleData, resourceType, shouldRender } = this.props;
    const currentData = consoleData[resourceType];

    if(show && shouldRender) {
      return (
        <Modal dialogClassName='modal-section' show={ show } onHide={ this.closeAllModals } onEnter={ this.onEnterModal }>
          <Modal.Header>
            <div className='col-md-2'>
              <span className='pull-left fa icon-reply' onClick={ this.closeAllModals }></span>
            </div>

            <div className='col-md-8 modal-title'>
              <h4>{ currentData.name }</h4>
            </div>
          </Modal.Header>

          <Modal.Body>
            <div className='row uploads-console-section'>
              <UploadsView resourceType={ resourceType } { ...currentData } />
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
    consoleData: state.resources.console || {
      video: { name: "some video", url: "gT_xyrHsrgs", youtube: true },
      audio: { name: "some audio", url: "someurl" },
      image: { name: "some image", url: "someurl" }
    }
  }
};

export default connect(mapStateToProps)(UploadsConsole);
