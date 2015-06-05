
/**
 * PlantDetailView
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

		render: function() {
			var plant_detail = Mustache.render(
				template,
                this.model.toJSON()
			);

			this.$el = $.parseHTML(plant_detail);
			return this;
		}
	});
});
