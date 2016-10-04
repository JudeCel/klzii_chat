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
      if(modal == 'pinboard') {
        this.activatePinboard();
      }
      else {
        this.openSpecificModal('resources', { type: modal });
      }
    });
  },
  activatePinboard() {
    const { sessionTopicConsole, channel, dispatch, session, currentUser } = this.props;

    if(!sessionTopicConsole.data.pinboard && currentUser.permissions.pinboard.can_enable) {
      let confirmed = true;
      if(this.isOtherItemsActive('pinboard')) {
        confirmed = confirm('Enabling pinboard will remove other active console items, are you sure?');
      }

      if(confirmed) {
        dispatch(PinboardActions.enable(channel));
      }
    }
  },
  componentDidUpdate(prevProps) {
    if(this.props.whiteboardImage && this.props.whiteboardImage != prevProps.whiteboardImage) {
      this.setState({ currentModal: 'image' });
    }
  },
  canShowResourceButton(buttonType) {
    const { currentUser } = this.props;
    switch (buttonType) {
      case 'pinboard': return currentUser.permissions.pinboard.can_enable;
      default: return true;
    }
  },
  render() {
    const { session } = this.props;

    const resourceButtons = [
      { type: 'video',    className: 'icon-video-1'},
      { type: 'audio',    className: 'icon-volume-up'},
      { type: 'pinboard', className: 'icon-camera'},
      { type: 'survey',   className: 'icon-ok-squared'},
      { type: 'file',     className: 'icon-pdf'},
    ];

    if(this.hasPermission(['resources', 'can_see_section'])) {
      return (
        <div className='resources-section'>
          <ul className='icons'>
            {
              resourceButtons.map((button, index) => {
                if (this.canShowResourceButton(button.type)) {
                  return (
                    <li key={ index } onClick={ this.openModal.bind(this, button.type) }>
                      <i className={ button.className } />
                    </li>
                  )
                }
              })
            }
          </ul>

          <UploadsModal show={ this.shouldShow(['video', 'audio', 'image', 'file']) } />
          <SurveyModal show={ this.shouldShow(['survey']) } />
        </div>
      )
    }
    else {
      return(<div className='resources-section'></div>)
    }
  }
});

const mapStateToProps = (state) => {
  return {
    channel: state.sessionTopic.channel,
    sessionTopicConsole: state.sessionTopicConsole,
    currentUser: state.members.currentUser,
    modalWindows: state.modalWindows,
    whiteboardImage: state.modalWindows.whiteboardImage,
    session: state.chat.session
  }
};

export default connect(mapStateToProps)(Resources);
