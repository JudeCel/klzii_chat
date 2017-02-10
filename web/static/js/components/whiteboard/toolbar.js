import React from 'react';
import ToolbarButtons from './toolbar/index';
import { ButtonToolbar, Tooltip } from 'react-bootstrap';

var whiteboardDelegate;
function init(data) {
  whiteboardDelegate = data;
  return this;
}

const Buttons = React.createClass({
  getInitialState() {
    return { activeType: 'none' };
  },
  getClassnameParent(buttonType) {
    return this.state.activeType == buttonType ? 'set-active ' : '';
  },
  setType(buttonType, shapeType) {
    this.setState({ activeType: buttonType });
    whiteboardDelegate.drawData.current = shapeType;
    whiteboardDelegate.zoomEnabled(buttonType == 'zoom');

    if(buttonType == 'none') {
      whiteboardDelegate.deps.Shape.setMouseType('select');
    }
    else {
      whiteboardDelegate.deps.Shape.deselectShape();
      whiteboardDelegate.deps.Shape.setMouseType('draw');
    }
  },
  setWidth(value) {
    if(whiteboardDelegate.mouseData.selected) {
      whiteboardDelegate.mouseData.selected.stroke({ width: value, color: whiteboardDelegate.props.currentUser.colour });
      whiteboardDelegate.deps.Actions.shapeUpdate(whiteboardDelegate.deps.Helpers.shapeParams(whiteboardDelegate.mouseData.selected));
    }
    whiteboardDelegate.drawData.strokeWidth = value;
    this.forceUpdate();
  },
  setHistory(type) {
    let action = whiteboardDelegate.deps.History[type];
    action();
  },
  setDelete(all) {
    if(all) {
      whiteboardDelegate.deps.History.add(whiteboardDelegate.shapeData.added, 'removeAll');
      whiteboardDelegate.deps.Actions.shapeDeleteAll();
    }
    else if (whiteboardDelegate.mouseData.selected){
      whiteboardDelegate.deps.History.add(whiteboardDelegate.mouseData.selected, 'remove');
      whiteboardDelegate.deps.Actions.shapeDelete(whiteboardDelegate.mouseData.selected);
    }
  },
  setImage(type, url) {
    this.setType(type, type);
    whiteboardDelegate.drawData.imageUrl = url;
    whiteboardDelegate.deps.Shape.createShapeWithDefaultCoords();
    this.setType('none', 'none');
  },
  setText(type, text) {
    this.setType(type, type);
    whiteboardDelegate.drawData.text = text;
    whiteboardDelegate.deps.Shape.createShapeWithDefaultCoords();
    this.setType('none', 'none');
  },
  tooltipFormat(text) {
    return <Tooltip id='tooltip'><strong>{ text }</strong></Tooltip>
  },
  zoomIn(shouldZoomin) {
    whiteboardDelegate.zoom(shouldZoomin);
  },
  zoomRestore(shouldZoomin) {
    whiteboardDelegate.resetZoom();
  },
  render() {
    const params = {
      setType: this.setType,
      setImage: this.setImage,
      setText: this.setText,
      setDelete: this.setDelete,
      setHistory: this.setHistory,
      setWidth: this.setWidth,
      strokeWidth: whiteboardDelegate.drawData.strokeWidth,
      getClassnameParent: this.getClassnameParent,
      tooltipFormat: this.tooltipFormat,
      activeType: this.state.activeType,
      zoomIn: this.zoomIn,
      zoomRestore: this.zoomRestore
    };

    return (
      <ButtonToolbar className='row panel-buttons-section'>
        <span className='toolbar-section'>
          <ToolbarButtons.Hand    { ...params } />
          <ToolbarButtons.Forms   { ...params } />
          <ToolbarButtons.Poly    { ...params } />
          <ToolbarButtons.Image   { ...params } />
          <ToolbarButtons.Text    { ...params } />
          <ToolbarButtons.Width   { ...params } />
          <ToolbarButtons.Delete  { ...params } />
          <ToolbarButtons.Zoom    { ...params } />
          <ToolbarButtons.History { ...params } />
        </span>
      </ButtonToolbar>
    )
  }
});

export default {
  Buttons,
  init
};
