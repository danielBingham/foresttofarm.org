<?php

/**
 * A class describing one of the possible root patterns plants display
 *
 * @property	int	$id	The primary key.
 * @property	string	$name	The name of this root pattern.
 * @property	string	$symbol	A symbol representing this root pattern.
 * @property	string	$description	A description of this root pattern.
 */
class RootPattern extends Eloquent
{
	public $timestamps = FALSE;

	protected $table = 'root_patterns';
	protected $hidden = array('pivot');
}
