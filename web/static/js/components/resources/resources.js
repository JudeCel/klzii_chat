import React, {PropTypes}                     from 'react';
import { connect }                            from 'react-redux';
import { Modal }                              from "react-bootstrap";
import Constants                              from '../../constants';
import Actions                                from '../../actions/resource';
import  Modales                               from "./modales";

const { ImageModal, AudioModal, VideoModal } = Modales;

const Resources =  React.createClass({
  changeModalWindow(e){
    let modal = e.target.getAttribute('data-modal');
    const {dispatch, channal} = this.props
    dispatch({type: Constants.OPEN_RESOURCE_MODAL, modal });
    dispatch(Actions.get(channal, modal))
  },
  closeModalWindow(e){
    let modal = e.target.getAttribute('data-modal')
    this.props.dispatch({type: Constants.CLOASE_RESOURCE_MODAL });
    this.props.dispatch({type: Constants.CLEAN_RESOURCE, modal });
  },
  onDelete(e){
    const {dispatch, channal} = this.props
    let id = e.target.getAttribute('data-id');
    dispatch(Actions.delete(channal, id))
  },
  render() {
    const {permissions, modalWindow } = this.props
    if (permissions && permissions.resources.can_upload) {
      return (
        <div className="resources col-md-12">
          <div
            onClick={this.changeModalWindow}
            data-modal="image"
            className="resource glyphicon glyphicon-picture">
            <ImageModal
              show={modalWindow =="image"}
              onHide={this.closeModalWindow}
              onDelete={this.onDelete} />
          </div>
          <div
            onClick={this.changeModalWindow}
            data-modal="video"
            className="resource glyphicon glyphicon-film">
            <VideoModal
              show={modalWindow == "video"}
              onHide={this.closeModalWindow}
              onDelete={this.onDelete} />
          </div>
          <div
            onClick={this.changeModalWindow}
            data-modal="audio"
            className="resource glyphicon glyphicon-volume-up">
            <AudioModal
              show={modalWindow == "audio"}
              onHide={this.closeModalWindow}
              onDelete={this.onDelete} />
          </div>
        </div>
      );
    }else{
      return(false)
    }
  }
})
export default Resources;

const mapStateToProps = (state) => {
  return {
    modalWindow: state.resources.modalWindow,
    channal: state.topic.channel,
    permissions:  state.members.currentUser.permissions
  }
};
export default connect(mapStateToProps)(Resources);
