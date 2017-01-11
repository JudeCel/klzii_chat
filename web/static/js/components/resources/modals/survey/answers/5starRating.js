import React, {PropTypes} from 'react';
import { connect }        from 'react-redux';
import Rating             from 'react-rating';

const SurveyView5StarRating = React.createClass({
  getAvarageCount() {
    const { answers } = this.props;
    if(answers.length == 1) {
      return answers[0].answer.value;
    }
    else {
      let sum = 0;
      answers.map(function(item){
        sum += item.answer.value;
      });
      return sum / answers.length;
    }
  },
  render() {
    const { answers,survey, modalWindows } = this.props;

    if(answers.length) {
      return (
        <div>
          <div className='text-center'>
            <h3>{ survey.question }</h3>
            <h5>Current Vote Result</h5>
          </div>
          <ul className='list-group'>
            <li key={ -1 } className='list-group-item'>
              <div className='row'>
                <div className='col-md-6 survey-answer'>
                  <b>Average</b>
                </div>
                <div className='col-md-6 star-rating-section text-right'>
                  <Rating placeholder='fa fa-star' empty='fa fa-star-o' full='fa fa-star' initialRate={ this.getAvarageCount() } readonly={ true } />
                </div>
              </div>
            </li>

            {
              answers.map((answer, index) =>
                <li key={ index } className='list-group-item'>
                  <div className='row'>
                    <div className='col-md-6 survey-answer'><b>{ answer.session_member.username }</b></div>
                    <div className='col-md-6 star-rating-section text-right'>
                      <Rating placeholder='fa fa-star' empty='fa fa-star-o' full='fa fa-star' initialRate={ answer.answer.value } readonly={ true } />
                    </div>
                  </div>
                </li>
              )
            }
          </ul>
        </div>
      )
    }
    else if (modalWindows.postData) {
      return false;
    } else {
      return (<h4 className='text-center'>There are no answers yet</h4>)
    }

  }
});

const mapStateToProps = (state) => {
  return {
    survey: state.miniSurveys.console,
    answers: state.miniSurveys.view.mini_survey_answers,
    modalWindows: state.modalWindows
  }
};

export default connect(mapStateToProps)(SurveyView5StarRating);
