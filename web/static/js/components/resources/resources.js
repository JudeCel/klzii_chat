import React, {PropTypes} from 'react';
import { connect }        from 'react-redux';
import Constants          from '../../constants';
import Actions            from '../../actions/resource';
import mixins             from '../../mixins';
import Modals             from './modals';

const { UploadsModal, SurveyModal } = Modals;

const Resources = React.createClass({
  mixins: [mixins.modalWindows],
  getInitialState() {
    return { resourceData: {}, currentModal: null };
  },
  compareState(modals) {
    return modals.includes(this.state.currentModal);
  },
  openModal(modal) {
    this.setState({ currentModal: modal }, function() {
      this.openSpecificModal('resources');
    });
  },
  onDelete(id) {
    const { dispatch, channel } = this.props;
    dispatch(Actions.delete(channel, id));
  },
  onCreate(child) {
    const { name, url, files, resourceId } = this.state.resourceData;
    const { dispatch, currentUserJwt } = this.props;

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
    else if (resourceIds) {
      // TODO: update SessionResources
      dispatch(Actions.createSessionResources(currentUserJwt, resourceIds));
    }

    this.setState({ resourceData: {} });
    child.onBack();
  },
  afterChange(data) {
    this.setState(data);
  },
  render() {
    const { currentModal } = this.state;
    const { permissions } = this.props;

    if(permissions && permissions.resources.can_upload) {
      return (
        <div className='resources-section col-md-4'>
          <ul className='icons'>
            <li onClick={ this.openModal.bind(this, 'video') }>
              <i className='icon-video-1' />
            </li>
            <li onClick={ this.openModal.bind(this, 'audio') }>
              <i className='icon-volume-up' />
            </li>
            <li onClick={ this.openModal.bind(this, 'image') }>
              <i className='icon-picture' />
            </li>
            <li>
              <i className='icon-camera' />
            </li>
            <li onClick={ this.openModal.bind(this, 'survey') }>
              <i className='icon-ok-squared' />
            </li>
          </ul>

          <UploadsModal
            resourceType={ currentModal }
            shouldRender={ this.compareState(['video', 'audio', 'image']) }
            onDelete={ this.onDelete }
            afterChange={ this.afterChange }
            onCreate={ this.onCreate }
          />
          <SurveyModal shouldRender={ this.compareState(['survey']) } />
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
    permissions: state.members.currentUser.permissions,
    modalWindows: state.modalWindows,
    currentUserJwt: state.members.currentUser.jwt,
    channel: state.topic.channel,
    permissions: state.members.currentUser.permissions
  }
};

export default connect(mapStateToProps)(Resources);
