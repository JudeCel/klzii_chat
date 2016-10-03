import React, {PropTypes} from 'react';
import { connect }        from 'react-redux';

const SurveyViewYesNoMaybe = React.createClass({
  render() {
    const { answers } = this.props;
    const staticAnswers = ['Yes', 'No', 'Unsure'];

    if(answers.length) {
      return (
        <ul className='list-group'>
          {
            answers.map((answer, index) => {
              return (
                <li key={ index } className='list-group-item'>
                  <div className='row'>
                    <div className='col-md-6'>{ answer.session_member.username }</div>
                    <div className='col-md-6 text-right'>{ staticAnswers[answer.answer.value - 1] }</div>
                  </div>
                </li>
              )
            })
          }
        </ul>
      )
    }
    else {
      return (<h4 className='text-center'>There are no answers yet</h4>)
    }
  }
});

const mapStateToProps = (state) => {
  return {
    answers: state.miniSurveys.view.mini_survey_answers
  }
};

export default connect(mapStateToProps)(SurveyViewYesNoMaybe);
