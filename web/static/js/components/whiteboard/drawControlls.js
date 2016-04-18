
(function() {
	var lineAttributes = { stroke: 'red', strokeWidth: 2, strokeDasharray: "5,5" };

	Snap.plugin( function( Snap, Element, Paper, global ) {

		var ftOption = {
			handleFill: "silver",
			handleStrokeDash: "5,5",
			handleStrokeWidth: "2",
			handleLength: "75",
			handleRadius: "7",
			handleLineWidth: 2,
		};

		Element.prototype.ftSetSelectedCallback = function(c) {
			this.onSelected = c;
		}

		Element.prototype.ftSetTransformedCallback = function(c) {
			this.onTransformed = c;
		}

		Element.prototype.ftRemove = function(c) {
			this.ftRemoveHandles();
			this.unclick();
			this.onSelected = null;
			this.onTransformed = null;
			if (this.group) this.group.remove();
			this.remove();
			this.removeData();
		}

		Element.prototype.ftInitShape = function() {
			this.ftInit();
			if (!this.group) this.group = this.paper.g(this);
		}

		Element.prototype.ftCreateHandles = function() {
			this.ftInit();
			var freetransEl = this;
			var bb = freetransEl.getBBox();
			var translateDragger = this.paper.circle(bb.cx, bb.cy, ftOption.handleRadius ).attr({ fill: ftOption.handleFill });
			//if (!this.group) this.group = this.paper.g(this);

			var handlesGroup = this.paper.g();

			//if (this.type != "polyline") {
				var rotateDragger = this.paper.circle(bb.cx + bb.width/2 + ftOption.handleLength, bb.cy, ftOption.handleRadius ).attr({ fill: ftOption.handleFill });
				var yScaler = this.ftCreateYScale(bb, this);
				var joinLine = freetransEl.ftDrawJoinLine( rotateDragger );

				freetransEl.data( "joinLine", joinLine);
				freetransEl.data( "scaleFactor", calcDistance( bb.cx, bb.cy, rotateDragger.attr('cx'), rotateDragger.attr('cy') ) );
				freetransEl.data( "scaleFactorY", calcDistance( bb.cx, bb.cy, yScaler.attr('cx'), yScaler.attr('cy') ) );

				rotateDragger.drag(
					dragHandleRotateMove.bind( rotateDragger, freetransEl ),
					dragHandleRotateStart.bind( rotateDragger, freetransEl  ),
					dragHandleRotateEnd.bind( rotateDragger, freetransEl  )
				);

				yScaler.drag(
					dragHandleYRotateMove.bind( yScaler, freetransEl ),
					dragHandleRotateStart.bind( yScaler, freetransEl  ),
					dragHandleRotateEnd.bind( yScaler, freetransEl  )
				);
				handlesGroup.add(joinLine, rotateDragger, yScaler);
			//}

			handlesGroup.add(translateDragger);
			if (!this.group) this.group = this.paper.g(this);
			this.group.add(handlesGroup);

			freetransEl.data( "handlesGroup", handlesGroup );

			translateDragger.drag( 	elementDragMove.bind(  translateDragger, freetransEl ),
						elementDragStart.bind( translateDragger, freetransEl ),
						elementDragEnd.bind( translateDragger, freetransEl ) );

			freetransEl.unclick();
			freetransEl.data("click", freetransEl.click( function() {
				this.ftRemoveHandles();
			} ) );

			freetransEl.ftStoreInitialTransformMatrix();
			freetransEl.ftHighlightBB();

			this.ftInformSelected(this, true);
			return this;
		};

		Element.prototype.ftUnselect = function() {
			this.ftRemoveHandles();
			if (this.onSelected) {
				this.onSelected(this, false);
			}
		}

		Element.prototype.ftInformSelected = function(selected) {
			if (this.onSelected) {
				this.onSelected(this, selected);
			}
		}

		Element.prototype.ftCreateYScale = function(bb, mainObject) {
			var freetransEl = this;
      var yScaler = this.paper.circle(bb.x + bb.width/2, bb.y, ftOption.handleRadius).attr({ fill: ftOption.handleFill });
			return yScaler;
		}

		Element.prototype.ftInit = function() {
			this.data("angle", 0);
			this.data("scale", 1);
			this.data("tx", 0);
			this.data("ty", 0);
			return this;
		};

		Element.prototype.ftCleanUp = function() {
			var myClosureEl = this;
			var myData = ["angle", "scale", "scaleFactor","scaleFactorY", "tx", "ty", "otx", "oty", "bb", "bbT", "initialTransformMatrix", "handlesGroup", "joinLine"];
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
			if (this.data( "handlesGroup")) this.data( "handlesGroup").remove();
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
				this.data("joinLine").attr({ x1: objtps.x, y1: objtps.y, x2: rotateHandle.attr('cx'), y2: rotateHandle.attr('cy') });
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
			var yScale = "";
			if (this.data("scaley")) {
				yScale = " " + this.data("scaley");
			} else {
				yScale = " 1";
			}
			var tstring = "t" + this.data("tx") + "," + this.data("ty") + this.ftGetInitialTransformMatrix().toTransformString() + 's' + this.data("scale") + yScale;
			this.attr({ transform: tstring });
			this.data("bbT") && this.ftHighlightBB();
			this.group.attr({ transform: "r" + this.data("angle") });
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

		Element.prototype.ftUpdatePosition = function(x, y) {
			this.attr({x: x, y: y, cx: x, cy: y});
			reinitHandles(this);
		}

		Element.prototype.ftUpdateRotation = function(angle) {
			this.group.attr({ transform: "r" + angle });
			reinitHandles(this);
		}
	});


	function reinitHandles(el) {
		el.ftRemoveHandles();
		el.ftCreateHandles();
		el.ftHighlightBB();
	}

	function rectObjFromBB ( bb ) {
		return { x: bb.x, y: bb.y, width: bb.width, height: bb.height }
	}

	function elementDragStart( mainEl, x, y, ev ) {
		this.parent().selectAll('circle').forEach( function( el, i ) {
				el.ftStoreStartCenter();
		} );
		mainEl.ftInformSelected(mainEl, true);
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
	}

	function elementDragEnd( mainEl, dx, dy, x, y ) {
		if (mainEl.onTransformed) {
			mainEl.onTransformed(mainEl);
		}
	};

	function dragHandleRotateStart( mainElement ) {
		this.ftStoreStartCenter();
		this.data('startAngle', mainElement.group.matrix?mainElement.group.matrix.split().rotate:0);
		mainElement.ftInformSelected(mainElement, true);
	};

	function dragHandleRotateEnd( mainElement ) {
		if (mainElement.onTransformed) {
			mainElement.onTransformed(mainElement);
		}
	};

	function dragHandleRotateMove( mainEl, dx, dy, x, y, event ) {
		var handle = this;
		var mainBB = mainEl.getBBox();

		var x = this.data("tx") + dx;
		var y = this.data("ty") + dy;

		var angle = Snap.angle( mainBB.cx, mainBB.cy, x, y ) - 180;

		handle.attr({ cx: +handle.data('ocx') + dx, cy: +handle.data('ocy') + dy });
		var angle = Snap.angle( mainBB.cx, mainBB.cy, handle.attr('cx'), handle.attr('cy') ) - 180 + this.data('startAngle');


		mainEl.data("angle", angle);
		var distance = calcDistance( mainBB.cx, mainBB.cy, handle.attr('cx'), handle.attr('cy') );

		handle.attr({
			cx: mainBB.cx + distance,
			cy: mainBB.cy
		});

		mainEl.ftDrawJoinLine( handle );

		mainEl.data("scale", distance / mainEl.data("scaleFactor"), 1 );
		mainEl.ftUpdateTransform();
	};

	function dragHandleYRotateMove( mainEl, dx, dy, x, y, event ) {
		var handle = this;
		var mainBB = mainEl.getBBox();

		handle.attr({ cx: +handle.data('ocx') + dx, cy: +handle.data('ocy') + dy });
		var distance = calcDistance( mainBB.cx, mainBB.cy, handle.attr('cx'), handle.attr('cy') );

		handle.attr({
			cx: mainBB.cx,
			cy: mainBB.cy - distance
		});

		mainEl.data("angle", this.data('startAngle'));
		mainEl.data("scaley", distance / mainEl.data("scaleFactorY"), 1 );
		mainEl.ftUpdateTransform();
	};

	function calcDistance(x1,y1,x2,y2) {
		return Math.sqrt( Math.pow( (x1 - x2), 2)  + Math.pow( (y1 - y2), 2)  );
	}

})();
