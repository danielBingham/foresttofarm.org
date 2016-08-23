require([
	'jquery',
	'underscore',
    'backbone',
    'app/router'],
function($, _, Backbone, Router) {
    var router = new Router();

    $("header nav a.icon-menu").click(function(e) {
        e.preventDefault();     
        $("header nav a.icon-menu").hide();
        $("nav#main-menu").animate({width: "toggle", opacity: "toggle"}, 200);
        return false;
    });

    var hideMenu = function() {
        $("nav#main-menu").animate(
            {width: "toggle", opacity: "toggle"}, 
            200, 
            function() {
                $("header nav a.icon-menu").show();
            }
        );
    };

    $("nav#main-menu a").click(hideMenu);
    $("nav#main-menu a.icon-menu").click(function(e) {
        e.preventDefault();
        return false;
    });

   
   
});
