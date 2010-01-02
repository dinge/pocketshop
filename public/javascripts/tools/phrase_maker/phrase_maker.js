document.observe("dom:loaded", function() {

  document.observe("mouse_event:out", function(event) {
    var container = $(Event.element(event.memo)).up('.tools_phrase_maker_triple');
    if(container != undefined ) {
      var control = container.down('.control');
      if(control != undefined) {
        container.removeClassName('active');
        control.hide();
      }
    }
  });

  document.observe("mouse_event:over", function(event) {
    var container = $(Event.element(event.memo)).up('.tools_phrase_maker_triple');
    if(container != undefined ) {
      var control = container.down('.control');
      if(control != undefined) {
        container.addClassName('active');
        control.show();
      }
    }
  });

});