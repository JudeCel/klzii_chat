import React, {PropTypes}  from 'react';
import { connect }         from 'react-redux';
import { Modal }           from "react-bootstrap";
import Constants            from '../../constants';
import Actions             from '../../actions/resource';
import ImageUpload         from "./imageUpload";
import VideoUpload         from "./videoUpload";

const Resources =  React.createClass({
  changeModalWindow(e){
    let modal = e.target.getAttribute('data-modal');
    const {dispatch, channal} = this.props
    dispatch({type: Constants.OPEN_RESOURCE_MODAL, modal });
    dispatch(Actions.getResource(channal, modal))
  },
  closeModalWindow(e){
    let modal = e.target.getAttribute('data-modal')
    this.props.dispatch({type: Constants.CLOASE_RESOURCE_MODAL });
    this.props.dispatch({type: Constants.CLEAN_RESOURCE, modal });
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
            <ImageUpload show={modalWindow =="image"} onHide={this.closeModalWindow} />
          </div>
          <div
            onClick={this.changeModalWindow}
            data-modal="video"
            className="resource glyphicon glyphicon-film">
            <VideoUpload show={modalWindow == "video"} onHide={this.closeModalWindow} />
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
