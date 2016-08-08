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
         *
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

        update: function(changes) {
            if ( changes ) {
                _.each(changes.added, _.bind(function(plant) {
                    this.appendSubview(new PlantBoxView({model:plant}));
                }, this));

                _.each(changes.removed, _bind(function(plant) {
                    var subview = _.find(this.subviews, function(test_subview) {
                        if (test_subview.model.id == plant.id) {
                            return true;
                        } else {
                            return false;
                        }
                    });
                    subview.remove();
                    delete subview;
                }, this));
           
               // TODO Handle merges. 
            }   

            AbstractParentView.prototype.update.call(this);
        }



	});

    return PlantListView;
});
