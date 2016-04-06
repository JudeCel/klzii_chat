import React, {PropTypes}  from 'react';

const UploadTypeVideo = React.createClass({
  render() {
    const { url, youtube } = this.props;

    if(youtube) {

    }
    else {
      return (
        <video controls>
          <source src={ url } type='audio/mp4' />
        </video>
      )
    }
  }
});

export default UploadTypeVideo;
