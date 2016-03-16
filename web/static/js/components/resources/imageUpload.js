import React, {PropTypes}  from 'react';
import Dropzone            from 'react-dropzone';
import { connect }         from 'react-redux';
import Actions             from '../../actions/resource';
import { Modal }           from "react-bootstrap"

const ImageUpload =  React.createClass({
  onDrop: function(files){
    const { dispatch, currentUserId, currentTopicId } = this.props
    dispatch(Actions.upload(files, "image", currentUserId, currentTopicId))
  },
  onOpenClick: function () {
    this.refs.dropzone.open();
  },
  render() {
    const {show, onHide, images, onDelete} = this.props
    return (
      <div>
        <Modal  show={show} onHide={onHide}>
          <Modal.Header closeButton >
            <Modal.Title>Images</Modal.Title>
              <div className="add glyphicon glyphicon-plus" onClick={this.onOpenClick}/>
          </Modal.Header>

          <Modal.Body>
            <Dropzone className="col-md-5" multiple={false} ref="dropzone" onDrop={this.onDrop} >
              <div>Try dropping some files here</div>
            </Dropzone>
            <div >
              { images.map((image) =>
                <div onClick={ onDelete }
                  data-id={ image.id }
                  key={image.id}
                  className="glyphicon glyphicon-remove-circle">

                  <img key={ image.id }
                      className="col-md-7"
                      src={ image.thumb }
                       />
                </div>
              )}
            </div>
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
    modalWindow: state.resources.modalWindow,
    currentTopicId: state.topic.current.id
  }
};
export default connect(mapStateToProps)(ImageUpload);
