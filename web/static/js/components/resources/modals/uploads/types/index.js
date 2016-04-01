import React, {PropTypes} from 'react';
import UploadTypeImage    from './image';
import UploadTypeVideo    from './video';
import UploadTypeAudio    from './audio';

const UploadTypeIndex = React.createClass({
  render() {
    const { resourceType, url, youtube } = this.props;

    if(resourceType == 'image') {
      return (<UploadTypeImage url={ url } />)
    }
    else if(resourceType == 'video') {
      return (<UploadTypeVideo url={ url } youtube={ youtube } />)
    }
    else if(resourceType == 'audio') {
      return (<UploadTypeAudio url={ url } />)
    }
    else {
      return (<div>Not found</div>)
    }
  }
});

export default UploadTypeIndex;
