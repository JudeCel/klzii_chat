import React, {PropTypes}  from 'react';
import { connect }         from 'react-redux';
import { Modal }           from "react-bootstrap"
import VideoUpload         from "./videoUpload"


const Resources =  React.createClass({
  getInitialState() {
    return {
      openModalVideo: false
    };
  },
  openModalVideo(){
    this.setState({ openModalVideo: true });

  },
  closeModalVIdeo(){
     this.setState({ openModalVideo: false });
  },
  render() {
    return (
      <div className="col-md-12">
        <div
          onClick={this.openModalVideo}
          className="glyphicon glyphicon-facetime-video">
            <VideoUpload show={this.state.openModalVideo} onHide={this.closeModalVIdeo} />
        </div>
      </div>
    );
  }
})
export default Resources;
