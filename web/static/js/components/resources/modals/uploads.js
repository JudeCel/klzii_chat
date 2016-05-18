import React, {PropTypes} from 'react';
import { connect }        from 'react-redux';
import { Modal }          from 'react-bootstrap';
import UploadsIndex       from './uploads/index';
import mixins             from '../../../mixins';
import Actions            from '../../../actions/session_resource';

const Uploads = React.createClass({
  mixins: [mixins.modalWindows, mixins.helpers],
  getInitialState() {
    return { rendering: 'index', tabActive: 1 };
  },
  initialWithTitle(props) {
    return { ...this.getInitialState(), title: `Add ${props.modalName}` }
  },
  componentWillReceiveProps(nextProps) {
    if(nextProps.show && nextProps.modalWindows != this.props.modalWindows) {
      this.setState(this.initialWithTitle(nextProps), function() {
        const { dispatch, currentUserJwt, modalName } = this.props;
        dispatch(Actions.index(currentUserJwt, { type: this.get_session_resource_types(modalName) }));
      });
    }
  },
  onCreate() {
    const { name, url, files, resourceIds } = this.state.resourceData;
    const { dispatch, currentUserJwt, modalName } = this.props;

    if(url) {
      let data = {
        type: 'link',
        scope: 'youtube',
        name: name,
        file: url
      };

      dispatch(Actions.youtube(data, currentUserJwt));
    }
    else if(files) {
      let data = {
        type: modalName,
        scope: 'collage',
        name: name,
        files: files
      };

      dispatch(Actions.upload(data, currentUserJwt));
    }
    else if (resourceIds) {
      dispatch(Actions.create(currentUserJwt, resourceIds, modalName));
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
  },
  manipulateModalWindow() {
    let id = 'modal-uploads-' + this.props.modalName;
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
    const { modalName } = this.props;
    return { 1: `${modalName} Resource List`, 2: `Add ${modalName} from URL`, 3: `Upload ${modalName}` };
  },
  onTab(id) {
    this.setState({ tabActive: id, title: this.tabModalTitles()[id] });
  },
  isTabActive(id) {
    return id == this.state.tabActive;
  },
  tabActiveClass(id, videoCheck) {
    if(videoCheck && this.props.modalName != 'video') {
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
    const { modalName, show } = this.props;
    const tabs = [
      { order: 1, title: 'Resource List' },
      { order: 2, title: 'Add From URL' },
      { order: 3, title: 'Upload' },
    ];

    if(show) {
      return (
        <Modal id={ 'modal-uploads-' + modalName } dialogClassName='modal-section' show={ show } onHide={ this.onClose } onEnter={ this.onEnterModal }>
          <ul className='nav nav-tabs nav-justified tab-section hidden'>
            {
              tabs.map((tab, index) =>
                <li key={ tab.order } className={ this.tabActiveClass(tab.order, tab.order == 2) } onClick={ this.onTab.bind(this, tab.order) }>
                  <a style={ this.tabStyle(tab.order) }>{ tab.title }</a>
                </li>
              )
            }
          </ul>

          <Modal.Header>
            <div className='col-md-2'>
              <span className='pull-left fa icon-reply' onClick={ this.onBack }></span>
            </div>

            <div className='col-md-8 modal-title'>
              <h4>{ title || `Add ${modalName}` }</h4>
            </div>

            <div className='col-md-2'>
              <span className={ this.newButtonClass() } onClick={ this.onNew }></span>
            </div>
          </Modal.Header>

          <Modal.Body>
            <div className='row uploads-section'>
              <UploadsIndex { ...{ rendering, tabActive, modalName, afterChange: this.afterChange } } />
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
    currentUserJwt: state.members.currentUser.jwt,
    channel: state.sessionTopic.channel,
  }
};

export default connect(mapStateToProps)(Uploads);
