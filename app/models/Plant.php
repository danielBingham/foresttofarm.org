<?php

class Plant extends Eloquent
{
	protected $table = 'plants';
	protected $hidden = array('pivot');


	public function commonNames()
	{
		return $this->hasMany('PlantCommonName', 'plant_id');
	}

	public function habits()
	{
		return $this->belongsToMany('Habit', 'plant_habits', 'plant_id', 'habit_id');
	}

	public function rootPatterns()
	{
		return $this->belongsToMany('RootPattern', 'plant_root_patterns', 'plant_id', 'root_pattern_id');
	}

	public function habitats()
	{
		return $this->belongsToMany('Habitat', 'plant_habitats', 'plant_id', 'habitat_id');
	}

	public function harvests()
	{
		return $this->belongsToMany('Harvest', 'plant_harvests', 'plant_id', 'harvest_id');
	}

	public function roles()
	{
		return $this->belongsToMany('Role', 'plant_roles', 'plant_id', 'role_id');
	}

	public function drawbacks()
	{
		return $this->belongsToMany('Drawback', 'plant_drawbacks', 'plant_id', 'drawback_id');
	}

	public function lightTolerances()
	{
		return $this->belongsToMany('LightTolerance', 'plant_light_tolerances', 'plant_id', 'light_tolerance_id');
	}

	public function moistureTolerances()
	{
		return $this->belongsToMany('MoistureTolerance', 'plant_moisture_tolerances', 'plant_id', 'moisture_tolerance_id');
	}
}
