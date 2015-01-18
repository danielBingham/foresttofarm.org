require([
	'jquery',
	'underscore',
	'backbone',
	'app/models/Plants',
	'app/views/PlantsView'],
function($, _, Backbone, Plants, PlantsView) {
	var plants = new Plants();
	plants.fetch();
	var plantsView = new PlantsView({collection: plants});

	$('#main').html(plantsView.render().el); 
});
