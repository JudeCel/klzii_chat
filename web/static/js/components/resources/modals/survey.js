import React, {PropTypes}  from 'react';
import { Modal }           from 'react-bootstrap'
import SurveyIndex         from './survey/index.js';

const Survey = React.createClass({
  getInitialState() {
    return { creating: false, survey: {} };
  },
  afterChange(data) {
    this.setState(data);
  },
  onBack(e) {
    if(this.state.creating) {
      this.setState(this.getInitialState());
    }
    else {
      this.props.onHide(e);
    }
  },
  onOpen(e) {
    this.setState(this.getInitialState());
    this.props.onEnter(e);
  },
  onNew() {
    const { creating, survey } = this.state;
    if(creating) {
      //call save
      console.log(survey);
    }
    else {
      this.setState({ creating: true });
    }
  },
  newButtonClass(creating) {
    const className = 'pull-right fa ';
    return creating ? className + 'fa-check' : className + 'fa-plus';
  },
  render() {
    const { creating } = this.state;
    const { show, onHide } = this.props;

    return (
      <Modal dialogClassName='modal-section' show={ show } onHide={ onHide } onEnter={ this.onOpen }>
        <Modal.Header>
          <div className='col-md-2'>
            <span className='pull-left fa fa-long-arrow-left' onClick={ this.onBack }></span>
          </div>

          <div className='col-md-8 modal-title'>
            <h4>Voting</h4>
          </div>

          <div className='col-md-2'>
            <span className={ this.newButtonClass(creating) } onClick={ this.onNew }></span>
          </div>
        </Modal.Header>

        <Modal.Body>
          <div className='row survey-section'>
            <SurveyIndex creating={ creating } afterChange={ this.afterChange } />
          </div>
        </Modal.Body>
      </Modal>
    )
  }
});

export default Survey;
