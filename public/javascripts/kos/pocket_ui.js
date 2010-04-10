var Kos = {};

Kos.PocketUi = {
  init: function() {
    this.loadGroups();
    this.loadItems();
    this.initEventListeners();
  },

  loadGroups: function() {
    var self = this;
    $.getJSON(
      '/kos/pocket_ui/groups',
      function(json) {
        $.each(json, function(group) { self.Group.create(json[group]); });
        self.displayGroups();
      }
    );
  },

  loadItems: function() {
    var self = this;
    $.getJSON(
      '/kos/pocket_ui/items',
      function(json) {
        $.each(json, function(item) { self.Item.create(json[item]); });
        // self.displayItems();
      }
    );
  },

  displayGroups: function() {
    var self = this;
    this.Group.each( function(group) {
      $("#content").append( self.Templates.smallGroupImages()(group) );
    });
  },

  displayItems: function() {
    var self = this;
    this.Item.each( function(item) {
      $("#content").append( self.Templates.smallItemImage()(item) );
    });
  },

  initEventListeners: function() {
    var self = this;
    $('div.group').live('touchstart', function(event) {
      event.preventDefault();
      // console.log(event.originalEvent.touches.length);
      // console.log(event);
      // console.log(this);
      self.displayGroupDetail($(this));
    });
    $('div.group').live('click', function(event) {
      event.preventDefault();
      self.displayGroupDetail($(this));
    });
  },

  displayGroupDetail: function(el) {
    el.addClass('in');
  }

};

Kos.PocketUi.Group = SuperModel.setup("Group");
Kos.PocketUi.Item = SuperModel.setup("Item");

Kos.PocketUi.Group.attributes = ['title', 'id', 'price', 'imagePath'];
Kos.PocketUi.Item.attributes = ['title', 'id', 'parent_id', 'imagePath'];


Kos.PocketUi.Templates = {
  smallGroupImages: function(item) {
    return _.template("<div class='group pop' id='group_<%= id %>'><img src='<%= imagePath %>'/></div>");
  },

  smallItemImage: function(item) {
    return _.template("<img src='<%= imagePath %>' />");
  }
};


// Kos.PocketUi.Template = _.template("<%= id %> <%= title %> <%= price %> <img src='<%= imagePath %>' /> <br />");



$(function(){
  // $('body').bind('touchmove', function(e) { e.preventDefault(); });
  Kos.PocketUi.init();
});



var Item = Kos.PocketUi.Item;