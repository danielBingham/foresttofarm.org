/**
 * Plant Model
 */
define([
	'jquery',
	'underscore',
	'backbone'],
function($, _, Backbone) {
	return Backbone.Model.extend({
		urlRoot: '/api/v0/plants',

	});
});
