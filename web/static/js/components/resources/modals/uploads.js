import React, {PropTypes} from 'react';
import { connect }        from 'react-redux';
import { Modal }          from 'react-bootstrap';
import UploadsIndex       from './uploads/index';
import mixins             from '../../../mixins';
import Actions            from '../../../actions/session_resource';

const Uploads = React.createClass({
  mixins: [mixins.modalWindows, mixins.helpers],
  getInitialState() {
    return { rendering: 'index', tabActive: 1, name: "", resourceData: {} };
  },
  initialWithTitle(props) {
    return { ...this.getInitialState(), title: `Add ${props.modalData.type}` }
  },
  componentWillReceiveProps(nextProps) {
    if(nextProps.show) {
      this.setState(this.initialWithTitle(nextProps));
    }
  },
  onCreate() {
    const { name, url, files, resourceIds } = this.state.resourceData;
    const { dispatch, currentUserJwt, modalData } = this.props;

    if(url) {
      let data = {
        type: 'link',
        scope: 'videoService',
        name: name,
        file: url
      };

      dispatch(Actions.videoService(data, currentUserJwt));
    }
    else if(files) {
      let data = {
        type: modalData.type,
        scope: modalData.type == 'file' ? 'pdf' : 'collage',
        name: name,
        files: files
      };

      dispatch(Actions.upload(data, currentUserJwt));
    }
    else if (resourceIds) {
      dispatch(Actions.create(currentUserJwt, resourceIds, modalData.type));
    }
  },
  afterChange(data) {
    this.setState(data);
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
    if (this.newButtonDisabled() == false) {
      if(this.state.rendering == 'new') {
        this.onCreate();
        this.onBack();
      }
      else {
        this.setState({ rendering: 'new', title: this.tabModalTitles()[1] }, function() {
          let { parent, tabs } = this.manipulateModalWindow();
          parent.insertBefore(tabs, parent.childNodes[0]);
        });
      }
    }
  },
  manipulateModalWindow() {
    let id = 'modal-uploads-' + this.props.modalData.type;
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
  isNameEmpty() {
    return this.state.resourceData && (this.state.resourceData.name == null || this.state.resourceData.name == "");
  },
  isUploadImageDataCorrect() {
    const { resourceData} = this.state;
    return (this.isNameEmpty() || resourceData.files == null);
  },
  newButtonDisabled() {
    const { rendering, tabActive, resourceData} = this.state;
    let disabled = false;
    if (rendering == 'new' && tabActive == 3 && this.isUploadImageDataCorrect()) {
      disabled = true;
    }
    return disabled;
  },
  newButtonDisabledClass() {
    if (this.newButtonDisabled()) {
      return " disabled";
    } else {
      return "";
    }
  },
  newButtonClass() {
    const { rendering } = this.state;
    const className = 'pull-right fa ';

    if(rendering == 'index') {
      return className + 'fa-plus';
    }
    else if(rendering == 'new') {
      return className + 'fa-check' + this.newButtonDisabledClass();
    }
    else {
      return className + 'hidden';
    }
  },
  tabModalTitles() {
    const { modalData } = this.props;
    if(modalData.type == "image") {
      return { 1: `${modalData.type} Gallery`, 2: `Add ${modalData.type} from URL`, 3: `Upload ${modalData.type}` };
    }
    else {
      return { 1: `${modalData.type} Resource List`, 2: `Add ${modalData.type} from URL`, 3: `Upload ${modalData.type}` };
    }
  },
  selectTabTitle(title, order) {
    const { modalData } = this.props;
    if(modalData.type == "image" && order == 1) {
      return "Gallery";
    }
    else {
      return title;
    }
  },
  onTab(id) {
    this.setState({ tabActive: id, title: this.tabModalTitles()[id] });
  },
  isTabActive(id) {
    return id == this.state.tabActive;
  },
  tabActiveClass(id, videoCheck) {
    if(videoCheck && this.props.modalData.type != 'video') {
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
    const { rendering, tabActive, title } = this.state;
    const { modalData, show } = this.props;
    const tabs = [
      { order: 1, title: 'Resource List' },
      { order: 2, title: 'Add From URL' },
      { order: 3, title: 'Upload' },
    ];

    if(show) {
      return (
        <Modal id={ 'modal-uploads-' + modalData.type } dialogClassName='modal-section' show={ show } onHide={ this.onClose } onEnter={ this.onEnterModal }>
          <ul className='nav nav-tabs nav-justified tab-section hidden'>
            {
              tabs.map((tab, index) =>
                <li key={ tab.order } className={ this.tabActiveClass(tab.order, tab.order == 2) } onClick={ this.onTab.bind(this, tab.order) }>
                  <a style={ this.tabStyle(tab.order) }>{ this.selectTabTitle(tab.title, tab.order) }</a>
                </li>
              )
            }
          </ul>

          <Modal.Header>
            <div className='col-md-2'>
              <span className='pull-left fa icon-reply' onClick={ this.onBack }></span>
            </div>

            <div className='col-md-8 modal-title'>
              <h4>{ title || `Add ${modalData.type}` }</h4>
            </div>

            <div className='col-md-2'>
              <span className={ this.newButtonClass() } onClick={ this.onNew } disabled={ this.newButtonDisabled() }></span>
            </div>
          </Modal.Header>

          <Modal.Body>
            <div className='row uploads-section'>
              <UploadsIndex { ...{ rendering, tabActive, afterChange: this.afterChange, modalName: modalData.type } } />
              { this.fileSizeMessage(title) }
            </div>
          </Modal.Body>
        </Modal>
      )
    }
    else {
      return (false)
    }
  },
  fileSizeMessage(title){
    if(title == "Upload file") {
      return (
        <div className='col-md-12'>
          <p className="col-md-offset-2 col-md-10 file-size-message">Maximum file size is 5MB.</p>
        </div>
      )
    }
  }
});

const mapStateToProps = (state) => {
  return {
    modalWindows: state.modalWindows,
    modalData: state.modalWindows.currentModalData,
    colours: state.chat.session.colours,
    currentUserJwt: state.members.currentUser.jwt,
    channel: state.sessionTopic.channel
  }
};

export default connect(mapStateToProps)(Uploads);
