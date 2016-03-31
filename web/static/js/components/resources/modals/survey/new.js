import React, {PropTypes}  from 'react';

const SurveyManage = React.createClass({
  onSave(e) {
    const { title, question, type } = this.state;
    console.log({ title, question, type });
  },
  onChange(e) {
    const data = { [e.target.id]: e.target.value };
    this.setState(data);
  },
  getInitialState() {
    return { survey: {} };
  },
  render() {
    const { survey } = this.state;

    return (
      <div className='col-md-12'>
        <div className='form-group'>
          <label htmlFor='title'>Title</label>
          <input type='text' className='form-control' defaultValue={ survey.title } id='title' placeholder='Title' onChange={ this.onChange } />
        </div>
        <div className='form-group'>
          <label htmlFor='question'>Question</label>
          <input type='text' className='form-control' defaultValue={ survey.question } id='question' placeholder='Question' onChange={ this.onChange } />
        </div>
        <span className='pull-right fa fa-check' onClick={ this.onSave }></span>
      </div>
    )
  }
});

export default SurveyManage;
