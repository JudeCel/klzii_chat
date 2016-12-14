import React, {PropTypes} from 'react';

const UploadTypeVideoService = React.createClass({
  getInitialState() {
    return { iframe: false };
  },
  loadIframe() {
    this.setState({ iframe: true });
  },
  render() {
    const { url, autoPlay, source } = this.props;

    if (this.state.iframe || autoPlay) {
      if (source == "youtube") {
        return (
          <iframe type='text/html' src={ `${window.location.protocol}//www.youtube.com/embed/` + url +"?autoplay=1" } frameBorder='0' allowFullScreen="1" />
        )
      } else if (source == "vimeo") {
        return (
          <iframe type='text/html' src={ `${window.location.protocol}//player.vimeo.com/video/` + url +"?autoplay=1" } frameBorder='0' allowFullScreen="1" />
        )
      } else {
        return;
      }
    } else {
      if (source == "youtube") {
        return (
          <img className='img-responsive youtube-preview cursor-pointer' src={ `${window.location.protocol}//img.youtube.com/vi/${ url }/hqdefault.jpg` } onClick={ this.loadIframe } />
        )
      } else if (source == "vimeo") {
        return (
          <iframe type='text/html' src={ `${window.location.protocol}//player.vimeo.com/video/` + url } frameBorder='0' />
        )
      } else {
        return;
      }
    }
  }
});

export default UploadTypeVideoService;
