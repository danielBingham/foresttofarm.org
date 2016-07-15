/**
 * PlantView
 */
define([
	'jquery',
	'underscore',
	'backbone',
	'mustache',
	'text!app/templates/plant-detail-template.html'],
function($, _, Backbone,Mustache,template) {
	return Backbone.View.extend({
		tagName: 'div',	
		className: 'plant-detail',

		render: function() {
			var plant_detail = Mustache.render(
				template,
				{
					id: this.model.get('id'),
					genus: this.model.get('genus'),
					species: this.model.get('species'),
					common_name: this.model.get('common_names')[0].name
				}
			);

			this.$el = $.parseHTML(plant_detail);
			return this;
		}
	});
});
