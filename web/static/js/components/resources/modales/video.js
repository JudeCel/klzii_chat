import React, {PropTypes}  from 'react';
import Dropzone            from 'react-dropzone';
import { connect }         from 'react-redux';
import Actions             from '../../../actions/resource';
import { Modal }           from "react-bootstrap"

const Video =  React.createClass({
  onDrop: function(files){
    const { dispatch, currentUserId, currentTopicId } = this.props
    dispatch(Actions.upload(files, "video", currentUserId, currentTopicId, this.state.name))
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
    const {show, onHide, videos, onDelete} = this.props
    return (
      <div>
        <Modal  show={show} onHide={onHide}>
          <Modal.Header closeButton >
            <Modal.Title>Videos</Modal.Title>
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
              { videos.map((video) =>
                <div onClick={ onDelete }
                  data-id={ video.id }
                  key={video.id}
                  className="glyphicon glyphicon-remove-circle">

                  <div key={ video.name + video.id }>{ video.name }</div>
                  <video key={ video.id } controls>
                    <source key={ video.id }
                      className="col-md-7"
                      src={ video.url }
                      type="audio/mp4"
                      />
                  </video>
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
    videos: state.resources.videos,
    modalWindow: state.resources.modalWindow,
    currentTopicId: state.topic.current.id
  }
};
export default connect(mapStateToProps)(Video);
