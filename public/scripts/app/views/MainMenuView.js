/**
 * A View to handle the main menu of the site.
 */
define([
    'jquery',
    'underscore',
    'backbone'],
function($, _, Backbone, Mustache) {
 
    var MainMenuView = Backbone.View.extend({

        events: {
            'click a': 'hideMenu',
            'click a.icon-menu': 'menuIconClicked',

        },

        hideMenu: function() {
            $("nav#main-menu").animate(
                {width: "toggle", opacity: "toggle"}, 
                200, 
                function() {
                    $("header nav a.icon-menu").show();
                }
            );
        },

        menuIconClicked: function(e) {
            e.preventDefault();
            return false;
        }

    });

    return MainMenuView; 
});
