import React, {PropTypes}                     from 'react';

const Console = React.createClass({
  render() {
    return (
      <div className='console-section'>
        <ul className='icons'>
          <li>
            <i className='icon-video-1' />
          </li>
          <li>
            <i className='icon-volume-up' />
          </li>
          <li>
            <i className='icon-camera' />
          </li>
          <li>
            <i className='icon-ok-squared' />
          </li>
          <li>
            <i className='icon-pdf' />
          </li>
        </ul>
      </div>
    )
  }
});

export default Console;
