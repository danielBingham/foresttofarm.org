<?php

/**
 * A plant's grow habit.
 *
 * What form does the plant usually take?  What's it's grow habit?
 *
 * @property	int	$id	The primary key.
 * @property	string	$name	The name of the habit.
 * @property	string	$symbol	The short symbol of the growth habit.
 * @property	string	$description	The description of the growth habit.
 */
class Habit extends Eloquent
{
	public $timestamps = FALSE;

	protected $table = 'habits';
	protected $hidden = array('pivot');
}
