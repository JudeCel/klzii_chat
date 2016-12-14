import React, {PropTypes} from 'react';
import UploadTypeImage    from './image';
import UploadTypeVideo    from './video';
import UploadTypeAudio    from './audio';
import UploadTypePdf      from './pdf';

const UploadTypeIndex = React.createClass({
  render() {
    const { modalName, url, videoService, autoPlay, source } = this.props;

    if(!url) {
      return (<div>Not found</div>)
    }

    if(modalName == 'image') {
      return (<UploadTypeImage url={ url } />)
    }
    else if(modalName == 'video') {
      return (<UploadTypeVideo url={ url } videoService={ videoService } autoPlay={autoPlay} source={ source }/>)
    }
    else if(modalName == 'audio') {
      return (<UploadTypeAudio url={ url } />)
    }
    else if(modalName == 'file') {
      return (<UploadTypePdf url={ url } />)
    }
    else {
      return (<div>Not found</div>)
    }
  }
});

export default UploadTypeIndex;
