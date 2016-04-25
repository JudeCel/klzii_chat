
(function() {
	var lineAttributes = { stroke: 'red', strokeWidth: 2, strokeDasharray: "5,5" };
	var startDragTarget, startDragElement, startBBox, startScreenCTM;
	Snap.plugin( function( Snap, Element, Paper, global  ) {

		var ftOption = {
			handleFill: "#c0c0c090",
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
			if (this.group) this.group.remove();
			this.remove();
			this.removeData();
		}

		Element.prototype.ftCreateHandles = function() {
			this.ftInit();
			var freetransEl = this;
			var bb = freetransEl.getBBox();
			console.log("===", this.matrix.split());
			/*var angle = (this.matrix?this.matrix.split().rotate:0)-0;
			var rotation = rotateVector(bb.width/2 + ftOption.handleLength, -bb.height/2, angle);
			console.log("______rotation", rotation);
			var rotateDragger = this.paper.circle(bb.cx + rotation[0], bb.cy + rotation[1], ftOption.handleRadius ).attr({ fill: ftOption.handleFill });
			*/
			var rotateDragger = this.paper.circle(bb.cx + bb.width/2 + ftOption.handleLength, bb.cy - bb.height/2, ftOption.handleRadius ).attr({ fill: ftOption.handleFill });
			var translateDragger = this.paper.circle(bb.cx, bb.cy, ftOption.handleRadius ).attr({ fill: ftOption.handleFill });

			var joinLine = freetransEl.ftDrawJoinLine( rotateDragger );
			var handlesGroup = this.paper.g( joinLine, rotateDragger, translateDragger );

			freetransEl.data( "handlesGroup", handlesGroup );
			freetransEl.data( "joinLine", joinLine);

			freetransEl.data( "scaleFactor", calcDistance( bb.cx, bb.cy, rotateDragger.attr('cx'), rotateDragger.attr('cy') ) );
			translateDragger.drag( 	elementDragMove.bind(  translateDragger, freetransEl ),
						elementDragStart.bind( translateDragger, freetransEl ),
						elementDragEnd.bind( translateDragger, freetransEl ) );

			freetransEl.unclick();
			freetransEl.data("click", freetransEl.click( function() {  this.ftRemoveHandles() } ) );

			rotateDragger.drag(
				dragHandleRotateMove.bind( rotateDragger, freetransEl ),
				dragHandleRotateStart.bind( rotateDragger, freetransEl  ),
				dragHandleRotateEnd.bind( rotateDragger, freetransEl  )
			);
			freetransEl.ftStoreInitialTransformMatrix();

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
			var myData = ["angle", "scale", "scaleFactor", "tx", "ty", "otx", "oty", "bb", "bbT", "initialTransformMatrix", "handlesGroup", "joinLine"];
			myData.forEach( function( el ) { myClosureEl.removeData([el]) });
			return this;
		};

		Element.prototype.ftStoreStartCenter = function() {
			this.data('ocx', this.attr('cx') );
			this.data('ocy', this.attr('cy') );
			return this;
		}

		Element.prototype.ftStoreInitialTransformMatrix = function() {
			this.data('initialTransformMatrix', this.transform().localMatrix );
			return this;
		};

		Element.prototype.ftGetInitialTransformMatrix = function() {
			return this.data('initialTransformMatrix');
		};

		Element.prototype.ftRemoveHandles = function() {
			this.unclick();
			if (this.data( "handlesGroup"))	this.data( "handlesGroup").remove();
			this.data( "bbT" ) && this.data("bbT").remove();
			this.data( "bb" ) && this.data("bb").remove();
			this.click( function() { this.ftCreateHandles() } ) ;
			this.ftCleanUp();
			return this;
		};

		Element.prototype.ftDrawJoinLine = function( handle ) {
			var lineAttributes = { stroke: ftOption.handleFill, strokeWidth: ftOption.handleStrokeWidth, strokeDasharray: ftOption.handleStrokeDash };

			var rotateHandle = handle.parent()[1];
			var thisBB = this.getBBox();

			var objtps = this.ftTransformedPoint( thisBB.cx, thisBB.cy);

			if( this.data("joinLine") ) {
				var x2 = 0, y2 = 0;
				if (rotateHandle) {
					x2 = rotateHandle.attr('cx');
					y2 = rotateHandle.attr('cy');
				}
				this.data("joinLine").attr({ x1: objtps.x, y1: objtps.y, x2: x2, y2: y2 });
			} else {
				return this.paper.line( thisBB.cx, thisBB.cy, handle.attr('cx'), handle.attr('cy') ).attr( lineAttributes );
			};

			return this;
		};

		Element.prototype.ftTransformedPoint = function( x, y ) {
			var transform = this.transform().diffMatrix;
			return { x:  transform.x( x,y ) , y:  transform.y( x,y ) };
		};

		Element.prototype.ftUpdateTransform = function() {
			var tstring = "t" + this.data("tx") + "," + this.data("ty") + this.ftGetInitialTransformMatrix().toTransformString() + "r" + this.data("angle") + 'S' + this.data("scale" );
			this.attr({ transform: tstring });
			this.data("bbT") && this.ftHighlightBB();
			return this;
		};

		Element.prototype.ftHighlightBB = function() {
			this.data("bbT") && this.data("bbT").remove();
			this.data("bb") && this.data("bb").remove();
			this.data("bbT", this.paper.rect( rectObjFromBB( this.getBBox(1) ) )
							.attr({ fill: "none", stroke: ftOption.handleFill, strokeDasharray: ftOption.handleStrokeDash })
							.transform( this.transform().global.toString() ) );
			this.data("bb", this.paper.rect( rectObjFromBB( this.getBBox() ) )
							.attr({ fill: "none", stroke: ftOption.handleFill, strokeDasharray: ftOption.handleStrokeDash }) );
			return this;
		};

		///scale section------------------

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
						if( params.type == 'knob' ) {
										this.drag( moveDragKnob, startDrag, endDrag );
						} else {
										this.drag( moveDragSlider, startDrag, endDrag );
						}
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
										} );
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
						this.data("onDragStartFunc")();
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

						el.data("posX", +el.data("origPosX") + tdx) ;// el.data("posY", +el.data("origPosY") + tdy);
						var posX = +el.data("posX");
						var maxPosX = +el.data("maxPosX");
						var minPosX = +el.data("minPosX");

						//if( posX > maxPosX ) { el.data("posX", maxPosX ); };
						if( posX < minPosX ) { el.data("posX", minPosX ); };
						el.data("fracX", 1/ ( (maxPosX - minPosX) / el.data("posX") ) );
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

		// Call the matrix checks above, and set any transformation
		function moveDragSlider( dx,dy ) {
						var posX;
						updateMovement( this, dx, dy );
						posX = this.data("posX");
						this.attr({ transform: this.data("origTransform") + (posX ? "T" : "t") + [posX,0] });
						this.data("onDragFunc")(this);
		};

		// drag our knob. Currently there is no min/max working, need to add a case for testing rotating anticlockwise beyond 0

		function moveDragKnob( dx,dy,x,y, ev ) {
						var pnt = startDragTarget.ownerSVGElement.createSVGPoint();
						pnt.x = ev.clientX; pnt.y = ev.clientY;
						var vPnt = pnt.matrixTransform(this.data("startScreenCTM").inverse());
						var transformRequestObj = startDragTarget.ownerSVGElement.createSVGTransform();

						var deg = Math.atan2(vPnt.x - this.data("startBBox").cx, vPnt.y - this.data("startBBox").cy) * 180 / Math.PI ;
						deg = deg + 180;
						this.transform('r' + -deg + "," + ( this.data("startBBox").cx - this.data("centerOffsetX") ) + "," + parseInt(this.data("startBBox").cy - -this.data("centerOffsetY") )  );
						this.data("fracX", deg/360);
						this.data("onDragFunc")(this);
		}

		function endDrag() {
						this.data('onDragEndFunc')();
		};
	});

	function rectObjFromBB ( bb ) {
		return { x: bb.x, y: bb.y, width: bb.width, height: bb.height }
	}

	function elementDragStart( mainEl, x, y, ev ) {
		this.ftInformSelected(mainEl, true);
		this.parent().selectAll('circle').forEach( function( el, i ) {
				el.ftStoreStartCenter();
		} );
		mainEl.data("otx", mainEl.data("tx") || 0);
		mainEl.data("oty", mainEl.data("ty") || 0);
	};

	function elementDragMove( mainEl, dx, dy, x, y ) {
		var dragHandle = this;

		this.parent().selectAll('circle').forEach( function( el, i ) {
			el.attr({ cx: +el.data('ocx') + dx, cy: +el.data('ocy') + dy });

		} );
		mainEl.data("tx", mainEl.data("otx") + +dx);
		mainEl.data("ty", mainEl.data("oty") + +dy);
		mainEl.ftUpdateTransform();
		mainEl.ftDrawJoinLine( dragHandle );
		informTransformed(mainEl);
	}

	function elementDragEnd( mainEl, dx, dy, x, y ) {
		informFinishedTransform(mainEl);
	};

	function informFinishedTransform(mainEl) {
		if (mainEl.onFinishTransform) {
			mainEl.onFinishTransform(mainEl);
		}
	}

	function dragHandleRotateStart( mainElement ) {
		this.ftInformSelected(mainElement, true);
		this.ftStoreStartCenter();
	};

	function dragHandleRotateEnd( mainElement ) {
		informFinishedTransform(mainElement);
	};

	function normalizeScaleVector(x, y, s) {
		var norm = Math.sqrt(x * x + y * y);
	  if (norm != 0) { // as3 return 0,0 for a point of zero length
	    x = s * x / norm;
	    y = s * y / norm;
	  }
	//	console.log(norm);
		return [x, y];
	}
	function dragHandleRotateMove( mainEl, dx, dy, x, y, event ) {
		var handle = this;
		var mainBB = mainEl.getBBox();
	//	console.log(dx, dy, mainEl.data("scaleFactor"));
		// var normalised = normalizeScaleVector(dx, dy, mainEl.data("scaleFactor"));
		// dx = normalised[0];
		// dy = normalised[1];

		var cx = Number(handle.data('ocx')) + dx;
		var cy = Number(handle.data('ocy')) + dy;

		var vx = cx - mainBB.cx;
		var vy = cy - mainBB.cy;

		// var normalised = normalizeScaleVector(vx, vy, mainEl.data("scaleFactor"));
		// //CALCULATE CORRECT SCALE HERE
		//
		// var cx = Number(handle.data('ocx')) - normalised[0];
		// var cy = Number(handle.data('ocy')) - normalised[1];
		//
		// console.log(cx, cy);
		// cx -= normalised[0];
		// cy -= normalised[1];

		mainEl.data("angle", Snap.angle( mainBB.cx, mainBB.cy, cx, cy) - 180);

//		var distance = calcDistance( mainBB.cx, mainBB.cy, cx, cy );

		handle.attr({ cx: cx, cy: cy });

		mainEl.ftUpdateTransform();
		mainEl.ftDrawJoinLine( handle );

		informTransformed(mainEl);
	};

	function informTransformed(mainEl) {
		if (mainEl.onTransformed) {
			mainEl.onTransformed(mainEl);
		}
	}

	function calcDistance(x1,y1,x2,y2) {
		return Math.sqrt( Math.pow( (x1 - x2), 2)  + Math.pow( (y1 - y2), 2)  );
	}

})();
