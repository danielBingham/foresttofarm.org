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
         * Has this view been created?
         *
         * @type    {boolean}
         */
        is_created: true,

        /**
         * Is this view attached to the DOM?
         *
         * @type    {boolean}
         */
        is_attached: true,
       
        /**
         * A list of subviews that have already been rendered in the order of
         * their rendering (and thus their appearance in the browser).
         *
         * @type    {Backbone.View}
         */ 
        rendered_subviews: [],

        /**
         * A queue of subviews awaiting rendering in order of their rendering.
         *
         * @type    Backbone.View
         */
        subviews_to_render: [], 

        /**
         * Add a subview to the queue of views awaiting rendering.
         *
         * @param   Backbone.View   subview The subview to add to the render
         *  stack.
         *
         * @return this
         */ 
        appendSubview: function(subview) {
            this.subviews_to_render.push(subview);
            return this;
        },

        renderSubviews: function() {
            var subview = null;
            while (subview = this.subviews_to_render.shift() ) {
                this.$el.append(subview.render().$el);
                this.rendered_subviews.push(subview);
            }
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

        create: function() {
            this.renderSubviews();
        },

        update: function() {
            this.renderSubviews();
        },

        /**
         * Render any subviews attached to the main view but not yet rendered.
         *
         * @return  this
         */
		render: function() {
            if ( ! this.is_created ) {
                this.create();
            } else {
                this.update();
            }

            return this;
		}


	});

    return MainView;
});
