
(function() {
	var lineAttributes = { stroke: 'red', strokeWidth: 2, strokeDasharray: "5,5" };
	var startDragTarget, startDragElement, startBBox, startScreenCTM;
	Snap.plugin( function( Snap, Element, Paper, global  ) {

		var ftOption = {
			handleFill: "#c0c0c0",
			handleStrokeDash: "5,5",
			handleStrokeWidth: "2",
			handleLength: "75",
			handleRadius: "7",
			handleLineWidth: 2,
		};
		Element.prototype.ftRemove = function(c) {
			this.ftRemoveHandles();
			this.unclick();
			this.onSelected = null;
			this.onTransformed = null;
			this.onFinishTransform = null;
			this.remove();
			this.removeData();
		}

		Element.prototype.ftSetupControls = function() {
			this.click( function() { this.ftCreateHandles();} ) ;
		}

		Element.prototype.ftUpdateRotateHandler = function() {
			var box = this.getBBox();
			var bb = getShapeSize(this);
			var splitParams = this.matrix.split();
			var rotation = rotateVector(bb.height/2, 0, splitParams.rotate -90);
			if (!this.rotateDragger) {
				this.rotateDragger = this.paper.image("/images/svgControls/rotate.png", box.cx + rotation[0], box.cy - rotation[1], ftOption.handleRadius*2, ftOption.handleRadius*2);
			} else {
				var dBox = this.translateDragger.getBBox();
				this.rotateDragger.attr('x', dBox.cx + rotation[0]);
				this.rotateDragger.attr('y', dBox.cy - rotation[1]);
			}
		}

		Element.prototype.ftCreateHandles = function() {
			if (this.setupDone) this.ftInit();
			var freetransEl = this;
			freetransEl.ftStoreInitialTransformMatrix();
			var bb = this.getBBox();
			var splitParams = this.matrix.split();

			var translateDragger = this.paper.image("/images/svgControls/move.png", bb.cx - ftOption.handleRadius, bb.cy - ftOption.handleRadius, ftOption.handleRadius*2, ftOption.handleRadius*2);
			this.data("angle", splitParams.rotate);
			this.translateDragger = translateDragger;
			this.ftUpdateRotateHandler();
			var rotateDragger = this.rotateDragger;

			this.initialWidth = bb.width/2;
			this.initialHeight = bb.height/2;
			var handlesGroup = this.paper.g( rotateDragger, translateDragger );

			createScaleControl(this.paper, this);
			this.setupDone = true;
			freetransEl.data( "handlesGroup", handlesGroup );

			freetransEl.data( "scaleFactor", Snap.calcDistance( bb.cx, bb.cy, rotateDragger.attr('x'), rotateDragger.attr('y') ) );
			translateDragger.drag( 	elementDragMove.bind(  translateDragger, freetransEl ),
						elementDragStart.bind( translateDragger, freetransEl ),
						elementDragEnd.bind( translateDragger, freetransEl ) );

			freetransEl.unclick();
			freetransEl.data("click", freetransEl.click( function() {
				this.ftRemoveHandles();
				this.ftInformSelected(this, false);
			} ) );


			rotateDragger.drag(
				dragHandleRotateMove.bind( rotateDragger, freetransEl ),
				dragHandleRotateStart.bind( rotateDragger, freetransEl  ),
				dragHandleRotateEnd.bind( rotateDragger, freetransEl  )
			);

			freetransEl.ftHighlightBB();
			this.ftInformSelected(this, true);
			return this;
		};

		Element.prototype.ftInformSelected = function(shape, selected) {
			if (shape.onSelected) {
				shape.onSelected(shape, selected);
			}
		}

		Element.prototype.ftUnselect = function() {
			this.ftRemoveHandles();
			if (this.onSelected) {
				this.onSelected(this, false);
			}
		}

		Element.prototype.ftInit = function() {
			this.data("angle", 0);
			this.data("scale", 1);

			this.data("tx", 0);
			this.data("ty", 0);
			return this;
		};

		Element.prototype.ftSetSelectedCallback = function(c) {
			this.onSelected = c;
		}

		Element.prototype.ftSetTransformedCallback = function(c) {
			this.onTransformed = c;
		}

		Element.prototype.ftSetFinishedTransformCallback = function(c) {
			this.onFinishTransform = c;
		}

		Element.prototype.ftCleanUp = function() {
			var myClosureEl = this;
			var myData = ["angle", "scale", "scaleFactor", "otx", "oty", "bb", "bbT", "initialTransformMatrix", "handlesGroup", "joinLine"];
			myData.forEach( function( el ) { myClosureEl.removeData([el]) });
			return this;
		};

		Element.prototype.ftStoreStartCenter = function() {
			this.data('ocx', this.attr('x') );
			this.data('ocy', this.attr('y') );
			return this;
		}

		Element.prototype.ftStoreInitialTransformMatrix = function() {
			this.data('initialTransformMatrix', this.transform() );
			this.data("tx", 0);
			this.data("ty", 0);
			return this;
		};

		Element.prototype.ftGetInitialTransformMatrix = function() {
			return this.data('initialTransformMatrix').localMatrix;
		};

		Element.prototype.ftGetInitialFullransformMatrix = function() {
			return this.data('initialTransformMatrix');
		};

		Element.prototype.ftRemoveHandles = function() {
			this.rotateDragger = null;
			this.unclick();
			if (this.data( "handlesGroup"))	this.data( "handlesGroup").remove();
			this.data( "bbT" ) && this.data("bbT").remove();
			this.data( "bb" ) && this.data("bb").remove();
			this.click( function() { this.ftCreateHandles() } ) ;
			if (this.scaleXControl) this.scaleXControl.remove();
			if (this.scaleYControl) this.scaleYControl.remove();
			this.ftCleanUp();
			return this;
		};

		Element.prototype.ftDrawJoinLine = function( handle ) {
			var lineAttributes = { stroke: ftOption.handleFill, strokeWidth: ftOption.handleStrokeWidth, strokeDasharray: ftOption.handleStrokeDash };

			var rotateHandle = handle.parent()[1];
			var thisBB = this.getBBox();
			var handleBB = handle.getBBox();

			var objtps = this.ftTransformedPoint( thisBB.cx, thisBB.cy);

			if( this.data("joinLine") ) {
				var x2 = 0, y2 = 0;
				if (rotateHandle) {
					x2 = handleBB.cx;
					y2 = handleBB.cy;
				}
				this.data("joinLine").attr({ x1: objtps.x, y1: objtps.y, x2: x2, y2: y2 });
			} else {
				return this.paper.line( thisBB.cx, thisBB.cy, handleBB.cx, handleBB.cy ).attr( lineAttributes );
			};
			return this;
		};

		Element.prototype.ftTransformedPoint = function( x, y ) {
			var transform = this.transform().diffMatrix;
			return { x:  transform.x( x,y ) , y:  transform.y( x,y ) };
		};

		Element.prototype.ftUpdateTransform = function() {
			var matr = this.ftGetInitialTransformMatrix().clone();
			var tstring = "t" + this.data("tx") + "," + this.data("ty") + matr.toTransformString();
			this.attr({ transform: tstring });
			this.ftHighlightBB();
			this.updateTransformControls(this);

			return this;
		};

		Element.prototype.ftHighlightBB = function() {
			this.data("bbT") && this.data("bbT").remove();
			this.data("bb") && this.data("bb").remove();
			this.data("bbT", this.paper.rect( rectObjFromBB( this.getBBox(1) ) )
				.attr({ fill: "none", stroke: ftOption.handleFill, strokeDasharray: ftOption.handleStrokeDash })
				.transform( this.transform().global.toString() ) );
			return this;
		};

		// Initialise our slider with its basic transform and drag funcs
		Element.prototype.initSlider = function( params ) {
			var emptyFunc = function() {};
			this.data('origTransform', this.transform().local );
			this.data('onDragEndFunc', params.onDragEndFunc || emptyFunc );
			this.data('onDragFunc', params.onDragFunc || emptyFunc );
			this.data('onDragStartFunc', params.onDragStartFunc || emptyFunc );
		}

		// initialise the params, and set up our max and min. Check if its a slider or knob to see how we deal
		Element.prototype.sliderAnyAngle = function( params ) {
			this.initSlider( params );
			this.data("maxPosX", params.max); this.data("minPosX", params.min);
			this.data("centerOffsetX", params.centerOffsetX); this.data("centerOffsetY", params.centerOffsetY)
			this.data("posX", params.min);
			this.drag( moveDragSlider, startDrag, endDrag );
		}

		Element.prototype.setCapMaxPosition = function( posX ) {
			this.data("maxPosX", posX);
			if (posX < this.data("posX")) {
				this.setCapPosition(posX);
			}
		}
		Element.prototype.setCapPosition = function( posX ) {
			this.data("posX", posX);
			this.attr({ transform: this.data("origTransform") + (posX ? "T" : "t") + [posX,0] });
		}
		// load in the slider svg file, and transform the group element according to our params earlier.
		// Also choose which id is the cap

		Paper.prototype.slider = function( params , callback) {
			var myPaper = this,  myGroup;
			var loaded = Snap.load( params.filename, function( frag ) {
				myGroup = myPaper.group().add( frag );
				myGroup.transform("t" + params.x + "," + params.y);
				var myCap = myGroup.select( params.capSelector );
				myCap.myGroup = myGroup;
				myCap.data("sliderId", params.sliderId);
				myCap.sliderAnyAngle( params );
				sliderSetAttributes( myGroup, params.attr );
				sliderSetAttributes( myCap, params.capattr );
				myGroup.myCap = myCap;
				callback(myGroup);
			});
			return myGroup;
		}

	 // Extra func, to pass through extra attributes passed when creating the slider

		function sliderSetAttributes ( myGroup, attr, data ) {
			var myObj = {};
			if( typeof attr != 'undefined' ) {
				for( var prop in attr ) {
					myObj[ prop ] = attr[prop];
					myGroup.attr( myObj );
					myObj = {};
				};
			};
		};

		// Our main slider startDrag, store our initial matrix settings.
		var startDrag = function( x, y, ev ) {
			startDragTarget = ev.target;
			if( ! ( this.data("startBBox") ) ) {
				this.data("startBBox", this.getBBox());
				this.data("startScreenCTM",startDragTarget.getScreenCTM());
			}
			this.data('origPosX', this.data("posX") ); this.data('origPosY', this.data("posY") );
			this.data("onDragStartFunc")(this);
		}


		// move the cap, our dx/dy will need to be transformed to element matrx. Test for min/max
		// set a value 'fracX' which is a fraction of amount moved 0-1 we can use later.

		function updateMovement( el, dx, dy ) {
			// Below relies on parent being the file svg element, 9
			var angle = el.myGroup.matrix.split().rotate;
			var rotation = rotateVector(dx, dy, angle);
			dx = rotation[0];
			dy = rotation[1];
			var snapInvMatrix = el.parent().transform().localMatrix.invert();
			snapInvMatrix.e = snapInvMatrix.f = 0;
			var tdx = snapInvMatrix.x( dx,dy ), tdy = snapInvMatrix.y( dx,dy );

			el.data("posX", +el.data("origPosX") + tdx);
			var posX = +el.data("posX");
			var maxPosX = +el.data("maxPosX");
			var minPosX = +el.data("minPosX");

			if( posX < minPosX ) { el.data("posX", minPosX ); };
			el.data("fracX", 1/ ( (maxPosX - minPosX) / el.data("posX") ) );
		}

		// Call the matrix checks above, and set any transformation
		function moveDragSlider( dx,dy ) {
			var posX;
			updateMovement( this, dx, dy );
			posX = this.data("posX");
			this.attr({ transform: this.data("origTransform") + (posX ? "T" : "t") + [posX,0] });
			this.data("onDragFunc")(this);
		};
		function endDrag() {
			this.data('onDragEndFunc')(this);
		};

		//control creation
		function createScaleControl(paper, activeShape) {
	    var self = this;
	    var transformObj;
	    var myDragEndFunc = function( el ) {
				activeShape.ftStoreInitialTransformMatrix();
	      el.setCapMaxPosition(el.data("posX"));
				informFinishedTransform(activeShape);
	    }

	    var myDragStartFunc = function(el) {
	      activeShape.ftStoreInitialTransformMatrix();
	    }

	    // what we want to do when the slider changes. They could have separate funcs as the call back or just pick the right element
	    var myDragFunc = function( el ) {
	      if (!el) return;

	      if( el.data("sliderId") == "x" ) {
	        updateElementParameters(activeShape, {width: el.data("posX"), scaleX: el.data("fracX")});
	      } else if( el.data("sliderId") == "y" ) {
	        updateElementParameters(activeShape, {height: el.data("posX"), scaleY: el.data("fracX")});
	      }

				activeShape.ftUpdateRotateHandler();
				activeShape.ftHighlightBB();
			}

	    paper.slider({ sliderId: "x", capSelector: "#cap", filename: "/images/svgControls/sl.svg",
	      x: "0", y:"0", min: "10", max: "300", centerOffsetX: "0", centerOffsetY: "0",
	      onDragEndFunc: myDragEndFunc, onDragStartFunc: myDragStartFunc, onDragFunc: myDragFunc,
	      attr: { transform: 't-100,-100' } } , function(elX) {
	          // Create vertical control
	          paper.slider({ sliderId:"y", capSelector: "#cap", filename: "/images/svgControls/sl.svg",
	            x: "0", y:"0", min: "10", max: "300", centerOffsetX: "0", centerOffsetY: "0",
	            onDragEndFunc: myDragEndFunc, onDragStartFunc: myDragStartFunc, onDragFunc: myDragFunc,
	            attr: { transform: 't-100,-100r90' } } , function(elY) {
	              activeShape.scaleXControl = elX;
	              activeShape.scaleYControl = elY;

								activeShape.updateTransformControls(activeShape, true);
	            });
	      });
	  }

		function hideScaleControls(shape) {
			shape.scaleXControl.attr({transform: "t-100,-100"});
			shape.scaleYControl.attr({transform: "t-100,-100"});
		}

		function updateElementParameters(shape, params) {
	    switch (shape.type) {
	     	case "ellipse":
	        if (params.width) {
	          shape.attr({rx: params.width});
	        } else if (params.height) {
	          shape.attr({ry: params.height});
	        }
	        break;
	      case "rect":
	        var tstring= shape.attr().transform;
	        var width = shape.attr().width;
	        var height = shape.attr().height;
	        var attributes = {};
	        if (params.width) {
	          attributes.width = params.width*2;
	          attributes.x = Number(shape.attr().x) - (attributes.width - width)/2;
	        } else if (params.height) {
	          attributes.height = params.height*2;
	          attributes.y = Number(shape.attr().y) - (attributes.height - height)/2;
	        }
	        attributes.transform = tstring;
	        shape.attr(attributes);
	        break;

	      default:
	        var elEttributes = shape.attr();
	        var matr = shape.ftGetInitialTransformMatrix().clone();
					var splitParams = matr.split();
					var splitParams = shape.matrix.split();
					var scX = 1;
					var scY = 1;
					if (params.scaleX) scX = params.scaleX;
					if (params.scaleY) scY = params.scaleY;

					var transform = matr.toTransformString()+"S"+scX+","+scY;
	        shape.attr({transform: transform});
	        break;
	    }
	  }

		Element.prototype.updateTransformControls = function(shape, resetControlValues) {
	    var angle = shape.matrix.split().rotate;
	    var transformStr = "";
	    var attrs = shape.attr();
	    var width = 0;
	    var height = 0;
	    var box = shape.getBBox();
			var boxSize = getShapeSize(shape);
			transformStr = "t"+ this.translateDragger.attr("x") + "," + this.translateDragger.attr("y") + "r";

	    var originalTransform = shape.matrix.split();
	    if (shape.type == "rect") {
	      width = attrs.width/2*originalTransform.scalex;
	      height = attrs.height/2*originalTransform.scaley;
	    } else if (shape.type == "ellipse") {
	      width = attrs.rx*originalTransform.scalex;
	      height = attrs.ry*originalTransform.scaley;
	    } else {
	      if (resetControlValues) {
	        width = boxSize.width/2;
	        height = boxSize.height/2;
	      } else {
	        width = shape.scaleXControl.myCap.data("posX");
	        height = shape.scaleYControl.myCap.data("posX");
	      }
	    }

	    shape.scaleXControl.myCap.setCapPosition(0);
	    shape.scaleYControl.myCap.setCapPosition(0);
	    shape.scaleXControl.attr({transform: transformStr+angle});
	    shape.scaleYControl.attr({transform: transformStr+(angle+90)});

	    shape.scaleXControl.myCap.setCapPosition(width);
	    shape.scaleYControl.myCap.setCapPosition(height);

	    shape.scaleXControl.myCap.setCapMaxPosition(width);
	    shape.scaleYControl.myCap.setCapMaxPosition(height);
	    shape.scaleXControl.insertAfter(shape);
	    shape.scaleYControl.insertAfter(shape);

			//console.log("shape__", this.translateDragger.attr("x"));
	  }
	});

	function rectObjFromBB ( bb ) {
		return { x: bb.x, y: bb.y, width: bb.width, height: bb.height }
	}

	function elementDragStart( mainEl, x, y, ev ) {
		this.ftInformSelected(mainEl, true);
		this.parent().selectAll('image').forEach( function( el, i ) {
				el.ftStoreStartCenter();
		} );
		mainEl.ftStoreStartCenter();
		mainEl.data("otx", mainEl.data("tx") || 0);
		mainEl.data("oty", mainEl.data("ty") || 0);
	};

	function elementDragMove( mainEl, dx, dy, x, y ) {
		var dragHandle = this;
		this.parent().selectAll('image').forEach( function( el, i ) {
			el.attr({ x: +el.data('ocx') + dx, y: +el.data('ocy') + dy});
		} );
		mainEl.data("tx", mainEl.data("otx") + +dx);
		mainEl.data("ty", mainEl.data("oty") + +dy);
		mainEl.ftUpdateTransform();
		//mainEl.ftDrawJoinLine( dragHandle );
		informTransformed(mainEl);
	}

	function elementDragEnd( mainEl, dx, dy, x, y ) {
		informFinishedTransform(mainEl);
		mainEl.ftStoreInitialTransformMatrix();
	};

	function informFinishedTransform(mainEl) {
		if (mainEl.onFinishTransform) {
			mainEl.onFinishTransform(mainEl);
		}
	}

	function dragHandleRotateStart( mainElement ) {
		this.ftInformSelected(mainElement, true);
		this.ftStoreStartCenter();
		mainElement.ftStoreInitialTransformMatrix();
	};

	function dragHandleRotateEnd( mainElement ) {
		this.ftStoreStartCenter();
		informFinishedTransform(mainElement);
		mainElement.ftStoreInitialTransformMatrix();
	};

	function normalizeScaleVector(x, y, s) {
		var norm = Math.sqrt(x * x + y * y);
	  if (norm != 0) {
	    x = s * x / norm;
	    y = s * y / norm;
	  }
		return [x, y];
	}
	function dragHandleRotateMove( mainEl, dx, dy, x, y, event ) {
		var handle = this;
		var mainBB = mainEl.getBBox();
		var cx = Number(handle.data('ocx')) + dx;
		var cy = Number(handle.data('ocy')) + dy;

		var vx = cx - mainBB.cx;
		var vy = cy - mainBB.cy;

		var normalised = normalizeScaleVector(vx, vy, mainEl.data("scaleFactor"));
		var cx = mainBB.cx + normalised[0];
		var cy = mainBB.cy + normalised[1];

		var angle = Snap.angle( mainBB.cx, mainBB.cy, cx, cy) - 90;
		mainEl.data("angle", angle);
		handle.attr({ x: cx, y: cy });
		var matr = mainEl.ftGetInitialTransformMatrix().clone();
		var splitParams = matr.split();
		var mainDBB = mainEl.translateDragger.getBBox();
		var myMatrix = new Snap.Matrix();

		myMatrix.rotate(angle, mainDBB.cx, mainDBB.cy);
		myMatrix.add(matr);

		mainEl.transform( myMatrix.toTransformString());

		mainEl.ftHighlightBB();
		mainEl.updateTransformControls(mainEl);

		informTransformed(mainEl);
	};

	function informTransformed(mainEl) {
		if (mainEl.onTransformed) {
			mainEl.onTransformed(mainEl);
		}
	}

	Snap.calcDistance = function(x1,y1,x2,y2) {
		return Math.sqrt( Math.pow( (x1 - x2), 2)  + Math.pow( (y1 - y2), 2)  );
	}

	function rotateVector(x, y, angle) {
		var cx = 0, cy = 0;
		x = Number(x);
		y = Number(y);
		var radians = (Math.PI / 180.0) * angle;
		var cos = Math.cos(radians),
				sin = Math.sin(radians),
				nx = (cos * (x - cx)) + (sin * (y - cy)) + cx,
				ny = (cos * (y - cy)) - (sin * (x - cx)) + cy;
		return [nx, ny];
	}

	function getShapeSize(shape) {
		var clone = shape.clone();
		var matr = shape.matrix;
		var splitParams = matr.split();
		var tstring = "r0" + "s" + splitParams.scalex + "," + splitParams.scaley ;
		clone.attr({ transform: tstring });
		var box = clone.getBBox();
		clone.remove();
		return box;
	}

})();
