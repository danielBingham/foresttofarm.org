/**
 * AbstractParentView
 *
 * An abstract view that tracks and manages subviews.
 */
define([
	'jquery',
	'underscore',
    'app/views/abstract/AbstractView'],
function($, _, AbstractView) {

    /**
     *
     */
	var AbstractParentView = AbstractView.extend({

        /**
         *
         */
        subviews: [],

        /**
         *
         */
        appendSubview: function(subview) {
            this.subviews.push(subview);
            this.$el.append(subview.$el);
            if ( this.is_attached_to_DOM ) {
                subview.markAttachedToDOM();
            }

            return this;
        },

        /**
         * Attach a subview to the DOM of the parent view. 
         */
        attachSubviewToParent: function(subview) {
            return this;
        },

        markAttachedToDOM: function() {
            _.each(this.rendered_subviews, function(subview) {
                subview.markAttachedToDOM();
            });

            AbstractView.prototype.markAttachedToDOM.call(this);
            return this;
        },

        update: function() {
            AbstractView.prototype.update.call(this);

            _.each(this.subviews, function(subview) {
                subview.render();
            });
            
            return this;
        }

	});

    return AbstractParentView;
});
