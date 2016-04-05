import React, { PropTypes } from 'react';
import { connect }          from 'react-redux';
import sessionActions       from '../actions/session';
import topicActions         from '../actions/topic';
import Messages             from '../components/messages/messages.js';
import Input                from '../components/messages/input.js';
import Whiteboard           from '../components/whiteboard';
import Facilitator          from '../components/members/facilitator.js';
import Participants         from '../components/members/participants.js';
import ChangeAvatarModal    from '../components/members/changeAvatarModal.js';
import TopicSelect          from '../components/topics/select.js';
import Resources            from '../components/resources/resources.js';
import HeaderLinks          from '../components/header/links.js';

const ChatView = React.createClass({
  getInitialState() {
    return {};
  },
  styles() {
    const { colours } = this.props;
    return {
      room: {
        backgroundColor: colours.mainBackground,
        border: '2px solid ' + colours.mainBorder
      }
    };
  },
  componentWillMount() {
    this.props.dispatch(sessionActions.connectToChannel());
  },
  componentWillReceiveProps(nextProps){
    if(nextProps.sessionReady && !nextProps.topicReady) {
      this.props.dispatch(topicActions.selectCurrent(nextProps.socket, nextProps.topics));
    }
  },
  openAvatarModal() {
    this.setState({ openAvatarModal: true });
  },
  closeAvatarModal() {
    this.setState({ openAvatarModal: false });
  },
  avatarModalExports() {
    return {
      openAvatarModal: this.openAvatarModal,
      closeAvatarModal: this.closeAvatarModal,
    };
  },
  render() {
    const { error } = this.props;

    if(error) {
      return (<div>{error}</div>)
    }
    else {
      return (
        <div id='chat-app-container'>
          <nav className='row header-section'>
            <div className='header-innerbox'>
              <TopicSelect/>
              <Resources/>
              <HeaderLinks/>
            </div>
          </nav>

          <div className='row room-outerbox'>
            <div className='col-md-12 room-section' style={ this.styles().room }>
              <ChangeAvatarModal show={ this.state.openAvatarModal } onHide={ this.closeAvatarModal } />
              <div className='row'>
                <div className='col-md-8'>
                  <div className='row'>
                    <Facilitator { ...this.avatarModalExports() }/>
                    {/*<Whiteboard/>*/}
                  </div>
                  <div className='row'>
                    <Participants { ...this.avatarModalExports() }/>
                  </div>
                </div>

                <div className='col-md-4'>
                  <Messages/>
                </div>

                <div className='col-md-12'>
                  <Input/>
                </div>
              </div>
            </div>
          </div>
        </div>
      )
    }
  }
});

const mapStateToProps = (state) => {
  return {
    colours: state.chat.session.colours,
    sessionReady: state.chat.ready,
    error: state.chat.error,
    topics: state.chat.session.topics,
    topicReady: state.topic.ready,
    socket: state.chat.socket
  };
};

export default connect(mapStateToProps)(ChatView);
