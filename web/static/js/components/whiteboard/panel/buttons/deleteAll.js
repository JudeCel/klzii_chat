import React, {PropTypes} from 'react';

const DeleteAllButton = React.createClass({
  deleteAll() {
    var message = {
      action: "deleteAll"
    };
    var messageJSON = {
      eventType: 'deleteAll',
      message: message
    };
    this.sendMessage(messageJSON);
    undoHistoryFactory.addStepToUndoHistory(this.addAllDeletedObjectsToHistory(this.shapes));
  },
  addAllDeletedObjectsToHistory(shapes) {
    let objects = [];
    let self = this;
    Object.keys(shapes).forEach(function(key, index) {
      let element = shapes[key];
      if (element) {
        objects.push(self.prepareMessage(element, "delete"));
      }
    });
    return objects;
  },
  onClick() {
    // this.props.changeButton({ mode: 'deleteActive' });
  },
  render() {
    return (
      <i className='btn btn-default fa fa-eraser' aria-hidden='true' onClick={ this.onClick } />
    )
  }
});

export default DeleteAllButton;
