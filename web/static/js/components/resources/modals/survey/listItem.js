import React, {PropTypes}  from 'react';

const SurveyListItem = React.createClass({
  getValuesFromObject(object) {
    let { id, active, question, title, type } = object;
    return { id, active, question, title, type };
  },
  getInitialState() {
    let survey = this.props.survey || {};
    return this.getValuesFromObject(survey);
  },
  onChange() {
    this.setState({ active: true });
  },
  onDelete() {
    console.log("delete ", this.state);
  },
  onResult() {
    this.props.onView(this.getValuesFromObject(this.state));
  },
  render() {
    const { justInput } = this.props;
    const { id, active, question, title, type } = this.state;

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
              <span onClick={ this.onResult }>{ title }</span>
              <br />
              { question }
            </div>

            <div className='col-md-6 text-right'>
              <input id={ 'question' + id } name='active' type='radio' className='with-font' onChange={ this.onChange } defaultChecked={ active } />
              <label htmlFor={ 'question' + id }></label>
              <span className='fa fa-times' onClick={ this.onDelete }></span>
            </div>
          </div>
        </li>
      )
    }
  }
});

export default SurveyListItem;
