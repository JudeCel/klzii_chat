import React, {PropTypes}  from 'react';

const SurveyList = React.createClass({
  findSurvey(e) {
    const { surveys } = this.props;
    return surveys[e.target.dataset.survey];
  },
  onActivate(e) {
    let survey = this.findSurvey(e);
    survey.active = !survey.active;
    this.forceUpdate();
  },
  editSurvey(e) {
    const { onEdit } = this.props;
    let survey = this.findSurvey(e);
    onEdit(survey);
  },
  correctClass(survey) {
    return survey.active ? 'fa fa-check-square' : 'fa fa-square-o';
  },
  render() {
    const { onDelete, surveys } = this.props;

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
                  <span className='fa fa-times' onClick={ onDelete } data-survey={ index }></span>
                  <span className='fa fa-wrench' onClick={ this.editSurvey } data-survey={ index }></span>
                </div>
              </div>
            </li>
          )
        }
      </ul>
    )
  }
});

export default SurveyList;
