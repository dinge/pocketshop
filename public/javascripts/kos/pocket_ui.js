var Kos = {};

Kos.PocketUi = {
  init: function() {
    this.initContainers();
    this.loadGroups();
    this.loadItems();
    this.initEventListeners();
  },

  loadGroups: function() {
    var self = this;
    $.getJSON(
      '/kos/pocket_ui/groups',
      function(json) {
        $.each(json, function(group) {
          self.Group.create(json[group]);
          // self.preloadImage(json[group].image_path);
        });
        self.initGroupsContainer();
        self.displayInFrontScreen(self.$groupsContainer, 'unser zeug');
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
          // self.preloadImage(json[item].image_path);
          // self.preloadImage(json[item].large_image_path);
        });
      }
    );
  },

  preloadImage: function(imagePath) {
    image = new Image;
    image.src = imagePath;
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

    $('#overview_link').
      live('touchstart', function(event) {
        self.displayGroups();
      }).
      live('click', function(event) {
        self.displayGroups();
      });
  },

  initGroupsContainer: function() {
    this.$groupsContainer.html(this.Templates.groups( this.Group.all() ));
    this.rotateCards($('.group'));
  },

  displayGroups: function() {
    this.displayInFrontScreen(this.$groupsContainer, 'unser zeug');
  },

  displayGroupItems: function($group) {
    var groupId = $group.attr('id').split('_')[1];
    var group = this.Group.find( groupId );
    this.$groupItemsContainer.html( this.Templates.groupItems(group) );
    this.rotateCards($('.group_item'));
    this.displayInFrontScreen(this.$groupItemsContainer, group.title);
    this.addHomeButtonToLeftNav();
  },

  displayItem: function($item) {
    var itemId = $item.attr('id').split('_')[2];
    var item = this.Item.find( itemId );

    this.$detailContainer.html( this.Templates.largeItem(item) );
    this.rotateCards($('.item'));
    this.displayInFrontScreen(this.$detailContainer, item.title);
    // this.displayInDetailScreen(this.$detailContainer, item.title);
    this.addGroupsButtonToLeftNav(item);
  },

  displayInFrontScreen: function($element, title) {
    var $oldFrontScreen = $('.front_screen');
    $('.detail_screen').removeClass('detail_screen');
    $element.toggleClass('front_screen back_screen');
    $oldFrontScreen.toggleClass('front_screen back_screen');
    this.updateTitle(title);
  },

  displayInDetailScreen: function($element, title) {
    var $oldDetailScreen = $('.detail_screen');
    var $frontScreen = $('.front_screen');
    $element.addClass('detail_screen');
    $oldDetailScreen.removeClass('detail_screen');
    $frontScreen.css('opacity', '0.3');
    this.updateTitle(title);
  },

  addHomeButtonToLeftNav: function($oldFrontScreen) {
    if(!$('#overview_link').length) {
      this.$leftNavContainer.append( this.Templates.leftNavHomeButton() );
    }
  },

  addGroupsButtonToLeftNav: function(item) {
    // this.$leftNavContainer.append(_.template('<a href="#"><%= title %></a>', item.group() ));
  },

  initContainers: function() {
    $("#content").append(this.Templates.containers());
    this.$groupsContainer = $("#groups_container");
    this.$groupItemsContainer = $("#group_items_container");
    this.$detailContainer = $("#detail_container");
    this.$leftNavContainer = $('#leftnav');
  },

  rotateCards: function(cards) {
    cards.each(function() {
      $(this).css('-webkit-transform-origin', (Math.random() * 40 + 30) + '% ' + (Math.random() * 40 + 30) + '%' );
      $(this).css('-webkit-transform', 'rotate(' + (Math.random() * 5 - 2.5) + 'deg)' );
    });
  },


  updateTitle: function(title) {
    if(title) {
      $('#title').html(title.split(',')[0].substr(0, 50));
      $('#graytitle').html(title);
      document.title = title;
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
    var group = this;
    var items = _.map(this.item_ids, function(item_id) {
      var item = Kos.PocketUi.Item.find(item_id);
      item._group = group;
      return item;
    });

    return $.grep(items, function(item, i) {
      return i <= 12;
    });
  }
});


Kos.PocketUi.Item.include({
  group: function() {
    return this._group;
  }
});




Kos.PocketUi.Templates = {

  containers: function() {
    return "<div id='groups_container' class='back_screen'></div>" +
           "<div id='group_items_container' class='back_screen'></div>" +
           "<div id='detail_container' class='back_screen'></div>";
  },

  leftNavHomeButton: function() {
    return '<a href="#" id="overview_link" ><img alt="home" src="/images/iwebkit/home.png" /></a>';
  },

  groups: function(groups) {
    var templ =
      "<ul id='groups' class='pageitemX'>" +
        "<% _.each(groups, function(group) { %>" +
          "<li><%= Kos.PocketUi.Templates.group(group) %></li>" +
        "<% }); %>" +
      "</ul>";
    return _.template(templ, { groups: groups });
  },

  group: function(group) {
    var templ =
      "<div class='card_stack'>" +
        "<div class='group small_card under'>" +
          "<img src='<%= image_path %>'/><br/><%= title %>" +
        "</div>" +
        "<div class='group small_card upper' id='group_<%= id %>'>" +
          "<img src='<%= image_path %>'/><br/><%= title %>" +
        "</div>" +
      "</div>";
    return _.template(templ, group);
  },

  groupItems: function(group) {
    var templ =
      "<div class='group_items' id='group_item_<%= group.id %>'>" +
        "<ul class='pageitemX'>" +
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
        "<img src='<%= image_path %>' /><br/><%= title.substr(0, 100) %><br/> €<%= price %>" +
      "</div>";
    return _.template(templ, item);
  },

  largeItem: function(item) {
    var templ =
      "<div id='item_<%= id %>' class='item large_card'>" +
        "<img src='<%= large_image_path %>' /><br/><%= title.substr(0, 30) %>" +
      "</div>";
    return _.template(templ, item);
  }

};


// Kos.PocketUi.Template = _.template("<%= id %> <%= title %> <%= price %> <img src='<%= imagePath %>' /> <br />");



$(function(){
  // prevent scrolling via touch/swipe
  // $('body').bind('touchmove', function(e) { e.preventDefault(); });
  Kos.PocketUi.init();
});


// for debugging
var Item = Kos.PocketUi.Item;
var Group = Kos.PocketUi.Group;