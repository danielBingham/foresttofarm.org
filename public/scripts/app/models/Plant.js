/**
 * Plant Model
 */

define([
	'jquery',
	'underscore',
	'backbone'],
function($, _, Backbone) {
	return Backbone.Model.extend({
		urlRoot: '/index.php/api/v0/plant',

	});
});
