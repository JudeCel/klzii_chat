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
          <ul className='icons'>
            <li>
              <i className='icon-video-1' onClick={ this.changeModalWindow } data-modal='video' />
            </li>
            <li>
              <i className='icon-volume-up' onClick={ this.changeModalWindow } data-modal='audio' />
            </li>
            <li>
              <i className='icon-picture' onClick={ this.changeModalWindow } data-modal='image' />
            </li>
            <li>
              <i className='icon-camera' />
            </li>
            <li>
              <i className='icon-ok-squared' />
            </li>
          </ul>

          <VideoModal show={ modalWindow == 'video' } onHide={ this.closeModalWindow } onDelete={ this.onDelete } />
          <AudioModal show={ modalWindow == 'audio' } onHide={ this.closeModalWindow } onDelete={ this.onDelete } />
          <ImageModal show={ modalWindow == 'image' } onHide={ this.closeModalWindow } onDelete={ this.onDelete } />
        </div>
      )
    }
    else {
      return(<div className='resources-section col-md-4'></div>)
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
