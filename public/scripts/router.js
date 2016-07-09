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
    routes: {
        '': 'index',
        'plant/:id': 'viewPlant'
    },

    index: function() {
        var plants = new Plants();
        var plant_view = new PlantsView({collection:plants});

        plants.fetch();
    },

    viewPlant: function(id) {
        var plant = new Plant(id);
        var plant_view = new PlantView(plant);

        plant.fetch();
    }  
});


});
