/**
 * ImageService
 */
define([
	'jquery',
	'underscore'],
function($, _) {
/**
     * An object to wrap an image endpoint and handle uploading.  
     *
     * Image uploading asynchronously is a process requiring a lot of hook
     * points and callbacks.  So this object wraps and contains the process and
     * allows for easy replacement and overriding of callbacks.  Callbacks can
     * be overridden either by setting them directly like so:
     *
     * ```
     * var uploader = new ImageUploader(endpoint);
     * uploader.beforeUpload = function() {
     *      // Do something
     * };
     * uploader.upload();
     * ```
     * Or they can be overridden using the provided convenience setters, which
     * allow for easy chaining:
     *
     * ```
     * var uploader = image_service.getUploader()
     *      .setBeforeCallback(function() {
     *          // Do something
     *      })
     *      .setSuccessCallback(function() {
     *          // Do something
     *      })
     *      .upload();
     * ```
     *
     */
    var ImageUploader = function(endpoint) {
        this.endpoint = endpoint; 
    };

    ImageUploader.prototype = {

        /**
         * Convenience method to all chaining of setting callbacks.
         *
         * @see ImageUploader.beforeUpload
         */ 
        setBeforeCallback: function(beforeCallback) {
            this.beforeUpload = beforeCallback;
            return this;
        },

        /**
         * Convenience method to all chaining of setting callbacks.
         *
         * @see ImageUploader.updateProgress
         */ 
        setProgressCallback: function(progressCallback) {
            this.updateProgress = progressCallback;
            return this;
        },

        /**
         * Convenience method to all chaining of setting callbacks.
         *
         * @see ImageUploader.onSuccess
         */ 
        setSuccessCallback: function(successCallback) {
            this.onSuccess = successCallback;
            return this;
        },

        /**
         * Convenience method to all chaining of setting callbacks.
         *
         * @see ImageUploader.onError
         */ 
        setErrorCallback: function(errorCallback) {
            this.errorCallback = errorCallback;
            return this;
        },
       
        /**
         * Called at the beginning of the upload process to allow the object's
         * user to do any setup necessary.  This could mean hiding the upload
         * form and showing a progress bar, popping open a modal, or doing preupload
         * data manipulations.
         *
         * @returns {void}
         */ 
        beforeUpload: function() {}, 

        /**
         * Called periodically through out the upload process with updates on the
         * current state of the upload.  This allows the uploader's user to update
         * the UX to show progress on the upload.
         *
         * @param   {ProgressEvent}    event   A ProgressEvent containing
         * properties allowing us to display the current progress of the
         * upload.  @see
         * https://developer.mozilla.org/en-US/docs/Web/Events/progress
         *
         * @returns {void}
         */
        updateProgress: function() {},

        /**
         * Called on the successful completion of the file upload.
         *
         * @param   {Event} event   A standard event object.
         *
         * @returns {void}
         */
        onSuccess: function() {},

        /**
         * Called when the server reports an error or the client fails to connect
         * to the server.
         *
         * @param   {Event} event   A standard event object.
         *
         * @returns {void}
         */
        onError: function() {},

        /**
         * Begin the process of uploading an image.
         *
         * @param   {File}  image   The image file to be uploaded, retrieved
         *  from the files array of the change event of a file field.
         *
         * @returns {void}
         */
        upload: function(image) {
            this.beforeUpload();

            // Build the form data that will hold the image
            form_data = new FormData();
            form_data.append('image', image);

            $.ajax({
                url: this.endpoint,
                type: 'POST',
                xhr: _.bind(function() {
                    var tracking_xhr = $.ajaxSettings.xhr();
                    if (tracking_xhr.upload) {
                        tracking_xhr.upload.addEventListener('progress', this.updateProgress);
                    }
                    return tracking_xhr;
                }, this),
                success: this.onSuccess,
                error: this.onError,
                data: form_data,
                processData: false,
                contentType: false
            });
        }
    };

    /**
     * A service to handle front end image manipulation.  Exposes methods
     * to handle image uploading and image cropping.
     *
     * To upload an image:
     *
     * ```
     * service = new ImageService(endpoint);
     * service.getUploader().setSuccessCallback(function(event) {
     *      // Handle success
     * }).setErrorCallback(function(event) {
     *      // Handle error
     * }).upload(image);
     * ```
     */
	var ImageService = function(endpoint_base) {

        /**
         *
         */
        this.upload_endpoint = endpoint_base + '/images';
    };
        
    ImageService.prototype = {
        
        /**
         * Get an uploader object for this service's endpoint.  This will allow
         * the setting of callbacks and asynchronus uploading of files to the
         * server.
         *
         * @see ImageUploader
         *
         * @returns {ImageUploader} An uploader object allowing for uploading
         * of files to the server.
         */
        getUploader: function() {
            return new ImageUploader(this.upload_endpoint);
        },

        /**
         * Handle the cropping of an image on the client side.
         */
        handleCrop: function() {

        }

	};

    return ImageService;
});
