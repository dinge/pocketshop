document.observe("dom:loaded", function() {
  document.body.observe('mouseover', Elbe.MouseEvent.Delegator.over);
  document.body.observe('mouseout',  Elbe.MouseEvent.Delegator.out);
  // Elbe.MouseEvent.Droppables.init();
});


var logger = function(message) {
  console.log(message);
};

Effect.DefaultOptions.duration = 0.25;
