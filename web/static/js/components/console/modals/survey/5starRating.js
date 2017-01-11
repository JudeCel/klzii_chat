import React, {PropTypes} from 'react';
import { connect }        from 'react-redux';
import Rating             from 'react-rating';

const Answer5StarRating = React.createClass({
  onChange(value) {
    this.props.afterChange(value);
  },
  getPlaceHolder() {
    let survey = this.props.survey.mini_survey_answer;
    return survey ? survey.answer.value : 0;
  },
  render() {
    const { survey } = this.props;

    return (
      <div className='col-md-12'>
        <div className='text-center'>
          <h3>{ survey.question }</h3>
        </div>

        <div className='text-center star-rating-section'>
          <Rating onChange={ this.onChange } placeholder='fa fa-star' empty='fa fa-star-o' full='fa fa-star' placeholderRate={ this.getPlaceHolder() } />
        </div>
      </div>
    )
  }
});

const mapStateToProps = (state) => {
  return {
    survey: state.miniSurveys.console
  }
};

export default connect(mapStateToProps)(Answer5StarRating);
