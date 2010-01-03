document.observe("dom:loaded", function() {

  if($('tools_phrase_maker_triple_subject_name')) {
    $('tools_phrase_maker_triple_subject_name').focus();
  };

  if($('tools_phrase_maker_phrase_name')) {
    $('tools_phrase_maker_phrase_name').focus();
  };

  document.observe("mouse_event:out", function(event) {
    var container = $(Event.element(event.memo)).up('.phrase_maker_gizmo');
    if(container != undefined ) {
      var control = container.down('.control');
      if(control != undefined) {
        control.hide();
      }
    }
  });

  document.observe("mouse_event:over", function(event) {
    var container = $(Event.element(event.memo)).up('.phrase_maker_gizmo');
    if(container != undefined ) {
      var control = container.down('.control');
      if(control != undefined) {
        control.show();
      }
    }
  });



  document.observe("mouse_event:out", function(event) {
    var container = $(Event.element(event.memo)).up('.phrase_maker_gizmo .control');
    if(container != undefined ) {
      container.up('.phrase_maker_gizmo .wrapper').removeClassName('active');
    }
  });

  document.observe("mouse_event:over", function(event) {
    var container = $(Event.element(event.memo)).up('.phrase_maker_gizmo .control');
    if(container != undefined ) {
      container.up('.phrase_maker_gizmo .wrapper').addClassName('active');
    }
  });

});