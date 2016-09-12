import React, {PropTypes}  from 'react';
import { connect }         from 'react-redux';
import { Modal }           from 'react-bootstrap';
import mixins              from '../../../mixins';
import PinboardActions     from '../../../actions/pinboard';
import UploadImage         from '../../resources/modals/uploads/new/upload';

const PinboardConsole = React.createClass({
  mixins: [mixins.modalWindows, mixins.validations],
  afterChange(data) {
    this.setState(data.resourceData);
  },
  addToPinboard() {
    const { name, files } = this.state;
    const { dispatch, sessionTopic, currentUserJwt } = this.props;
    if (!this.props.modalWindows.postData) {
      let data = {
        type: 'image',
        scope: 'pinboard',
        name: name,
        files: files,
        sessionTopicId: sessionTopic.id
      };
      dispatch(PinboardActions.upload(data, currentUserJwt));
    }
  },
  render() {
    const { show } = this.props;

    if(show) {
      return (
        <Modal dialogClassName='modal-section' show={ show } onHide={ this.closeAllModals } onEnter={ this.onEnterModal }>
          <Modal.Header>
            <div className='col-md-2'>
              <span className='pull-left fa icon-reply' onClick={ this.closeAllModals }></span>
            </div>

            <div className='col-md-8 modal-title'>
              <h4>Upload image to pinboard</h4>
            </div>

            <div className='col-md-2'>
              <span className='pull-right fa fa-check' onClick={ this.addToPinboard }></span>
            </div>
          </Modal.Header>

          <Modal.Body>
            <div className='row pinboard-upload-section mobile-camera'>
              <UploadImage modalName='image' afterChange={ this.afterChange } />
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
    currentUserJwt: state.members.currentUser.jwt,
    sessionTopic: state.sessionTopic.current,
    modalWindows: state.modalWindows,
    colours: state.chat.session.colours,
  }
};

export default connect(mapStateToProps)(PinboardConsole);
