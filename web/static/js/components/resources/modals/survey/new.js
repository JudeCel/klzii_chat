import React, {PropTypes}  from 'react';

const SurveyNew = React.createClass({
  getInitialState() {
    return { type: 'yesNoMaybe' };
  },
  onChange(e) {
    const data = { [e.target.id]: e.target.value };

    this.setState(data, function() {
      const { title, question, type } = this.state;
      this.props.afterChange({ survey: { title, question, type } });
    });
  },
  render() {
    const { title, question, type } = this.state;

    return (
      <div className='col-md-12'>
        <div className='form-group'>
          <label htmlFor='title'>Title</label>
          <input type='text' className='form-control no-border-radius' id='title' placeholder='Title' onChange={ this.onChange } />
        </div>
        <div className='form-group'>
          <label htmlFor='question'>Question</label>
          <input type='text' className='form-control no-border-radius' id='question' placeholder='Question' onChange={ this.onChange } />
        </div>
        <div className='form-group'>
          <label htmlFor='type'>Type</label>
          <select id='type' className='form-control no-border-radius' onChange={ this.onChange }>
            <option value='yesNoMaybe'>Yes/No/Unsure</option>
            <option value='5starRating'>5 Star rating</option>
          </select>
        </div>
      </div>
    )
  }
});

export default SurveyNew;
