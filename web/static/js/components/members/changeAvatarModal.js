import React, {PropTypes} from 'react';
import { connect }        from 'react-redux';
import { Modal }          from 'react-bootstrap';
import onEnterModalMixin  from '../../mixins/onEnterModal';
import Avatar             from './avatar';
import AvatarPreview      from './preview';

const ChangeAvatarModal = React.createClass({
  mixins: [onEnterModalMixin],
  getInitialState() {
    return { tabActive: 'hair' };
  },
  componentWillReceiveProps() {
    const { id, username, avatarData } = this.props.currentUser;
    this.setState({ id, username, avatarData });
  },
  onClose(e) {
    this.setState(this.getInitialState());
    this.props.onHide(e);
  },
  onSave(e) {

  },
  onOpen(e) {
    const { id, username, avatarData } = this.props.currentUser;
    this.setState({ id, username, avatarData });
    this.onEnter(e);
  },
  onNameChange(e) {
    this.setState({ username: e.target.value });
  },
  isTabActive(type) {
    return this.state.tabActive == type;
  },
  tabClassName(type) {
    return this.isTabActive(type) ? 'active' : '';
  },
  switchTab(e) {
    this.setState({ tabActive: e.target.dataset.type });
  },
  chooseAvatar(e) {
    const id = e.currentTarget.dataset.id;
    let { tabActive, avatarData } = this.state;
    avatarData[this.state.tabActive] = id;
    this.setState({ avatarData: avatarData });
  },
  previewImages(type) {
    return {
      hair: 8,
      head: 8,
      body: 6,
      desk: 6
    }[type];
  },
  render() {
    const { show, colours } = this.props;
    const { id, username, avatarData, tabActive } = this.state;
    const previews = Array(this.previewImages(tabActive)).fill();
    const tabs = [
      { type: 'hair' },
      { type: 'head' },
      { type: 'body' },
      { type: 'desk' }
    ];

    if(show) {
      return (
        <Modal dialogClassName='modal-section change-avatar-modal' show={ show } onHide={ this.onClose } onEnter={ this.onOpen }>
          <Modal.Header>
            <div className='col-md-2'>
              <span className='pull-left fa icon-reply' onClick={ this.onClose }></span>
            </div>

            <div className='col-md-8 modal-title'>
              <h4>Customize Your Biizu</h4>
            </div>

            <div className='col-md-2'>
              <span className='pull-right fa fa-check' onClick={ this.onSave }></span>
            </div>
          </Modal.Header>

          <Modal.Body>
            <div className='customize-avatar-section'>
              <div className='row biizu-section div-inline-block'>
                <div className='preview-section div-inline-block' style={ { borderColor: colours.mainBorder } }>
                  <Avatar member={ { id, username, avatarData, online: true, edit: true } } colour={ colours.facilitator } specificId='change-avatar' />
                </div>

                <div className='elements-section div-inline-block' style={ { borderColor: colours.mainBorder } }>
                  {
                    previews.map((_, index) =>
                      <div key={ tabActive+index } className='col-md-3 cursor-pointer' onClick={ this.chooseAvatar } data-id={ index }>
                        <AvatarPreview index={ index } type={ tabActive } />
                      </div>
                    )
                  }
                </div>
              </div>

              <div className='row selection-section'>
                <div className='form-inline div-inline-block'>
                  <div className='form-group'>
                    <label htmlFor='username' className='control-label'>Username</label>
                    <input type='text' className='form-control no-border-radius' id='username' placeholder='Username' value={ username } onChange={ this.onNameChange } />
                  </div>
                </div>

                <div className='pull-right div-inline-block'>
                  <ul className='icons'>
                    {
                      tabs.map((tab, index) =>
                        <li key={tab.type} className={ this.tabClassName(tab.type) } onClick={ this.switchTab } data-type={tab.type}>
                          <i className={ `icon-${tab.type}` } data-type={tab.type} />
                        </li>
                      )
                    }
                  </ul>
                </div>
              </div>
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
    colours: state.chat.session.colours,
    currentUser: state.members.currentUser
  }
};

export default connect(mapStateToProps)(ChangeAvatarModal);
