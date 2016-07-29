/**
 * Plant List View
 *
 * Shows a scrollable, pageable list of plant short info boxes.
 *
 * @class   PlantsView
 */
define([
	'jquery',
	'underscore',
	'backbone',
	'app/views/PlantBoxView'],
function($, _, Backbone, PlantBoxView) {

    /**
     *
     */
	var PlantsView = Backbone.View.extend({
        tagName: 'ul',
        attributes: {
            id: 'plants'
        },

        /**
         *
         */
        renderedSubviews: [],

        /**
         *
         */
        subviewsToRender: [],

        /**
         *
         */
		initialize: function() {
			this.listenTo(this.collection, 	'sync', this.update);
		},

        /**
         *
         */
        appendSubview: function(subview) {
            this.subviewsToRender.push(subview);
            return this;
        },

        /**
         *
         */
        update: function() {
            _.each(this.collection.models, function(plant) {
                var viewRendered = _.find(this.renderedSubviews, 
                    function(subview) {
                        return (subview.model.id == plant.id);
                    }
                );

                if ( ! viewRendered ) {
                    this.appendSubview(new PlantBoxView({model: plant}));
                }

            }, this);

            this.render();
        },

        /**
         *
         */
		render: function() {
            var subview = null;
            while(subview = this.subviewsToRender.shift()) {
                this.$el.append(subview.render().$el);
                this.renderedSubviews.push(subview);
            } 
                  
			return this;
		}

	});

    return PlantsView;
});
