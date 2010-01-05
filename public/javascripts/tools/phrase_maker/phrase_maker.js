Tools.PhraseMaker = {};

Tools.PhraseMaker.Tabs = {
  Options: function() {
    return { beforeChange: Tools.PhraseMaker.Tabs.beforeChange };
  },

  beforeChange: function(oldTabElement, newTabElement) {
    phrase_id = parseInt(location.pathname.match(/phrases\/(.+)\/edit/)[1]);
    switch (newTabElement.id) {
      case 'tab_subject':
        Tools.PhraseMaker.GraphVisualization.loadGraph('subject', phrase_id);
        break;
      case 'tab_object':
        Tools.PhraseMaker.GraphVisualization.loadGraph('object', phrase_id);
        break;
    }
  }
};



Tools.PhraseMaker.GraphVisualization = {

  instances: {},

  loadGraph: function(ident, node_id, reload) {
    var graphInit = this.initGraph(ident, node_id);

    if(graphInit.reload == true || reload) {
      new Ajax.Request(graphInit.url, {
        method: 'get',
        onSuccess: function(response) {
          graphInit.graph.loadJSON(response.responseJSON);
          graphInit.graph.refresh();
          graphInit.reload = false;
        }
      });
    }
  },

  appendtoGraph: function(ident, node_id) {
    var graphInit = this.initGraph(ident);

    // graphInit.graph.refresh();

    new Ajax.Request(this.url(ident, node_id), {
      method: 'get',
      onSuccess: function(response) {
        graphInit.graph.root = node_id;
        graphInit.graph.op.sum(response.responseJSON, { 
          type: 'fade:con',
          hideLabels: false,
          duration: 500
        });
        // graphInit.graph.refresh();
      }
    });


  },

  url: function(ident, node_id) {
    return '/tools/phrase_maker/phrases/' + node_id + '/json_for_graph?start_role=' + ident;
  },

  initGraph: function(ident, node_id) {
    if(this.instances[ident]) {
      return this.instances[ident];
    }

    var canvas = new Canvas('canvas_for_' + ident, {
      injectInto: 'graph_visualization_for_' + ident,
      width:      700,
      height:     700,
      backgroundCanvas: Visualization.RgraphSetups.BackgroundCircles
    });

    return this.instances[ident] = { 
      graph:  new RGraph(canvas, Visualization.RgraphSetups.grapOptions(ident)),
      reload: true,
      url:    this.url(ident, node_id),
    };
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