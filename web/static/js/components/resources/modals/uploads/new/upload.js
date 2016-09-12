import React, {PropTypes} from 'react';
import ReactDOM           from 'react-dom';

const UploadNew = React.createClass({
  getInitialState() {
    return { fileName: '' };
  },
  onNameChange(e) {
    const data = { [e.target.id]: e.target.value };
    this.sendDataToParent(data);
  },
  onFileChange(e) {
    const file = e.target.files[0];
    const data = { files: [file], fileName: file.name };
    this.sendDataToParent(data);
  },
  sendDataToParent(data) {
    this.setState(data, function() {
      const { name, files } = this.state;
      this.props.afterChange({ resourceData: { name, files } });
    });
  },
  openSelect(e) {
    let el = e.currentTarget; 
    this.updateFileUpload(el.getAttribute('id') == "uploadMobileSourceCamera");

    let element = ReactDOM.findDOMNode(this).querySelector('#uploadFile');
    if(element) {
      element.click();
    }
  },
  updateFileUpload(useCamera) {
    let el = document.getElementById("uploadFile");
    if (useCamera) {
      el.setAttribute("capture", "camera");
    }
    else {
      el.removeAttribute("capture");
    }
    document.getElementById("uploadMobileSource").style.display = 'none';
  },
  chooseFile(e) {
    if (window.innerWidth < 768 && (this.props.modalName == "image" || this.props.modalName == "video")) {
      let el = e.currentTarget;
      while ((el = el.parentElement) && !el.classList.contains("mobile-camera"));
      if (el) {
        document.getElementById("uploadMobileSource").style.display = 'block';
        return;
      }
    }
    this.openSelect(e);
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
            <input type='text' className='form-control no-border-radius' id='name' placeholder='Name' onChange={ this.onNameChange } />
          </div>
        </div>

        <div className='form-group'>
          <div className='col-md-2'>
            <label htmlFor='uploadFile'>File</label>
          </div>

          <div className='col-md-10'>
            <div className='input-group'>
              <input type='file' className='hidden' id='uploadFile' onChange={ this.onFileChange } accept={ fileTypes[modalName] } />
              <input type='text' className='form-control no-border-radius' value={ fileName } disabled='true' />
              <span onClick={ this.chooseFile } className='input-group-addon no-border-radius cursor-pointer'>Choose File</span>
              <div id='uploadMobileSource'>
                <div id='uploadMobileSourceCamera' onClick={ this.openSelect }>Take Photo or Video</div>
                <div onClick={ this.openSelect }>Choose Existing</div>
              </div>
            </div>
          </div>
        </div>
      </div>
    )
  }
});

export default UploadNew;
