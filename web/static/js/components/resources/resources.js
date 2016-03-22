import React, {PropTypes}                     from 'react';
import { connect }                            from 'react-redux';
import { Modal }                              from 'react-bootstrap';
import Constants                              from '../../constants';
import Actions                                from '../../actions/resource';
import Modals                                 from './modals';

const { ImageModal, AudioModal, VideoModal } = Modals;

const Resources = React.createClass({
  changeModalWindow(e) {
    const { dispatch, channel } = this.props;

    let modal = e.target.getAttribute('data-modal');
    dispatch({ type: Constants.OPEN_RESOURCE_MODAL, modal });
    dispatch(Actions.get(channel, modal));
  },
  closeModalWindow(e) {
    const { dispatch } = this.props;

    let modal = e.target.getAttribute('data-modal');
    dispatch({ type: Constants.CLOASE_RESOURCE_MODAL });
    dispatch({ type: Constants.CLEAN_RESOURCE, modal });
  },
  onDelete(e) {
    const { dispatch, channel } = this.props;

    let id = e.target.getAttribute('data-id');
    dispatch(Actions.delete(channel, id));
  },
  render() {
    const { permissions, modalWindow, colours } = this.props;

    if(permissions && permissions.resources.can_upload) {
      return (
        <div className='resources-section col-md-4'>
          <span className='links glyphicon glyphicon-film' onClick={ this.changeModalWindow } data-modal='video'>
            <VideoModal show={ modalWindow == 'video' } onHide={ this.closeModalWindow } onDelete={ this.onDelete } />
          </span>

          <span className='links glyphicon glyphicon-volume-up' onClick={ this.changeModalWindow } data-modal='audio'>
            <AudioModal show={ modalWindow == 'audio' } onHide={ this.closeModalWindow } onDelete={ this.onDelete } />
          </span>

          <span className='links glyphicon glyphicon-picture' onClick={ this.changeModalWindow } data-modal='image'>
            <ImageModal show={ modalWindow =='image' } onHide={ this.closeModalWindow } onDelete={ this.onDelete } />
          </span>

          <span className='links glyphicon glyphicon-camera'></span>
          <span className='links glyphicon glyphicon-ok'></span>
        </div>
      )
    }
    else {
      return(false)
    }
  }
});

const mapStateToProps = (state) => {
  return {
    modalWindow: state.resources.modalWindow,
    colours: state.chat.session.colours,
    channel: state.topic.channel,
    permissions:  state.members.currentUser.permissions
  }
};

export default connect(mapStateToProps)(Resources);
