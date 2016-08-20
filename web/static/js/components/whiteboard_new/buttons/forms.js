import React from 'react';
import Shapes from './shapes';
import { OverlayTrigger, Button, Popover } from 'react-bootstrap';

const ButtonsForms = React.createClass({
  getInitialState() {
    return { activeButton: null, buttonType: 'forms' };
  },
  getClassnameChild(shapeType) {
    const { buttonType, activeButton } = this.state;
    return this.props.activeType == buttonType && activeButton == shapeType ? 'set-active ' : '';
  },
  setActiveButton(shapeType) {
    this.refs.forms.hide();
    this.setState({ activeButton: shapeType });
    this.props.setType(this.state.buttonType);
  },
  render() {
    const params = {
      getClassnameChild: this.getClassnameChild,
      setActiveButton: this.setActiveButton,
    };

    return (
      <OverlayTrigger ref='forms' trigger='click' rootClose placement='top' overlay={
          <Popover id='wb-buttons-forms'>
            <Shapes.Forms.CircleEmpty { ...params } />
            <Shapes.Forms.CircleFilled { ...params } />
            <Shapes.Forms.RectEmpty { ...params } />
            <Shapes.Forms.RectFilled { ...params } />
            {/* <Shapes.Image { ...params } /> */}
          </Popover>
        }>

        <Button className={ this.props.getClassnameParent(this.state.buttonType) }><i className='fa fa-star' aria-hidden='true' /></Button>
      </OverlayTrigger>
    )
  }
});

export default ButtonsForms;
