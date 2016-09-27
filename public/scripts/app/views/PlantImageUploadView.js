/**
 * PlantImageUploadView
 *
 * A view to allow uploading of images to plants.
 */
define([
	'jquery',
	'underscore',
	'mustache',
    'app/views/abstract/AbstractView',
    'app/services/ImageService',
	'text!app/templates/plant-image-upload-template.html'],
function($, _, Mustache,AbstractView,ImageService,template) {

    /**
     * A view to allow upload of Images to Plants.
     */
    var PlantImageUploadView = AbstractView.extend({
        /**
         * The database id of the plant we're adding images to.
         */
        plant_id: null,

        /**
         * A reference to the application's router.
         */
        router: null,

        /**
         * Initialize the view with an Image uploader and bind to the
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

            this.plant_id = options.plant_id; 
            this.router = options.router;
            
            var image_service = new ImageService('/api/v0/plants/' + this.plant_id);
            var image_uploader = image_service.getUploader()
                .setBeforeCallback(_.bind(this.beginUpload, this))
                .setProgressCallback(_.bind(this.updateProgress, this))
                .setSuccessCallback(_.bind(this.uploadSuccess, this))
                .setErrorCallback(_.bind(this.uploadError, this));

            this.$el.find("#image").change(function(event) {
                event.preventDefault();
                image_uploader.upload(this.files[0]);
            }); 
        },

        /**
         * Called before we begin the upload.  Allows us to take any preparatory
         * actions that need to happen before we start uploading.
         *
         * @returns {void}
         */
        beginUpload: function() {
            this.$el.find("#image-field").css('display', 'none');
            this.$el.find("progress").css('display', 'block');
        },

        /**
         * Handle progress updates on the upload, updating the UX to show
         * progress.
         *
         * @param   {ProgressEvent} event   A progress event representing the
         * incremented progress. @see
         * https://developer.mozilla.org/en-US/docs/Web/API/ProgressEvent
         *
         * @returns {void}
         */
        updateProgress: function(event) {
            if (event.lengthComputable) {
                this.$el.find("progress").attr({value: event.loaded, max: event.total});
            }
        },

        /**
         * Handle success events on the upload.
         *
         * @param   {Event} event   The standard event object.
         *
         * @returns {void}
         */
        uploadSuccess: function(event) {
            this.$el.find("progress").css('display', 'none');
            this.router.navigate('/plants/'+this.plant_id+'/images', true);
        },

        uploadError: function(event) {

        },

        /**
         * Create an upload form to allow uploading of images for
         * the given plant.
         *
         * @return  {JQuery}    A jquery element object with the parsed
         *  template and model data.
         */
        parse: function() {
            var upload_template = Mustache.render(
                template,
                {
                    plant_id: this.plant_id,
                }
            );

            return $.parseHTML(upload_template.trim());
        }

    });

    return PlantImageUploadView;
});
