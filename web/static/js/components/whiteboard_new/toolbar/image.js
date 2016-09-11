import React       from 'react';
import { connect } from 'react-redux';
import mixins      from '../../../mixins';

const ButtonsImage = React.createClass({
  mixins: [mixins.modalWindows, mixins.validations],
  getInitialState() {
    return { buttonType: 'image' };
  },
  onSelect(url) {
    this.closeAllModals();
    this.props.setImage(this.state.buttonType, url.full);
  },
  onClick() {
    this.openSpecificModal('whiteboardImage', { select: this.onSelect, type: 'image' });
  },
  render() {
    if(this.hasPermission(['whiteboard', 'can_add_image'])) {
      return (
        <button className={ this.props.getClassnameParent(this.state.buttonType) + 'btn btn-default' } onClick={ this.onClick }>
          <i className='fa fa-file-image-o' aria-hidden='true' />
        </button>
      )
    }
    else {
      return(false)
    }
  }
});

const mapStateToProps = (state) => {
  return {
    currentUser: state.members.currentUser,
    modalWindows: state.modalWindows
  }
};

export default connect(mapStateToProps)(ButtonsImage);
