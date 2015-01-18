require([
	'jquery',
	'underscore',
	'backbone']
function($,_,Backbone) {
	return Backbone.Model.extend({
		urlRoot: '/api/v0/plant'
	});
});
