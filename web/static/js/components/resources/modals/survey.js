import React, {PropTypes}  from 'react';
import { connect }         from 'react-redux';
import { Modal }           from 'react-bootstrap'
import SurveyIndex         from './survey/index.js';

const Survey = React.createClass({
  getInitialState() {
    return { manage: false, survey: {} };
  },
  onClose(e) {
    this.setState(this.getInitialState());
    this.props.onHide(e);
  },
  onBack(e) {
    if(this.state.manage) {
      this.setState(this.getInitialState());
    }
    else {
      this.onClose(e);
    }
  },
  onNew() {
    this.setState({ manage: true, survey: {} });
  },
  onEdit(survey) {
    this.setState({ manage: true, survey: survey });
  },
  onDelete(survey) {
    console.log("delete ", survey);
  },
  render() {
    const { manage, survey } = this.state;
    const { show, onEnter, surveys } = this.props;

    return (
      <Modal dialogClassName='modal-section' show={ show } onHide={ this.onClose } onEnter={ onEnter }>
        <Modal.Header>
          <div className='col-md-2'>
            <span className='pull-left fa fa-long-arrow-left' onClick={ this.onBack }></span>
          </div>

          <div className='col-md-8 modal-title'>
            <h4>Voting</h4>
          </div>

          <div className='col-md-2'>
            {
              (() => {
                if(manage) {
                  return (false)
                }
                else {
                  return (<span className='pull-right fa fa-plus' onClick={ this.onNew }></span>)
                }
              })()
            }
          </div>
        </Modal.Header>

        <Modal.Body>
          <div className='row survey-section'>
            <SurveyIndex surveys={ surveys } survey={ survey } onDelete={ this.onDelete } onEdit={ this.onEdit } manage={ manage } />
          </div>
        </Modal.Body>
      </Modal>
    )
  }
});

const mapStateToProps = (state) => {
  return {
    surveys: state.resources.surveys || [
      { title: 'Survey', question: 'Do you like?', type: 'first', active: true },
      { title: 'Survey', question: 'Do you like?', type: 'first', active: false }
    ]
  }
};

export default connect(mapStateToProps)(Survey);
