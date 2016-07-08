require([
	'jquery',
	'underscore',
	'backbone',

    'router'
	'app/models/Plants',
	'app/views/PlantsView'],
function($, _, Backbone, Router, Plants, PlantsView) {
    var router = new Router();
    Backbone.history.start({ pushState: true, root: '/' });
});
