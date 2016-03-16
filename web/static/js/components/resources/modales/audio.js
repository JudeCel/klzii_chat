import React, {PropTypes}  from 'react';
import Dropzone            from 'react-dropzone';
import { connect }         from 'react-redux';
import Actions             from '../../../actions/resource';
import { Modal }           from "react-bootstrap"

const Audio =  React.createClass({
  onDrop: function(files){
    const { dispatch, currentUserId, currentTopicId } = this.props
    dispatch(Actions.upload(files, "audio", currentUserId, currentTopicId))
  },
  onOpenClick: function () {
    this.refs.dropzone.open();
  },
  render() {
    const {show, onHide, audios, onDelete} = this.props
    return (
      <div>
        <Modal  show={show} onHide={onHide}>
          <Modal.Header closeButton >
            <Modal.Title>Audios</Modal.Title>
              <div className="add glyphicon glyphicon-plus" onClick={this.onOpenClick}/>
          </Modal.Header>

          <Modal.Body>
            <Dropzone className="col-md-5" multiple={false} ref="dropzone" onDrop={this.onDrop} >
              <div>Try dropping some files here</div>
            </Dropzone>
            <div >
              { audios.map((audio) =>
                <div onClick={ onDelete }
                  data-id={ audio.id }
                  key={audio.id}
                  className="glyphicon glyphicon-remove-circle">
                  <audio key={ audio.id } controls>
                    <source key={ audio.id }
                      className="col-md-7"
                      src={ audio.url }
                      type="audio/mp3"
                      />
                  </audio>
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
    audios: state.resources.audios,
    modalWindow: state.resources.modalWindow,
    currentTopicId: state.topic.current.id
  }
};
export default connect(mapStateToProps)(Audio);
