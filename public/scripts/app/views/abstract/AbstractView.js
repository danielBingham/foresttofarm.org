/**
 * AbstractView
 *
 * The AbstractView that lays out the method skeleton our views will use.
 */
define([
	'jquery',
	'underscore',
	'backbone'],
function($, _, Backbone) {

    /**
     * An exception thrown by errors in the views.
     */
    var ViewException = function(message) {
        this.message = message;
        this.getMessage = function() {
          return this.message;
        };  
    };

    /**
     * The abstract base view underlying all other views in Forest to Farm.
     * Sets up the parse / create / update / render logic.  
     *
     * !!NOTE!!  Certain methods in this view, such as ``parse()`` must be
     * overridden in order for the view to function.  If they are not
     * overridden, the view will throw an exception on initialization when
     * create is called.
     */
	var AbstractView = Backbone.View.extend({
        
        /**
         * Has this view been created yet?
         *
         * @type    {boolean}
         */
        is_created: false,


        /**
         * Has this view been attached to the DOM yet?
         *
         * @type    {boolean}
         */
        is_attached_to_DOM: false,

        /**
         * Mark this view as having been attached to the DOM.
         *
         * @return this
         */
        markAttachedToDOM: function() {
            this.is_attached_to_DOM = true;
            return this;
        },

        /**
         * Mark this view as having been detached from the DOM.
         *
         * @return this
         */
        markUnattachedFromDOM: function() {
            this.is_attached_to_DOM = false;
            return this;
        },

        /**
         * Initialize this view and create its DOM elements.
         *
         */
		initialize: function() {
            this.create();
		},

        /**
         * This method parses any templates used by this view, assembles them,
         * and then should return a JQuery object representing them.
         *
         * @note This method must be overridden in child views.
         *
         * @throws  ViewException  If not overridden will throw a view exception.
         *
         * @return  {JQuery}    A jquery object containing the parsed template
         *  HTML. 
         */
        parse: function() {
            throw new ViewException('Parse must be overridden and implemented.'); 
        },

        /**
         * Parse this view's template data and assign the parsed templates to
         * this view's element (``this.el``).  Then mark this view as created.
         *
         * @return  {this}
         */
        create: function() {
            this.setElement(this.parse());
            this.is_created = true;
            return this;
        },

        /**
         * Remove this view from the DOM, remove event handlers, stop
         * listening, and destroy its element.  Resets the view to the
         * pre-initialize state. You can still use this view object, but you'll
         * need to call ``render()`` or ``create()`` again before using it.
         *
         * @return  this
         */
        destroy: function() {
            this.remove();
            this.undelegateEvents();
            this.el = null;
            this._ensureElement();
            this.is_created = false;
            this.markUnattachedFromDOM();
            return this;
        },

        /**
         * Update this view's data in the DOM.  Assumes this view's element
         * has already been created.
         *
         * @return  {this}
         */
        update: function() {
            return this; 
        },

        /**
         * Render this view.  If the view needs to be create it, then create
         * it.  Otherwise, just update it.
         *
         * @return  {this}
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

    return AbstractView;
});
