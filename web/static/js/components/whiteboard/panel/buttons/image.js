import React, {PropTypes} from 'react';
import { connect }        from 'react-redux';
import mixins             from '../../../../mixins';

const ImageButton = React.createClass({
  mixins: [mixins.modalWindows, mixins.validations],
  onSelect(url) {
    this.closeAllModals();
    this.props.changeButton({ data: { mode: 'image', url: url.full } });
  },
  onClick() {
    this.openSpecificModal('whiteboardImage', { select: this.onSelect, type: 'image' });
    this.props.parent.hide();
  },
  render() {
    if(this.hasPermission(['whiteboard', 'can_add_image'])) {
      return (
        <i className={ this.props.activeClass('image') + 'btn btn-default fa fa-file-image-o' } aria-hidden='true' onClick={ this.onClick } />
      )
    }else {
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

export default connect(mapStateToProps)(ImageButton);
