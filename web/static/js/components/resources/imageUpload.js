import React, {PropTypes}  from 'react';
import Dropzone            from 'react-dropzone';
import { connect }         from 'react-redux';
import Actions             from '../../actions/resource';
import { Modal }           from "react-bootstrap"

const ImageUpload =  React.createClass({
  onDrop: function(files){
    const { dispatch, currentUserId, currentTopicId } = this.props
  },
  onOpenClick: function () {
    this.refs.dropzone.open();
  },
  render() {
    const {show, onHide, images} = this.props
    return (
      <div>
        <Modal  show={show} onHide={onHide}>
          <Modal.Header closeButton>
            <Modal.Title>Images</Modal.Title>
          </Modal.Header>

          <Modal.Body>
            <Dropzone ref="dropzone" onDrop={this.onDrop} >
              <div>Try dropping some files here, or click to select files to upload.</div>
            </Dropzone>

            <button type="button" onClick={this.onOpenClick}>
                Open
            </button>
              { images.map((images) => <img key={video.id} src={ video.URL} /> ) }
          </Modal.Body>
        </Modal>
    </div>
    );
  }
})
const mapStateToProps = (state) => {
  return {
    channal: state.topic.channel,
    currentUserId: state.members.currentUser.id,
    images: state.resources.images,
    currentTopicId: state.topic.current.id
  }
};
export default connect(mapStateToProps)(ImageUpload);
