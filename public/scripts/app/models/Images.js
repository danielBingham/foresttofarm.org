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
         * This collection can wrap any image endpoint, but it must be
         * initialized with the parent endpoint.
         */
        base_url: null,
        
        initialize: function(models, options) {
            this.base_url = options.base_url;
        },

        getUrl: function() {
            if ( this.base_url == null ) {
                throw new Error('Images collection requires a ``base_url`` to be set!');
            }

            return this.base_url + '/images';
        }

	});
});
