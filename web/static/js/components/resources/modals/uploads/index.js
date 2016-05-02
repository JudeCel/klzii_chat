import React, {PropTypes} from 'react';
import UploadNew          from './new';
import UploadList         from './list';

const UploadsIndex = React.createClass({
  render() {
    const { resourceType, rendering, tabActive, onDelete, afterChange } = this.props;

    if(rendering == 'new') {
      return (
        <div className='tab-content'>
          <UploadNew { ...{ resourceType, afterChange, tabActive } }/>
        </div>
      )
    }
    else {
      return (<UploadList { ...{ resourceType, onDelete } }/>)
    }
  }
});

export default UploadsIndex;
