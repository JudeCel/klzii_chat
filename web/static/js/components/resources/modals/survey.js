import React, {PropTypes}  from 'react';
import { Modal }           from 'react-bootstrap'
import SurveyIndex         from './survey/index.js';

const Survey = React.createClass({
  getInitialState() {
    return { rendering: 'index', survey: {} };
  },
  afterChange(data) {
    this.setState(data);
  },
  onBack(e) {
    if(this.state.rendering != 'index') {
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
    const { rendering, survey } = this.state;
    if(rendering == 'new') {
      //call save
      console.log(survey);
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
    const { show, onHide } = this.props;

    return (
      <Modal dialogClassName='modal-section' show={ show } onHide={ onHide } onEnter={ this.onOpen }>
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
});

export default Survey;
