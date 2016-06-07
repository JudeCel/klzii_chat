import React, {PropTypes}  from 'react';
import { connect }         from 'react-redux';
import MiniSurveyActions   from '../../../../actions/miniSurvey';

const SurveyListItem = React.createClass({
  getValuesFromObject(object) {
    let { id, question, title, type } = object;
    return { id, question, title, type };
  },
  getInitialState() {
    let survey = this.props.survey || {};
    return this.getValuesFromObject(survey);
  },
  onChange() {
    const { dispatch, channel } = this.props;
    dispatch(MiniSurveyActions.addToConsole(channel, this.state.id));
  },
  onDelete() {
    console.log("delete ", this.state);
  },
  onResult() {
    this.props.onView(this.getValuesFromObject(this.state));
  },
  render() {
    const { justInput, topicConsole } = this.props;
    const { id, question, title, type } = this.state;

    if(justInput) {
      return (
        <li className='list-group-item'>
          <div className='row'>
            <div className='col-md-offset-6 col-md-6 text-right'>
              <input id='question00' name='active' type='radio' className='with-font' onChange={ this.onChange } defaultChecked='true' />
              <label htmlFor='question00'>None</label>
            </div>
          </div>
        </li>
      )
    }
    else {
      return (
        <li className='list-group-item'>
          <div className='row'>
            <div className='col-md-6'>
              <strong className='cursor-pointer' onClick={ this.onResult }>{ title }</strong>
              <br />
              { question }
            </div>

            <div className='col-md-6 text-right'>
              <input id={ 'question' + id } name='active' type='radio' className='with-font' onChange={ this.onChange } defaultChecked={ id == topicConsole.mini_survey_id } />
              <label htmlFor={ 'question' + id }></label>
              <span className='fa fa-times' onClick={ this.onDelete }></span>
            </div>
          </div>
        </li>
      )
    }
  }
});

const mapStateToProps = (state) => {
  return {
    topicConsole: state.sessionTopic.console,
    channel: state.sessionTopic.channel
  }
};

export default connect(mapStateToProps)(SurveyListItem);
