Visualization.RgraphSetups = {

  grapOptions: function(ident) {
    
    return {
      Node: {
        color: '#000000'
      },

      Edge: {
        color: '#aaa',
        type: 'arrow',
        dim: 300
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

        if (node._depth <= 1) {
          style.fontSize = "0.8em";
          style.color = "#000000";

        } else if(node._depth == 2){
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
  }
  
  
  
};