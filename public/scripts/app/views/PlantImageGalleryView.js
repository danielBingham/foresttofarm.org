/**
 * Plant Image Gallery View
 *
 * Shows a scrollable, pageable gallery of images attached to a plant.
 *
 */
define([
	'jquery',
	'underscore',
    'mustache',
    'app/views/abstract/AbstractParentView',
    'text!app/templates/plant-image-gallery-template.html',
	'app/views/PlantImageView'],
function($, _, Mustache, AbstractParentView, template, PlantImageView) {

    /**
     * @todo Comment.
     */
	var PlantImageGalleryView = AbstractParentView.extend({
        /**
         * Initialize the view, calling parent class initializers and binding
         * the view to its events.
         */
		initialize: function() {
            AbstractParentView.prototype.initialize.apply(this,arguments);

			this.listenTo(this.collection, 	'update',
                _.bind(function(collection, options) {
                    this.update(options.changes);          
                }, this)
            );
		},


        parse: function() {
            var list = Mustache.render(
                template, 
                {
                    plant_id: this.collection.plant_id
                }
            );
            return $.parseHTML(list);
        },

        /**
         *
         */
        create: function() {
            AbstractParentView.prototype.create.call(this);

            _.each(this.collection.models, _.bind(function(image) {
                this.appendSubview(new PlantImageView({model: image}));
            }, this));

            return this;
        },

        /**
         * Update the plant image gallery.  If provided a list of changes to 
         * the plant collection, then add or remove ``PlantImageView`` objects
         * as appropriate.  Otherwise, render each subview to update them
         * for any changes.
         *
         * @param   {*} changes Any changes that occurred in the collection.
         *      Hash structure:
         *          changes[added] - Models added to the collection.
         *          changes[removed] - Models removed from the collection.
         *          changes[merged] - TODO What am I?
         *
         * @return this
         */
        update: function(changes) {
            if ( changes ) {
                _.each(changes.added, _.bind(function(image) {
                    this.appendSubview(new PlantImageView({model:image}));
                }, this));

                _.each(changes.removed, _.bind(function(image) {
                    var subview = _.find(this.subviews, function(test_subview) {
                        if (test_subview.model.id == image.id) {
                            return true;
                        } else {
                            return false;
                        }
                    });
                    subview.remove();
                }, this));
            }   

            AbstractParentView.prototype.update.call(this);
            return this;
        }
	});

    return PlantImageGalleryView;
});
