<?php

/**
 * Controller to manage the site from the backend in the event that we have a
 * javascript fall through.  This is primarily for older browsers and search
 * engine bots.
 */
class SiteController extends BaseController {

	protected $layout = 'layouts.master';


    /**
     * Index of the site.  Presents a list of all plant data.
     */
	public function index()
    {
        $plants_controller = new PlantsController();
        $plant_models = $plants_controller->index();

    }

    /**
     * A single plant page showing the plant's data.  Returns
     * a parsed HTML template.
     *
     * @param   int $id The id of the plant to display.
     *
     * @return void
     */
    public function plant($id) 
    {

        $plants_controller = new PlantsController();
        $plant_model = $plants_controller->plant($id);

        
        return View::make('plant')->with('plant', $plant_model);
    }

    /**
     * Display the search form or process a completed search.
     */
    public function search($search)
    {

    }
}
