import React, {PropTypes} from 'react';
import ReactDOM           from 'react-dom';

const UploadNew = React.createClass({
  getInitialState() {
    return {};
  },
  onDataChange(e) {
    const data = { [e.target.id]: e.target.value };
    this.sendDataToParent(data);
  },
  sendDataToParent(data) {
    this.setState(data, function() {
      const { name, url } = this.state;
      this.props.afterChange({ resourceData: { name, url } });
    });
  },
  render() {
    return (
      <div className='col-md-12'>
        <div className='form-group'>
          <div className='col-md-2'>
            <label htmlFor='name'>Name</label>
          </div>

          <div className='col-md-10'>
            <input type='text' className='form-control no-border-radius' id='name' placeholder='Name' onChange={ this.onDataChange } />
          </div>
        </div>

        <div className='form-group'>
          <div className='col-md-2'>
            <label htmlFor='uploadFile'>URL</label>
          </div>

          <div className='col-md-10'>
            <input type='text' className='form-control no-border-radius' id='url' placeholder='Youtube or Vimeo URL' onChange={ this.onDataChange } />
          </div>
        </div>
      </div>
    )
  }
});

export default UploadNew;
