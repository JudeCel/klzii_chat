import React, {PropTypes}  from 'react';
import SurveyList          from './list';
import SurveyNew           from './new';

const SurveyIndex = React.createClass({
  render() {
    if(this.props.creating) {
      return (<SurveyNew afterChange={ this.props.afterChange } />)
    }
    else {
      return (<SurveyList />)
    }
  }
});

export default SurveyIndex;
