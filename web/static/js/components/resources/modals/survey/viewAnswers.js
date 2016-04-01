import React, {PropTypes}    from 'react';
import SurveyViewYesNoMaybe  from './answers/yesNoMaybe';
import SurveyView5StarRating from './answers/5starRating';

const SurveyViewAnswers = React.createClass({
  render() {
    const { type } = this.props;

    if(type == 'yesNoMaybe') {
      return (<SurveyViewYesNoMaybe />)
    }
    else if(type == '5starRating') {
      return (<SurveyView5StarRating />)
    }
    else {
      return (<div>Not found</div>)
    }
  }
});

export default SurveyViewAnswers;
