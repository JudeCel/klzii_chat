import React, {PropTypes}      from 'react';
import { connect }             from 'react-redux';
import UploadTypes             from './types/index';
import SesssionResourceActions from '../../../../actions/session_resource';
import ConsoleActions          from '../../../../actions/console';

const UploadListItem = React.createClass({
  onDelete(id) {
    const { dispatch, jwt } = this.props;
    dispatch(SesssionResourceActions.delete(jwt, id));
  },
  getInitialState() {
    const { sessionResourceId, resource, sessionTopicConsole, modalName } = this.props;
    let res = resource || {};
    res.active = sessionTopicConsole.data[modalName + '_id'] == res.id ? true : false;
    res.sessionResourceId = sessionResourceId;
    return res
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
  onSelect(url) {
    const { modalData } = this.props;

    if(modalData.select) {
      modalData.select(url);
    }
  },
  showRadio(id, modal, active) {
    if(modal != 'image') {
      return (
        <span>
          <input id={ 'question' + id } name='active' type='radio' className='with-font' onClick={ this.onActivate } defaultChecked={ active } />
          <label htmlFor={ 'question' + id } />
        </span>
      )
    }
  },
  render() {
    const { justInput, modalName, resource } = this.props;
    const { sessionResourceId, active, type } = this.state;

    if(justInput && modalName != 'image') {
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
    else if(resource) {
      return (
        <li className='list-group-item'>
          <div className='row'>
            <div className='col-md-6' onClick={ this.onSelect.bind(this, resource.url) }>
              { resource.name }
              <br />
              <UploadTypes modalName={ modalName } url={ resource.url } youtube={ resource.scope == 'youtube' }/>
            </div>

            <div className='col-md-6 text-right'>
              { this.showRadio(resource.id, modalName, active) }
              <span className='fa fa-times' onClick={ this.onDelete.bind(this, sessionResourceId) } />
            </div>
          </div>
        </li>
      )
    }
    else {
      return (false)
    }
  }
});

const mapStateToProps = (state) => {
  return {
    channel: state.sessionTopic.channel,
    sessionTopicConsole: state.sessionTopicConsole,
    jwt: state.members.currentUser.jwt,
    modalData: state.modalWindows.currentModalData
  }
};

export default connect(mapStateToProps)(UploadListItem);
