import React, {PropTypes} from 'react';
import { connect }        from 'react-redux';
import SurveyViewAnswers  from './viewAnswers';

const SurveyViewResults = React.createClass({
  render() {
    const { survey } = this.props;
    const staticAnswers = ['Yes', 'No', 'Maybe'];

    return (
      <div className='col-md-12'>
        <div className='text-center'>
          { survey.question }
        </div>

        <SurveyViewAnswers type={ survey.type } />
      </div>
    )
  }
});

const mapStateToProps = (state) => {
  return {
    survey: state.resources.survey || { id: 1, title: 'Survey', question: 'Do you like?', type: '5starRating', active: true }
  }
};

export default connect(mapStateToProps)(SurveyViewResults);
