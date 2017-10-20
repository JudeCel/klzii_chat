import React, {PropTypes} from 'react';
import { connect }        from 'react-redux';
import Modals             from './modals';
import mixins             from '../../mixins';

const { UploadsModal } = Modals;

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
  render() {
    var type = this.getCurrentResourceType();
    
    if(!type) return null;

    const { modalName } = this.state;

    return (
        <div>
            <span onClick={ this.openModal.bind(this, type, true) } className="icon-type-video-green">
                <i className="icon-video-1"></i>
            </span>

            <UploadsModal show={ this.shouldShow(this.resourceTypes) } modalName={ modalName } />
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