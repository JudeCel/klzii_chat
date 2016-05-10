import React, {PropTypes} from 'react';
import Youtube            from './youtube';

const UploadTypeVideo = React.createClass({
  render() {
    const { url, youtube } = this.props;

    if(youtube) {
      return (
        <Youtube url={ url.full } />
      )
    }
    else {
      return (
        <video controls>
          <source src={ url.full } type='audio/mp4' />
        </video>
      )
    }
  }
});

export default UploadTypeVideo;
