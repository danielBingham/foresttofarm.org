define([
    'jquery',
    'underscore',
    'backbone',
    'app/models/Plant',
    'app/models/Plants',
    'app/views/PlantView',
    'app/views/PlantsView'],
function(
    $, 
    _, 
    Backbone,
    Plant,
    Plants,
    PlantView,
    PlantsView
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
        'plant/:id': 'viewPlant'
    },

    /**
     * Initialize this router to override and handle any links, preventing them
     * from hitting the backend. 
     */
    initialize: function() {
        Backbone.history.start({ pushState: true });
        $(document).on('click', 'a:not([data-bypass])', _.bind(function (event) {

            var href = $(this).attr('href');
            var protocol = this.protocol + '//';

            if (href.slice(protocol.length) !== protocol) {
              event.preventDefault();
              this.navigate(href, true);
            }
        }, this));    
    },

    /** 
     * The site index.  A an auto-paged list of plants available for viewing.
     */
    index: function() {
        var plants = new Plants();
        var plant_view = new PlantsView({collection:plants});

        plants.fetch();
    },

    /**
     * A detail page to view the details of a single plant.
     *
     * @param   {number}    id  The database id of the plant we'd like to view.
     */
    viewPlant: function(id) {
        alert('Called with ' + id);

//        var plant = new Plant(id);
 //       var plant_view = new PlantView(plant);

  //      plant.fetch();
    }  
});


});
