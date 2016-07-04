import React, {PropTypes} from 'react';
import { connect }        from 'react-redux';
import mixins             from '../../mixins';
import Modals             from './modals';
import PinboardActions    from './../../actions/pinboard';

const { UploadsModal, SurveyModal } = Modals;

const Resources = React.createClass({
  mixins: [mixins.modalWindows, mixins.validations, mixins.helpers],
  getInitialState() {
    return { currentModal: null };
  },
  shouldShow(modals) {
    const { currentModal } = this.state;

    let includes = (modals.includes(currentModal) && this.showSpecificModal('resources'));
    let whiteboardImage = (modals.includes(currentModal) && currentModal == 'image' && this.showSpecificModal('whiteboardImage'));

    return includes || whiteboardImage;
  },
  openModal(modal) {
    this.setState({ currentModal: modal }, function() {
      if(this.state.currentModal == 'pinboard') {
        this.activatePinboard();
      }
      else {
        this.openSpecificModal('resources');
      }
    });
  },
  activatePinboard() {
    const { tConsole, channel, dispatch } = this.props;

    if(!tConsole.pinboard) {
      let confirmed = true;
      if(this.isOtherItemsActive('pinboard')) {
        confirmed = confirm('Enabling pinboard will remove other active console items, are you sure?');
      }

      if(confirmed) {
        dispatch(PinboardActions.enablePinboard(channel));
      }
    }
  },
  componentDidUpdate(prevProps) {
    if(this.props.whiteboardImage && this.props.whiteboardImage != prevProps.whiteboardImage) {
      this.setState({ currentModal: 'image' });
    }
  },
  render() {
    const { currentModal } = this.state;
    const resourceButtons = [
      { type: 'video',    className: 'icon-video-1'    },
      { type: 'audio',    className: 'icon-volume-up'  },
      { type: 'image',    className: 'icon-picture'    },
      { type: 'pinboard', className: 'icon-camera'     },
      { type: 'survey',   className: 'icon-ok-squared' },
    ];

    if(this.hasPermission(['resources', 'can_upload'])) {
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
    channel: state.sessionTopic.channel,
    tConsole: state.sessionTopic.console,
    currentUser: state.members.currentUser,
    modalWindows: state.modalWindows,
    whiteboardImage: state.modalWindows.whiteboardImage,
  }
};

export default connect(mapStateToProps)(Resources);
