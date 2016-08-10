/**
 * PlantBoxView
 *
 * A view partial to display a plant's box in the list view.
 *
 */
define([
	'jquery',
	'underscore',
	'mustache',
    'app/views/abstract/AbstractView',
	'text!app/templates/plant-box-template.html'],
function($, _, Mustache,AbstractView,template) {

    /**
     * A view wrapping and managing the list display box for each plant.
     */
	var PlantBoxView = AbstractView.extend({

        /**
         * Initialize this view.  Bind the change events, create and attach the
         * DOM element.
         *
         * @return  {void}
         */
		initialize: function() {
            AbstractView.prototype.initialize.call(this);

            this.listenTo(this.model, 'change', _.bind(this.update, this));
		},

        /**
         * Parse this view's mustache template and populate it with data from
         * the model.
         *
         * @return  {JQuery}    A jquery element object with the parsed
         *  template and model data.
         */
        parse: function() {
			var display_box = Mustache.render(
				template,
				{
					id: this.model.get('id'),
					genus: this.model.get('genus'),
					species: this.model.get('species'),
					common_name: this.model.get('common_names')[0].name
				}
			);

            return $.parseHTML(display_box);
        },

        /** 
         * Update this view.  Don't recreate it, instead insert the new data
         * into the existing element.
         *
         * @return this 
         */
        update: function() {
            this.$el.find("a.title")
                .html(this.model.get('genus') + ' ' + this.model.get('species')); 
            this.$el.find("span.sub-title")
                .html(this.model.get('common_names')[0].name);
            return this;

        }
	});

    return PlantBoxView;
});
