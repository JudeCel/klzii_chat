import React, {PropTypes}  from 'react';
import Dropzone            from 'react-dropzone';
import { connect }         from 'react-redux';
import Actions             from '../../actions/resource';

const VideoUpload =  React.createClass({
  onDrop: function(files){
    const { dispatch, currentUserId, currentTopicId } = this.props
    dispatch(Actions.video(files, currentUserId, currentTopicId))
  },
  onOpenClick: function () {
    this.refs.dropzone.open();
  },
  render() {
    return (
      <div>
        <Dropzone ref="dropzone" onDrop={this.onDrop} >
          <div>Try dropping some files here, or click to select files to upload.</div>
        </Dropzone>
        <button type="button" onClick={this.onOpenClick}>
            Open Dropzone
        </button>
    </div>
    );
  }
})
export default VideoUpload;
const mapStateToProps = (state) => {
  return {
    channal: state.topic.channel,
    currentUserId: state.members.currentUser.id,
    videos: state.resources.videos,
    currentTopicId: state.topic.current.id,
  }
};
export default connect(mapStateToProps)(VideoUpload);
