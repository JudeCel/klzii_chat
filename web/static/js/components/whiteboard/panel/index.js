import React, {PropTypes} from 'react';
import { connect }        from 'react-redux';
import { ButtonToolbar, OverlayTrigger, Button, Popover }    from 'react-bootstrap'
// import mixins             from '../../../mixins';
import PopoverButtons            from './buttons';

const ButtonPanel = React.createClass({
  // mixins: [mixins.validations, mixins.modalWindows],
  render() {
    const strokeWidthArray = [2, 4, 6];
    const { changeButton } = this.props;

    return (
      <ButtonToolbar className='row panel-buttons-section'>
        <div className='col-md-offset-4'>
          <OverlayTrigger trigger='click' rootClose placement='top' overlay={
              <Popover id='circleShapes'>
                <PopoverButtons.EmptyCircle changeButton={ changeButton } />
                <PopoverButtons.FilledCircle changeButton={ changeButton } />
                <PopoverButtons.EmptyRect changeButton={ changeButton } />
                <PopoverButtons.FilledRect changeButton={ changeButton } />

                {/*<i className={this.toolStyle(this.ModeEnum.image)+" fa fa-file-image-o"} aria-hidden="true" onClick={this.prepareImage}></i>*/}
              </Popover>
            }>

            <Button><i className='fa fa-star' aria-hidden='true' /></Button>
          </OverlayTrigger>

          <OverlayTrigger trigger='click' rootClose placement='top' overlay={
              <Popover id='scribleShapes'>
                <PopoverButtons.EmptyScribble changeButton={ changeButton } />
                <PopoverButtons.FilledScribble changeButton={ changeButton } />
                <PopoverButtons.Line changeButton={ changeButton } />
                <PopoverButtons.Arrow changeButton={ changeButton } />
                <PopoverButtons.Text changeButton={ changeButton } />
              </Popover>
            }>

            <Button><i className='fa fa-pencil' aria-hidden='true' /></Button>
          </OverlayTrigger>

          <OverlayTrigger trigger='click' rootClose placement='top' overlay={
              <Popover id='lineWidthShapes'>
                {
                  strokeWidthArray.map((value) =>
                    <PopoverButtons.StrokeWidth key={ value } changeButton={ changeButton } width={ value } />
                  )
                }
              </Popover>
            }>

            <Button><i className='fa fa-cog' aria-hidden='true' /></Button>
          </OverlayTrigger>

          <OverlayTrigger trigger='click' rootClose placement='top' overlay={
              <Popover id='eraserShapes'>
                <PopoverButtons.DeleteActive />
                <PopoverButtons.DeleteAll />
              </Popover>
            }>

            <Button><i className='fa fa-eraser' aria-hidden='true'/></Button>
          </OverlayTrigger>

          <PopoverButtons.StepUndo />
          <PopoverButtons.StepRedo />
        </div>
      </ButtonToolbar>
    )
  }
});

const mapStateToProps = (state) => {
  return {

  }
};

export default connect(mapStateToProps)(ButtonPanel);
