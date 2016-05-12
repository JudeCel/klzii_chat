import React, {PropTypes} from 'react';
import { connect }        from 'react-redux';
import Constants          from '../../constants';
import Modals             from './modals';
import onEnterModalMixin  from '../../mixins/onEnterModal';

const { SurveyModal, UploadsModal } = Modals;

const Console = React.createClass({
  mixins: [onEnterModalMixin],
  getInitialState() {
    return { currentModal: null };
  },
  compareState(modals) {
    return modals.includes(this.state.currentModal);
  },
  closeModal(e) {
    const { dispatch } = this.props;
    dispatch({ type: Constants.CLOSE_CONSOLE_MODAL, modal: this.state.currentModal });
    this.setState({ currentModal: null });
  },
  openModal(e) {
    const { dispatch, channel } = this.props;

    let modal = e.currentTarget.getAttribute('data-modal');
    dispatch({ type: Constants.OPEN_CONSOLE_MODAL, modal });
    this.setState({ currentModal: modal });
    // dispatch(Actions.get(channel, modal));
  },
  hasConsole(type) {
    let { tConsole } = this.props;
    return tConsole[type + '_id'];
  },
  consoleButtonClassName(type) {
    return this.hasConsole(type) ? 'cursor-pointer active' : '';
  },
  render() {
    const { currentModal } = this.state;

    return (
      <div>
        <div className='console-section'>
          <ul className='icons'>
            <li onClick={ this.openModal } className={ this.consoleButtonClassName('video') } data-modal='video'>
              <i className='icon-video-1' />
            </li>
            <li onClick={ this.openModal } className={ this.consoleButtonClassName('audio') } data-modal='audio'>
              <i className='icon-volume-up' />
            </li>
            <li onClick={ this.openModal } className={ this.consoleButtonClassName('image') } data-modal='image'>
              <i className='icon-camera' />
            </li>
            <li onClick={ this.openModal } className={ this.consoleButtonClassName('survey') } data-modal='survey'>
              <i className='icon-ok-squared' />
            </li>
            <li>
              <i className='icon-pdf' />
            </li>
          </ul>
        </div>

        <SurveyModal show={ this.compareState(['survey']) } onHide={ this.closeModal } onEnter={ this.onEnter } />
        <UploadsModal show={ this.compareState(['video', 'audio', 'image']) } onHide={ this.closeModal } onEnter={ this.onEnter } resourceType={ currentModal } />
      </div>
    )
  }
});

const mapStateToProps = (state) => {
  return {
    colours: state.chat.session.colours,
    channel: state.topic.channel,
    tConsole: state.topic.console
  }
};

export default connect(mapStateToProps)(Console);
