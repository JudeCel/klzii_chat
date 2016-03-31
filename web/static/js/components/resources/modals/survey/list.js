import React, {PropTypes}  from 'react';
import { connect }         from 'react-redux';

const SurveyList = React.createClass({
  findSurvey(e) {
    const { surveys } = this.props;
    return surveys[e.target.dataset.survey];
  },
  correctClass(survey) {
    return survey.active ? 'fa fa-check-square' : 'fa fa-square-o';
  },
  onActivate(e) {
    let survey = this.findSurvey(e);
    survey.active = !survey.active;
    this.forceUpdate();
  },
  onDelete(e) {
    let survey = this.findSurvey(e);
    console.log("delete ", survey);
  },
  render() {
    const { surveys } = this.props;

    return (
      <ul className='list-group'>
        {
          surveys.map((survey, index) =>
            <li key={ index } className='list-group-item'>
              <div className='row'>
                <div className='col-md-6'>
                  { survey.title }<br />
                  { survey.question }
                </div>

                <div className='col-md-6 text-right'>
                  <span className={ this.correctClass(survey) } onClick={ this.onActivate } data-survey={ index }></span>
                  <span className='fa fa-times' onClick={ this.onDelete } data-survey={ index }></span>
                </div>
              </div>
            </li>
          )
        }
      </ul>
    )
  }
});

const mapStateToProps = (state) => {
  return {
    surveys: state.resources.surveys || [
      { title: 'Survey', question: 'Do you like?', type: 'first', active: true },
      { title: 'Survey', question: 'Do you like?', type: 'first', active: false }
    ]
  }
};

export default connect(mapStateToProps)(SurveyList);
