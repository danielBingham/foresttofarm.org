require([
	'jquery',
	'underscore',
	'backbone',
	'app/models/Plants',
	'app/views/PlantsView'],
function($, _, Backbone, Plants, PlantsView) {

    var Router = Backbone.Router.extend({
        routes: {
            "plant/:id": "getPlant",
            "*actions": "defaultRoute"
        }

    });

    var router = new Router();

    router.on('route:defaultRoute', function(actions) {
        var plants = new Plants();
        var plant_view = new PlantsView({collection:plants});

        plants.fetch();
    });

    router.on('route:getPlant', function(id) {
            var plant = new Plant({id: id}); 
            var plant_detail_view = new PlantDetailView({plant: plant});
    });

    Backbone.history.start();
});
