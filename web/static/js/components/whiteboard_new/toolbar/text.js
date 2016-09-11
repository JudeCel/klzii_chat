import React       from 'react';
import { connect } from 'react-redux';
import mixins      from '../../../mixins';

const ButtonsText = React.createClass({
  mixins: [mixins.modalWindows],
  getInitialState() {
    return { buttonType: 'text' };
  },
  onSelect(text) {
    this.closeAllModals();
    this.props.setText(this.state.buttonType, text);
  },
  onClick() {
    this.openSpecificModal('whiteboardText', { select: this.onSelect });
  },
  render() {
    return (
      <button className={ this.props.getClassnameParent(this.state.buttonType) + 'btn btn-default' } onClick={ this.onClick }>
        <i className='fa fa-font' aria-hidden='true' />
      </button>
    )
  }
});

const mapStateToProps = (state) => {
  return {
    modalWindows: state.modalWindows
  }
};

export default connect(mapStateToProps)(ButtonsText);
