import React, {PropTypes}  from 'react';
import Dropzone            from 'react-dropzone';
import { connect }         from 'react-redux';
import Actions             from '../../../actions/resource';
import { Modal }           from 'react-bootstrap'

const Image = React.createClass({
  onDrop: function(files) {
    const { dispatch, currentUserJwt, currentTopicId } = this.props;
    dispatch(Actions.upload(files, 'image', currentUserJwt, this.state.name))
    this.setState({ name: '' });
  },
  getInitialState: function() {
    return { name: '' };
  },
  onChange: function(e) {
    this.setState({ name: e.target.value });
  },
  render() {
    const { show, onHide, images, onDelete, onEnter } = this.props
    return (
      <div>
        <Modal dialogClassName='modal-section' show={ show } onHide={ onHide } onEnter={ onEnter }>
          <Modal.Header closeButton>
            <Modal.Title>Images</Modal.Title>
          </Modal.Header>

          <Modal.Body>
            <input type='text' onChange={ this.onChange } className='form-control' placeholder='Name' />

            <div>
              {
                images.map((image) =>
                  <div onClick={ onDelete } data-id={ image.id } key={ image.id } className='glyphicon glyphicon-remove-circle'>
                    <div key={ image.name + image.id }>{ image.name }</div>
                    <img key={ image.id } className='col-md-7' src={ image.url } />
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
    images: state.resources.images,
    modalWindow: state.resources.modalWindow,
    currentTopicId: state.topic.current.id
  }
};

export default connect(mapStateToProps)(Image);
