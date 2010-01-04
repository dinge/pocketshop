Tools.PhraseMaker = {};

Tools.PhraseMaker.Tabs = {
  Options: function() {
    return { beforeChange: Tools.PhraseMaker.Tabs.beforeChange };
  },

  beforeChange: function(oldTabElement, newTabElement) {
    switch (newTabElement.id) {
      case 'tab_subject':
        Tools.PhraseMaker.GraphVisualization.loadGraph('subject');
        break;
      case 'tab_object':
        Tools.PhraseMaker.GraphVisualization.loadGraph('object');
        break;
    }
  }
};



Tools.PhraseMaker.GraphVisualization = {
  loadGraph: function(grammar_attribute) {

    if(!$('canvas_for_' + grammar_attribute)) {
      var canvas = new Canvas('canvas_for_' + grammar_attribute, {
        injectInto: 'graph_visualization_for_' + grammar_attribute,
        width: 700,
        height: 700,
        backgroundCanvas: Visualization.RgraphSetups.BackgroundCircles 
      });

      var rgraph = new RGraph(canvas, Visualization.RgraphSetups.GrapOptions());

      new Ajax.Request(location.href.gsub(/edit$/, 'json_for_graph?start_role=' + grammar_attribute), {
        method: 'get',
        onSuccess: function(response) {
          rgraph.loadJSON(response.responseJSON);
          rgraph.refresh();
        }
      });
    }

  }
};



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