import React, {PropTypes} from 'react';
import { ButtonToolbar, OverlayTrigger, Button, Popover }    from 'react-bootstrap'
import PopoverButtons            from './buttons';

const ButtonPanel = React.createClass({
  getInitialState() {
    return { active: 'none' };
  },
  setActive(value) {
    this.setState({ active: value });
  },
  parentActiveClass(value) {
    return this.state.active == value ? 'set-active ' : '';
  },
  popoverActiveClass(mode) {
    return this.props.enum[mode] == this.props.mode ? 'set-active ' : '';
  },
  paramsForChild(parent) {
    return {
      changeButton: this.props.changeButton,
      activeClass: this.popoverActiveClass,
      setActiveParent: this.setActive.bind(this, parent)
    };
  },
  render() {
    const strokeWidthArray = [2, 4, 6];
    let params = {
      circle: this.paramsForChild('circleShapes'),
      scribble: this.paramsForChild('scribleShapes'),
      lineWidth: this.paramsForChild('lineWidthShapes'),
      eraser: this.paramsForChild('eraserShapes'),
    };

    return (
      <ButtonToolbar className='row panel-buttons-section'>
        <div className='col-md-offset-4'>
          <OverlayTrigger trigger='click' rootClose placement='top' overlay={
              <Popover id='circleShapes'>
                <PopoverButtons.EmptyCircle { ...params.circle } />
                <PopoverButtons.FilledCircle { ...params.circle } />
                <PopoverButtons.EmptyRect { ...params.circle } />
                <PopoverButtons.FilledRect { ...params.circle } />

                {/*<i className={this.toolStyle(this.ModeEnum.image)+" fa fa-file-image-o"} aria-hidden="true" onClick={this.prepareImage}></i>*/}
              </Popover>
            }>

            <Button className={ this.parentActiveClass('circleShapes') }><i className='fa fa-star' aria-hidden='true' /></Button>
          </OverlayTrigger>

          <OverlayTrigger trigger='click' rootClose placement='top' overlay={
              <Popover id='scribleShapes'>
                <PopoverButtons.EmptyScribble { ...params.scribble } />
                <PopoverButtons.FilledScribble { ...params.scribble } />
                <PopoverButtons.Line { ...params.scribble } />
                <PopoverButtons.Arrow { ...params.scribble } />
                <PopoverButtons.Text { ...params.scribble } />
              </Popover>
            }>

            <Button className={ this.parentActiveClass('scribleShapes') }><i className='fa fa-pencil' aria-hidden='true' /></Button>
          </OverlayTrigger>

          <OverlayTrigger trigger='click' rootClose placement='top' overlay={
              <Popover id='lineWidthShapes'>
                {
                  strokeWidthArray.map((value) =>
                    <PopoverButtons.StrokeWidth key={ value } { ...params.lineWidth } width={ value } />
                  )
                }
              </Popover>
            }>

            <Button className='normal'><i className='fa fa-cog' aria-hidden='true' /></Button>
          </OverlayTrigger>

          <OverlayTrigger trigger='click' rootClose placement='top' overlay={
              <Popover id='eraserShapes'>
                <PopoverButtons.DeleteActive { ...params.eraser } />
                <PopoverButtons.DeleteAll { ...params.eraser } />
              </Popover>
            }>

            <Button className='normal'><i className='fa fa-eraser' aria-hidden='true'/></Button>
          </OverlayTrigger>

          <PopoverButtons.StepUndo { ...this.paramsForChild() } />
          <PopoverButtons.StepRedo { ...this.paramsForChild() } />
          <PopoverButtons.TextModal { ...this.paramsForChild() } />
        </div>
      </ButtonToolbar>
    )
  }
});

export default ButtonPanel;
