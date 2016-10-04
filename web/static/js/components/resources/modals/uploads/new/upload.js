import React, {PropTypes} from 'react';
import ReactDOM           from 'react-dom';

const UploadNew = React.createClass({
  getInitialState() {
    return { fileName: '', uploadMobileSourceVisibility: false, useCamera: false, name: "" };
  },
  onNameChange(e) {
    const data = { [e.target.id]: e.target.value };
    this.sendDataToParent(data);
  },
  onFileChange(e) {
    const file = e.target.files[0];
    let newName = this.state.name;

    if (!newName) {
      newName = file.name;
    }

    const data = { files: [file], fileName: file.name, name: newName};
    this.sendDataToParent(data);
  },
  sendDataToParent(data) {
    this.setState(data, function() {
      const { name, files } = this.state;
      this.props.afterChange({ resourceData: { name, files } });
    });
  },
  openSelect(useMobileCamera, e) {
      this.setState({
        useCamera: useMobileCamera,
        uploadMobileSourceVisibility: false
      });

    let element = ReactDOM.findDOMNode(this).querySelector('#uploadFile');
    if(element) {
      element.click();
    }
  },
  getFileUploadCapture() {
    const { modalName } = this.props;
    return this.state.useCamera ? { capture: true, accept: modalName + "/*" } : {};
  },
  isMobileCameraAllowed() {
    const { modalName } = this.props;
    return window.innerWidth < 768 && (modalName == "image" || modalName == "video");
  },
  chooseFile(e) {
    const { mobileCamera } = this.props;
    if (mobileCamera && this.isMobileCameraAllowed()) {
      this.setState({uploadMobileSourceVisibility: !this.state.uploadMobileSourceVisibility});
    }
    else {
      this.openSelect(false, e);
    }
  },
  getUploadMobileSourceStyle() {
    return {
      display: (this.state.uploadMobileSourceVisibility ? "block" : "none")
    };
  },
  render() {
    const { modalName } = this.props;
    const { fileName } = this.state;
    const fileTypes = {
      image: '.gif, .jpg, .png',
      video: '.mp4',
      audio: '.mp3',
      file: '.pdf',
    };

    return (
      <div className='col-md-12'>
        <div className='form-group'>
          <div className='col-md-2'>
            <label htmlFor='name'>Name</label>
          </div>

          <div className='col-md-10'>
            <input type='text' className='form-control no-border-radius' id='name' placeholder='Name' onChange={ this.onNameChange } value={ this.state.name } />
          </div>
        </div>

        <div className='form-group'>
          <div className='col-md-2'>
            <label htmlFor='uploadFile'>File</label>
          </div>

          <div className='col-md-10'>
            <div className='input-group'>
              <input type='file' className='hidden' id='uploadFile' onChange={ this.onFileChange } accept={ fileTypes[modalName] } { ...this.getFileUploadCapture() } />
              <input type='text' className='form-control no-border-radius' value={ fileName } disabled='true' />
              <span onClick={ this.chooseFile } className='input-group-addon no-border-radius cursor-pointer'>Choose File</span>
              <div id='uploadMobileSource' style={ this.getUploadMobileSourceStyle() }>
                <div onClick={ this.openSelect.bind(this, true) }>Take Photo or Video</div>
                <div onClick={ this.openSelect.bind(this, false) }>Choose Existing</div>
              </div>
            </div>
          </div>
        </div>
      </div>
    )
  }
});

export default UploadNew;
