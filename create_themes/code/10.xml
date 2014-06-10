(function() {
  'use strict';
  var website = openerp.website;
  website.openerp_website = {};
  website.snippet.animationRegistry.my_snippet = website.snippet.Animation.extend({
  
    selector : ".mt_simple_snippet",
    
    start: function(){
      var h1 = this.$el.find("h1");
      var h1_width = h1.width();
      h1.css('width',0);
      h1.animate( { width: h1_width }, 3000 );
    },
  
  });
})();