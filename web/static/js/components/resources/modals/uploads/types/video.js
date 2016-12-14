import React, {PropTypes} from 'react';
import VideoService       from './videoService/index';

const UploadTypeVideo = React.createClass({
  render() {
    const { url, videoService, autoPlay, source } = this.props;

    if(videoService) {
      return (
        <VideoService url={ url.full } autoPlay={autoPlay} source={ source } />
      )
    }
    else {
      return (
        <video controls autoPlay={autoPlay} >
          <source src={ url.full } type='audio/mp4' />
        </video>
      )
    }
  }
});

export default UploadTypeVideo;
