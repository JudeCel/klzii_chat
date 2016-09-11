import React from 'react';
import { ButtonToolbar } from 'react-bootstrap';

import Hand    from './toolbar/hand';
import Forms   from './toolbar/forms';
import Poly    from './toolbar/poly';
import Width   from './toolbar/width';
import Delete  from './toolbar/delete';
import History from './toolbar/history';
import Image   from './toolbar/image';

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
  render() {
    const params = {
      setType: this.setType,
      setImage: this.setImage,
      getClassnameParent: this.getClassnameParent,
      activeType: this.state.activeType
    };

    return (
      <ButtonToolbar className='row panel-buttons-section'>
        <div className='col-md-offset-4'>
          <Hand { ...params } />
          <Forms { ...params } />
          <Poly { ...params } />
          <Image { ...params } />
          <Width strokeWidth={ self.drawData.strokeWidth } setWidth={ this.setWidth } />
          <Delete setDelete={ this.setDelete } />
          <History setHistory={ this.setHistory } />
        </div>
      </ButtonToolbar>
    )
  }
});

export default {
  Buttons,
  init
};
