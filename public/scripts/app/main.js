require([
	'jquery',
	'underscore',
    'backbone',
    'app/router',
    'app/views/HeaderMenuView',
    'app/views/MainMenuView'],
function($, _, Backbone, Router, HeaderMenuView, MainMenuView) {

    var HeaderMenuView = new HeaderMenuView({el: '#header-menu'});
    var MainMenuView = new MainMenuView({el: '#main-menu'});

    var router = new Router();
   
});
