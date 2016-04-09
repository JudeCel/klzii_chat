import React, {PropTypes} from 'react';
import { connect }        from 'react-redux';
import { Modal }          from 'react-bootstrap';
import SurveyAnswer       from './survey/answer';

const SurveyConsole = React.createClass({
  afterChange(value) {
    this.setState({ value: value });
  },
  answer() {
    console.log("answer ", this.state.value, this.props.survey);
  },
  render() {
    const { show, onHide, onEnter, survey } = this.props;

    if(show) {
      return (
        <Modal dialogClassName='modal-section' show={ show } onHide={ onHide } onEnter={ onEnter }>
          <Modal.Header>
            <div className='col-md-2'>
              <span className='pull-left fa icon-reply' onClick={ onHide }></span>
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
    survey: state.resources.survey || {id: 1, title: 'Survey', question: 'Do you like?', type: '5starRating', active: true}
  }
};

export default connect(mapStateToProps)(SurveyConsole);
