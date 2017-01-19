/**
 * Plant List View
 *
 * Shows a scrollable, pageable list of plant short info boxes.
 *
 */
define([
	'jquery',
	'underscore',
    'mustache',
    'app/views/abstract/AbstractParentView',
    'text!app/templates/plant-list-template.html',
	'app/views/PlantBoxView'],
function($, _, Mustache, AbstractParentView, template, PlantBoxView) {

    /**
     * @todo Comment.
     */
	var PlantListView = AbstractParentView.extend({

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

        /**
         * 
         */
        parse: function() {
            var list = Mustache.render(template);
            return $.parseHTML(list);
        },

        /**
         *
         */
        create: function() {
            AbstractParentView.prototype.create.call(this);

            _.each(this.collection.models, _.bind(function(plant) {
                this.appendSubview(new PlantBoxView({model: plant}));
            }, this));

            return this;
        },

        /**
         * Update the plant list view.  If provided a list of changes to 
         * the plant collection, then add or remove ``PlantBoxView`` objects
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
                _.each(changes.added, _.bind(function(plant) {
                    this.appendSubview(new PlantBoxView({model:plant}));
                }, this));

                _.each(changes.removed, _.bind(function(plant) {
                    var subview = _.find(this.subviews, function(test_subview) {
                        if (test_subview.model.id == plant.id) {
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

    return PlantListView;
});
