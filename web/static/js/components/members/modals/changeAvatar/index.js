import React, {PropTypes} from 'react';
import { connect }        from 'react-redux';
import { Modal }          from 'react-bootstrap';
import mixins             from '../../../../mixins';
import MemberActions      from '../../../../actions/member';
import Avatar             from '../../avatar';
import AvatarPreview      from './preview';
import _                  from 'lodash';

const ChangeAvatarModal = React.createClass({
  mixins: [mixins.modalWindows, mixins.validations],
  getInitialState() {
    return { tabActive: 'hair', avatarData: {} };
  },
  componentWillReceiveProps() {
    this.setStateBasedOnCurrentUser();
  },
  setStateBasedOnCurrentUser() {
    const { id, username, avatarData, colour } = this.props.currentUser;
    this.setState({ id, username, colour, avatarData:  _.cloneDeep(avatarData) });
  },
  onClose(e) {
    this.setState(this.getInitialState());
    this.closeAllModals();
  },
  onSave(e) {
    let payload = {}
    const { dispatch, channel } = this.props;
    const { avatarData, username } = this.state
    this.closeAllModals();
    payload.avatarData = avatarData;

    if (this.hasPermission(['member', 'can_change_name'])) {
      payload.username = username
    }
    dispatch(MemberActions.updateAvatar(channel, payload));
  },
  onOpen(e) {
    this.setStateBasedOnCurrentUser();
    this.onEnterModal(e);
    e.setAttribute("allowscroll", "true");
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
    avatarData[tabActive] = id;
    this.setState({ avatarData: avatarData });
  },
  tempArray(type) {
    const count = {
      hair: 8,
      head: 8,
      body: 6,
      desk: 6
    }[type];

    return Array(count).fill();
  },
  visableTabClass(type) {
    const className = 'row';
    return type == this.state.tabActive ? className : className + ' hidden';
  },
  renderUsername(username){
    if (this.hasPermission(['member', 'can_change_name'])) {
      return(
        <div>
          <label htmlFor='username' className='control-label'>Nickname</label>
          <input type='text' className='form-control no-border-radius' id='username' placeholder='Username' value={ username } onChange={ this.onNameChange } maxLength={15}/>
        </div>
      )
    }
  },
  render() {
    const show = this.showSpecificModal('avatar');
    const { colours } = this.props;
    const { id, username, avatarData, colour, tabActive } = this.state;
    let memberData = { id: "change-avatar", username, colour, avatarData, online: true, edit: true };
    const tabs = [
      { type: 'hair' },
      { type: 'head' },
      { type: 'body' },
      { type: 'desk' }
    ];

    if(show) {
      return (
        <Modal dialogClassName='modal-section change-avatar-modal' show={ show } onHide={ this.onClose } onEnter={ this.onOpen }>
          <Modal.Header className='biizu-header-section'>
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

          <Modal.Body className='biizu-body-section'>
            <div className='customize-avatar-section'>
              <div className='row biizu-section div-inline-block'>
                <div className='preview-section div-inline-block' style={ { borderColor: colours.mainBorder } }>
                  <Avatar member={ _.cloneDeep(memberData) } specificId="change-avatar-modal"/>
                </div>

                <div className='elements-section div-inline-block' style={ { borderColor: colours.mainBorder } }>
                  {
                    tabs.map((tab) =>
                      <div key={ tab.type } className={ this.visableTabClass(tab.type) }>
                        {
                          this.tempArray(tab.type).map((_, index) =>
                            <div key={ tab.type+index } className='col-md-3 cursor-pointer' onClick={ this.chooseAvatar } data-id={ index }>
                              <AvatarPreview index={ index } type={ tab.type } />
                            </div>
                          )
                        }

                        {/* Default one */}
                        <div key={ -1 } className='col-md-3 cursor-pointer' onClick={ this.chooseAvatar } data-id={ -1 }>
                          <AvatarPreview index={ -1 } type={ tab.type } />
                        </div>
                      </div>
                    )
                  }
                </div>
              </div>

              <div className='row selection-section'>
                <div className='form-inline div-inline-block displayname-section'>
                  <div className='form-group'>
                    { this.renderUsername(username) }
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
    modalWindows: state.modalWindows,
    colours: state.chat.session.colours,
    session: state.chat.session,
    currentUser: state.members.currentUser,
    channel: state.chat.channel
  }
};

export default connect(mapStateToProps)(ChangeAvatarModal);
