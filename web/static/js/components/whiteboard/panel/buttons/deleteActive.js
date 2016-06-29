import React, {PropTypes} from 'react';

const DeleteActiveButton = React.createClass({
  deleteActive() {
    if (this.activeShape && this.activeShape.permissions.can_delete) {
      let message = this.prepareMessage(this.activeShape, "delete");
      undoHistoryFactory.addStepToUndoHistory(message);

      this.sendObjectData('delete');
      this.activeShape.ftRemove();
      this.shapes[this.activeShape.id] = null;
      this.activeShape = null;
    }
  },
  onClick() {
    // this.props.changeButton({ mode: 'deleteActive' });
  },
  render() {
    return (
      <i className='btn btn-default fa fa-eraser' aria-hidden='true' onClick={ this.onClick }>*</i>
    )
  }
});

export default DeleteActiveButton;
