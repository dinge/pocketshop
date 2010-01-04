var backgroundCanvasOptions = {
  styles: {
      strokeStyle: '#ddd'
  },
  impl: {
    init: function(){},
    plot: function(canvas, ctx){
      var times = 3, d = 100;
      var pi2 = Math.PI * 2;
      for (var i = 1; i <= times; i++) {
        ctx.beginPath();
        ctx.arc(0, 0, i * d, 0, pi2, true);
        ctx.stroke();
        ctx.closePath();
      }
    }
  }
};


document.observe("dom:loaded", function() {


  var grapOptions = function(){
    return {
      //Set Node and Edge colors.
      Node: {
          color: '#000000'
      },

      Edge: {
          color: '#aaa',
          type: 'line',
          dim: 300
      },

      onBeforeCompute: function(node){
          // Log.write("centering " + node.name + "...");
          //Add the relation list in the right column.
          //This list is taken from the data property of each JSON node.
          // document.getElementById('inner-details').innerHTML = node.data.relation;
      },

      onAfterCompute: function(){
          // Log.write("done");
      },
      //Add the name of the node in the correponding label
      //and a click handler to move the graph.
      //This method is called once, on label creation.
      onCreateLabel: function(domElement, node){
          domElement.innerHTML = node.name;
          domElement.onclick = function(){
              rgraph_for_object.onClick(node.id);
          };
      },
      //Change some label dom properties.
      //This method is called each time a label is plotted.
      onPlaceLabel: function(domElement, node){
          var style = domElement.style;
          style.display = '';
          style.cursor = 'pointer';

          if (node._depth <= 1) {
              style.fontSize = "0.8em";
              style.color = "#000000";

          } else if(node._depth == 2){
              style.fontSize = "0.7em";
              style.color = "#494949";

          } else {
              style.display = 'none';
          }

          var left = parseInt(style.left);
          var w = domElement.offsetWidth;
          style.left = (left - w / 2) + 'px';
      }};
  };


  if($('canvas_for_subject') && $('canvas_for_object')) {

    var canvas_for_subject = new Canvas('canvas_for_subject', {
      injectInto: 'canvas_for_subject',
      width: 700,
      height: 700,
      backgroundCanvas: backgroundCanvasOptions 
    });

    var canvas_for_object = new Canvas('canvas_for_object', {
      injectInto: 'canvas_for_object',
      width: 700,
      height: 700,
      backgroundCanvas: backgroundCanvasOptions 
    });

    var rgraph_for_subject = new RGraph(canvas_for_subject, grapOptions());
    var rgraph_for_object = new RGraph(canvas_for_object, grapOptions());

    new Ajax.Request(location.href.gsub(/edit$/, 'json_for_graph?start_role=subject&end_role=object'), {
      method: 'get',
      onSuccess: function(response) {
        rgraph_for_subject.loadJSON(response.responseJSON);
        rgraph_for_subject.refresh();
      }
    });

    new Ajax.Request(location.href.gsub(/edit$/, 'json_for_graph?start_role=object&end_role=subject'), {
      method: 'get',
      onSuccess: function(response) {
        rgraph_for_object.loadJSON(response.responseJSON);
        rgraph_for_object.refresh();
      }
    });
  };

});