<?php

/**
 * One of many possible drawbacks a plant might have
 *
 * Plants have drawbacks, from poisonness to dispersiveness.  This is one of
 * them.
 *
 * @property	int	$id	The primary key.
 * @property	string	$name	The name of this drawback.
 */
class Drawback extends Eloquent
{
	public $timestamps = FALSE;

	protected $table = 'drawbacks';
	protected $hidden = array('pivot');
}
