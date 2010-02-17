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
    return '/tools/phrase_maker/phrases/' + node_id + '/json_for_grammar_based_graph?start_role=' + ident;
  },

  initGraph: function(ident, node_id) {
    if(this.instances[ident]) {
      return this.instances[ident];
    }

    var canvas = new Canvas('canvas_for_' + ident, {
      injectInto: 'graph_visualization_for_' + ident,
      width:      700,
      height:     700,
      backgroundCanvas: Visualization.Rgraph.Setups.BackgroundCircles
    });

    // RGraph, Hypertree, TM.Squarified, ST

    return this.instances[ident] = {
      // graph:  new RGraph(canvas, Visualization.Rgraph.Setups.graphOptions(ident)),
      graph:  new RGraph(canvas, Visualization.Rgraph.Setups.graphOptions),
      reload: true,
      url:    this.url(ident, node_id)
    };
  }

};



Tools.PhraseMaker.PhraseCentricGraphVisualization = {

  ident: 'phrase_centric_graph_visualization',

  loadGraph: function(node_id) {
    var graphInit = this.initGraph(node_id);

    new Ajax.Request(graphInit.url, {
      method: 'get',
      onSuccess: function(response) {
        graphInit.graph.loadJSON(response.responseJSON);
        graphInit.graph.refresh();
      }
    });
  },


  scopeNewNode: function(node) {
    var graphInit = this.initGraph(node.id);
    new Ajax.Request(this.url(node.id) + '?grammar_attribute=' + node.data.grammar_attribute, {
      method: 'get',
      onSuccess: function(response) {
        graphInit.graph.root = node.id;
        graphInit.graph.op.morph(response.responseJSON, {
          type: 'fade:con',
          hideLabels: false,
          duration: 1300
        });
      }
    });
  },

  url: function(node_id) {
    return '/tools/phrase_maker/phrases/' + node_id + '/json_for_path_based_graph';
  },

  initGraph: function(node_id) {
    if(Visualization.Rgraph.Instances[this.ident]) return Visualization.Rgraph.Instances[this.ident];

    var canvas = new Canvas('canvas_for_phrase_centric_graph_visualization', {
      injectInto: 'phrase_centric_graph_visualization',
      width:      700,
      height:     700,
      backgroundCanvas: Visualization.Rgraph.Setups.BackgroundCircles
    });

    return Visualization.Rgraph.Instances[this.ident] = {
      graph:  new RGraph(canvas,
                Object.extend(Visualization.Rgraph.Setups.graphOptions, this.graphOptions)),
      url:    this.url(node_id)
    };
  },


  graphOptions: {
    onCreateLabel: function(element, node){
      element.innerHTML = node.name;
      if (node.data.grammar_attribute != 'predicate') {
        element.observe('click', function(event){
          Tools.PhraseMaker.PhraseCentricGraphVisualization.scopeNewNode(node);
        });
      }
    },

    setLabelStyle: function(node, element){
      element.addClassName(node.data.grammar_attribute);
    }
  }

};

