import React          from 'react';
import whiteboard     from '../../whiteboard' ;
import OnParticipants from '../../whiteboard/onParticipants' ;
import Raphael        from 'webpack-raphael' ;
window.Raphael = Raphael;
require('../../whiteboard/scale.raphael') ;
require('../../whiteboard/raphael.free_transform') ;

const Whiteboard =  React.createClass({
  componentWillMount() {
    window.sendMessage = function (json) {
    //	make sure we have enough information
      if (isEmpty(json)) return;
      if (isEmpty(json.type)) return;

      if (isEmpty(json.message)) {
        // socket.emit(json.type);					//	don't need to pass any arguments
      } else {
        if (isEmpty(json.all)) {
          // socket.emit(json.type, json.message);
        } else {
          // socket.emit(json.type, json.message, json.all);
        }
      }
    };
    window.currentUser = this.props.currentUser;
    window.currentUser.colour = "66666"
    window.role = this.props.currentUser.role;
    window.WHITEBOARD_MODE_NONE = 0;
    window.WHITEBOARD_MODE_MOVE = 1,				//	we can move objects
    window.WHITEBOARD_MODE_SCALE = 2;				//	we can delete objects
    window.WHITEBOARD_MODE_ROTATE = 3;				//	we can delete objects
    window.WHITEBOARD_MODE_DELETE = 10;
    window.BROWSER_BACKGROUND_COLOUR = '#def1f8',
    window.BACKGROUND_COLOUR = '#ffffff',
    window.BORDER_COLOUR = '#e51937',
    window.WHITEBOARD_BACKGROUND_COLOUR = '#e1d8d8',
    window.WHITEBOARD_BORDER_COLOUR = '#a4918b',
    window.WHITEBOARD_ICON_BACKGROUND_COLOUR = '#408ad2',
    window.WHITEBOARD_ICON_BORDER_COLOUR = '#a4918b',
    window.MENU_BACKGROUND_COLOUR = '#679fd2',
    window.MENU_BORDER_COLOUR = '#043a6b',
    window.ICON_COLOUR = '#e51937',
    window.TEXT_COLOUR = '#e51937',
    window.LABEL_COLOUR = '#679fd2',
    window.BUTTON_BACKGROUND_COLOUR = '#a66500',
    window.BUTTON_BORDER_COLOUR = '#ffc973';
    window.whiteboardSmall = {
      width: 316,
      height: 153
    };

    window.whiteboardLarge = {
      width: 950,
      height: 460
    };
    window.whiteboardSetup = "drawing";
    window.um = new sf.ifs.View.UndoManager();
    window.whiteboardMode =  window.WHITEBOARD_MODE_NONE;
    window.buildWhiteboard = null;
    window.Raphael = Raphael
  },
  componentDidMount(){
    window.paperWhiteboard = Raphael("whiteboard");
    window.paperCanvas = ScaleRaphael("canvas", 950, 460);
    window.paperExpand = Raphael("expand");
    window.paperShrink = Raphael("shrink");
    window.paperTextbox = Raphael("textbox");
    window.paperTextboxHTML = Raphael("textbox-html");
    window.paperTitleWhiteboard = Raphael("title-whiteboard");

    window.whiteboard = document.getElementById('whiteboard');
    OnParticipants()
  },
  onExpandClick(e){
    window.whiteboard.json.onClick('expand');
  },
  onShrinkClick(e){
    window.whiteboard.json.onClick('shrink');
  },
  render() {
    return (
      <div id="canvas_container">
        <div id="textbox"
         style={{
          zIndex: -3,
          position: "absolute",
          left: "0px",
          top: "0px",
          width: "1000px",
          height: "656px",
          margin: 0
         }}>
          <div id="textbox-html"
             style={{
              display: "block",
              position: "relative",
              left: "180px",
              top: "-500px",
              width: "640px",
              height: "300px",
              margin: 0
            }}>
            <div id="textbox-inner-html"
                 style={{
                  display: "block",
                  position: "relative",
                  left: "0px",
                  top: "-400px",
                  width: "0px",
                  height: "0px",
                  margin: 0
                }}></div>
             </div>
        </div>
        <div id="title-whiteboard"
          style={{
            zIndex: 1,
            position: "absolute",
            left: "368px",
            top: "82px",
            width: "85px",
            height: "30px",
            argin: 0
          }}>
        </div>
        <div id="expand"
         style={{zIndex: 1,
            position: "absolute",
            left: "624px",
            top: "79px",
            width: "36px",
            height: "36px",
            margin: 0
          }}>
        </div>
       <div id="shrink"
         style={{
          zIndex: 3,
          position: "absolute",
          left: "900px",
          top: "62px",
          width: "51px",
          height: "51px",
          margin: "0"
        }}>
       </div>

        <div id="whiteboard"
          style={{zIndex: -1,
            position: 'absolute',
            left: '0px',
            top: '0px',
            width: '1000px',
            height: '646px',
            margin: 0
          }}>
          <div id="canvas"
            style={{
              position: 'absolute',
              left: "350px",
              top: "103px",
              width: "316px",
              height: "153px",
              margin: 0
            }}/>
        </div>
        <div id="expand"
          onClick={this.onExpandClick}
          style={{zIndex: 1,
            position: "absolute",
            left: "624px",
            top: "79px",
            width: "36px",
            height: "36px",
            margin: 0
          }}>
        </div>
        <div id="shrink"
          onClick={this.onShrinkClick}
          style={{
            zIndex: 3,
            position: "absolute",
            left: "900px",
            top: "62px",
            width: "51px",
            height: "51px",
            margin: 0
          }}>
        </div>
      </div>
    );
  }
})
export default Whiteboard;
