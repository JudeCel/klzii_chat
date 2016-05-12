import React, {PropTypes} from 'react';
import UploadTypes        from './types/index';

const UploadListItem = React.createClass({
  getValuesFromObject(object) {
    let { id, active, name, type, url, youtube } = object;
    return { id, active, name, type, url, youtube };
  },
  getInitialState() {
    let resource = this.props.resource || {};
    return this.getValuesFromObject(resource);
  },
  onActivate() {
    this.setState({ active: true });
  },
  render() {
    const { justInput, onDelete, resourceType } = this.props;
    const { id, active, name, type, url, youtube } = this.state;

    if(justInput) {
      return (
        <li className='list-group-item'>
          <div className='row'>
            <div className='col-md-offset-6 col-md-6 text-right'>
              <input id='question00' name='active' type='radio' className='with-font' onClick={ this.onActivate } defaultChecked='true' />
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
              { name }
              <br />
              <UploadTypes resourceType={ resourceType } url={ url } youtube={ youtube } />
            </div>

            <div className='col-md-6 text-right'>
              <input id={ 'question' + id } name='active' type='radio' className='with-font' onClick={ this.onActivate } defaultChecked={ active } />
              <label htmlFor={ 'question' + id }></label>
              <span className='fa fa-times' onClick={ onDelete } data-id={ id }></span>
            </div>
          </div>
        </li>
      )
    }
  }
});

export default UploadListItem;