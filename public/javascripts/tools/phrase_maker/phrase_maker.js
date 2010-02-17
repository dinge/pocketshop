Tools.PhraseMaker = {};

Tools.PhraseMaker.Tabs = {
  Options: function() {
    return { beforeChange: Tools.PhraseMaker.Tabs.beforeChange };
  },

  beforeChange: function(oldTabElement, newTabElement) {
    var phrase_id = parseInt( location.pathname.match(/phrases\/(.+)\/edit/)[1], 10);
    switch (newTabElement.id) {
      case 'tab_subject':
        Tools.PhraseMaker.GraphVisualization.loadGraph('subject', phrase_id);
        break;
      case 'tab_object':
        Tools.PhraseMaker.GraphVisualization.loadGraph('object', phrase_id);
        break;
      case 'tab_phrase_merger':
        new Ajax.Request('/tools/phrase_maker/phrases/' + phrase_id + '/phrase_merger', { method: 'get' });
        break;
    }
  }
};


document.observe("dom:loaded", function() {

  if($('tools_phrase_maker_triple_subject_name')) $('tools_phrase_maker_triple_subject_name').focus();
  if($('tools_phrase_maker_phrase_name'))         $('tools_phrase_maker_phrase_name').focus();


  var phrase_id = parseInt( location.pathname.match(/phrases\/(.+)\/edit/)[1], 10);
  Tools.PhraseMaker.PhraseCentricGraphVisualization.loadGraph(phrase_id);

  document.observe("mouse_event:out", function(event) {
    var container = $(Event.element(event.memo)).up('.phrase_maker_gizmo');
    if(container != undefined ) {
      $$('.same_gizmo').each( function(element) {
        element.removeClassName('same_gizmo');
      });

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
      if(control != undefined) control.show();

      var hovered = container.select(':hover');
      if(hovered.any()) {
        same_gizmos = $$( '.' + $w(hovered.first().className).last() );
        if(same_gizmos.size() >= 2) {
          same_gizmos.each( function(element) {
            element.addClassName('same_gizmo');
          });
        } else {
          hovered.first().shake({distance: 3});
        }
      }


    }
  });



  document.observe("mouse_event:out", function(event) {
    var container = $(Event.element(event.memo)).up('.phrase_maker_gizmo .control');
    if(container != undefined ) container.up('.phrase_maker_gizmo .wrapper').removeClassName('active');
  });

  document.observe("mouse_event:over", function(event) {
    var container = $(Event.element(event.memo)).up('.phrase_maker_gizmo .control');
    if(container != undefined ) container.up('.phrase_maker_gizmo .wrapper').addClassName('active');
  });

});