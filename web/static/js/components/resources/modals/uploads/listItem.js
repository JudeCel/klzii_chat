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
    const { sessionResourceId, id, active, name, type, url, scope, source } = this.state;

    let resourceName = name || !resource ? name : resource.name;
    let resourceUrl = url || !resource ? url : resource.url;
    let resourceScope = scope || !resource ? scope : resource.scope;
    let resourceId = id || !resource ? id : resource.id;
    let resourceSource = source || !resource ? source : resource.source;

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
    else if(resourceUrl) {
      return (
        <li className='list-group-item'>
          <div className='row'>
            <div className='col-md-6' onClick={ this.onSelect.bind(this, resourceUrl) }>
              { resourceName }
              <br />
              <UploadTypes modalName={ modalName } url={ resourceUrl } videoService={ resourceScope == 'videoService' } source={ source }/>
            </div>

            <div className='col-md-6 text-right'>
              { this.showRadio(resourceId, modalName, active) }
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
