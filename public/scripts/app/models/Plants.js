define([
	'jquery',
	'underscore',
	'backbone',
	'app/models/Plant'],
function($, _, Backbone, Plant) {
	return Backbone.Collection.extend({
		model: Plant,
		url: '/api/v0/plants'
	});
});
