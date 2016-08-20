import React from 'react';
import Shapes from './shapes';
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
            <Shapes.Poly.ScribbleEmpty { ...params } />
            <Shapes.Poly.ScribbleFilled { ...params } />
            <Shapes.Poly.Line { ...params } />
            <Shapes.Poly.Arrow { ...params } />
            {/* <Shapes.Image { ...params } /> */}
          </Popover>
        }>

        <Button className={ this.props.getClassnameParent(this.state.buttonType) }><i className='fa fa-pencil' aria-hidden='true' /></Button>
      </OverlayTrigger>
    )
  }
});

export default ButtonsPoly;
