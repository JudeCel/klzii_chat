import React, {PropTypes} from 'react';
import { connect }        from 'react-redux';
import { Modal }          from 'react-bootstrap';
import UploadsView        from '../../resources/modals/uploads/types/index';

const UploadsConsole = React.createClass({
  render() {
    const { show, onHide, onEnter, consoleData, resourceType } = this.props;
    const currentData = consoleData[resourceType];

    if(show) {
      return (
        <Modal dialogClassName='modal-section' show={ show } onHide={ onHide } onEnter={ onEnter }>
          <Modal.Header>
            <div className='col-md-2'>
              <span className='pull-left fa icon-reply' onClick={ onHide }></span>
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
    consoleData: state.resources.console || {
      video: { name: "some video", url: "gT_xyrHsrgs", youtube: true },
      audio: { name: "some audio", url: "someurl" },
      image: { name: "some image", url: "someurl" }
    }
  }
};

export default connect(mapStateToProps)(UploadsConsole);
