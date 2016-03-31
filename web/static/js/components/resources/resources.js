import React, {PropTypes} from 'react';
import { connect }        from 'react-redux';
import Constants          from '../../constants';
import Actions            from '../../actions/resource';
import Modals             from './modals';

const { ImageModal, AudioModal, VideoModal, SurveyModal } = Modals;

const Resources = React.createClass({
  compareState(modal) {
    return this.props.modalWindow == modal;
  },
  changeModalWindow(e) {
    const { dispatch, channel } = this.props;

    let modal = e.target.getAttribute('data-modal');
    dispatch({ type: Constants.OPEN_RESOURCE_MODAL, modal });
    if(modal != 'survey') {
      dispatch(Actions.get(channel, modal));
    }
  },
  closeModalWindow(e) {
    const { dispatch } = this.props;

    dispatch({ type: Constants.CLOASE_RESOURCE_MODAL });
    dispatch({ type: Constants.CLEAN_RESOURCE });
  },
  onEnter(e) {
    const { colours } = this.props;

    let modalFrame = e.querySelector('.modal-content');
    modalFrame.style.borderColor = colours.mainBorder;
  },
  onDelete(e) {
    const { dispatch, channel } = this.props;

    let id = e.target.getAttribute('data-id');
    if(modal != 'survey') {
      dispatch(Actions.delete(channel, id));
    }
  },
  render() {
    const { permissions } = this.props;

    if(permissions && permissions.resources.can_upload) {
      return (
        <div className='resources-section col-md-4'>
          <ul className='icons'>
            <li onClick={ this.changeModalWindow } data-modal='video'>
              <i className='icon-video-1' data-modal='video' />
            </li>
            <li onClick={ this.changeModalWindow } data-modal='audio'>
              <i className='icon-volume-up' data-modal='audio' />
            </li>
            <li onClick={ this.changeModalWindow } data-modal='image'>
              <i className='icon-picture' data-modal='image' />
            </li>
            <li>
              <i className='icon-camera' />
            </li>
            <li onClick={ this.changeModalWindow } data-modal='survey'>
              <i className='icon-ok-squared' data-modal='survey' />
            </li>
          </ul>

          <VideoModal show={ this.compareState('video') } onHide={ this.closeModalWindow } onDelete={ this.onDelete } onEnter={ this.onEnter } />
          <AudioModal show={ this.compareState('audio') } onHide={ this.closeModalWindow } onDelete={ this.onDelete } onEnter={ this.onEnter } />
          <ImageModal show={ this.compareState('image') } onHide={ this.closeModalWindow } onDelete={ this.onDelete } onEnter={ this.onEnter } />
          <SurveyModal show={ this.compareState('survey') } onHide={ this.closeModalWindow } onEnter={ this.onEnter } />
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
    colours: state.chat.session.colours,
    modalWindow: state.resources.modalWindow,
    channel: state.topic.channel,
    permissions: state.members.currentUser.permissions
  }
};

export default connect(mapStateToProps)(Resources);
