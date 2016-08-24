
/**
 * A View to handle the header main menu of the site.
 */
define([
    'jquery',
    'underscore',
    'backbone'],
function($, _, Backbone, Mustache) {
 
    var HeaderMenuView = Backbone.View.extend({

        events: {
            'click a.icon-menu': 'showMenu',

        },

        showMenu: function(e) {
            e.preventDefault();     
            $("header nav a.icon-menu").hide();
            $("nav#main-menu").animate({width: "toggle", opacity: "toggle"}, 200);
            return false;
        }

    });

    return HeaderMenuView; 
});
