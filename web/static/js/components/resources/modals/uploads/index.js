import React, {PropTypes} from 'react';
import UploadNew          from './new';
import UploadList         from './list';

const UploadsIndex = React.createClass({
  render() {
    const { resourceType, rendering, onDelete, afterChange } = this.props;

    if(rendering == 'new') {
      return (<UploadNew resourceType={ resourceType } afterChange={ afterChange } />)
    }
    else {
      return (<UploadList resourceType={ resourceType } onDelete={ onDelete } />)
    }
  }
});

export default UploadsIndex;
