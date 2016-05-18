import React, {PropTypes} from 'react';
import NewUpload          from './new/upload';
import NewYoutube         from './new/youtube';
import NewGallery         from './new/gallery';

const UploadNew = React.createClass({
  currentActives() {
    let tab = this.props.tabActive;
    return {
      1: tab == 1,
      2: tab == 2,
      3: tab == 3
    };
  },
  activeClass(id) {
    let className = 'tab-pane';
    return this.currentActives()[id] ? className + ' active' : className;
  },
  render() {
    const { modalName, afterChange } = this.props;
    let tabs = this.currentActives();

    if(tabs[1]) {
      return (
        <div className={ this.activeClass(1) }>
          <NewGallery { ...{ modalName, afterChange, active: tabs[1] }} />
        </div>
      )
    }
    else if(tabs[2]) {
      return (
        <div className={ this.activeClass(2) }>
          <NewYoutube { ...{ afterChange }} />
        </div>
      )
    }
    else if(tabs[3]) {
      return (
        <div className={ this.activeClass(3) }>
          <NewUpload { ...{ modalName, afterChange }} />
        </div>
      )
    }
    else {
      return (false)
    }
  }
});

export default UploadNew;
