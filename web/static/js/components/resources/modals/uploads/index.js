import React, {PropTypes} from 'react';
import UploadNew          from './new';
import UploadList         from './list';

const UploadsIndex = React.createClass({
  render() {
    const { resourceType, rendering, tabActive, onDelete, afterChange } = this.props;

    if(rendering == 'new') {
      return (<UploadNew { ...{ resourceType, afterChange, tabActive } }/>)
    }
    else {
      return (<UploadList { ...{ resourceType, onDelete } }/>)
    }
  }
});

export default UploadsIndex;
