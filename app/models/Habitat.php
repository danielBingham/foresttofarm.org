<?php

/**
 * The habitat in which this plant natively grows
 *
 * This represents the habitat in which this plant is normally found in the
 * wild.
 *
 * @property	int	$id	The primary key.
 * @property	string	$name	The name of the habitat.
 */
class Habitat extends Eloquent
{
	public $timestamps = FALSE;

	protected $table = 'habitats';
	protected $hidden = array('pivot');
}
