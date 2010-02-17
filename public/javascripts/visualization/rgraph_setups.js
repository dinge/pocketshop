Visualization.Rgraph = {};
Visualization.Rgraph.Instances = {};

Visualization.Rgraph.Setups = {

  graphOptions: {
      Node: {
        color: '#000000',
        overridable: true
      },

      Edge: {
        color: '#dedede',
        type: 'arrow',
        dim: 90,
        overridable: true
      },

      transition: Trans.Elastic.easeOut,
      interpolation: 'polar',

      levelDistance: 90,
      withLabels: true,

      clearCanvas: true,
      // duration: 2500,
      // fps: 40,

      onBeforeCompute: function(node){},
      onAfterCompute:  function(){},

      onBeforePlotNode:function(node){},
      onAfterPlotNode: function(node){},

      onBeforePlotLine: function(adj){
        adj.data.$lineWidth = 1;
        // adj.startAlpha = 1;
        // adj.endAlpha = 0.1;
        // logger(adj);
        // if (!adj.data.$lineWidth)
        //     adj.data.$lineWidth = Math.random() * 5 + 1;
      },

      onAfterPlotLine: function(adj){},

      onCreateLabel: function(domElement, node){
        domElement.innerHTML = node.name;
      },

      onPlaceLabel: function(domElement, node){
        var style = domElement.style;
        style.display = '';
        style.cursor = 'pointer';

        this.setLabelStyle(node, domElement);

        var left = parseInt(style.left, 10),
            w = domElement.offsetWidth;
        style.left = (left - w / 2) + 'px';
      },



      setLabelStyle: function(node, domElement){
        var style = domElement.style;
        if (node._depth == 0) {
          style.fontSize = "2.0em";
          style.color = "#000000";
        } else if(node._depth == 1){
          style.color = "#333";
          style.fontSize = "1.2em";
        } else if(node._depth >= 2){
          style.fontSize = "0.7em";
          style.color = "#494949";
        } else {
          // style.display = 'none';
        }
      }

  },



  BackgroundCircles: {
    styles: {
      strokeStyle: '#ededed'
    },
    impl: {
      init: function(){},
      plot: function(canvas, ctx){
        var times = 5,
            d   = Visualization.Rgraph.Setups.graphOptions.levelDistance,
            pi2 = Math.PI * 2;

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