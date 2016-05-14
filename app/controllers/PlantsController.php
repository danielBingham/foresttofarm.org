<?php

/**
 * Controller for handling the API
 */
class PlantsController extends BaseController {

	public function index()
	{
		$plants = Plant::with(
				'commonNames',
				'habits',
				'rootPatterns',
				'habitats',
				'harvests',
				'roles',
				'drawbacks',
				'lightTolerances',
				'moistureTolerances')
			->get();

        return $plants;
	}

	public function single($id)
	{
		$plant = Plant::with(
			'commonNames',
			'habits',
			'rootPatterns',
			'habitats',
			'harvests',
			'roles',
			'drawbacks',
			'lightTolerances',
			'moistureTolerances')
		->where('id', '=', $id)
		->first();

        return $plant;
	}
}
