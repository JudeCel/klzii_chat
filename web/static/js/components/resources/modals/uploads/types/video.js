import React, {PropTypes}  from 'react';

const UploadTypeVideo = React.createClass({
  render() {
    const { url, youtube } = this.props;

    if(youtube) {
      return (
        <iframe type='text/html' src={ "http://www.youtube.com/embed/" + url } frameBorder='0' />
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
