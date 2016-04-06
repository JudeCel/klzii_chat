import React, {PropTypes} from 'react';
import { Modal }          from 'react-bootstrap';
import UploadsIndex       from './uploads/index';
import ReactDOM           from 'react-dom';

const Uploads = React.createClass({
  getInitialState() {
    return { rendering: 'index', tabActive: 1 };
  },
  componentWillReceiveProps(nextProps) {
    this.setState({ title: `Add ${nextProps.resourceType}` });
  },
  onBack(e) {
    if(this.state.rendering != 'index') {
      this.manipulateModalWindow();
      this.setState(this.getInitialState());
    }
    else {
      this.onClose(e);
    }
  },
  onClose(e) {
    this.setState(this.getInitialState());
    this.props.onHide(e);
  },
  onNew(e) {
    if(this.state.rendering == 'new') {
      this.props.onCreate(this);
    }
    else {
      this.setState({ rendering: 'new', title: this.tabModalTitles()[1] }, function() {
        let { parent, tabs } = this.manipulateModalWindow();
        parent.insertBefore(tabs, parent.childNodes[0]);
      });
    }
  },
  manipulateModalWindow() {
    let id = 'modal-uploads-' + this.props.resourceType;
    let modal = document.getElementById(id);
    let parent = modal.querySelector('.modal-section');
    let tabs = modal.querySelector('.tab-section');

    if(tabs.className.includes('hidden')) {
      tabs.className = tabs.className.replace(' hidden', '');
    }
    else {
      tabs.className += ' hidden';
    }

    return { modal, parent, tabs };
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
  tabModalTitles() {
    const { resourceType } = this.props;
    return { 1: `${resourceType} Resource List`, 2: `Add a ${resourceType} from URL`, 3: `Upload a ${resourceType}` };
  },
  onTab(e) {
    const id = e.target.dataset.id;
    this.setState({ tabActive: id, title: this.tabModalTitles()[id] });
  },
  isTabActive(id) {
    return id == this.state.tabActive;
  },
  tabActiveClass(id, videoCheck) {
    if(videoCheck && this.props.resourceType != 'video') {
      return 'hidden';
    }
    else {
      return this.isTabActive(id) ? 'active' : '';
    }
  },
  tabStyle(id) {
    const { mainBorder } = this.props;
    let style = { borderColor: mainBorder };
    if(this.isTabActive(id)) {
      style.backgroundColor = mainBorder;
    }

    return style;
  },
  render() {
    const { rendering, tabActive, title } = this.state;
    const { show, onHide, onDelete, onEnter, afterChange, resourceType } = this.props;

    if(show) {
      return (
        <Modal id={ 'modal-uploads-'+resourceType } dialogClassName='modal-section' show={ show } onHide={ this.onClose } onEnter={ onEnter }>
          <ul className='nav nav-tabs nav-justified tab-section hidden'>
            <li className={ this.tabActiveClass(1) } onClick={ this.onTab }><a style={ this.tabStyle(1) } data-id={ 1 }>Resource List</a></li>
            <li className={ this.tabActiveClass(2, true) } onClick={ this.onTab }><a style={ this.tabStyle(2) } data-id={ 2 }>Add From URL</a></li>
            <li className={ this.tabActiveClass(3) } onClick={ this.onTab }><a style={ this.tabStyle(3) } data-id={ 3 }>Upload</a></li>
          </ul>

          <Modal.Header>
            <div className='col-md-2'>
              <span className='pull-left fa icon-reply' onClick={ this.onBack }></span>
            </div>

            <div className='col-md-8 modal-title'>
              <h4>{ title || `Add ${resourceType}` }</h4>
            </div>

            <div className='col-md-2'>
              <span className={ this.newButtonClass() } onClick={ this.onNew }></span>
            </div>
          </Modal.Header>

          <Modal.Body>
            <div className='row uploads-section'>
              <UploadsIndex { ...{ rendering, tabActive, resourceType, onDelete, afterChange } } />
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
