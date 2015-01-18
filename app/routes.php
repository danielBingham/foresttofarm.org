<?php


/**
 * API
 */
Route::get('/api/v0/plants', 'PlantsController@index');

/**
 * Front facing routes
 */
Route::get('/', 'HomeController@index');
