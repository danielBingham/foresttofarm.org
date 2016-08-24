require([
	'jquery',
	'underscore',
    'backbone',
    'app/router',
    'app/views/HeaderMenuView',
    'app/views/MainMenuView'],
function($, _, Backbone, Router, HeaderMenuView, MainMenuView) {

    // Build the menu view structure.  These don't render anything, they bind
    // to existing elements in our layout already rendered to the DOM.
    var header_menu_view = new HeaderMenuView({el: '#header-menu'});
    header_menu_view.setMainMenuView(new MainMenuView({el: '#main-menu'})); 

    var router = new Router();
   
});
