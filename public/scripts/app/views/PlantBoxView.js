/**
 * PlantBoxView
 *
 * A view partial to display a plant's box in the list view.
 *
 */
define([
	'jquery',
	'underscore',
	'backbone',
	'mustache',
	'text!app/templates/plant-box-template.html'],
function($, _, Backbone, Mustache,template) {

    /**
     * A view wrapping and managing the list display box for each plant.
     */
	var PlantBoxView = Backbone.View.extend({
		tagName: 'li',	
		className: 'display-box',

        /**
         * Has this view been created and attached to the DOM?
         *
         * @type    {boolean}
         */
        is_attached: false,

        /**
         * Has this element been created?
         *
         * @type    {boolean}
         */
        is_created: false,

        /**
         * Initialize this view.  Bind the change events, create and attach the
         * DOM element.
         *
         * @return  {void}
         */
		initialize: function() {
            this.listenTo(this.model, 'change', _.bind(this.update, this));

            this.create();
		},
        
        /**
         * Mark whether or not this view has been attached to the DOM.
         *
         * @param   {boolean}   attached    If true, this view has been 
         *      attached to the DOM.  If false, it hasn't been or has been
         *      removed.
         *
         * @return  {this}
         */
        setAttached: function(attached) {
            this.is_attached = attached;
            return this;
        },

        /**
         * Parse this view's mustache template and populate it with data from
         * the model.
         *
         * @return  {JQuery}    A jquery element object with the parsed
         *  template and model data.
         */
        parse: function() {
			var display_box = Mustache.render(
				template,
				{
					id: this.model.get('id'),
					genus: this.model.get('genus'),
					species: this.model.get('species'),
					common_name: this.model.get('common_names')[0].name
				}
			);

            return $.parseHTML(display_box);
        },

        /**
         * Create this view's element from the mustache template and model.
         *
         * @return  {this}
         */
        create: function() {
            this.setElement(this.parse());
            this.is_created = true;
            return this;
        },

        /** 
         * Update this view.  Don't recreate it, instead insert the new data
         * into the existing element.
         *
         * @return  {void}
         */
        update: function() {
            this.$el.find("a.title")
                .html(this.model.get('genus') + ' ' + this.model.get('species')); 
            this.$el.find("span.sub-title")
                .html(this.model.get('common_names')[0].name);
            return this;

        },

        /**
         * Render this plant display box from the template.
         *
         * @return  {void}
         */
		render: function() {
            if( ! this.is_created) {
                this.create();
            } else {
                this.update();
            }

			return this;
		}
	});

    return PlantBoxView;
});
