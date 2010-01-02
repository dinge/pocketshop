var Elbe = {};

Elbe.MouseEvent = {};
Elbe.MouseEvent.Delegator = {
  over: function(event) {
    // logger("over");
    document.fire("mouse_event:over", event);
  },

  out: function(event) {
    // logger("out");
    document.fire("mouse_event:out", event);
  }
};


Elbe.MouseEvent.Droppables = {
  init: function() {
    $$('.droppable').each(function(element) {
      Droppables.add(element, {
        hoverclass: "drag-hover",
        onDrop: function(element) {
          logger('dropped');
          logger(element);
        }
      });
    });  
  }
};


Elbe.MouseEvent.DraggableObserver = {
  current: undefined,
  container: undefined,
  dragHandle: undefined,
  draggable: undefined,

  run: function() {
    current = this;
    current.runOverObserver();
    current.runOutObserver();
  },

  runOverEvent: function(container) {
    current.container = container;
    current.showDragHandle();
    current.createDraggable();
  },

  runOutEvent: function() {
    current.hideDragHandle();
    current.reset();
  },

  showDragHandle: function() {
    current.dragHandle = current.container.down('.drag-handle');
    current.dragHandle.appear({ to: 1 });
  },

  hideDragHandle: function() {
    current.dragHandle.fade({ to: 0.1 });
  },

  createDraggable: function() {
   current.draggable = new Draggable(current.container, { 
     handle: current.dragHandle,
     revert: false,
     onDrag: function(draggable) {
       // logger('-');
       // logger(draggable.element);
       logger( current.checkIfOverDroppable(draggable));
     }
    });
  },

  checkIfOverDroppable: function(draggable) {
    var draggablePosXY = Element.viewportOffset(draggable.element);
    logger(draggablePosXY);

    $$('.droppable').find( function(droppable) {
        // return draggable != droppable && Position.within(droppable,draggablePosXY.first() , draggablePosXY.last() );
        return Position.within(droppable, draggablePosXY.first(), draggablePosXY.last() );
    });
  },

  reset: function() {
    current.draggable.destroy();
    current.container = undefined;
    current.dragHandle = undefined;
  },

  runOverObserver: function() {
    document.observe("mouse_event:over", function(event) {
      var elementContainer = current.getContainerElementFromEvent(event);
      if(Object.isUndefined(current.container) && !(Object.isUndefined(elementContainer)) ) {
        current.runOverEvent(elementContainer);
      }
    });
  },

  runOutObserver: function() {
    document.observe("mouse_event:out", function(event) {
      if( !(Object.isUndefined(current.container)) &&
          !(Event.element(event.memo).descendantOf(current.container)) &&
          !(current.draggable.dragging) ){
        current.runOutEvent();
      }
    });
  },

  getContainerElementFromEvent: function(event) {
    return $(Event.element(event.memo)).up('.thing-container');
  }

};

// Elbe.MouseEvent.DraggableObserver.run();
