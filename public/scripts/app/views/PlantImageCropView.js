/**
 * PlantImageCropView 
 *
 * A view to allow cropping of plant images.
 */
define([
	'jquery',
	'underscore',
	'mustache',
    'jcrop',
    'app/models/CropGeometry',
    'app/views/abstract/AbstractView',
    'app/services/ImageService',
	'text!app/templates/plant-image-crop-template.html'],
function($, _, Mustache, Jcrop, CropGeometry,AbstractView,ImageService,template) {

    /**
     * A view to allow upload of Images to Plants.
     */
    var PlantImageCropView = AbstractView.extend({

        /**
         * A reference to the application's router.
         */
        router: null,

        /**
         * The image endpoint of the plant we're cropping an image for.
         */
        crop_endpoint: null,

        /**
         * Initialize the view with an Image cropper and bind to the
         * change event of the image field.  This will trigger an image
         * upload after the user selects an image.
         *
         * @param   {Object}    options An options hash with the structure:
         *  - plant_id  {int}   The id of the plant to which we are uploading
         *      images.
         *
         * @returns {void}
         */
        initialize: function(options) {
            AbstractView.prototype.initialize.call(this, options);

            this.router = options.router;
            this.crop_geometry = new CropGeometry();

            this.listenTo(this.model, 'change', _.bind(this.update, this));
           
            var image_service = new ImageService(
                '/api/v0/plants/' + this.model.get('plant_id')); 

            var image_cropper = image_service.getCropper()
                .setSuccessCallback(_.bind(this.cropSucceeded, this))
                .setErrorCallback(_.bind(this.cropFailed, this));

            this.launchJCrop(image_cropper); 
        },

        /**
         * Bind to events to set up Jcrop and then launch JCrop.
         *
         * @returns {undefined}
         */
        launchJCrop: function(image_cropper) {
            $(".crop-wrapper button").click(_.bind(function(event) {
                alert('Clicked!');
               // image_cropper.crop(this.model, this.crop_geometry); 
            }, this));

            $(document).ready(_.bind(function() {
                $("#image-to-crop").Jcrop({
                    onRelease: _.bind(this.crop_geometry.updateFromJCrop, 
                        this.crop_geometry),
                    addClass: 'jcrop-centered',
                    aspectRatio: 1
                });
            },this));
        },

        /**
         * Handle a crop failure.  Called directly from the jqXHR returned
         * by Jquery's ajax handler.  
         *
         * @see http://api.jquery.com/jquery.ajax/ 
         */
        cropFailed: function(jqXHR, textStatus, errorThrown) {
            this.showError('Attempt to crop image failed.  Please report this and try again.');
            // TODO log the error some how
        },
        
        /**
         * Handle crop success.  Called directly from the jqXHR returned
         * by Jquery's ajax handler.
         *
         * @see http://api.jquery.com/jquery.ajax/ 
         */
        cropSucceeded: function(data, textStatus, jqXHR) {
            this.router.navigate('/plants/' + this.model.get('plant_id') + '/images/' + this.model.get('id')); 
        },

        /**
         * Create an upload form to allow uploading of images for
         * the given plant.
         *
         * @return  {JQuery}    A jquery element object with the parsed
         *  template and model data.
         */
        parse: function() {
            var rendered_template = Mustache.render(
                template,
                {
                    id: this.model.get('id'),
                    plant_id: this.model.get('plant_id'),
                    full_path: this.model.get('full_path')
                }
            );

            return $.parseHTML(rendered_template.trim());
        },

        /**
         * Show an error message in the view.
         *
         * @param   {String}    error_message   The message we want to display.
         *
         * @returns {void}
         */
        showError: function(error_message) {
            this.$el.find('#errors').html(error_message);
        },
        
        /**
         * Update the view to show the newly loaded image or to show any changes
         * to the image.
         *
         * @returns {void}
         */
        update: function() {
            this.$el.find('img').attr('src', this.model.get('full_path'));
            return this;
        }

    });

    return PlantImageCropView;
});
