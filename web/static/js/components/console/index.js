import React, {PropTypes} from 'react';
import { connect }        from 'react-redux';
import Modals             from './modals';
import mixins             from '../../mixins';

const { SurveyModal, UploadsModal, PinboardModal } = Modals;

const Console = React.createClass({
  mixins: [mixins.modalWindows, mixins.helpers, mixins.validations],
  getInitialState() {
    return { modalName: null };
  },
  shouldShow(modals) {
    return modals.includes(this.state.modalName) && this.showSpecificModal('console');
  },
  openModal(type, permission) {
    if(this.isConsoleActive(type) && permission) {
      this.setState({ modalName: type }, function() {
        this.openSpecificModal('console');
      });
    }
  },
  isConsoleActive(type) {
    return this.getConsoleResourceId(type);
  },
  consoleButtonStyle(type, permission) {
    const color = this.props.colours.consoleButtonActive;
    return this.isConsoleActive(type) ? { color: color, borderColor: color, opacity: 1, cursor: permission ? 'pointer' : '' } : {};
  },
  consoleSectionStyle() {
    let sectionStyle = 'console-section';
    if(this.hasPermission(['messages', 'can_new_message']) == false) {
      sectionStyle += " console-section-no-input";
    }
    return sectionStyle;
  },
  render() {
    const { modalName } = this.state;
    const consoleButtons = [
      { type: 'video',       className: 'icon-video-1',    permission: true },
      { type: 'audio',       className: 'icon-volume-up',  permission: true },
      { type: 'pinboard',    className: 'icon-camera',     permission: this.hasPermission(['pinboard', 'can_add_resource']) },
      { type: 'mini_survey', className: 'icon-ok-squared', permission: this.hasPermission(["mini_surveys", "can_display_voting"]) },
      { type: 'file',        className: 'icon-pdf',        permission: true},
    ];

    return (
      <div>
        <div className={this.consoleSectionStyle()}>
          <ul className='icons'>
            {
              consoleButtons.filter((i)=> {return i.permission}).map((button, index) =>
                <li key={ index } onClick={ this.openModal.bind(this, button.type, button.permission) } style={ this.consoleButtonStyle(button.type, button.permission) } className={'icon-type-' + button.type}>
                  <i className={ button.className } />
                </li>
              )
            }
          </ul>
        </div>

        <PinboardModal show={ this.shouldShow(['pinboard']) } />
        <SurveyModal show={ this.shouldShow(['mini_survey']) } />
        <UploadsModal show={ this.shouldShow(['video', 'audio', 'file']) } modalName={ modalName } />
      </div>
    )
  }
});

const mapStateToProps = (state) => {
  return {
    currentUser: state.members.currentUser,
    colours: state.chat.session.colours,
    modalWindows: state.modalWindows,
    sessionTopicConsole: state.sessionTopicConsole
  }
};

export default connect(mapStateToProps)(Console);
