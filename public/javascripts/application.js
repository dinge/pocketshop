document.observe("dom:loaded", function() {
  document.body.observe('mouseover', Elbe.MouseEvent.Delegator.over);
  document.body.observe('mouseout',  Elbe.MouseEvent.Delegator.out);
  // Elbe.MouseEvent.Droppables.init();
  // $$('input.clear_value_on_click').each(initClearValueOnClick);


  $$('.tab_control').each(function(tab_group){
    new Control.Tabs(tab_group, {
      hover: true,
      showFunction: Element.show,
      hideFunction: Element.hide,
      linkSelector: function(tab_container){
        return tab_container.select('li').map( function(list_element) {
          var link = new Element('a', {
            href: '#' + list_element.getAttribute('data-tab-id')
          }).update(list_element.innerHTML);
          list_element.update(link);
          return link;
        });
      }
    });
  });


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

});


var logger = function(message) {
  console.log(message);
};




var initClearValueOnClick = function(element) {
  // element.observe('click',  function(){ this.value = ''; } );
  // element.observe('blur',   function(){ this.value = ''; } );
};
