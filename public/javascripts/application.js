var Tools = {};
var Visualization = {};

Effect.DefaultOptions.duration = 0.25;

Ajax.Responders.register({
  onCreate: function() {
    if($('ajax_loading_indicator') && Ajax.activeRequestCount > 0)
      Effect.Appear('ajax_loading_indicator',{ duration: 0.15, queue: 'end' });
  },
  onComplete: function() {
    if($('ajax_loading_indicator') && Ajax.activeRequestCount == 0)
      Effect.Fade('ajax_loading_indicator', { duration: 0.15, queue: 'end' });
  }
});



document.observe("dom:loaded", function() {

  document.body.observe('mouseover', Elbe.MouseEvent.Delegator.over);
  document.body.observe('mouseout',  Elbe.MouseEvent.Delegator.out);
  document.body.observe('click',     Elbe.MouseEvent.Delegator.click);

  // Elbe.MouseEvent.Droppables.init();
  // $$('input.clear_value_on_click').each(initClearValueOnClick);

  // tab controls
  $$('.tab_control').each(function(tab_group){
    var options = {
      hover: true,
      linkSelector: function(tab_container){
        return tab_container.select('li').map( function(list_element) {
          var link = new Element('a', {
            href: '#' + list_element.getAttribute('data-tab-id')
          }).update(list_element.innerHTML);
          list_element.update(link);
          return link;
        });
      }
    };

    var optionsCallback = eval(tab_group.getAttribute('data-tab-options-callback'));
    if(Object.isFunction(optionsCallback)){
      Object.extend(options, optionsCallback.apply() || {});
    }

    new Control.Tabs(tab_group, options);
  });


  // control with confirmation
  document.observe("mouse_event:click", function(event) {
    var container = $(event.memo.element()).up('.control_with_confirmation');
    if(container) {
      var confirmation_question = container.down('.confirmation_question');
      var confirmation_success = container.down('.confirmation_success');
      confirmation_question.toggle();
      // confirmation_success.toggle().highlight({duration: 0.7, startcolor:'#bb0000' }).addClassName('warning_message');
      confirmation_success.toggle();
      window.setTimeout(function() { 
        if( confirmation_success.visible() && !confirmation_question.visible() ){
          confirmation_question.show();
          // confirmation_success.hide().removeClassName('warning_message');
          confirmation_success.hide();
        }
      }, 3000);
    }
  });


});



var logger = function(message) {
  console.log(message);
};


var initClearValueOnClick = function(element) {
  // element.observe('click',  function(){ this.value = ''; } );
  // element.observe('blur',   function(){ this.value = ''; } );
};
