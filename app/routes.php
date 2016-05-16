<?php


/**
 * API
 */
Route::get('/api/v0/plants', 'ApiController@plants');
Route::get('/api/v0/plant/{id}', 'ApiController@plant');

/**
 * Front facing routes
 */
Route::get('/', 'SiteController@index');
Route::get('/plant/{id}', 'SiteController@plant');
