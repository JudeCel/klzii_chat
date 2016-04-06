import React, {PropTypes} from 'react';
import { connect }        from 'react-redux';
import Constants          from '../../constants';
import Modals             from './modals';

const { SurveyModal } = Modals;

const Console = React.createClass({
  getInitialState() {
    return { currentModal: null };
  },
  compareState(modal) {
    return this.state.currentModal == modal;
  },
  closeModal(e) {
    const { dispatch } = this.props;
    dispatch({ type: Constants.CLOSE_CONSOLE_MODAL, modal: this.state.currentModal });
    this.setState({ currentModal: null });
  },
  openModal(e) {
    const { dispatch, channel } = this.props;

    let modal = e.target.getAttribute('data-modal');
    dispatch({ type: Constants.OPEN_CONSOLE_MODAL, modal });
    this.setState({ currentModal: modal });
    // dispatch(Actions.get(channel, modal));
  },
  onEnter(e) {
    const { colours } = this.props;

    let modalFrame = e.querySelector('.modal-content');
    modalFrame.style.borderColor = colours.mainBorder;
  },
  render() {
    return (
      <div>
        <div className='console-section'>
          <ul className='icons'>
            <li>
              <i className='icon-video-1' />
            </li>
            <li>
              <i className='icon-volume-up' />
            </li>
            <li>
              <i className='icon-camera' />
            </li>
            <li onClick={ this.openModal } data-modal='survey'>
              <i className='icon-ok-squared' data-modal='survey' />
            </li>
            <li>
              <i className='icon-pdf' />
            </li>
          </ul>
        </div>

        <SurveyModal show={ this.compareState('survey') } onHide={ this.closeModal } onEnter={ this.onEnter } />
      </div>
    )
  }
});

const mapStateToProps = (state) => {
  return {
    colours: state.chat.session.colours,
    channel: state.topic.channel
  }
};

export default connect(mapStateToProps)(Console);
