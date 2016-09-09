import React, {PropTypes} from 'react';
import Youtube            from './youtube';

const UploadTypeVideo = React.createClass({
  render() {
    const { url, youtube, autoPlay } = this.props;

    if(youtube) {
      return (
        <Youtube url={ url.full } autoPlay={autoPlay} />
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
