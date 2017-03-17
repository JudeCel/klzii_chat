import React, {PropTypes} from 'react';
import { connect }        from 'react-redux';

const AccessDenied = React.createClass({
  render() {
    return (
      <div className='download-section'>
        <div className='col-md-12 text-center dialog-text-mod'>
          <h4><b>Sorry</b></h4>
          <p><h4>On the Free Account you don't have access to Chat Room Reports.</h4></p>
        </div>
      </div>
    )
  }
});

export default AccessDenied;
