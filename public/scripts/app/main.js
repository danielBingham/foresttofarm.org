require([
	'jquery',
	'underscore',
	'backbone',
	'app/models/Plants',
	'app/views/PlantsView'],
function($, _, Backbone, Plants, PlantsView) {
	var plants = new Plants();
	var plant_view = new PlantsView({collection:plants});

	plants.fetch();
});
