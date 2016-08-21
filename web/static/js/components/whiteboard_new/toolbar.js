import React from 'react';
import { ButtonToolbar } from 'react-bootstrap';

import Hand from './toolbar/hand';
import Forms from './toolbar/forms';
import Poly from './toolbar/poly';
import Width from './toolbar/width';

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
    self.drawData.strokeWidth = value;
    this.forceUpdate();
  },
  render() {
    const params = {
      setType: this.setType,
      getClassnameParent: this.getClassnameParent,
      activeType: this.state.activeType
    };

    return (
      <ButtonToolbar className='row panel-buttons-section'>
        <div className='col-md-offset-4'>
          <Hand { ...params } />
          <Forms { ...params } />
          <Poly { ...params } />
          <Width strokeWidth={ self.drawData.strokeWidth } setWidth={ this.setWidth } />
        </div>
      </ButtonToolbar>
    )
  }
});

export default {
  Buttons,
  init
};
