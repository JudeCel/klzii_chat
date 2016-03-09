import React, {PropTypes}  from 'react';
import { connect }         from 'react-redux';
import { Modal }           from "react-bootstrap";
import Constants            from '../../constants';
import ImageUpload         from "./imageUpload";
import VideoUpload         from "./videoUpload";

const Resources =  React.createClass({
  changeModalWindow(e){
    let modal = e.target.getAttribute('data-modal');
    this.props.dispatch({type: Constants.OPEN_RESOURCE_MODAL, modal });
  },
  closeModalWindow(){
    this.props.dispatch({type: Constants.CLOASE_RESOURCE_MODAL });
  },
  render() {
    return (
      <div className="resources col-md-12">
        <div
          onClick={this.changeModalWindow}
          data-modal="image"
          className="resource glyphicon glyphicon-picture">
            <ImageUpload show={this.props.modalWindow =="image"} onHide={this.closeModalWindow} />
        </div>
        <div
          onClick={this.changeModalWindow}
          data-modal="video"
          className="resource glyphicon glyphicon-film">
            <VideoUpload show={this.props.modalWindow == "video"} onHide={this.closeModalWindow} />
        </div>
      </div>
    );
  }
})
export default Resources;

const mapStateToProps = (state) => {
  return {
    modalWindow: state.resources.modalWindow
  }
};
export default connect(mapStateToProps)(Resources);
