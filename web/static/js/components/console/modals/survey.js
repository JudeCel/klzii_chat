import React, {PropTypes}  from 'react';
import { connect }         from 'react-redux';
import { Modal }           from 'react-bootstrap';
import SurveyAnswer        from './survey/answer';
import mixins              from '../../../mixins';
import MiniSurveyActions   from '../../../actions/miniSurvey';
import NotificationActions from '../../../actions/notifications';

const SurveyConsole = React.createClass({
  mixins: [mixins.modalWindows, mixins.validations],
  getInitialState() {
    return {};
  },
  afterChange(value) {
    this.setState({ value: value });
  },
  answer() {
    const { dispatch, currentUserJwt, survey } = this.props;
    let hasMissing = this.hasFieldsMissing(this.state, ['value']);

    if(hasMissing) {
      NotificationActions.showNotification(dispatch, { message: 'Please select answer', type: 'error' });
    }
    else {
      dispatch(MiniSurveyActions.answer(currentUserJwt, { ...survey, value: this.state.value }, this.closeAllModals));
    }
  },
  onShow(e) {
    const { dispatch, currentUserJwt, topicConsole, sessionTopicId } = this.props;

    this.onEnterModal(e);
    dispatch(MiniSurveyActions.getConsole(currentUserJwt, topicConsole.mini_survey_id, sessionTopicId));
  },
  render() {
    const { survey, show } = this.props;

    if(show) {
      return (
        <Modal dialogClassName='modal-section' show={ show } onHide={ this.closeAllModals } onEnter={ this.onShow }>
          <Modal.Header>
            <div className='col-md-2'>
              <span className='pull-left fa icon-reply' onClick={ this.closeAllModal }></span>
            </div>

            <div className='col-md-8 modal-title'>
              <h4>{ survey.title }</h4>
            </div>

            <div className='col-md-2'>
              <span className='pull-right fa fa-check' onClick={ this.answer }></span>
            </div>
          </Modal.Header>

          <Modal.Body>
            <div className='row survey-answer-section'>
              <SurveyAnswer type={ survey.type } afterChange={ this.afterChange } />
            </div>
          </Modal.Body>
        </Modal>
      )
    }
    else {
      return (false)
    }
  }
});

const mapStateToProps = (state) => {
  return {
    modalWindows: state.modalWindows,
    colours: state.chat.session.colours,
    survey: state.miniSurveys.console,
    currentUserJwt: state.members.currentUser.jwt,
    sessionTopicId: state.sessionTopic.current.id,
    topicConsole: state.sessionTopic.console
  }
};

export default connect(mapStateToProps)(SurveyConsole);
