<?php

use Illuminate\Console\Command;
use Symfony\Component\Console\Input\InputOption;
use Symfony\Component\Console\Input\InputArgument;


/**
 * A command to load our data from a CSV file where we are compiling it
 * in to the database.
 *
 * To run from the command line:
 * php artisan data:load [datafile]
 *
 */
class DataLoad extends Command {

	/**
	 * The console command name.
	 *
	 * @var string
	 */
	protected $name = 'data:load';

	/**
	 * The console command description.
	 *
	 * @var string
	 */
	protected $description = 'Load data from a csv file.';

	/**
	 * Create a new command instance.
	 *
	 * @return void
	 */
	public function __construct()
	{
		parent::__construct();
	}

	/**
	 * Execute the console command.
	 *
	 * @return void
	 */
	public function fire()
	{
        
        $filename = $this->argument('csv_file');

        // Set up the CSV parsing service.
        $plantCSVService = new PlantCSVParsingService();
        $plantCSVService->setOutput($this);
        $plantCSVService->parseCSVFile($filename);
	}

	/**
	 * Print a Debug Message
	 *
	 * @param	string $message The message to print.
	 * @return void
	 */
	public function debug($message)
	{
		$now = new DateTime();
		$this->info($now->format("Y-m-d\tH:i:sO") . ':: ' . $message);
    }

    /**
     * Print an Error message to the console.
     *
     * @param   string  $message    The message to print.
     * @return void
     */
    public function error($message)
    {
		$now = new DateTime();
        $message = $now->format("Y-m-d\tH:i:sO") . ':: ' . $message;
        parent::error($message);
    }

	/**
	 * Get the console command arguments.
	 *
	 * @return array
	 */
	protected function getArguments()
	{
		return array(
			array('csv_file', InputArgument::REQUIRED, 'The file to be processed into the database.'),
		);
	}

	/**
	 * Get the console command options.
	 *
	 * @return array
	 */
	protected function getOptions()
	{
		return array();
	}

}
