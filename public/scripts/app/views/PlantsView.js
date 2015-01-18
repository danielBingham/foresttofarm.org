/**
 * PlantView
 */
define([
	'jquery',
	'underscore',
	'backbone',
	'app/views/PlantView'],
function($, _, Backbone, PlantView) {
	return Backbone.View.extend({
		tagName: 'ul',

		id: 'plants',

		render: function() {
			_.each(this.collection.models, function(plant) {
				var plant_view = new PlantView({model: plant});
				$(this.el).append(plant_view.render().el);	
			}, this);
			return this;
		}

	});

});
