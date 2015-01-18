/**
 * PlantView
 */
define([
	'jquery',
	'underscore',
	'backbone'],
function($, _, Backbone) {
	return Backbone.View.extend({
		tagName: 'li',	
		className: 'display-box',

		template: _.template($('#display-box-template').html()),

		render: function() {
			$(this.el).html(this.template(this.model.getDisplayBoxData()));
			return this;
		}
	});
});
