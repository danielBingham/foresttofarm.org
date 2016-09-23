/**
 * Image Model
 */

define([
	'jquery',
	'underscore',
	'backbone'],
function($, _, Backbone) {
	return Backbone.Model.extend({

        /**
         * This model can wrap any image endpoint, but it must
         * be initialized with the parent endpoint.
         */
        base_url: null,

        initialize: function(options) { 
            this.base_url = options.base_url;
        },

        getUrl: function() {
            if ( this.base_url == null) {
                throw new Error('Image model requires a ``base_url`` to be set!');
            }

            return this.base_url + '/images';
        }

	});
});
