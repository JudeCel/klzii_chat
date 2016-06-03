import React, {PropTypes} from 'react';
import SelectReport       from './selectReport';

const ReportsView = React.createClass({
  render() {
    const { rendering } = this.props;

    if(rendering == 'index') {
      return (
        <SelectReport />
      )
    }
    else {
      return (
        <ShowFile />
      )
    }
  }
});

export default ReportsView;
