import React, {PropTypes} from 'react';
import UploadNew          from './new';
import UploadList         from './list';

const UploadsIndex = React.createClass({
  render() {
    const { modalName, rendering, tabActive, afterChange } = this.props;

    if(rendering == 'new') {
      return (
        <div className='tab-content'>
          <UploadNew { ...{ modalName, afterChange, tabActive } }/>
        </div>
      )
    }
    else {
      return (<UploadList { ...{ modalName } }/>)
    }
  }
});

export default UploadsIndex;
