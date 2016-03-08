import React, {PropTypes}  from 'react';
import Dropzone            from 'react-dropzone';
import { connect }         from 'react-redux';
import Actions             from '../../actions/resource';
import { Modal }           from "react-bootstrap"

const VideoUpload =  React.createClass({
  onDrop: function(files){
    const { dispatch, currentUserId, currentTopicId } = this.props
    dispatch(Actions.video(files, currentUserId, currentTopicId))
  },
  onOpenClick: function () {
    this.refs.dropzone.open();
  },
  render() {
    const {show, onHide} = this.props
    return (
      <div>

        <Modal  show={show} onHide={onHide}>
          <Modal.Header closeButton>
            <Modal.Title>Videos</Modal.Title>
          </Modal.Header>

          <Modal.Body>
            <Dropzone ref="dropzone" onDrop={this.onDrop} >
              <div>Try dropping some files here, or click to select files to upload.</div>
            </Dropzone>

            <button type="button" onClick={this.onOpenClick}>
                Open
            </button>

          </Modal.Body>
        </Modal>
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
    currentTopicId: state.topic.current.id
  }
};
export default connect(mapStateToProps)(VideoUpload);
