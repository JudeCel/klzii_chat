import React, {PropTypes}  from 'react';
import AnswerYesNoMaybe    from './yesNoMaybe';
import Answer5StarRating   from './5starRating';

const SurveyAnswer = React.createClass({
  render() {
    const { type, afterChange } = this.props;

    if(type == 'yesNoMaybe') {
      return (<AnswerYesNoMaybe afterChange={ afterChange } />)
    }
    else if(type == '5starRating') {
      return (<Answer5StarRating afterChange={ afterChange } />)
    }
    else {
      return (<div>Not found</div>)
    }
  }
});

export default SurveyAnswer;
