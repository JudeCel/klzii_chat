import React, {PropTypes} from 'react';
import UploadTypeVideoServiceVimeo    from './vimeo';
import UploadTypeVideoServiceYoutube  from './youtube';

const UploadTypeIndex = React.createClass({
  render() {
    const { url, autoPlay, source } = this.props;

    if(!url) {
      return (<div>Not found</div>)
    } else if (source == 'youtube') {
      return (<UploadTypeVideoServiceYoutube url={ url } autoPlay={autoPlay} />)
    } else if (source == 'vimeo') {
      return (<UploadTypeVideoServiceVimeo url={ url } autoPlay={autoPlay} />)
    } else {
      return (<div>Not found</div>)
    }
  }
});

export default UploadTypeIndex;
