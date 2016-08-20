import React from 'react';
import { ButtonToolbar } from 'react-bootstrap';

import Hand from './buttons/hand';
import Forms from './buttons/forms';
import Poly from './buttons/poly';
import Width from './buttons/width';

const Buttons = React.createClass({
  getInitialState() {
    return { activeType: 'none' };
  },
  getClassnameParent(buttonType) {
    return this.state.activeType == buttonType ? 'set-active ' : '';
  },
  setType(buttonType) {
    this.setState({ activeType: buttonType });
  },
  render() {
    const params = {
      setType: this.setType,
      getClassnameParent: this.getClassnameParent
    };

    return (
      <ButtonToolbar className='row panel-buttons-section'>
        <div className='col-md-offset-4'>
          <Hand { ...params } />
          <Forms { ...params } />
          <Poly { ...params } />
          <Width />
        </div>
      </ButtonToolbar>
    )
  }
});

export default Buttons;
