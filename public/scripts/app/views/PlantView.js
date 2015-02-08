/**
 * PlantView
 */
define([
	'jquery',
	'underscore',
	'backbone',
	'mustache',
	'text!app/templates/plant-box-template.html'],
function($, _, Backbone,Mustache,template) {
	return Backbone.View.extend({
		tagName: 'li',	
		className: 'display-box',

		render: function() {
			var display_box = Mustache.render(
				template,
				{
					id: this.model.get('id'),
					genus: this.model.get('genus'),
					species: this.model.get('species'),
					common_name: this.model.get('common_names')[0].name
				}
			);

			this.$el = $.parseHTML(display_box);
			return this;
		}
	});
});
