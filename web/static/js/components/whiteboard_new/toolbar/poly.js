import React from 'react';
import Buttons from './buttons';
import { OverlayTrigger, Button, Popover } from 'react-bootstrap';

const ButtonsPoly = React.createClass({
  getInitialState() {
    return { activeButton: null, buttonType: 'poly' };
  },
  getClassnameChild(shapeType) {
    const { buttonType, activeButton } = this.state;
    return this.props.activeType == buttonType && activeButton == shapeType ? 'set-active ' : '';
  },
  setActiveButton(shapeType) {
    this.refs.poly.hide();
    this.setState({ activeButton: shapeType });
    this.props.setType(this.state.buttonType);
  },
  render() {
    const params = {
      getClassnameChild: this.getClassnameChild,
      setActiveButton: this.setActiveButton,
    };

    return (
      <OverlayTrigger ref='poly' trigger='click' rootClose placement='top' overlay={
          <Popover id='wb-buttons-poly'>
            <Buttons.Poly.ScribbleEmpty { ...params } />
            <Buttons.Poly.ScribbleFilled { ...params } />
            <Buttons.Poly.Line { ...params } />
            <Buttons.Poly.Arrow { ...params } />
            {/* <Buttons.Poly.Text { ...params } /> */}
          </Popover>
        }>

        <Button className={ this.props.getClassnameParent(this.state.buttonType) }><i className='fa fa-pencil' aria-hidden='true' /></Button>
      </OverlayTrigger>
    )
  }
});

export default ButtonsPoly;
