/**
 * Layout 
 *
 * A service to manage the layout of the our app. 
 *
 * Usage Examples:
 *
 * To append content to the layout:
 *
 * ```
 * layout.append(content).render();
 * ```
 *
 * To replace the content in the layout:
 *
 * ```
 * layout.setContent(content).render();
 * ```
 * 
 *
 */
define([
	'jquery',
	'underscore',
	'backbone',
	'mustache'],
function($, _, Backbone,Mustache) {
	return Backbone.View.extend({
		tagName: 'div',	
        idName: 'main',

        /**
         * A string representing the content we'd like to be rendered into
         * the layout.
         *
         * @type   jquery object 
         */
         $contents: [],

        /**
         * Replace the current content in the layout.
         */
        setContent: function($content) {
            this.$contents = [$content];
            return this;
        },

        /**
         * Append the content to the current layout.
         *
         * @param   {jquery}    $content
         */
        appendContent: function($content) {
            this.$contents.push($content);
            return this;
        },

        /**
         * Render this plant display box from the template.
         */
		render: function() {
			this.$el.empty();
            this.$el.append(this.$contents);
			return this;
		}
	});
});
