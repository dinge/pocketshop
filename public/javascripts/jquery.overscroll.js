/*
 * Copyright (C) 2009 Jonathan Azoff <jon@azoffdesign.com>
 *
 * This script is free software; you can redistribute it and/or modify it
 * under the terms of the GNU General Public License as published by the
 * Free Software Foundation; either version 2, or (at your option) any
 * later version.
 *
 * This program is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * General Public License for more details.
 */
 
 // changelog 1.1.0 Optimized scrolling-internals so that it is both smoother and more memory efficient 
 //					(relies entirely on event model now). Added the ability to scroll horizontally 
 //					(if the overscrolled element has wider children).
 
 // changelog 1.0.3: Extended the easing object, as opposed to the $ object (thanks Andre)
 
 // changelog 1.0.2: Fixed timer to actually return milliseconds (thanks Don)
 
 // changelog 1.0.1: Fixed bug with interactive elements and made scrolling smoother (thanks Paul and Aktar) 
 
 // OverScroll v1.1.0 - A $ plugin that turns any DOM element with overflow and at least one child into a scrollable (iphone-like) interface.  
 // Usage: 	call $("selector").overscroll() on any element to turn it into a scroller. 
 //			**See http://azoffdesign.com/plugins/js/overscroll for an example.
 // Arguments: None. Currently, the plugin does not take any arguments.
 // Returns: A $ object that represents the scrollable container(s)
 // Notes:	In order to get the most out of this plugin, make sure to only apply it to parent elements 
 //			that are smaller than the collective width and/or height then their children. This way,
 //			you can see the actual scroll effect as you pan the element.
 // Dependencies: You MUST have two cursors to get the hand to show up, open, and close during the panning 
 //				  process. You can put the cursors wherever you want, just make sure to reference them in 
 //				  the code below. I have provided initial static linkages to these cursors for your 
 //				  convenience (see below).
 
;(function($){

	// create overscroll
	var o = $.fn.overscroll = function() {
		this.each(o.init);
	}
	
	$.extend(o, {
		
		// overscroll icons
		icons: {
			open: "http://static.azoffdesign.com/misc/open.cur",
			closed: "http://static.azoffdesign.com/misc/closed.cur"
		},
		
		// main initialization function
		init: function() {
			var	data = {},
				target = $(this)
				.css({"cursor":"url("+o.icons.open+"), default", "overflow": "hidden"})
				.bind("select mousedown", data, o.start)
				.bind("mouseup mouseleave", data, o.stop);
				
			data.target = target;		
		},
		
		// starts the drag operation and binds the mouse move handler
		start: function(event) {
			if ( o.isClickable(event.target) ) return true;
			
			event.data.target
				.css("cursor", "url("+o.icons.closed+"), default")
				.bind("mousemove", event.data, o.drag)
				.stop(true, true);
			
			event.data.position = { 
				x: event.pageX,
				y: event.pageY
			};
			
			event.data.capture = {};
			
			return false;
		},
		
		// ends the drag operation and unbinds the mouse move handler
		stop: function(event) {
			
			if( typeof event.data.position !== "undefined" ) {
				
				event.data.target
					.css("cursor", "url("+o.icons.open+"), default")
					.unbind("mousemove", o.drag);
					
				if ( typeof event.data.capture.time !== "undefined" ) {	
					var dt = (o.time() - event.data.capture.time);
					var dx = o.constants.scrollMod * (event.pageX - event.data.capture.x);
					var dy = o.constants.scrollMod * (event.pageY - event.data.capture.y);
					event.data.target.stop(true, true).animate({
						scrollLeft: (this.scrollLeft - dx),
						scrollTop: (this.scrollTop - dy)
					},{ 
						queue: false, 
						duration: o.constants.scrollSmoothness, 
						easing: "cubicEaseOut" 
					},
						dt
					);
				}
				
				event.data.capture = event.data.position = undefined;
			}
			
			return true;
		},
		
		// updates the current scroll location during a mouse move
		drag: function(event) {
			this.scrollLeft -= (event.pageX - event.data.position.x);
			this.scrollTop -= (event.pageY - event.data.position.y);
			event.data.position.x = event.pageX;
			event.data.position.y = event.pageY;
			
			if (typeof event.data.capture.index === "undefined" || --event.data.capture.index==0 ) {
				event.data.capture = {
					x: event.pageX,
					y: event.pageY,
					time: o.time(),
					index: o.constants.captureThreshold
				}
			}

			return true;
		},

		// determines if the current target is clickable
		// used for avoiding the drag command on clickable elements
		isClickable: function(target) {
			if(typeof target.clickable === "undefined")
				target.clickable = o.clickableRegExp.test(target.tagName);
			return target.clickable;
		},
		
		time: function() {
			return (new Date()).getTime();
		},
		
		// determines what elements are clickable
		clickableRegExp: (/input|textarea|select|a/i),
		
		constants: {
			captureThreshold: 4,
			scrollSmoothness: 800,
			scrollMod: 2
		}
		
	});

	// easing function for the flow
	$.extend( $.easing, {
		
		cubicEaseOut: function(p, n, firstNum, diff) {
			var c = firstNum + diff;
			return c*((p=p/1-1)*p*p + 1) + firstNum;
		}
		
	});

})(jQuery);