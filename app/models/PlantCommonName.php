<?php

/**
 * Represents one of a plant's possibly many common names.
 *
 * @property int	$id			The primary key, auto increment.
 * @property int	$plant_id	The id of the plant to which this common name belongs.
 * @property string	$name		The common name.
 */
class PlantCommonName extends Eloquent
{
	public $timestamps = FALSE;

	protected $table = 'plant_common_names';
	protected $hidden = array('pivot');

	/**
	 * Get the Plant that this common name belongs to
	 *
	 * Retrieves the plant model that this common name is attached to.
	 *
	 * @return	Plant	The owner of this common name.
	 */
	public function plant()
	{
		return $this->belongsTo('Plant', 'plant_id');
	}
}
