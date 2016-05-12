import React, {PropTypes} from 'react';
import { connect }        from 'react-redux';
import UploadTypes        from './types/index';
import Actions            from '../../../../actions/console';

const UploadListItem = React.createClass({
  getValuesFromObject(object) {
    let { id, active, name, type, url, scope } = object;
    return { id, active, name, type, url, scope };
  },
  getInitialState() {
    const { resource, tConsole, resourceType } = this.props;

    let res = resource || {};
    res.active = tConsole[resourceType + '_id'] == res.id ? true : false;
    return this.getValuesFromObject(res);
  },
  onActivate() {
    this.setState({ active: true });
    const { dispatch, channel, resourceType } = this.props;

    if(this.state.id) {
      dispatch(Actions.addToConsole(channel, this.state.id));
    }
    else {
      dispatch(Actions.removeFromConsole(channel, this.props.resourceType));
    }
  },
  render() {
    const { justInput, onDelete, resourceType } = this.props;
    const { id, active, name, type, url, scope } = this.state;

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
              <UploadTypes resourceType={ resourceType } url={ url } youtube={ scope == 'youtube' } id={id}/>
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

const mapStateToProps = (state) => {
  return {
    channel: state.topic.channel,
    tConsole: state.topic.console
  }
};

export default connect(mapStateToProps)(UploadListItem);
