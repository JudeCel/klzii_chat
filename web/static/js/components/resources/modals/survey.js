import React, {PropTypes}  from 'react';
import { connect }         from 'react-redux';
import { Modal }           from 'react-bootstrap';
import SurveyIndex         from './survey/index.js';
import mixins              from '../../../mixins';
import MiniSurveyActions   from '../../../actions/miniSurvey';
import NotificationActions from '../../../actions/notifications';

const Survey = React.createClass({
  mixins: [mixins.modalWindows, mixins.validations],
  getInitialState() {
    return { rendering: 'index', survey: {} };
  },
  afterChange(data) {
    this.setState(data);
  },
  onClose() {
    this.setState(this.getInitialState());
    this.closeAllModals();
  },
  onBack() {
    if(this.state.rendering != 'index') {
      this.setState(this.getInitialState());
    }
    else {
      this.onClose();
    }
  },
  onShow(e) {
    if(e) {
      this.onEnterModal(e);
    }

    this.setState(this.getInitialState(), function() {
      const { sessionTopicId, currentUserJwt, dispatch } = this.props;
      dispatch(MiniSurveyActions.index(currentUserJwt, sessionTopicId));
    });
  },
  onNew() {
    const { rendering, survey } = this.state;

    if(rendering == 'new') {
      const { sessionTopicId, currentUserJwt, dispatch } = this.props;
      let hasMissing = this.hasFieldsMissing(survey, ['title', 'question', 'type']);

      if(hasMissing) {
        NotificationActions.showNotification(dispatch, { message: 'Please fill all fields', type: 'error' });
      }
      else {
        dispatch(MiniSurveyActions.create(currentUserJwt, { ...survey, sessionTopicId }, this.onShow));
      }
    }
    else {
      this.setState({ rendering: 'new' });
    }
  },
  onView(survey) {
    const { rendering } = this.state;
    if(rendering != 'view') {
      this.setState({ rendering: 'view' });
    }
  },
  newButtonClass(rendering) {
    const className = 'pull-right fa ';

    if(rendering == 'index') {
      return className + 'fa-plus';
    }
    else if(rendering == 'new') {
      return className + 'fa-check';
    }
    else {
      return className + 'hidden';
    }
  },
  render() {
    const { rendering } = this.state;
    const { show } = this.props;

    if(show) {
      return (
        <Modal dialogClassName='modal-section' show={ show } onHide={ this.onClose } onEnter={ this.onShow }>
          <Modal.Header>
            <div className='col-md-2'>
              <span className='pull-left fa icon-reply' onClick={ this.onBack }></span>
            </div>

            <div className='col-md-8 modal-title'>
              <h4>Voting</h4>
            </div>

            <div className='col-md-2'>
              <span className={ this.newButtonClass(rendering) } onClick={ this.onNew }></span>
            </div>
          </Modal.Header>

          <Modal.Body>
            <div className='row survey-create-section'>
              <SurveyIndex rendering={ rendering } afterChange={ this.afterChange } onView={ this.onView } />
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
    currentUserJwt: state.members.currentUser.jwt,
    sessionTopicId: state.sessionTopic.current.id,
    modalWindows: state.modalWindows,
    colours: state.chat.session.colours,
  }
};

export default connect(mapStateToProps)(Survey);
