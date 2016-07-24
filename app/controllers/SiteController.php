<?php

/**
 * Controller to manage the site from the backend in the event that we have a
 * javascript fall through.  This is primarily for older browsers and search
 * engine bots.
 */
class SiteController extends BaseController {

	protected $layout = 'layouts.master';


    /**
     * Index of the site.  Essentially hands control over to backbone.
     */
	public function index()
    {

    }

}
