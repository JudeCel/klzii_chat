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
    const { sessionTopicConsole, channel, dispatch, session } = this.props;

    if(!sessionTopicConsole.data.pinboard && session.type != 'forum') {
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
  render() {
    const { session } = this.props;

    const resourceButtons = [
      { type: 'video',    className: 'icon-video-1',    sessionTypes: ['focus', 'forum'] },
      { type: 'audio',    className: 'icon-volume-up',  sessionTypes: ['focus', 'forum'] },
      { type: 'image',    className: 'icon-picture',    sessionTypes: ['focus', 'forum'] },
      { type: 'pinboard', className: 'icon-camera',     sessionTypes: ['focus'] },
      { type: 'survey',   className: 'icon-ok-squared', sessionTypes: ['focus', 'forum'] },
      { type: 'file',     className: 'icon-pdf',        sessionTypes: ['focus', 'forum'] },
    ];

    if(this.hasPermission(['resources', 'can_see_section'])) {
      return (
        <div className='resources-section'>
          <ul className='icons'>
            {
              resourceButtons.map((button, index) => {
                if (button.sessionTypes.includes(session.type)) {
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
