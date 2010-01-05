Visualization.RgraphSetups = {

  grapOptions: function(ident) {

    return {
      Node: {
        color: '#000000',
        overridable: true
      },

      Edge: {
        color: '#aaa',
        // type: 'arrow',
        dim: 300,
        overridable: true
      },


      transition: Trans.Elastic.easeOut,
      interpolation: 'polar',

      levelDistance: 100,

      onBeforePlotLine: function(adj){
        adj.data.$lineWidth = 1;
        // adj.startAlpha = 1;
        // adj.endAlpha = 0.1;
        // logger(adj);
        // if (!adj.data.$lineWidth)
        //     adj.data.$lineWidth = Math.random() * 5 + 1;
      },

      onCreateLabel: function(domElement, node){
        domElement.innerHTML = node.name;
        domElement.onclick = function(){
          Tools.PhraseMaker.GraphVisualization.appendtoGraph(ident, node.id);
        };
      },

      onPlaceLabel: function(domElement, node){
        var style = domElement.style;
        style.display = '';
        style.cursor = 'pointer';

        // style.fontSize =  1 - (node._depth * node._depth * node._depth) + "em";

        if (node._depth == 0) {
          style.fontSize = "1.5em";
          style.color = "#000000";

        } else if(node._depth == 1){
          style.color = "#333";
          style.fontSize = "1.0em";

        } else if(node._depth >= 2){
          style.fontSize = "0.7em";
          style.color = "#494949";

        } else {
          // style.display = 'none';
        }

        var left = parseInt(style.left);
        var w = domElement.offsetWidth;
        style.left = (left - w / 2) + 'px';
      }

    };

  },


  BackgroundCircles: {
    styles: {
      strokeStyle: '#ddd'
    },
    impl: {
      init: function(){},
      plot: function(canvas, ctx){
        var times = 3, d = Visualization.RgraphSetups.grapOptions().levelDistance;
        var pi2 = Math.PI * 2;
        for (var i = 1; i <= times; i++) {
          ctx.beginPath();
          ctx.arc(0, 0, i * d, 0, pi2, true);
          ctx.stroke();
          ctx.closePath();
        }
      }
    }
  }



};