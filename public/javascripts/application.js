document.observe("dom:loaded", function() {
  document.body.observe('mouseover', Elbe.MouseEvent.Delegator.over);
  document.body.observe('mouseout',  Elbe.MouseEvent.Delegator.out);
  // Elbe.MouseEvent.Droppables.init();
  // $$('input.clear_value_on_click').each(initClearValueOnClick);
});


var logger = function(message) {
  // console.log(message);
};

Effect.DefaultOptions.duration = 0.25;


var initClearValueOnClick = function(element) {
  // element.observe('click',  function(){ this.value = ''; } );
  // element.observe('blur',   function(){ this.value = ''; } );
};
