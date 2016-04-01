import React, {PropTypes} from 'react';
import { Modal }          from 'react-bootstrap';
import UploadsIndex       from './uploads/index';

const Uploads = React.createClass({
  getInitialState: function() {
    return { rendering: 'index' };
  },
  onBack(e) {
    if(this.state.rendering != 'index') {
      this.setState(this.getInitialState());
    }
    else {
      this.props.onHide(e);
    }
  },
  onNew(e) {
    if(this.state.rendering == 'new') {
      this.props.onCreate(this);
    }
    else {
      this.setState({ rendering: 'new' });
    }
  },
  newButtonClass() {
    const { rendering } = this.state;
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
    const { show, onHide, onDelete, onEnter, afterChange, resourceType } = this.props;

    if(show) {
      return (
        <Modal dialogClassName='modal-section' show={ show } onHide={ onHide } onEnter={ onEnter }>
          <Modal.Header>
            <div className='col-md-2'>
              <span className='pull-left fa icon-reply' onClick={ this.onBack }></span>
            </div>

            <div className='col-md-8 modal-title'>
              <h4></h4>
            </div>

            <div className='col-md-2'>
              <span className={ this.newButtonClass() } onClick={ this.onNew }></span>
            </div>
          </Modal.Header>

          <Modal.Body>
            <div className='row uploads-section'>
              <UploadsIndex rendering={ rendering } resourceType={ resourceType } onDelete={ onDelete } afterChange={ afterChange } />
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

export default Uploads;
