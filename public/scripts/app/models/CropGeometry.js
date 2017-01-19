/**
 * CropGeometry 
 */
define([
	'jquery',
	'underscore'],
function($, _) {

    /**
     * A model to represent the geometry of a potential image crop.  Loosely
     * tied to JCrop, the JQuery plugin cropping library we're using.
     *
     */
    var CropGeometry = function() {
        this.x = 0;
        this.y = 0;
        this.width = 0;
        this.height = 0;

    };

    CropGeometry.prototype = {

        /**
         * Record the current geometry of the Jcrop selection window so we can
         * send it to the server when the user indicates they are finished
         * cropping.
         *
         * @param   {JcropCoordinates}  geometry    A hash containing the current
         * coordinates of the Jcrop selection window.  Possible values:
         *  - x - The x coordinate of the upper right vertice.
         *  - y - The y coordinate of the upper right vertice.
         *  - x2 - The x coordinate of the lower left vertice.
         *  - y2 - The y coordinate of the lower left vertice.
         *  - w - The width of the selection box.
         *  - h - The height of the selection box.
         *
         * @returns    {this}
         */
        updateFromJCrop: function(geometry) {
            this.x = geometry.x;
            this.y = geometry.y;
            this.width = geometry.w;
            this.height = geometry.h;
            return this;
        },

        /**
         * Get the crop geometry as a raw object to be sent to the server.
         *
         * @return  {Object}    A basic object hash containing the crop
         *  geometry.
         */
        getRawData: function() {
            return {
                x: this.x,
                y: this.y,
                width: this.width,
                height: this.height
            };
        }
    }; 

    return CropGeometry;
});
