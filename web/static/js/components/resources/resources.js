import React, {PropTypes} from 'react';
import { connect }        from 'react-redux';
import mixins             from '../../mixins';
import Modals             from './modals';

const { UploadsModal, SurveyModal } = Modals;

const Resources = React.createClass({
  mixins: [mixins.modalWindows, mixins.validations],
  getInitialState() {
    return { currentModal: null };
  },
  shouldShow(modals) {
    return modals.includes(this.state.currentModal) && this.showSpecificModal('resources');
  },
  openModal(modal) {
    this.setState({ currentModal: modal }, function() {
      this.openSpecificModal('resources');
    });
  },
  render() {
    const { currentModal } = this.state;
    const resourceButtons = [
      { type: 'video', className: 'icon-video-1' },
      { type: 'audio', className: 'icon-volume-up' },
      { type: 'image', className: 'icon-picture' },
      { type: 'video', className: 'icon-camera' },
      { type: 'survey', className: 'icon-ok-squared' },
    ]

    if(this.hasPermissions('resources', 'can_upload')) {
      return (
        <div className='resources-section col-md-4'>
          <ul className='icons'>
            {
              resourceButtons.map((button, index) =>
                <li key={ index } onClick={ this.openModal.bind(this, button.type) }>
                  <i className={ button.className } />
                </li>
              )
            }
          </ul>

          <UploadsModal show={ this.shouldShow(['video', 'audio', 'image']) } modalName={ currentModal } />
          <SurveyModal show={ this.shouldShow(['survey']) } />
        </div>
      )
    }
    else {
      return(<div className='resources-section col-md-4'></div>)
    }
  }
});

const mapStateToProps = (state) => {
  return {
    currentUser: state.members.currentUser,
    modalWindows: state.modalWindows,
  }
};

export default connect(mapStateToProps)(Resources);
