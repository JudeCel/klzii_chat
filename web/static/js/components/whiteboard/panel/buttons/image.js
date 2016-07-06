import React, {PropTypes} from 'react';
import { connect }        from 'react-redux';
import mixins             from '../../../../mixins';

const ImageButton = React.createClass({
  mixins: [mixins.modalWindows],
  onSelect(url) {
    this.closeAllModals();
    this.props.changeButton({ data: { mode: 'image', url: url.full } });
  },
  onClick() {
    this.openSpecificModal('whiteboardImage', { select: this.onSelect, type: 'image' });
    this.props.parent.hide();
  },
  render() {
    return (
      <i className={ this.props.activeClass('image') + 'btn btn-default fa fa-file-image-o' } aria-hidden='true' onClick={ this.onClick } />
    )
  }
});

const mapStateToProps = (state) => {
  return {
    modalWindows: state.modalWindows
  }
};

export default connect(mapStateToProps)(ImageButton);
