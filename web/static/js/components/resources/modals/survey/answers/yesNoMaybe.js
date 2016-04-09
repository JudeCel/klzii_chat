import React, {PropTypes} from 'react';
import { connect }        from 'react-redux';

const SurveyViewYesNoMaybe = React.createClass({
  render() {
    const { answers } = this.props;
    const staticAnswers = ['Yes', 'No', 'Maybe'];
    return (
      <ul className='list-group'>
        {
          answers.map((answer, index) => {
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
    answers: /*state.resources.survey.answers || */ [
      { id: 1, sessionMemberId: 1, value: 1, sessionMember: { username: 'Random 1' } },
      { id: 2, sessionMemberId: 2, value: 2, sessionMember: { username: 'Random 2' } }
    ]
  }
};

export default connect(mapStateToProps)(SurveyViewYesNoMaybe);
