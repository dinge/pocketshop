var Kos = {};

Kos.PocketUi = {
  init: function() {
    this.cardsPerScreen = 100;
    this.storeIdent = $('meta[name=pocket-store-current-ident]').attr("content");
    this.initContainers();
    this.loadGroups();
    this.loadItems();
    this.initEventListeners();
  },

  loadGroups: function() {
    var self = this;
    $.getJSON(
      '/kos/pocket_ui/groups',
      { store_ident: this.storeIdent },
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
      { store_ident: this.storeIdent },
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

    $('#overview_link').live('touchstart click', function(event) {
        self.displayGroups();
      });
    
    
    $('div.group').live('touchend click', function(event) {
        self.displayGroupItems($(this));
      });

    $('div.group').live('touchstart click', function(event) {
        self.hoverGroup($(this));
      });


    $('div.group_item').live('touchend click', function(event) {
        self.displayItem($(this));
      });
    

    // $('#flicker_container')[0].addEventListener("touchstart", self.touchHandler, false);
    // $('#flicker_container')[0].addEventListener("touchmove", self.touchHandler, false);


    // $('#swipe_container').multiswipe({
    //   fingers: 2,
    //   threshold: 10,
    //   swipeLeft: function() {
    //     alert("left");
    //   },
    //   swipeRight: function() {
    //     alert("right");
    //   }// ,
    //   // swipeUp: function() {
    //   //   alert("up");
    //   // },
    //   // swipeDown: function() {
    //   //   alert("down");
    //   // }
    // });

  },

  // touchHandler: function(event) {
  //   switch(event.type) {
  //     case 'touchstart':
  //       FlickerManager.initStartPosition(event);
  //       break;
  //     case 'touchmove':
  //       FlickerManager.move(event, $(this));
  //       break;
  //     default:
  //   }
  // },


  hoverGroup: function($group) {
    $group.css('background:', '#111111');
  },


  initGroupsContainer: function() {
    this.$groupsContainer.html(this.Templates.groups( _.inGroupsOf( this.Group.all(), this.cardsPerScreen)[0] ));
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
    this.displayInFrontScreen( this.$groupItemsContainer, group.title );
    this.addHomeButtonToLeftNav();
  },

  displayItem: function($item) {
    var itemId = $item.attr('id').split('_')[2];
    var item = this.Item.find( itemId );

    this.$detailContainer.html( this.Templates.largeItem(item) );
    this.rotateCards($('.item'));
    this.displayInFrontScreen( this.$detailContainer, item.title );
    // this.displayInDetailScreen(this.$detailContainer, item.title);
    this.addGroupsButtonToLeftNav(item);
  },

  displayInFrontScreen: function($element, title) {
    // $("body").animate({ scrollTop: 0 }, 0);
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
      var rotateDegree = $(this).hasClass('middle') ? (Math.random() * 10 - 5) : (Math.random() * 5 - 2.5);
      $(this).css({
        '-webkit-transform-origin': (Math.random() * 40 + 30) + '% ' + (Math.random() * 40 + 30) + '%',
        '-webkit-transform': 'rotate(' + rotateDegree + 'deg)'
      });
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
    // return  "<div id ='debug'><span id='x'>x</span> <span id='y'>y</span></div>"+
    return   "<div id='flicker_container'>" +
               "<div id='groups_container' class='back_screen'></div>" +
               "<div id='group_items_container' class='back_screen'></div>" +
               "<div id='detail_container' class='back_screen'></div>" +
             "</div>";
  },

  leftNavHomeButton: function() {
    return '<a href="#" id="overview_link" ><img alt="home" src="/images/iwebkit/home.png" /></a>';
  },

  groups: function(groups) {
    var templ =
      "<ul id='groups'>" +
        "<% _.each(groups, function(group) { %>" +
          "<li><%= Kos.PocketUi.Templates.group(group) %></li>" +
        "<% }); %>" +
      "</ul>";
    return _.template(templ, { groups: groups });
  },

  group: function(group) {
    // var templ =
    //   "<div class='card_stack'>" +
    //     "<div class='group small_card under'>" +
    //       "<img src='<%= image_path %>'/><br/><%= title %>" +
    //     "</div>" +
    //     "<div class='group small_card upper' id='group_<%= id %>'>" +
    //       "<img src='<%= image_path %>'/><br/><%= title %>" +
    //     "</div>" +
    //   "</div>";
    // item_ids.length
    var templ =
      "<div class='card_stack'>" +
        "<div class='group small_card under'>" +
          "<img src='<%= image_path %>'/><br/><%= title %>" +
        "</div>" +
        "<% if(item_ids.length > 1) { %>" +
          "<% for (i = 1; i <= 2; i++) { %>" +
            "<div class='group small_card middle'>" +
              "<img src='<%= image_path %>'/><br/><%= title %>" +
            "</div>" +
          "<% }; %>" +
        "<% }; %>" +
        "<div class='group small_card upper' id='group_<%= id %>'>" +
          "<img src='<%= image_path %>'/><br/><%= title %>" +
        "</div>" +
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


_.extend(_, {
  inGroupsOf: function(obj, number) {
    var results = [];
    _.each(obj, function(value, index, list) {
      if( (index % number) === 0 ) {
        results.push( list.slice(index, index + number) );
      }
    });
    return results;
  }
});


$(function(){
  // prevent scrolling via touch/swipe
  // $('body').bind('touchmove', function(e) { e.preventDefault(); });
  Kos.PocketUi.init();
});


// for debugging
var Item = Kos.PocketUi.Item;
var Group = Kos.PocketUi.Group;

// FlickerManager = {
//   initStartPosition: function(event) {
//     var touch = event.touches[0];
//     this.started = true;
//     this.startX = touch.pageX;
//     this.startY = touch.pageY;
//     this.threshold =  100;
//   },
//   
//   move: function(event, $container) {
//     var touch = event.touches[0];
// 
//     $('#x').html(touch.pageX);
//     var currentPosition = $container.offset().left;
// 
//     if(touch.pageX > this.startX) {
//       // right
//       var nextPosition = currentPosition + touch.pageX - this.startX;
//     }
//     
//     if(touch.pageX < this.startX) {
//       // left
//       var nextPosition = currentPosition + touch.pageX + this.startX;
//     }
//     
//     $container.offset({left: nextPosition });
// 
// 
//     // $($container).css({left: nextPosition + 'px'});
//     $('#y').html(nextPosition);
//     // $('#y').html($container.css('left'));
// 
//   }
// };
// 
