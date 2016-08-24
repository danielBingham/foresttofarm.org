/**
 * A View to handle the main menu of the site.
 */
define([
    'jquery',
    'underscore',
    'backbone'],
function($, _, Backbone, Mustache) {

    /**
     * View wrapper for the main menu (``#main-menu``).  Intended to wrap
     * an existing DOM element and bind events to it. 
     */ 
    var MainMenuView = Backbone.View.extend({

        // We bind to the link events in the menu this way because we want to
        // perform two slightly different actions.  When menu links clicked, we
        // want to change the page and hide the menu.  When the menu icon is
        // clicked, we just want to hide the menu, we don't want to change or
        // reload the page.  
        //
        // For clarity, we bind to explicitly non-overlapping events and perform
        // the actions in the bound methods.
        events: {
            'click a.icon-menu': 'menuButtonClicked', 
            'click a:not(.icon-menu)': 'hide'  
        },

        /**
         * Hide the main menu.
         *
         * @return  void
         */
        hide: function() {
            this.$el.animate(
                {width: "toggle", opacity: "toggle"}, 
                200, 
                _.bind(function() {
                    this.trigger('menus.main.hidden');
                }, this)
            );
        },

        /**
         * Show the main menu.
         *
         * @return  void
         */
        show: function() {
            this.$el.animate(
                {width: "toggle", opacity: "toggle"}, 
                200,
                _.bind(function() {
                    this.trigger('menus.main.shown');
                }, this)
            );
        },

        /**
         * When any link is clicked, we want to hide the menu.  However, when
         * the menu button is clicked we want to hide the menu with out changing
         * the page.  So we use this handler method for the menu icon link to
         * hide the menu and prevent a page refresh. 
         *
         * Note: Intended for binding to a JQuery or Backbone event.
         *
         * @return  boolean Returns false in order to stop propagation and 
         *      prevent the default.
         */
        menuButtonClicked: function(e) {
            this.hide();
            return false;
        }

    });

    return MainMenuView; 
});
