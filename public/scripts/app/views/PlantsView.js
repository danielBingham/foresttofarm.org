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
		initialize: function() {
			this.listenTo(this.collection, 	'sync', this.render);
		},

		render: function() {
			this.$el = $("#main ul#plants");

			_.each(this.collection.models, function(plant) {
				var plant_view = new PlantView({model: plant});
				plant_view.render();
				this.$el.append(plant_view.$el[0].outerHTML);	
			}, this);
			return this;
		}

	});

});
