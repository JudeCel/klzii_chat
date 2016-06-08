import React, {PropTypes}  from 'react';
import { connect }         from 'react-redux';
import SurveyListItem      from './listItem';

const SurveyList = React.createClass({
  render() {
    const { surveys, onView } = this.props;

    return (
      <ul className='list-group'>
        <SurveyListItem key={ -1 } justInput={ true } />
        {
          surveys.map((survey, index) =>
            <SurveyListItem key={ survey.id } survey={ survey } onView={ onView } />
          )
        }
      </ul>
    )
  }
});

const mapStateToProps = (state) => {
  return {
    surveys: state.miniSurveys.list
  }
};

export default connect(mapStateToProps)(SurveyList);
