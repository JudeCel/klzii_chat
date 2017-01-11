import React, {PropTypes} from 'react';
import { connect }        from 'react-redux';

const SurveyViewYesNoMaybe = React.createClass({
  render() {
    const { answers, survey } = this.props;
    const staticAnswers = ['Yes', 'No', 'Unsure'];

    if(answers.length) {
      return (
        <div>
          <div className='text-center'>
            <h3>{ survey.question }</h3>
            <h5>Current Vote Result</h5>
          </div>
          <ul className='list-group'>
            {
              answers.map((answer, index) => {
                return (
                  <li key={ index } className='list-group-item'>
                    <div className='row'>
                      <div className='col-md-3 col-md-offset-3 survey-answer'><b>{ answer.session_member.username }</b></div>
                      <div className='col-md-5 col-md-offset-1 survey-answer'>{ staticAnswers[answer.answer.value - 1] }</div>
                    </div>
                  </li>
                )
              })
            }
          </ul>
        </div>
      )
    }
    else {
      return (<h4 className='text-center'>There are no answers yet</h4>)
    }
  }
});

const mapStateToProps = (state) => {
  return {
    survey: state.miniSurveys.console,
    answers: state.miniSurveys.view.mini_survey_answers
  }
};

export default connect(mapStateToProps)(SurveyViewYesNoMaybe);
