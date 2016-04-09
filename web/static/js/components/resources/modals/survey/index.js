import React, {PropTypes}  from 'react';
import SurveyList          from './list';
import SurveyView          from './view';
import SurveyNew           from './new';

const SurveyIndex = React.createClass({
  render() {
    const { rendering, afterChange, onView } = this.props;

    if(rendering == 'new') {
      return (<SurveyNew afterChange={ afterChange } />)
    }
    else if(rendering == 'view') {
      return (<SurveyView />)
    }
    else {
      return (<SurveyList onView={ onView } />)
    }
  }
});

export default SurveyIndex;
