<?php

/**
 * Describes a role that a plant can play in an ecosystem
 *
 * Describes one of many possible roles a plant can play in an ecosystem.
 * Plants can play multiple roles.
 *
 * @property	int	$id	The primary key.
 * @property	string	$name	The name of this role.
 */
class Role extends Eloquent
{
	public $timestamps = FALSE;

	protected $table = 'roles';
}
