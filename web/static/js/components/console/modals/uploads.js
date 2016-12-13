import React, {PropTypes} from 'react';
import { connect }        from 'react-redux';
import { Modal }          from 'react-bootstrap';
import UploadTypes        from '../../resources/modals/uploads/types';
import mixins             from '../../../mixins';
import Actions            from '../../../actions/session_resource';


const UploadsConsole = React.createClass({
  mixins: [mixins.modalWindows, mixins.helpers],
  openModal(e) {
    this.onEnterModal(e);
    const { currentUserJwt, modalName, dispatch } = this.props;
    dispatch(Actions.getConsoleResource(currentUserJwt, this.getConsoleResourceId(modalName)));
  },
  render() {
    const { modalName, show, sessionTopicConsole } = this.props;

    if(show) {
      return (
        <Modal dialogClassName='modal-section' show={ show } onHide={ this.closeAllModals } onEnter={ this.openModal }>
          <Modal.Header>
            <div className='col-md-2'>
              <span className='pull-left fa icon-reply' onClick={ this.closeAllModals }></span>
            </div>

            <div className='col-md-8 modal-title'>
              <h4>{ sessionTopicConsole.consoleResource.name }</h4>
            </div>
          </Modal.Header>

          <Modal.Body>
            <div className='row uploads-console-section'>
              <UploadTypes modalName={ modalName } { ...sessionTopicConsole.consoleResource } videoService={ sessionTopicConsole.consoleResource.scope == 'videoService' } source={ sessionTopicConsole.consoleResource.source } autoPlay={true} />
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
    currentUserJwt: state.members.currentUser.jwt,
    colours: state.chat.session.colours,
    sessionTopicConsole: state.sessionTopicConsole,
  }
};

export default connect(mapStateToProps)(UploadsConsole);
