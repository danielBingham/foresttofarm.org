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

		echo $plants->toJson();
		//echo '<pre>'; echo json_encode(json_decode($plants->toJson()), JSON_PRETTY_PRINT); echo '</pre>';
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

		echo $plant->toJson();
	}
}
