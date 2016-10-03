import React, {PropTypes} from 'react';
import { connect }        from 'react-redux';
import SurveyViewAnswers  from './viewAnswers';

const SurveyViewResults = React.createClass({
  render() {
    const { survey } = this.props;

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
    survey: state.miniSurveys.view
  }
};

export default connect(mapStateToProps)(SurveyViewResults);
