import React, {PropTypes} from 'react';

const UploadTypeVideoServiceVimeo = React.createClass({
  render() {
    const { url, autoPlay } = this.props;

    return autoPlay ? 
      (<iframe type='text/html' src={ `${window.location.protocol}//player.vimeo.com/video/` + url +"?autoplay=1" } frameBorder='0' allowFullScreen="1" />) :
      (<iframe type='text/html' src={ `${window.location.protocol}//player.vimeo.com/video/` + url } frameBorder='0' />)
  }
});

export default UploadTypeVideoServiceVimeo;
