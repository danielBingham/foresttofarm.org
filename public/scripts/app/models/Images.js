/**
 * Images
 *
 * A model to represent an image collection.
 */
define([
	'jquery',
	'underscore',
	'backbone',
	'app/models/Plant'],
function($, _, Backbone, Plant) {
	return Backbone.Collection.extend({

        /** 
         * This collection needs a plant_id in order to retrieve images, since
         * images are has many child of plants.
         */
        plant_id: null,
        
        initialize: function(models, options) {
            this.plant_id = options.plant_id;
        },

        url: function() {
            if ( this.plant_id == null ) {
                throw new Error('Images collection requires a ``plant_id`` to be set!');
            }

            return '/api/v0/plants/' + this.plant_id + '/images';
        }

	});
});
