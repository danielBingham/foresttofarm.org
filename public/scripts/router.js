define([
    'jquery',
    'underscore'],
function($, _) {

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
