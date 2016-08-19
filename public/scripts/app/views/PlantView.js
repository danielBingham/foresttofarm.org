/**
 * PlantView
 */
define([
	'jquery',
	'underscore',
	'mustache',
    'app/views/abstract/AbstractView',
	'text!app/templates/plant-detail-template.html'],
function($, _, Mustache,AbstractView,template) {
	var PlantDetailView = AbstractView.extend({

        initialize: function() {
            AbstractView.prototype.initialize.call(this); 

            this.listenTo(this.model, 'change', _.bind(this.update, this));
        },

        update: function() {
            var $newEl = this.parse();
            this.$el.replaceWith($newEl);
            this.setElement($newEl);
            return this;
        },

        parse: function() {
            var plant_json = this.model.toJSON();
           
            // Collapse height values down to a single one. 
            if ( plant_json.minimum_height ) {
                plant_json.height = plant_json.minimum_height + ' - ' + plant_json.maximum_height;
            } else {
                plant_json.height = plant_json.maximum_height;
            }

            // Collapse width values down to a single one. 
            if ( plant_json.minimum_width ) {
                plant_json.width = plant_json.minimum_width + ' - ' + plant_json.maximum_width;
            } else {
                plant_json.width = plant_json.maximum_width;
            }

            // Collapse Zone values down to a single one.
            if( plant_json.maximum_zone ) {
                plant_json.zone = plant_json.minimum_zone + ' - ' + plant_json.maximum_zone;
            } else {
                plant_json.zone = plant_json.minimum_zone;
            }

			var plant_detail_template  = Mustache.render(
				template,
                plant_json
			);

			return $.parseHTML(plant_detail_template.trim());
        }

	});

    return PlantDetailView;
});
