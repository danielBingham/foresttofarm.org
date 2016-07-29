/**
 * A View wrapping for the main content area of the site.
 */
define([
	'jquery',
	'underscore',
	'backbone',
	'mustache'],
function($, _, Backbone,Mustache) {

	var MainView = Backbone.View.extend({
       
        /**
         * A list of subviews that have already been rendered in the order of
         * their rendering (and thus their appearance in the browser).
         *
         * @type    Backbone.View
         */ 
        renderedSubviews: [],

        /**
         * A queue of subviews awaiting rendering in order of their rendering.
         *
         * @type    Backbone.View
         */
        subviewsToRender: [], 


        /**
         * Add a subview to the queue of views awaiting rendering.
         *
         * @param   Backbone.View   subview The subview to add to the render stack.
         *
         * @return this
         */ 
        appendSubview: function(subview) {
            this.subviewsToRender.push(subview);
            return this;
        },
        

        /**
         * Clear out the content area.
         *
         * @return  this
         */
        clear: function() {
            this.subviews = [];
            this.$el.empty();
            return this;
        },

        /**
         * Render the main view area and all subviews in the
         * ``subviewsToRender`` queue.
         *
         * @return  this
         */
		render: function() {
            var subview = null;
            while(subview = this.subviewsToRender.shift() ) {
                this.$el.append(subview.render().$el);
                this.renderedSubviews.push(subview);
            }
            return this;
		}


	});

    return MainView;
});
