Tools.GraphViewer.GraphVisualization = {

  loadGraph: function(){
    var graphInit = this.initGraph();

    new Ajax.Request(graphInit.url, {
      method: 'get',
      onSuccess: function(response) {
        graphInit.graph.loadJSON(response.responseJSON);
        graphInit.graph.refresh();
      }
    });

  },

  initGraph: function() {

    var canvas = new Canvas('canvas', {
      injectInto: 'graph_visualization',
      width:      700,
      height:     700,
      backgroundCanvas: Visualization.Rgraph.Setups.BackgroundCircles
    });

    // RGraph, Hypertree, TM.Squarified, ST
    return {
      graph: new RGraph(canvas, Visualization.Rgraph.Setups.graphOptions(this)),
      url: '/tools/graph_viewer.json'
    };
  }

};