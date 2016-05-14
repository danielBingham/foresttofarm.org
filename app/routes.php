<?php


/**
 * API
 */
Route::get('/api/v0/plants', 'PlantsController@index');
Route::get('/api/v0/plant/{id}', 'PlantsController@single');

/**
 * Front facing routes
 */
Route::get('/', 'HomeController@index');
Route::get('/plant/{id}', 'HomeController@plant');
