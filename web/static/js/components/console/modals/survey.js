import React, {PropTypes}  from 'react';
import { connect }         from 'react-redux';
import { Modal }           from 'react-bootstrap';
import SurveyAnswer        from './survey/answer';
import mixins              from '../../../mixins';
import MiniSurveyActions   from '../../../actions/miniSurvey';
import NotificationActions from '../../../actions/notifications';
import SurveyViewAnswers   from '../../resources/modals/survey/viewAnswers';

const SurveyConsole = React.createClass({
  mixins: [mixins.modalWindows, mixins.validations],
  getInitialState() {
    return {};
  },
  afterChange(value) {
    this.setState({ value: value });
  },
  answer() {
    const { dispatch, channel, survey } = this.props;
    let hasMissing = this.hasFieldsMissing(this.state, ['value']);

    if(hasMissing) {
      NotificationActions.showNotification(dispatch, { message: 'Please select answer', type: 'error' });
    }
    else {
      let params = {
        id: survey.id,
        answer: {
          value: this.state.value,
          type: survey.type
        }
      };
      dispatch(MiniSurveyActions.answer(channel, params, this.closeAllModals));
    }
  },
  onShow(e) {
    const { dispatch, channel, sessionTopicConsole } = this.props;

    this.onEnterModal(e);
    dispatch(MiniSurveyActions.getConsole(channel, sessionTopicConsole.data.mini_survey_id));
  },
  surveyNotAnswered(survey) {
    return !(this.props.survey && this.props.survey.mini_survey_answer);
  },
  showContent(survey) {
    if(survey.id) {
      if(this.hasPermission(['console', 'can_vote_mini_survey']) && this.surveyNotAnswered()) {
        return <SurveyAnswer type={ survey.type } afterChange={ this.afterChange } />
      }
      else {
        this.onViewAnswers(survey);
        return <SurveyViewAnswers type={ survey.type } />
      }
    }
  },
  onViewAnswers(survey) {
    const { dispatch, channel } = this.props;
    dispatch(MiniSurveyActions.viewAnswers(channel, survey.id));
  },
  canAnswer() {
    if(this.hasPermission(['console', 'can_vote_mini_survey']) && this.surveyNotAnswered()) {
      return <span className='pull-right fa fa-check' onClick={ this.answer }></span>
    }
  },
  render() {
    const { survey, show } = this.props;

    if(show) {
      return (
        <Modal dialogClassName='modal-section survey-modal' show={ show } onHide={ this.closeAllModals } onEnter={ this.onShow }>
          <Modal.Header>
            <div className='col-md-2'>
              <span className='pull-left fa icon-reply' onClick={ this.closeAllModals }></span>
            </div>

            <div className='col-md-8 modal-title'>
              <h2>{ survey.title }</h2>
            </div>

            <div className='col-md-2'>
              { this.canAnswer() }
            </div>
          </Modal.Header>

          <Modal.Body>
            <div className='row survey-answer-section'>
              { this.showContent(survey) }
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
    currentUser: state.members.currentUser,
    modalWindows: state.modalWindows,
    colours: state.chat.session.colours,
    survey: state.miniSurveys.console,
    channel: state.sessionTopic.channel,
    sessionTopicConsole: state.sessionTopicConsole
  }
};

export default connect(mapStateToProps)(SurveyConsole);
