/**
 * PlantView
 */
define([
	'jquery',
	'underscore',
	'backbone',
	'app/views/PlantBoxView'],
function($, _, Backbone, PlantBoxView) {
	return Backbone.View.extend({
		initialize: function() {
			this.listenTo(this.collection, 	'sync', this.render);
		},

		render: function() {
			this.$el = $("#main ul#plants");

			_.each(this.collection.models, function(plant) {
				var plant_box_view = new PlantBoxView({model: plant});
				plant_box_view.render();
				this.$el.append(plant_box_view.$el[0].outerHTML);	
			}, this);
			return this;
		}

	});

});
