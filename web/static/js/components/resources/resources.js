import React, {PropTypes} from 'react';
import { connect }        from 'react-redux';
import Constants          from '../../constants';
import Actions            from '../../actions/resource';
import onEnterModalMixin  from '../../mixins/onEnterModal';
import Modals             from './modals';

const { UploadsModal, SurveyModal } = Modals;

const Resources = React.createClass({
  mixins: [onEnterModalMixin],
  getInitialState() {
    return { resourceData: {} };
  },
  compareState(modals) {
    return modals.includes(this.props.modalWindow);
  },
  changeModalWindow(e) {
    const { dispatch, channel, modalWindow } = this.props;
    if(modalWindow.length) {
      this.closeModalWindow(e);
    }

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
  onDelete(e) {
    const { dispatch, channel } = this.props;

    let id = e.target.getAttribute('data-id');
    if(this.props.modalWindow != 'survey') {
      dispatch(Actions.delete(channel, id));
    }
  },
  onCreate(child) {
    const { name, url, files, resourceIds } = this.state.resourceData;
    const { dispatch, modalWindow, currentUserJwt } = this.props;

    if(url) {
      //youtube
      let data = {
        type: 'link',
        scope: 'youtube',
        name: name,
        file: url
      };

      dispatch(Actions.youtube(data, currentUserJwt));
    }
    else if(files) {
      // upload
      let data = {
        type: modalWindow,
        scope: 'collage',
        name: name,
        files: files
      };

      dispatch(Actions.upload(data, currentUserJwt));
    }
    else {
      // resource id
      console.error(resourceIds);
    }

    this.setState({ resourceData: {} });
    child.onBack();
  },
  afterChange(data) {
    this.setState(data);
  },
  render() {
    const { permissions, modalWindow, colours } = this.props;

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

          <UploadsModal
            resourceType={ modalWindow }
            show={ this.compareState(['video', 'audio', 'image']) }
            onHide={ this.closeModalWindow }
            onDelete={ this.onDelete }
            onEnter={ this.onEnter }
            afterChange={ this.afterChange }
            onCreate={ this.onCreate }
            mainBorder={ colours.mainBorder }
          />
          <SurveyModal show={ this.compareState(['survey']) } onHide={ this.closeModalWindow } onEnter={ this.onEnter } />
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
    currentUserJwt: state.members.currentUser.jwt,
    modalWindow: state.resources.modalWindow,
    channel: state.topic.channel,
    permissions: state.members.currentUser.permissions
  }
};

export default connect(mapStateToProps)(Resources);
