import React, {PropTypes} from 'react';
import { connect }        from 'react-redux';
import mixins             from '../../../../mixins';

const TextButton = React.createClass({
  mixins: [mixins.modalWindows],
  onClick() {
    this.props.setActiveParent();
    this.openSpecificModal('whiteboardText');
  },
  render() {
    return (
      <i className={ this.props.activeClass('text') + 'btn btn-default fa' } aria-hidden='true' onClick={ this.onClick }>ABC</i>
    )
  }
});

const mapStateToProps = (state) => {
  return {
    modalWindows: state.modalWindows
  }
};

export default connect(mapStateToProps)(TextButton);
