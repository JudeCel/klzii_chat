import React from 'react';
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
    this.props.setType(this.state.buttonType, shapeType);
  },
  render() {
    const buttons = [
      { id: 'circleEmpty',  className: 'btn btn-default fa fa-circle-o' },
      { id: 'circleFilled', className: 'btn btn-default fa fa-circle'   },
      { id: 'rectEmpty',    className: 'btn btn-default fa fa-square-o' },
      { id: 'rectFilled',   className: 'btn btn-default fa fa-square'   }
    ];

    return (
      <OverlayTrigger ref='forms' trigger='click' rootClose placement='top' overlay={
          <Popover id='wb-buttons-forms'>
            {
              buttons.map((object, index) =>
                <i key={ index } className={ this.getClassnameChild(object.id) + object.className } aria-hidden='true' onClick={ this.setActiveButton.bind(this, object.id) } />
              )
            }
            {/* <Buttons.Forms.Image { ...params } /> */}
          </Popover>
        }>

        <Button className={ this.props.getClassnameParent(this.state.buttonType) }><i className='fa fa-star' aria-hidden='true' /></Button>
      </OverlayTrigger>
    )
  }
});

export default ButtonsForms;
