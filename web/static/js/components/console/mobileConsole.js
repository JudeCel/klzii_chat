import React, {PropTypes} from 'react';
import { connect }        from 'react-redux';
import Modals             from './modals';
import mixins             from '../../mixins';

const { UploadsModal, SurveyModal } = Modals;

const MobileConsole = React.createClass({
  mixins: [mixins.modalWindows, mixins.helpers, mixins.validations],
  resourceTypes: ['video', 'audio', 'file'],
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
    return this.getConsoleResourceId(type) != null;
  },
  getCurrentResourceType() {
    return this.resourceTypes.find(type => { return this.getConsoleResourceId(type) != null });
  },
  getResourceButtons() {
    var type = this.getCurrentResourceType();

    if(!type) return null;

    return (            
        <span onClick={ this.openModal.bind(this, type, true) } className="icon-type-video-green">
          <i className="icon-video-1"></i>
        </span>
      );
  },
  getMiniSurveyButton() {
    if (!this.isConsoleActive('mini_survey')) return null;

    return (            
        <span onClick={ this.openModal.bind(this, 'mini_survey', true) } className="icon-type-mini_survey-green">
          <i className="icon-ok-squared"></i>
        </span>
      );
  },
  render() {
    const { modalName } = this.state;

    return (
        <div>
            { this.getResourceButtons() }
            { this.getMiniSurveyButton() }

            <UploadsModal show={ this.shouldShow(this.resourceTypes) } modalName={ modalName } />
            <SurveyModal show={ this.shouldShow(['mini_survey']) } />
        </div>
    );
  }
});

const mapStateToProps = (state) => {
  return {
    modalWindows: state.modalWindows,
    sessionTopicConsole: state.sessionTopicConsole
  }
};

export default connect(mapStateToProps)(MobileConsole);