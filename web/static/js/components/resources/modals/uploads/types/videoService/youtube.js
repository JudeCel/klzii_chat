import React, {PropTypes} from 'react';

const UploadTypeVideoServiceYoutube = React.createClass({
  getInitialState() {
    return { iframe: false };
  },
  loadIframe() {
    this.setState({ iframe: true });
  },
  render() {
    const { url, autoPlay } = this.props;

    if (this.state.iframe || autoPlay) {
      return (<iframe type='text/html' src={ `${window.location.protocol}//www.youtube.com/embed/` + url +"?autoplay=1" } frameBorder='0' allowFullScreen="1" />)
    } else {
      return (<img className='img-responsive youtube-preview cursor-pointer' src={ `${window.location.protocol}//img.youtube.com/vi/${ url }/hqdefault.jpg` } onClick={ this.loadIframe } />)
    }
  }
});

export default UploadTypeVideoServiceYoutube;
