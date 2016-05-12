import React, {PropTypes} from 'react';
import { connect }        from 'react-redux';
import { Modal }          from 'react-bootstrap';
import UploadsIndex       from './uploads/index';
import mixins             from '../../../mixins';
import Actions            from '../../../actions/resource';

const Uploads = React.createClass({
  mixins: [mixins.modalWindows],
  getInitialState() {
    return { rendering: 'index', tabActive: 1 };
  },
  initialWithTitle(props) {
    return { ...this.getInitialState(), title: `Add ${props.resourceType}` }
  },
  componentWillReceiveProps(nextProps) {
    if(nextProps.shouldRender && nextProps.modalWindows != this.props.modalWindows) {
      this.loadResources(nextProps);
    }
  },
  loadResources(props) {
    const { resourceType, dispatch, channel } = props;
    this.setState(this.initialWithTitle(props));
    dispatch(Actions.get(channel, resourceType));
  },
  onBack() {
    if(this.state.rendering != 'index') {
      this.manipulateModalWindow();
      this.setState(this.initialWithTitle(this.props));
    }
    else {
      this.onClose();
    }
  },
  onClose() {
    this.setState(this.initialWithTitle(this.props));
    this.closeAllModals();
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
    const { mainBorder } = this.props.colours;
    let style = { borderColor: mainBorder };
    if(this.isTabActive(id)) {
      style.backgroundColor = mainBorder;
    }

    return style;
  },
  render() {
    const show = this.showSpecificModal('resources');
    const { rendering, tabActive, title } = this.state;
    const { onDelete, afterChange, resourceType, shouldRender } = this.props;

    if(show && shouldRender) {
      return (
        <Modal id={ 'modal-uploads-'+resourceType } dialogClassName='modal-section' show={ show } onHide={ this.onClose } onEnter={ this.onEnterModal }>
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

const mapStateToProps = (state) => {
  return {
    modalWindows: state.modalWindows,
    colours: state.chat.session.colours,
    channel: state.topic.channel,
  }
};

export default connect(mapStateToProps)(Uploads);
