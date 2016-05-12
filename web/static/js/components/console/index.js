import React, {PropTypes} from 'react';
import { connect }        from 'react-redux';
import Modals             from './modals';
import mixins             from '../../mixins';

const { SurveyModal, UploadsModal } = Modals;

const Console = React.createClass({
  mixins: [mixins.modalWindows],
  getInitialState() {
    return { currentModal: null };
  },
  compareState(modals) {
    return modals.includes(this.state.currentModal);
  },
  openModal(modal) {
    this.setState({ currentModal: modal });
    this.openSpecificModal('console');
  },
  render() {
    const { currentModal } = this.state;

    return (
      <div>
        <div className='console-section'>
          <ul className='icons'>
            <li onClick={ this.openModal.bind(this, 'video') }>
              <i className='icon-video-1' />
            </li>
            <li onClick={ this.openModal.bind(this, 'audio') }>
              <i className='icon-volume-up' />
            </li>
            <li onClick={ this.openModal.bind(this, 'image') }>
              <i className='icon-camera' />
            </li>
            <li onClick={ this.openModal.bind(this, 'survey') }>
              <i className='icon-ok-squared' />
            </li>
            <li>
              <i className='icon-pdf' />
            </li>
          </ul>
        </div>

        <SurveyModal shouldRender={ this.compareState(['survey']) } />
        <UploadsModal shouldRender={ this.compareState(['video', 'audio', 'image']) } resourceType={ currentModal } />
      </div>
    )
  }
});

const mapStateToProps = (state) => {
  return {
    modalWindows: state.modalWindows
  }
};

export default connect(mapStateToProps)(Console);
