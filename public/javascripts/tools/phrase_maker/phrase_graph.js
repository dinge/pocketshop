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
          duration: 1300
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

    // RGraph, Hypertree, TM.Squarified, ST

    return this.instances[ident] = { 
      graph:  new RGraph(canvas, Visualization.RgraphSetups.grapOptions(ident)),
      reload: true,
      url:    this.url(ident, node_id),
    };
  }

};
