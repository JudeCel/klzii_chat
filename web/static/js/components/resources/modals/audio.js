import React, {PropTypes}  from 'react';
import Dropzone            from 'react-dropzone';
import { connect }         from 'react-redux';
import Actions             from '../../../actions/resource';
import { Modal }           from 'react-bootstrap'

const Audio = React.createClass({
  onDrop: function(files) {
    const { dispatch, currentUserJwt, currentTopicId } = this.props;
    dispatch(Actions.upload(files, 'audio', currentUserJwt, this.state.name));
    this.setState({ name: '' });
  },
  getInitialState: function() {
    return { name: '' };
  },
  onChange: function(e) {
    this.setState({ name: e.target.value });
  },
  render() {
    const { show, onHide, audios, onDelete } = this.props
    return (
      <div>
        <Modal show={ show } onHide={ onHide }>
          <Modal.Header closeButton>
            <Modal.Title>Audios</Modal.Title>
          </Modal.Header>

          <Modal.Body>
            <input type='text' onChange={ this.onChange } className='form-control' placeholder='Name' />

            <div>
              {
                audios.map((audio) =>
                  <div onClick={ onDelete } data-id={ audio.id } key={ audio.id } className='glyphicon glyphicon-remove-circle'>
                    <div key={ audio.name + audio.id }>{ audio.name }</div>

                    <audio key={ audio.id } controls>
                      <source key={ audio.id } className='col-md-7' src={ audio.url } type='audio/mp3' />
                    </audio>
                  </div>
                )
              }
            </div>
          </Modal.Body>

          <Modal.Footer>
            <Dropzone className='col-md-12' multiple={ false } ref='dropzone' onDrop={ this.onDrop }>
              <div>Try dropping some files here</div>
            </Dropzone>
          </Modal.Footer>
        </Modal>
      </div>
    )
  }
});

const mapStateToProps = (state) => {
  return {
    channal: state.topic.channel,
    currentUserJwt: state.members.currentUser.jwt,
    audios: state.resources.audios,
    modalWindow: state.resources.modalWindow,
    currentTopicId: state.topic.current.id
  }
};

export default connect(mapStateToProps)(Audio);
