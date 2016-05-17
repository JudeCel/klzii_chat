import React, {PropTypes} from 'react';

const UploadTypeYoutube = React.createClass({
  getInitialState() {
    return { iframe: false };
  },
  loadIframe() {
    this.setState({ iframe: true });
  },
  render() {
    const { url } = this.props;

    if(this.state.iframe) {
      return (
        <iframe type='text/html' src={ 'http://www.youtube.com/embed/' + url } frameBorder='0' />
      )
    }
    else {
      return (
        <img className='cursor-pointer' src={ `http://img.youtube.com/vi/${ url }/hqdefault.jpg` } onClick={ this.loadIframe } />
      )
    }
  }
});

export default UploadTypeYoutube;
