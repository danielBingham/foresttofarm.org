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
			var plant_detail_template  = Mustache.render(
				template,
                plant_json
			);

			return $.parseHTML(plant_detail_template.trim());
        }

	});

    return PlantDetailView;
});
