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

		render: function() {
			var display_box = $("#display-box-template").clone();
			display_box.attr('id', 'plant-' + this.model.get('id'));
			display_box.find('.title').html(this.model.get('genus') + ' ' + this.model.get('species'));
			display_box.find('.sub-title').html(this.model.get('common_names')[0].name);
			this.$el = display_box;
			return this;
		}
	});
});
