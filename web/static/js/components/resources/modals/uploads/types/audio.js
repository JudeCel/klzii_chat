import React, {PropTypes}  from 'react';

const UploadTypeAudio = React.createClass({
  render() {
    const { url } = this.props;
    return (
      <audio controls>
        <source src={ url.full } type='audio/mp3' />
      </audio>
    )
  }
});

export default UploadTypeAudio;
