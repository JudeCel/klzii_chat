import React from 'react';
import ToolbarButtons from './toolbar/index';
import { ButtonToolbar, Tooltip } from 'react-bootstrap';

var self;
function init(data) {
  self = data;
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
    self.drawData.current = shapeType;

    if(buttonType == 'none') {
      self.deps.Shape.setMouseType('select');
    }
    else {
      self.deps.Shape.deselectShape();
      self.deps.Shape.setMouseType('draw');
    }
  },
  setWidth(value) {
    if(self.mouseData.selected) {
      self.mouseData.selected.stroke({ width: value, color: self.props.currentUser.colour });
      self.deps.Actions.shapeUpdate(self.deps.Helpers.shapeParams(self.mouseData.selected));
    }
    self.drawData.strokeWidth = value;
    this.forceUpdate();
  },
  setHistory(type) {
    let action = self.deps.History[type];
    action();
  },
  setDelete(all) {
    if(all) {
      self.deps.History.add(self.shapeData.added, 'removeAll');
      self.deps.Actions.shapeDeleteAll();
    }
    else {
      self.deps.History.add(self.mouseData.selected, 'remove');
      self.deps.Actions.shapeDelete(self.mouseData.selected);
    }
  },
  setImage(type, url) {
    this.setType(type, type);
    self.drawData.imageUrl = url;
  },
  setText(type, text) {
    this.setType(type, type);
    self.drawData.text = text;
    self.createShapeWithDefaultCoords();
    this.setType('none', 'none');
  },
  tooltipFormat(text) {
    return <Tooltip id='tooltip'><strong>{ text }</strong></Tooltip>
  },
  render() {
    const params = {
      setType: this.setType,
      setImage: this.setImage,
      setText: this.setText,
      setDelete: this.setDelete,
      setHistory: this.setHistory,
      setWidth: this.setWidth,
      strokeWidth: self.drawData.strokeWidth,
      getClassnameParent: this.getClassnameParent,
      tooltipFormat: this.tooltipFormat,
      activeType: this.state.activeType
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
