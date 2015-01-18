define([
	'jquery',
	'underscore',
	'backbone',
	'app/models/Plant'],
function($, _, Backbone, Plant) {
	return Backbone.Collection.extend({
		model: Plant,
		url: 'index.php/api/v0/plants'
	});
});
