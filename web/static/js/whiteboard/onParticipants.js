module.exports = init;

var getExpandWhiteboardPath = function() {
	return "M1.999,2.332v26.499H28.5V2.332H1.999zM26.499,26.832H4V12.5h8.167V4.332h14.332V26.832zM15.631,17.649l5.468,5.469l-1.208,1.206l5.482,1.469l-1.47-5.481l-1.195,1.195l-5.467-5.466l1.209-1.208l-5.482-1.469l1.468,5.48L15.631,17.649z";
};

var getShrinkWhiteboardPath = function() {
	return getExpandWhiteboardPath();
};

var getWhiteboardJSON = function(size) {
  var result = null;
  switch(size) {
    case "small": {
      if (!isEmpty(window.whiteboard)) {
        if (!isEmpty(window.whiteboard.paint)) {
          window.whiteboard.paint.paint.toBack();
        }
      }
      result = {
        enabled: true,			//	default false
        showControls: false,	//	default false
        scale: (window.whiteboardSmall.width / window.whiteboardLarge.width),		//	default 1.0
        actualScale: 1.0,
        onClick: whiteboardClick,
        zIndex: -1,
        board: {
          strokeWidth: 1,
          radiusInner: 5,
          radiusOuter: 10,
          paper:	paperWhiteboard
        },
        canvas: {
          x: 350,
          y: 103,
          width: window.whiteboardSmall.width,
          height: window.whiteboardSmall.height,
          paper:	paperCanvas
        },
        icon: {
          paper:	paperExpand
        },
        window: window
      }
    }
    break;
    case "large": {
      result = {
        enabled: true,			//	default false
        showControls: true,	//	default false
        scale: (window.whiteboardSmall.width / window.whiteboardLarge.width),
        actualScale: (window.whiteboardSmall.width / window.whiteboardLarge.width),
        onClick: whiteboardClick,
        zIndex: 2,
        board: {
          strokeWidth: 2,
          radiusInner: 9,
          radiusOuter: 18,
          paper:	paperWhiteboard
        },
        canvas: {
          x: 26,
          y: 100,
          width: window.whiteboardLarge.width,
          height: window.whiteboardLarge.height,
          paper:	paperCanvas
        },
        icon: {
          paper:	paperShrink
        },
        window: window
      }
    }
    break;
  }

  return result;
}

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
var whiteboardClick = function(direction) {
  var jsonWhiteboard = null;
  switch(direction) {
    case "shrink": {
      jsonWhiteboard = getWhiteboardJSON("small");
    }
    break;
    case "expand": {
      jsonWhiteboard = getWhiteboardJSON("large");
    }
    break;
  }

  if (jsonWhiteboard) {
    window.whiteboard.updateJSON(jsonWhiteboard);
    window.whiteboard.draw();
  }

  window.whiteboard.paint.setCursor("default");
}

// // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
// //	[G]	lets draw our white board (small)
function init() {
  var jsonWhiteboard = getWhiteboardJSON("small");
  window.whiteboard = new sf.ifs.View.Whiteboard(jsonWhiteboard);
  window.whiteboard.draw();
}

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
var getExpandWhiteboard = function(paper, x, y, radius) {
  var result = paper.set();

  //var background = paper.rect(x - 10, y - 10, radius, radius).attr({fill: "#ffd9dc", "stroke-opacity": 0});	//	red
  var background = paper.rect(x - 10, y - 10, radius, radius).attr({fill: "#e0ffe2", "stroke-opacity": 0});	//	green
  var icon = paper.path(getExpandWhiteboardPath).attr({fill: "#3f3f3f", stroke: "#7f7f7f", "stroke-width": 1});
  icon.transform("t" + (x - (radius / 2)) + "," + (y - (radius / 2)));

  result.push(background);
  result.push(icon);

  result.attr({title: "Maximise the Whiteboard"});

  return result;
}
