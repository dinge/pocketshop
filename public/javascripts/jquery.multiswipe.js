/*
 * jMultiswipe - jQuery Plugin
 * http://plugins.jquery.com/project/multiswipe
 * http://www.prettydang.com/demos/multiswipe/
 *
 * Copyright (c) 2010 Ryan Laughlin (www.prettydang.com)
 * based off of jSwipe (c) 2009 Ryan Scherf (www.ryanscherf.com)
 * Licensed under the MIT license
 *
 * $Date: 2010-02-06 (Sat, 06 Feb 2010) $
 * $version: 0.1
 * 
 * This jQuery plugin will only run on devices running Mobile Safari
 * on iPhone or iPod Touch devices running iPhone OS 2.0 or later. 
 * http://developer.apple.com/iphone/library/documentation/AppleApplications/Reference/SafariWebContent/HandlingEvents/HandlingEvents.html#//apple_ref/doc/uid/TP40006511-SW5
 */
(function($) {
	$.fn.multiswipe = function(options) {
		
		// Default thresholds & swipe functions
		var defaults = {
			threshold: 100,
			fingers: 2,
			swipeLeft: function() { alert('swiped left') },
			swipeRight: function() { alert('swiped right') },
			swipeUp: function() { alert('swiped up') },
			swipeDown: function() { alert('swiped down') }
		};
		
		var options = $.extend(defaults, options);
		
		if (!this) return false;
		
		return this.each(function() {
			
			var me = $(this)
			var gestureActive = false;
			
			// Private variables for each element
			var originalCoord = { x: 0, y: 0 }
			var finalCoord = { x: 0, y: 0 }
			
			// Screen touched, store the original coordinate
			function gestureStart(event) {
				console.log('Starting swipe gesture...')
				gestureActive = true;
			}
			
			function touchStart(event) {
				//event.preventDefault();
				if(gestureActive && event.targetTouches.length == defaults.fingers) {
					originalCoord.x = event.targetTouches[defaults.fingers-1].screenX;
					originalCoord.y = event.targetTouches[defaults.fingers-1].screenY;
				}
			}
			
			// Store coordinates as finger is swiping
			function touchMove(event) {
				event.preventDefault();
				if(gestureActive && event.targetTouches.length == defaults.fingers) {
					finalCoord.x = event.targetTouches[defaults.fingers-1].screenX; // Updated X,Y coordinates
					finalCoord.y = event.targetTouches[defaults.fingers-1].screenY;
				}
			}
			
			// Done Swiping
			// Trigger all relevant multiswipe events
			function gestureEnd(event) {
				console.log('Ending swipe gesture...')
				var changeY = originalCoord.y - finalCoord.y;
				var changeX = originalCoord.x - finalCoord.x;
				
				if(changeY > defaults.threshold) {
					defaults.swipeUp();
				}
				if(changeY < (defaults.threshold*-1)) {
					defaults.swipeDown();
				}
				if(changeX > defaults.threshold) {
					defaults.swipeLeft();
				}
				if(changeX < (defaults.threshold*-1)) {
					defaults.swipeRight();
				}
				gestureActive = false;
			}
			
			// Add gestures to all swipable areas
			this.addEventListener("gesturestart", gestureStart, false);
			this.addEventListener("touchstart", touchStart, false);
			this.addEventListener("touchmove", touchMove, false);
			this.addEventListener("gestureend", gestureEnd, false);
				
		});
	};
})(jQuery);