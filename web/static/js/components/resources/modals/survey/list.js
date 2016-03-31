import React, {PropTypes}  from 'react';
import { connect }         from 'react-redux';
import SurveyListItem      from './listItem';

const SurveyList = React.createClass({
  render() {
    const { surveys } = this.props;

    return (
      <ul className='list-group'>
        <SurveyListItem key={ -1 } justInput={ true } />
        {
          surveys.map((survey, index) =>
            <SurveyListItem key={ index } survey={ survey } />
          )
        }
      </ul>
    )
  }
});

const mapStateToProps = (state) => {
  return {
    surveys: state.resources.surveys || [
      { id: 1, title: 'Survey', question: 'Do you like?', type: 'first', active: true },
      { id: 2, title: 'Survey', question: 'Do you like?', type: 'first', active: false }
    ]
  }
};

export default connect(mapStateToProps)(SurveyList);
