var Kos = {};

Kos.PocketUi = {
  init: function() {
    this.loadGroups();
    this.loadItems();
    this.initEventListeners();
    this.addMoreDomStuff();
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
        $.each(json, function(item) {
          self.Item.create(json[item]);
          new Image(json[item].image_path);
        });
        // self.displayItems();
      }
    );
  },

  displayGroups: function() {
    var self = this;
    $("#content").append(self.Templates.groups( this.Group.all() ));
    this.GroupsContainer = $("#groups_container");
    this.rotateCards($('.group'));
    this.displayInFrontScreen(this.GroupsContainer, 'unser zeug');
  },

  displayItems: function() {
    var self = this;
    this.Item.each( function(item) {
      $("#content").append( self.Templates.smallItemImage(item) );
    });
  },

  initEventListeners: function() {
    var self = this;
    $('div.group').
      live('touchstart', function(event) {
        self.displayGroupItems($(this));
      }).
      live('click', function(event) {
        self.displayGroupItems($(this));
      });

    $('div.group_item').
      live('touchstart', function(event) {
        self.displayItem($(this));
      }).
      live('click', function(event) {
        self.displayItem($(this));
      });
  },

  displayGroupItems: function($group) {
    var groupId = $group.attr('id').split('_')[1];
    var group = this.Group.find( groupId );
    var groupItemDomId = 'group_item_' + groupId;

    if ( !$('#' + groupItemDomId).length ) {
      this.$groupItemsContainer.html( this.Templates.groupItems(group) );
    }
    this.rotateCards($('.group_item'));
    this.displayInFrontScreen(this.$groupItemsContainer, group.title);
  },

  displayItem: function($item) {
    var itemId = $item.attr('id').split('_')[2];
    var item = this.Item.find( itemId );

    this.$detailContainer.html( this.Templates.largeItem(item) );
    this.displayInDetailScreen(this.$detailContainer, item.title);
    // this.displayInFrontScreen(this.$detailContainer, item.title);
  },

  displayInFrontScreen: function($element, title) {
    var $oldFrontScreen = $('.front_screen');
    $element.addClass('front_screen');
    $oldFrontScreen.addClass('back_screen').removeClass('front_screen');
    this.updateTitle(title);
  },

  displayInDetailScreen: function($element, title) {
    var $oldDetailScreen = $('.detail_screen');
    $oldDetailScreen.removeClass('detail_screen');
    $element.addClass('detail_screen');
    this.updateTitle(title);
    this.$groupItemsContainer.css('opacity', '0.3');
  },
  

  addMoreDomStuff: function() {
    $("#content").append("<div id='group_items_container'></div>");
    $("#content").append("<div id='detail_container'></div>");
    this.$groupItemsContainer = $("#group_items_container");
    this.$detailContainer = $("#detail_container");
  },

  rotateCards: function(cards) {
    cards.each(function() {
      $(this).css('-webkit-transform', 'rotate(' + (Math.random() * 2 - 1) + 'deg)' );
    });
  },

  updateTitle: function(title) {
    if(title) {
      document.title = title;
      $('#graytitle').html(title);
    }
  }



};

Kos.PocketUi.Group = SuperModel.setup("Group");
Kos.PocketUi.Item = SuperModel.setup("Item");

Kos.PocketUi.Group.attributes = ['title', 'id', 'price', 'image_path'];
Kos.PocketUi.Item.attributes = ['title', 'id', 'parent_id', 'image_path', 'large_image_path'];



Kos.PocketUi.Group.include({
  items: function() {
    if (!this._cached_items) this._cached_items = this.findItems();
    return this._cached_items;
  },

  findItems: function() {
    return _.map(this.item_ids, function(item_id) {
      return Kos.PocketUi.Item.find(item_id);
    });
  }
});



Kos.PocketUi.Templates = {

  groups: function(groups) {
    var templ =
      "<div id='groups_container'>" +
        "<ul id='groups'>" +
          "<% _.each(groups, function(group) { %>" +
            "<li><%= Kos.PocketUi.Templates.group(group) %></li>" +
          "<% }); %>" +
        "</ul>" +
      "</div>";
    return _.template(templ, { groups: groups });
  },

  group: function(group) {
    var templ =
      "<div class='group small_card' id='group_<%= id %>'>" +
        "<img src='<%= image_path %>'/><br/><%= title %>" +
      "</div>";
    return _.template(templ, group);
  },

  groupItems: function(group) {
    var templ =
      "<div class='group_items' id='group_item_<%= group.id %>'>" +
        "<ul>" +
          "<% _.each(group.items(), function(item) { %>" +
            "<li><%= Kos.PocketUi.Templates.smallItem(item) %></li>" +
          "<% }); %>" +
        "</ul>" +
      "</div>";
    return _.template(templ, { group: group });
  },

  smallItem: function(item) {
    var templ =
      "<div id='group_item_<%= id %>' class='group_item small_card'>" +
        "<img src='<%= image_path %>' /><br/><%= title.substr(0, 15) %>" +
      "</div>";
    return _.template(templ, item);
  },

  largeItem: function(item) {
    var templ =
      "<div id='item_<%= id %>' class='large_card'>" +
        "<img src='<%= large_image_path %>' /><br/><%= title.substr(0, 30) %>" +
      "</div>";
    return _.template(templ, item);
  }

};


// Kos.PocketUi.Template = _.template("<%= id %> <%= title %> <%= price %> <img src='<%= imagePath %>' /> <br />");



$(function(){
  // $('body').bind('touchmove', function(e) { e.preventDefault(); });
  Kos.PocketUi.init();
});



var Item = Kos.PocketUi.Item;
var Group = Kos.PocketUi.Group;