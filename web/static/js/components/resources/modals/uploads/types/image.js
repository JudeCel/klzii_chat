import React, {PropTypes}  from 'react';

const UploadTypeImage = React.createClass({
  render() {
    const { url } = this.props;

    return (
      <img src={ url.thumb } />
    )
  }
});

export default UploadTypeImage;
