define([
    'jquery',
    'underscore',
    'backbone',
    'app/models/Plant',
    'app/models/Plants',
    'app/models/Image',
    'app/models/Images',
    'app/views/MainView',
    'app/views/PlantView',
    'app/views/PlantListView',
    'app/views/PlantImageGalleryView',
    'app/views/PlantImageView',
    'app/views/PlantImageUploadView',
    'app/views/PlantImageCropView'],
function(
    $, 
    _, 
    Backbone,
    Plant,
    Plants,
    Image,
    Images,
    MainView,
    PlantView,
    PlantListView,
    PlantImageGalleryView,
    PlantImageView,
    PlantImageUploadView,
    PlantImageCropView
) {

return Backbone.Router.extend({
    /**
     * What protocol is this website using?
     */
    protocol: "http",

    /**
     * A hash of routes that this router should handle.
     */
    routes: {
        '': 'index',
        'plants/:id': 'viewPlant',
        'plants/:plant_id/images': 'viewImageGallery',
        'plants/:plant_id/images/new': 'uploadPlantImage',
        'plants/:plant_id/images/:image_id': 'viewPlantImage',
        'plants/:plant_id/images/:image_id/edit': 'cropPlantImage',

    },

    main_view: null,

    /**
     * Initialize this router to override and handle any links, preventing them
     * from hitting the backend. 
     */
    initialize: function() {
        if ( ! this.main_view) {
            this.main_view = new MainView({el: "#main"});
        }
        
        Backbone.history.start({ pushState: true });

        // This is a little hacky. We need access to this down below as the
        // router, but we can't rebind 'this' because we also need access to
        // the clicked element.  So we'll stash the router in 'router' for now.
        var router = this;
        $(document).on('click', 'a:not([data-bypass])', function (event) {

            var href = $(this).attr('href');
            var protocol = this.protocol + '//';

            if (href.slice(protocol.length) !== protocol) {
              event.preventDefault();
              router.navigate(href, true);
            }
        }); 
    },

    /** 
     * The site index.  A an auto-paged list of plants available for viewing.
     *
     * @returns {void}
     */
    index: function() {
        this.main_view.clear();

        var plants = new Plants();

        var plant_list_view = new PlantListView({collection:plants});
        
        this.main_view.appendSubview(plant_list_view);
        this.main_view.render();

        plants.fetch();
    },

    /**
     * A detail page to view the details of a single plant.
     *
     * @param   {number}    id  The database id of the plant we'd like to view.
     *
     * @returns {void}
     */
    viewPlant: function(id) {
        this.main_view.clear();
        
        var plant = new Plant({id: id});
        plant.fetch();
        var plant_view = new PlantView({model:plant});

        this.main_view.appendSubview(plant_view);
        this.main_view.render();

    },

    viewImageGallery: function(plant_id) {
        this.main_view.clear();

        var images = new Images(null, {plant_id: plant_id});
        images.fetch();

        var plant_image_gallery_view = new PlantImageGalleryView({collection:images});
        this.main_view.appendSubview(plant_image_gallery_view);
        this.main_view.render();
    },

    viewPlantImage: function(plant_id, image_id) {

    },

    /**
     * Upload an image of a plant.
     *
     * @param   {number}    plant_id  The database id of the plant we'd like to add
     *  an image to.
     *
     * @returns  {void}
     */
    uploadPlantImage: function(plant_id) {
        this.main_view.clear();

        var image_upload_view = new PlantImageUploadView({plant_id:plant_id, router: this});

        this.main_view.appendSubview(image_upload_view);
        this.main_view.render();
    },

    /**
     *
     */
    cropPlantImage: function(plant_id, image_id) {
        this.main_view.clear();

        var image = new Image({id: image_id, base_url: '/api/v0/plants/' + plant_id});
        image.fetch();

        var image_crop_view = new PlantImageCropView({model: image});

        this.main_view.appendSubview(image_crop_view);
        this.main_view.render();

    }  

});


});
