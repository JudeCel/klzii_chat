import React, {PropTypes} from 'react';
import NewUpload          from './new/upload';
import NewYoutube         from './new/youtube';

const UploadNew = React.createClass({
  isCurrentActive(id) {
    return this.props.tabActive == id;
  },
  activeClass(id) {
    let className = 'tab-pane';
    return this.isCurrentActive(id) ? className + ' active' : className;
  },
  render() {
    const { resourceType, afterChange } = this.props;

    return (
      <div>
        <div className='tab-content'>
          <div className={ this.activeClass(1) }>1</div>
          <div className={ this.activeClass(2) }>
            <NewYoutube { ...{ afterChange }} />
          </div>
          <div className={ this.activeClass(3) }>
            <NewUpload { ...{ resourceType, afterChange }} />
          </div>
        </div>
      </div>
    )
  }
});

export default UploadNew;
