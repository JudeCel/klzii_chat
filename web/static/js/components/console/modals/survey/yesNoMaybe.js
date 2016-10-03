import React, {PropTypes} from 'react';
import { connect }        from 'react-redux';

const AnswerYesNoMaybe = React.createClass({
  onChange(value) {
    this.props.afterChange(value);
  },
  shouldBeChecked(value) {
    let survey = this.props.survey.mini_survey_answer;
    return survey ? survey.answer.value == value : false;
  },
  render() {
    const { survey } = this.props;
    const answers = ['Yes', 'No', 'Unsure'];

    return (
      <div className='col-md-12'>
        <div className='text-center'>
          { survey.question }
        </div>

        <ul className='list-group'>
          {
            answers.map((answer, index) =>
              <li key={ index + 1 } className='list-group-item'>
                <input id={ 'yesNoMaybe' + index + 1 } name='answer' type='radio' className='with-font'
                  defaultChecked={ this.shouldBeChecked(index + 1) }
                  onChange={ this.onChange.bind(this, index + 1) }
                />
                <label htmlFor={ 'yesNoMaybe' + index + 1 }>{ answer }</label>
              </li>
            )
          }
        </ul>
      </div>
    )
  }
});

const mapStateToProps = (state) => {
  return {
    survey: state.miniSurveys.console
  }
};

export default connect(mapStateToProps)(AnswerYesNoMaybe);
