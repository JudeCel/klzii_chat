import React, {PropTypes} from 'react';
import { connect }        from 'react-redux';

const SurveyViewYesNoMaybe = React.createClass({
  render() {
    const { survey } = this.props;
    const staticAnswers = ['Yes', 'No', 'Maybe'];

    return (
      <ul className='list-group'>
        {
          survey.answers.map((answer, index) => {
            return (
              <li key={ index } className='list-group-item'>
                <div className='row'>
                  <div className='col-md-3'>{ answer.sessionMember.username }</div>
                  <div className='col-md-9'>{ staticAnswers[answer.value - 1] }</div>
                </div>
              </li>
            )
          })
        }
      </ul>
    )
  }
});

const mapStateToProps = (state) => {
  return {
    survey: state.miniSurveys.view
  }
};

export default connect(mapStateToProps)(SurveyViewYesNoMaybe);
