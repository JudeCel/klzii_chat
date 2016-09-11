import React from 'react';
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
    this.props.setType(this.state.buttonType, shapeType);
  },
  render() {
    const buttons = [
      { id: 'scribbleEmpty',  className: 'btn btn-default fa fa-paint-brush' },
      { id: 'scribbleFilled', className: 'btn btn-default fa fa-leaf'        },
      { id: 'line',           className: 'btn btn-default fa fa-minus'       },
      { id: 'arrow',          className: 'btn btn-default fa fa-arrow-right' }
    ];

    return (
      <OverlayTrigger ref='poly' trigger='click' rootClose placement='top' overlay={
          <Popover id='wb-buttons-poly'>
            {
              buttons.map((object, index) =>
                <i key={ index } className={ this.getClassnameChild(object.id) + object.className } aria-hidden='true' onClick={ this.setActiveButton.bind(this, object.id) } />
              )
            }
            {/* <Buttons.Poly.Text { ...params } /> */}
          </Popover>
        }>

        <Button className={ this.props.getClassnameParent(this.state.buttonType) }><i className='fa fa-pencil' aria-hidden='true' /></Button>
      </OverlayTrigger>
    )
  }
});

export default ButtonsPoly;
