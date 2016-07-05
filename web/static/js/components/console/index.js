import React, {PropTypes} from 'react';
import { connect }        from 'react-redux';
import Modals             from './modals';
import mixins             from '../../mixins';

const { SurveyModal, UploadsModal, PinboardModal } = Modals;

const Console = React.createClass({
  mixins: [mixins.modalWindows, mixins.helpers],
  getInitialState() {
    return { modalName: null };
  },
  shouldShow(modals) {
    return modals.includes(this.state.modalName) && this.showSpecificModal('console');
  },
  openModal(type) {
    if(this.isConsoleActive(type)) {
      this.setState({ modalName: type }, function() {
        this.openSpecificModal('console');
      });
    }
  },
  isConsoleActive(type) {
    return this.getConsoleResourceId(type);
  },
  consoleButtonStyle(type) {
    const color = this.props.colours.consoleButtonActive;
    return this.isConsoleActive(type) ? { color: color, borderColor: color, opacity: 1, cursor: 'pointer' } : {};
  },
  render() {
    const { modalName } = this.state;
    const consoleButtons = [
      { type: 'video',       className: 'icon-video-1'    },
      { type: 'audio',       className: 'icon-volume-up'  },
      { type: 'pinboard',    className: 'icon-camera'     },
      { type: 'mini_survey', className: 'icon-ok-squared' },
      { type: 'pdf',         className: 'icon-pdf'        },
    ];

    return (
      <div>
        <div className='console-section'>
          <ul className='icons'>
            {
              consoleButtons.map((button, index) =>
                <li key={ index } onClick={ this.openModal.bind(this, button.type) } style={ this.consoleButtonStyle(button.type) } >
                  <i className={ button.className } />
                </li>
              )
            }
          </ul>
        </div>

        <PinboardModal show={ this.shouldShow(['pinboard']) } />
        <SurveyModal show={ this.shouldShow(['mini_survey']) } />
        <UploadsModal show={ this.shouldShow(['video', 'audio']) } modalName={ modalName } />
      </div>
    )
  }
});

const mapStateToProps = (state) => {
  return {
    colours: state.chat.session.colours,
    modalWindows: state.modalWindows,
    console: state.sessionTopic.console
  }
};

export default connect(mapStateToProps)(Console);
