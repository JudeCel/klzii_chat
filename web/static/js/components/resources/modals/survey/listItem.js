import React, {PropTypes}  from 'react';

const SurveyListItem = React.createClass({
  getInitialState() {
    let survey = this.props.survey || {};
    const { id, active, question, title, type } = survey;
    return { id, active, question, title, type }
  },
  onChange(e) {
    const { survey } = this.state;
    this.setState({ active: true });
  },
  onDelete(e) {
    const { survey } = this.state;
    console.log("delete ", survey);
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
              { title }
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
