import React, {PropTypes} from 'react';
import { connect }        from 'react-redux';
import { Modal }          from 'react-bootstrap';
import SurveyAnswer       from './survey/answer';
import mixins             from '../../../mixins';

const SurveyConsole = React.createClass({
  mixins: [mixins.modalWindows],
  getInitialState() {
    return {};
  },
  afterChange(value) {
    this.setState({ value: value });
  },
  answer() {
    console.log("answer ", this.state.value, this.props.survey);
  },
  render() {
    const show = this.showSpecificModal('console');
    const { survey, shouldRender } = this.props;

    if(show && shouldRender) {
      return (
        <Modal dialogClassName='modal-section' show={ show } onHide={ this.closeAllModals } onEnter={ this.onEnterModal }>
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
    survey: state.resources.survey || {id: 1, title: 'Survey', question: 'Do you like?', type: '5starRating', active: true}
  }
};

export default connect(mapStateToProps)(SurveyConsole);
