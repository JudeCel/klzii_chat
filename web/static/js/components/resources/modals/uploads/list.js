import React, {PropTypes} from 'react';
import { connect }        from 'react-redux';
import UploadListItem     from './listItem';

const UploadList = React.createClass({
  chooseResourceType(resources) {
    return this.props[resources];
  },
  render() {
    const { modalName } = this.props;
    const sessionResources = this.chooseResourceType(modalName);

    return (
      <ul className='list-group'>
        <UploadListItem key={ 'none' } justInput={ true } modalName={ modalName } />
        {
          sessionResources.map((sr, index) =>
            <UploadListItem key={ index } resource={ sr.resource } modalName={ modalName } />
          )
        }
      </ul>
    )
  }
});

const mapStateToProps = (state) => {
  return {
    image: state.resources.images,
    video: state.resources.videos,
    audio: state.resources.audios
  }
};

export default connect(mapStateToProps)(UploadList);
