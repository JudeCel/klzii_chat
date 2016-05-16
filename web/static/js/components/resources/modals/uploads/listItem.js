import React, {PropTypes} from 'react';
import { connect }        from 'react-redux';
import UploadTypes        from './types/index';
import SesssionResourceActions    from '../../../../actions/session_resource';
import ConsoleActions     from '../../../../actions/console';

const UploadListItem = React.createClass({
  onDelete(id) {
    const { dispatch, channel } = this.props;
    dispatch(SesssionResourceActions.delete(channel, id));
  },
  getValuesFromObject(object) {
    let { id, active, name, type, url, scope } = object;
    return { id, active, name, type, url, scope };
  },
  getInitialState() {
    const { resource, tConsole, modalName } = this.props;

    let res = resource || {};
    res.active = tConsole[modalName + '_id'] == res.id ? true : false;
    return this.getValuesFromObject(res);
  },
  onActivate() {
    this.setState({ active: true });
    const { dispatch, channel, modalName } = this.props;

    if(this.state.id) {
      dispatch(ConsoleActions.addToConsole(channel, this.state.id));
    }
    else {
      dispatch(ConsoleActions.removeFromConsole(channel, this.props.modalName));
    }
  },
  render() {
    const { justInput, modalName } = this.props;
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
              <UploadTypes modalName={ modalName } url={ url } youtube={ scope == 'youtube' }/>
            </div>

            <div className='col-md-6 text-right'>
              <input id={ 'question' + id } name='active' type='radio' className='with-font' onClick={ this.onActivate } defaultChecked={ active } />
              <label htmlFor={ 'question' + id } />
              <span className='fa fa-times' onClick={ this.onDelete.bind(this, id) } />
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
