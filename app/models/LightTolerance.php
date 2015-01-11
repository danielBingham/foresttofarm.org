<?php

/**
 * A class of Light Tolerance a Plant may exhibit
 *
 * This is a model representing the different classes of light tolerances a
 * plant may exhibit.  The classes typically used in plant literature are "Full
 * Sun", "Partial Shade" and "Full Shade".
 *
 * @property	int	$id	The primary key.
 * @property	string	$name	The name of light tolerance in question.
 */
class LightTolerance extends Eloquent
{
	public $timestamps = FALSE;

	protected $table = 'light_tolerances';
}
