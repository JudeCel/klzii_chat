const touchHandler = {
  processInput(event) {
    if (this.state.zoomEnabled) {
      return;
    }
    let touches = event.changedTouches;
    let type = "";
    if (touches) {
      let first = touches[0];
      switch(event.type)
      {
      case "touchstart": type = "mousedown"; break;
      case "touchmove":  type = "mousemove"; break;
      case "touchend":
      case "touchcancel":
      default:
        type = "mouseup";
        break;
      }

      if (touches.length == 1) {
        let simulatedEvent = document.createEvent("MouseEvent");
        let x = first.clientX;
        let y = first.clientY;

        simulatedEvent.initMouseEvent(type, true, true, window, 1,
          x, y,
          x , y, false,
          false, false, false, 1, null);
        event.target.dispatchEvent (simulatedEvent);
      }
      event.preventDefault();
    }
  }
}

export default touchHandler;
