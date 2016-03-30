import React, {PropTypes}  from 'react';
import SurveyList          from './list';
import SurveyManage        from './manage';

const SurveyIndex = React.createClass({
  render() {
    if(this.props.manage) {
      const { survey } = this.props;
      return (<SurveyManage survey={ survey } />)
    }
    else {
      const { onDelete, onEdit, surveys } = this.props;
      return (<SurveyList surveys={ surveys } onDelete={ onDelete } onEdit={ onEdit } />)
    }
  }
});

export default SurveyIndex;
