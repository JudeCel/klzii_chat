import React, {PropTypes}  from 'react';
import Dropzone            from 'react-dropzone';
import { connect }         from 'react-redux';
import Actions             from '../../../actions/resource';
import { Modal }           from "react-bootstrap"

const Image =  React.createClass({
  onDrop: function(files){
    const { dispatch, currentUserId, currentTopicId } = this.props
    dispatch(Actions.upload(files, "image", currentUserId, currentTopicId, this.state.name))
    this.setState({name: ""});
  },
  onOpenClick: function () {
    this.refs.dropzone.open();
  },
  getInitialState: function() {
    return {name: ""};
  },
  onChange: function(e) {
    this.setState({name: e.target.value});
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
            <input
              type="text"
              onChange={ this.onChange }
              className="form-control"
              placeholder="Name"
              />
            <Dropzone className="col-md-5" multiple={false} ref="dropzone" onDrop={this.onDrop} >
              <div>Try dropping some files here</div>
            </Dropzone>
            <div >
              { images.map((image) =>
                <div onClick={ onDelete }
                  data-id={ image.id }
                  key={image.id}
                  className="glyphicon glyphicon-remove-circle">

                  <div key={ image.name + image.id }>{ image.name }</div>
                  <img key={ image.id }
                    className="col-md-7"
                    src={ image.url }
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
export default connect(mapStateToProps)(Image);
