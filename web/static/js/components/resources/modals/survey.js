import React, {PropTypes} from 'react';
import { connect }        from 'react-redux';
import { Modal }          from 'react-bootstrap'
import SurveyIndex        from './survey/index.js';
import mixins             from '../../../mixins';

const Survey = React.createClass({
  mixins: [mixins.modalWindows],
  getInitialState() {
    return { rendering: 'index', survey: {} };
  },
  shouldComponentUpdate(nextProps, nextState) {
    return nextProps.shouldRender && nextProps.modalWindows != this.props.modalWindows
      || !nextProps.shouldRender && nextProps.modalWindows == this.props.modalWindows
      || this.state.rendering != nextState.rendering;
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
    this.setState(this.getInitialState());
    this.onEnterModal(e);
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
    const show = this.showSpecificModal('resources');
    const { rendering } = this.state;
    const { shouldRender } = this.props;

    if(show && shouldRender) {
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
    modalWindows: state.modalWindows,
    colours: state.chat.session.colours,
  }
};

export default connect(mapStateToProps)(Survey);
