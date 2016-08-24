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
     * A base class for views that need to wrap child views.
     */
	var AbstractParentView = AbstractView.extend({

        /**
         * An array of subviews that have been added to this view. Needs
         * to be created in the ``initialize()`` method.  If it's created
         * here, then all instances of AbstractParentView will end up sharing
         * the same subview array.
         *
         * @type    AbstractView[]
         */
        subviews: null,

        /**
         * Initialize the parent view.
         *
         * @return {void}
         */
        initialize: function() {
            this.subviews = []; // This is necessary to prevent all instances of
            // AbstractParentView from sharing the same subviews array.

            AbstractView.prototype.initialize.call(this);
        },

        /**
         * Append a subview to this view's structure and the DOM structure.  
         *
         * @param   {AbstractView}  subview The subview to add to this view.
         *
         * @return  this
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
         * Mark this view and any subviews as being attached to the DOM.
         *
         * @return this
         */
        markAttachedToDOM: function() {
            _.each(this.subviews, function(subview) {
                subview.markAttachedToDOM();
            });

            AbstractView.prototype.markAttachedToDOM.call(this);
            return this;
        },

        /**
         * Update this view and any subviews.
         *
         * @return  this
         */
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
