/**
 * PlantImageView
 *
 * A view partial to display a plant's box in the list view.
 *
 */
define([
	'jquery',
	'underscore',
	'mustache',
    'app/views/abstract/AbstractView',
	'text!app/templates/plant-image-template.html'],
function($, _, Mustache,AbstractView,template) {

    /**
     * A view wrapping and managing an image view for a single plant image.
     */
	var PlantImageView = AbstractView.extend({

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
			var image_template = Mustache.render(
				template,
				{
					id: this.model.get('id'),
                    plant_id: this.model.get('plant_id'),
					cropped_path: this.model.get('cropped_path'),
                    full_path:  this.model.get('full_path')
				}
			);

            return $.parseHTML(image_template.trim());
        },

        /** 
         * Update this view.  Don't recreate it, instead insert the new data
         * into the existing element.
         *
         * @return this 
         */
        update: function() {
            this.$el.find('img').attr('src', this.model.get('cropped_path'));
            this.$el.find('a').attr('href', '/plants/' + this.model.get('plant_id') + '/images/' + this.model.get('id'));
            this.$el.find('li').attr('id', 'image-' + this.model.get('id'));
            return this;
        }
	});

    return PlantImageView;
});
