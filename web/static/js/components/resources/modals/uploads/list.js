import React, {PropTypes} from 'react';
import { connect }        from 'react-redux';
import UploadListItem     from './listItem';
import UploadTypes        from './types/index';
import mixins             from '../../../../mixins';
import Actions            from '../../../../actions/session_resource';

const UploadList = React.createClass({
  mixins: [mixins.helpers],
  chooseResourceType(resources) {
    return this.props[resources];
  },
  componentDidUpdate(props, state) {
    const { dispatch, currentUserJwt, modalData } = this.props;

    if(props.modalData.type != modalData.type) {
      dispatch(Actions.index(currentUserJwt, { type: this.get_session_resource_types(modalData.type) }));
    }
  },
  render() {
    const { modalData } = this.props;
    const sessionResources = this.chooseResourceType(modalData.type) || [];

    return (
      <ul className='list-group'>
        <UploadListItem key={ 'none' } justInput={ true } modalName={ modalData.type } />
        {
          sessionResources.map((sr) =>
            <UploadListItem key={ modalData.type + sr.id } sessionResourceId={sr.id} resource={ sr.resource } modalName={ modalData.type } />
          )
        }
      </ul>
    )
  }
});

const mapStateToProps = (state) => {
  return {
    modalData: state.modalWindows.currentModalData,
    currentUserJwt: state.members.currentUser.jwt,
    image: state.resources.images,
    video: state.resources.videos,
    audio: state.resources.audios
  }
};

export default connect(mapStateToProps)(UploadList);
