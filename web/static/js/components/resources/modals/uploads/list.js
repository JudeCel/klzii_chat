import React, {PropTypes} from 'react';
import { connect }        from 'react-redux';
import UploadListItem     from './listItem';

const UploadList = React.createClass({
  chooseResourceType(resources) {
    return this.props[resources];
  },
  render() {
    const { resourceType, onDelete } = this.props;
    const resources = this.chooseResourceType(resourceType);

    return (
      <ul className='list-group'>
        <UploadListItem key={ -1 } justInput={ true } />
        {
          resources.map((resource, index) =>
            <UploadListItem key={ index } resource={ resource } resourceType={ resourceType } onDelete={ onDelete } />
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
