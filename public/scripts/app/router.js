define([
    'jquery',
    'underscore',
    'backbone',
    'app/models/Plant',
    'app/models/Plants',
    'app/views/MainView',
    'app/views/PlantView',
    'app/views/PlantListView'],
function(
    $, 
    _, 
    Backbone,
    Plant,
    Plants,
    MainView,
    PlantView,
    PlantListView
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
        'plants/:id': 'viewPlant'
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
     */
    viewPlant: function(id) {
        this.main_view.clear();
        
        var plant = new Plant({id: id});
        plant.fetch();
        var plant_view = new PlantView({model:plant});

        this.main_view.appendSubview(plant_view);
        this.main_view.render();

    }  
});


});
