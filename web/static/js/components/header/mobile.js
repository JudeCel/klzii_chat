import React, {PropTypes} from 'react';
import { connect }        from 'react-redux';

const MobileHeader = React.createClass({
  whiteboardIconClick() {
      if (document.getElementsByClassName("whiteboard-expand")[0])
          document.getElementsByClassName("whiteboard-expand")[0].click()
      else if (document.getElementsByClassName("pinboard-expand")[0])
          document.getElementsByClassName("pinboard-expand")[0].click();
  },
  render() {

    return (
      <div className='header-innerbox header-innerbox-mobile'>
        <div className='navbar-header'>
          <button type='button' className='navbar-toggle'>
            <span className='icon-bar'></span>
            <span className='icon-bar'></span>
            <span className='icon-bar'></span>
          </button>
          <span className='navbar-brand'><img src='/images/klzii_logo.png'/></span>
          <span className='navbar-whiteboard' onClick={this.whiteboardIconClick}><img src='/images/whiteboard-icon.png'/></span>
        </div>
      </div>
    )
  }
});

export default connect()(MobileHeader);
